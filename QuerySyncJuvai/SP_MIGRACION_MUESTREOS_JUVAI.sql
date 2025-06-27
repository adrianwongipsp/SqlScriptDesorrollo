
CREATE PROCEDURE [dbo].[SP_MIGRACION_MUESTREOS_JUVAI]    
  @fechaParametro DATE
AS   
BEGIN
SET DATEFIRST 1;
	DECLARE  @FechaInicio DATE  = DATEADD(DAY, -2,  @fechaParametro),
			 @FechaFin DATE     = @fechaParametro,
       /*PROCESO  DE MUESTREOS DE PESOS */
          @id INT               = 0,
		  @Modifica VARCHAR(75) = 'MIGRACION_JUVAI_' +FORMAT(GETDATE(), 'yyyy-MM-dd'),
		  @empresa VARCHAR(5),
		  @division VARCHAR(5),
		  @idPiscina INT,
		  @idPiscinaEje INT,
		  @tipoMuestreo VARCHAR(5)='';

--Verificar si la tabla temporal ya existe y eliminarla
		IF OBJECT_ID('tempdb..#tmp_muestreo_cultivo') IS NOT NULL
			DROP TABLE #tmp_muestreo_cultivo;

		-- Crear la tabla temporal
		CREATE TABLE #tmp_muestreo_cultivo (
			procesado BIT,
			idPiscina INT,
			idPiscinaEjecucion INT,
			Ciclo INT,
			keyPiscina VARCHAR(60),
			Rol VARCHAR(6) NULL,
			Clasificacion VARCHAR(60) NULL,
            FMuestreo DATETIME NULL,
			Fregistro DATETIME NULL,
			UsuarioResponsable VARCHAR(60) NULL, 
			idUsuario INT NULL,
			Descripcion VARCHAR(300) NULL, 
			Piscina VARCHAR(60),
			Cantidad INT NULL,
			PlGramoCamJuvai DECIMAL(18,5),
			nbIdImagen  INT,
			nombreSector  VARCHAR(60) NULL,
			pesopromedio DECIMAL(18,5) NULL,
			longitudpromedio DECIMAL(18,5) NULL,
			idMuestreoDetalle INT NULL,
		);

       INSERT INTO #tmp_muestreo_cultivo (idPiscina,idPiscinaEjecucion, Ciclo, keyPiscina, Rol, procesado, Clasificacion,FMuestreo,
	   Fregistro, UsuarioResponsable, idUsuario, Descripcion, Cantidad, PlGramoCamJuvai, nbIdImagen, nombreSector, pesopromedio, longitudpromedio)
		SELECT DISTINCT ej.idPiscina, ej.idPiscinaEjecucion, ej.Ciclo, ej.keyPiscina, ej.rolPiscina, 0,
		    CASE 
				WHEN DATEPART(WEEKDAY, x.dtFechaRegistro) IN (5,6,7,1) THEN 'PES'
				WHEN DATEPART(WEEKDAY, x.dtFechaRegistro) IN (2,3,4) THEN 'PRE'
            END AS Clasificacion,
			x.dtFechaRegistro AS FMuestreo,
			x.dtFechaRegistroEnvio AS Fregistro,
			x.txtUsuarioRegistro AS UsuarioResponsable,
			x.nbIdUsuario AS idUsuario,
			x.txtNombreMuestra AS Descripcion,
			x.nbNumeroAnimales AS Cantidad,
			(1.0 / NULLIF(x.nbAverageWeight, 0)) *1000 AS PlGramoCamJuvai,
			x.nbIdImagen,
			ej.nombreSector,
			x.nbAverageWeight AS  pesopromedio,
            x.nbAverageLength AS longitudpromedio
		FROM  EjecucionesPiscinaView ej
		     INNER JOIN [192.168.1.83].[IPSP_JUVAI].DBO.VW_BASEPESOMUESTRA x 
		     ON x.txtClavePiscina COLLATE SQL_Latin1_General_CP1_CI_AS = ej.keyPiscina 
		     AND x.nbIdPiscinaEjecucion=ej.idPiscinaEjecucion
		WHERE ej.estado IN('EJE', 'INI') AND CAST(x.dtFechaRegistro AS DATE) BETWEEN @FechaInicio AND @FechaFin
		      AND x.nbidtipomuestra      = 2 and ej.Ciclo>0
		      AND NOT EXISTS (SELECT * FROM AuditoriaMigracionJuvai y 
						      WHERE y.IdJuvai         = x.nbIdImagen
						      AND   y.TipoTransaccion='MUESTREO')

		
		  --SELECT * FROM #tmp_muestreo_cultivo
		  WHILE EXISTS(SELECT TOP 1 1 FROM #tmp_muestreo_cultivo WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				   @id                = nbIdImagen,
				   @idPiscina         = idPiscina,
				   @idPiscinaEje      = idPiscinaEjecucion
		        FROM #tmp_muestreo_cultivo 
				WHERE procesado=0
				ORDER BY nbIdImagen;

				SET @tipoMuestreo ='PLONG';

				  IF(@id>0)
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0, @ultimaSecuenciaDetalle INT =0;
						SELECT @empresa= empresa, @division= division from maePiscina where idPiscina=@idPiscina
						
						UPDATE x SET x.Piscina = (SELECT TOP 1 y.nombre from maePiscina y where y.idPiscina=x.idPiscina AND y.activo=1) 
						FROM #tmp_muestreo_cultivo x
						WHERE x.nbIdImagen = @id AND x.procesado	 = 0


						SELECT 
										 det.idPiscina
										,det.idPiscinaEjecucion
										,SUM(det.cantidadTotal) AS cantidadTotalAnt
										,ISNULL(ca.tipoMuestreoDetalle,'') AS tipoMuestreoDetalle --define los valores: pesoLongitudTotal y pesoGramosTotal 
										,ISNULL(CASE WHEN CA.tipoMuestreoDetalle='PLONG' THEN SUM(det.pesoLongitudTotal)  END, 0) AS  pesoLongitudTotalAnt
										,ISNULL(CASE WHEN CA.tipoMuestreoDetalle='PTALL' THEN SUM(det.pesoGramosTotal) END , 0) AS pesoGramosTotalAnt
										,SUM(det.pesoPromedioReportado) AS pesoPromedioReportadoAnt
										, ca.fechaMuestreo AS  fechaMuestreoAnt
		     						INTO #tmp_muestreos
						FROM   [IPSPCamaroneraProduccion].[dbo].proMuestreoPesoDetalle det
							   INNER JOIN [IPSPCamaroneraProduccion].[dbo].proMuestreoPeso ca ON det.idMuestreo=ca.idMuestreo    
						WHERE det.idPiscina= @idPiscina AND det.idPiscinaEjecucion=@idPiscinaEje
						      AND ca.estado='APR' 
							  AND det.activo= 1 
						GROUP BY  det.idPiscina ,det.idPiscinaEjecucion, ca.tipoMuestreoDetalle, ca.fechaMuestreo
						ORDER BY  ca.fechaMuestreo DESC


						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'MuestreoPeso'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'MuestreoPeso'  


						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + 1  -- Valor arbitrario pero seguro
						WHERE  tabla = 'MuestreoPesoDetalle'

					print 
							 ''    + cast(@ultimaSecuenciaCabecera as varchar(15))    
							 + '|' + cast(@id as varchar(15))   
							 + '|' + cast(@ultimaSecuenciaDetalle as varchar(15))
						
					INSERT INTO [dbo].[proMuestreoPeso]
							   ([idMuestreo]
							   ,[empresa]
							   ,[division]
							   ,[zona]
							   ,[secuencia]
							   ,[fechaRegistro]
							   ,[fechaMuestreo]
							   ,[camaronera]
							   ,[sector]
							   ,[descripcion]
							   ,[idResponsable]
							   ,[usuarioResponsable]
							   ,[tipoMuestreoDetalle]
							   ,[tipoMuestreo]
							   ,[estado]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion]
							   ,[responsable]
							   ,[codigoRolPiscina])
	                SELECT TOP 1  @ultimaSecuenciaCabecera 
								,@empresa
								,@division
								,p.codigoZona 
								,@ultimaSecuenciaCabecera
								,CAST(mp.Fregistro AS DATE)
								,CAST(mp.FMuestreo AS DATE)
								,p.codigoCamaronera 
								,p.codigoSector 
								,mp.Piscina + '(' + CAST(mp.PlGramoCamJuvai AS VARCHAR) +')'
								,ISNULL(mp.idUsuario,0)
								,mp.usuarioResponsable
								,''
								,mp.Clasificacion
								,'APR'
								,'AdminPsCam'
								,@Modifica+'_CRE'
								,GETDATE()
								,'AdminPsCam'
								,@Modifica+'_CRE'
								,GETDATE()
								,mp.UsuarioResponsable 
								,mp.Rol
						FROM 	 #tmp_muestreo_cultivo mp 
						INNER JOIN PiscinaUbicacion p WITH(NOLOCK) ON mp.idPiscina=p.idPiscina
						WHERE mp.nbIdImagen          = @id
	

						INSERT INTO [dbo].[proMuestreoPesoDetalle]
								   ([idMuestreoDetalle]
								   ,[idMuestreo]
								   ,[orden]
								   ,[idPiscina]
								   ,[cantidadTotal]
								   ,[longitudPromedio]
								   ,[longitudPromedioAnterior]
								   ,[fechaPesoAnterior]
								   ,[pesoLongitudTotal]
								   ,[pesoGramosTotal]
								   ,[pesoGramosAnterior]
								   ,[horaMuestreo]
								   ,[idPiscinaEjecucion]
								   ,[observacion]
								   ,[activo]
								   ,[usuarioCreacion]
								   ,[estacionCreacion]
								   ,[fechaHoraCreacion]
								   ,[usuarioModificacion]
								   ,[estacionModificacion]
								   ,[fechaHoraModificacion]
								   ,[pesoPromedioReportado])
		             SELECT TOP 1  (ROW_NUMBER() OVER(ORDER BY  mp.nbIdImagen)  + @ultimaSecuenciaDetalle) 
								  ,@ultimaSecuenciaCabecera
								  ,1
								  ,mp.idPiscina
								  ,mp.Cantidad
								  ,longitudPromedio
								  ,ISNULL(m.pesoLongitudTotalAnt,0)
								  ,m.fechaMuestreoAnt
								  ,longitudpromedio
								  ,pesopromedio
								  ,ISNULL(m.pesoGramosTotalAnt,0)
								  ,CAST(mp.FMuestreo AS TIME) AS horaMuestreo
								  ,mp.idPiscinaEjecucion
								  ,mp.Descripcion
								  ,1
							      ,'AdminPsCam'
								  ,@Modifica+'_CRE'
								  ,GETDATE()
								  ,'AdminPsCam'
								  ,@Modifica+'_CRE'
								  ,GETDATE()
								  ,NULL
						FROM  #tmp_muestreo_cultivo mp 
						INNER JOIN PiscinaUbicacion p WITH(NOLOCK) ON mp.idPiscina=p.idPiscina
						LEFT JOIN #tmp_muestreos m ON mp.idPiscina =m.idPiscina AND mp.idPiscinaEjecucion=m.idPiscinaEjecucion
						WHERE mp.nbIdImagen          = @id


					UPDATE d
					SET d.idMuestreoDetalle=(SELECT idMuestreoDetalle
					                   FROM  proMuestreoPesoDetalle de WITH (NOLOCK) 
					                   WHERE de.idMuestreo = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina)
					FROM   #tmp_muestreo_cultivo d
					WHERE d.nbIdImagen = @id 
					
					            
					
				IF(@tipoMuestreo='PLONG')
				BEGIN
				   DECLARE @ultimaSecuenciaL INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaL = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + 1  -- Valor arbitrario pero seguro
					WHERE tabla = 'MuestreoPesoLongitudDetalle'

					
					INSERT INTO [dbo].[proMuestreoPesoLongitudDetalle]
							   ([idMuestreoLongitudDetalle]
							   ,[idMuestreoDetalle]
							   ,[orden]
							   ,[longitud]
							   ,[medidaLongitud]
							   ,[peso]
							   ,[medidaPeso]
							   ,[cantidadMuestra]
							   ,[activo]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion])
		              SELECT   (ROW_NUMBER() OVER(ORDER BY mp.nbIdImagen)  + @ultimaSecuenciaL) 
								  ,mp.idMuestreoDetalle
								  ,1
								  ,mp.longitudpromedio
								  ,'MMETRO'
								  ,mp.PlGramoCamJuvai
								  ,'GRAMO'
								  ,mp.Cantidad
								  ,1
							      ,'AdminPsCam'
								  ,@Modifica+'_CRE'
								  ,GETDATE()
								  ,'AdminPsCam'
								  ,@Modifica+'_CRE'
								  ,GETDATE()
						FROM    #tmp_muestreo_cultivo mp  
				        WHERE mp.nbIdImagen        = @id
						

			  END 
			  ELSE
			  BEGIN
                	DECLARE  @ultimaSecuenciaT INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaT = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + 1  -- Valor arbitrario pero seguro
					WHERE tabla           = 'MuestreoPesoTallaDetalle'

					
					INSERT INTO [dbo].[proMuestreoPesoTallaDetalle]
								([idMuestreoTallaDetalle]
								,[idMuestreoDetalle]
								,[orden]
								,[talla]
								,[cantidadMuestra]
								,[pesoGramos]
								,[activo]
								,[usuarioCreacion]
								,[estacionCreacion]
								,[fechaHoraCreacion]
								,[usuarioModificacion]
								,[estacionModificacion]
								,[fechaHoraModificacion])
		            SELECT   (ROW_NUMBER() OVER(ORDER BY mp.nbIdImagen)  + @ultimaSecuenciaT) 
								,mp.idMuestreoDetalle
								,1
								,'001'
								,mp.Cantidad
								,mp.PlGramoCamJuvai
								  ,1
							      ,'AdminPsCam'
								  ,@Modifica+'_CRE'
								  ,GETDATE()
								  ,'AdminPsCam'
								  ,@Modifica+'_CRE'
								  ,GETDATE()
						FROM    #tmp_muestreo_cultivo mp  
				        WHERE mp.nbIdImagen        = @id

			  END
             END
			
			       UPDATE #tmp_muestreo_cultivo SET procesado = 1 WHERE nbIdImagen = @id AND procesado	 = 0
				   INSERT INTO AuditoriaMigracionJuvai(IdInsigne, IdJuvai, TipoTransaccion, Fecha)
				   SELECT @ultimaSecuenciaCabecera, mp.nbIdImagen, 'MUESTREO', GETDATE() 
						        FROM    #tmp_muestreo_cultivo mp  
				                WHERE mp.nbIdImagen        = @id

				DROP TABLE #tmp_muestreos
															  
        END	
DROP TABLE #tmp_muestreo_cultivo;
SELECT * FROM AuditoriaMigracionJuvai WHERE TipoTransaccion='MUESTREO';
END
