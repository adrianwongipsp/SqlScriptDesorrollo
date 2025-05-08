 
alter PROCEDURE [dbo].[SP_MIGRACION_PISCINA_CONTROL_MUESTREO]
AS
BEGIN
--BEGIN TRAN
		 DROP TABLE IF EXISTS #idsControlDetalle
		 DROP TABLE IF EXISTS #idsControl
		 
		   /*PROCESO  DE MUESTREOS DE PESOS */
          DECLARE @id INT = 0,
		  @idZona CHAR(3) = '',
          @CodCamaronera CHAR(5) = '',
          @CodSector CHAR(5)     = '',
		  @Count INT  = 0,
		  @Count1 INT = 0,
		  @Modifica varchar(75) = 'MIGRACION_PISCINA_20250505',
		  @idZona_NEW  CHAR(3)   = '',
          @CodCamaronera_NEW  CHAR(5) = '',
          @CodSector_NEW  CHAR(5)     = '';

		  SELECT DISTINCT  
		           de.idMuestreo
		          ,0 procesado
		          ,de.idMuestreoDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
				  ,ca.zona
				  ,ca.camaronera
				  ,ca.sector
				  ,mp.CODIGOZONA_NEW
				  ,mp.CODIGOCAMARONERA_NEW
				  ,mp.CODIGOSECTOR_NEW
		  INTO #idsControlDetalle
		  FROM proMuestreoPesoDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA 
		  INNER JOIN proMuestreoPeso ca 
		   ON de.idMuestreo = ca.idMuestreo


		  SELECT DISTINCT 
		           idMuestreo
				  ,zona
				  ,camaronera
				  ,sector
		          ,0 procesado
				  ,CODIGOZONA_NEW
				  ,CODIGOCAMARONERA_NEW
				  ,CODIGOSECTOR_NEW
		  INTO #idsControl
		  FROM #idsControlDetalle


		  --SELECT * FROM  #idsControl
		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				   @id                = idMuestreo,
				   @idZona            = zona,
		           @CodCamaronera     = camaronera,
			       @CodSector         = sector,
			  	   @idZona_NEW        = CODIGOZONA_NEW,
				   @CodCamaronera_NEW =	CODIGOCAMARONERA_NEW,
				   @CodSector_NEW	  =	CODIGOSECTOR_NEW
		        FROM #idsControl 
				WHERE procesado=0
				order by idMuestreo

				SELECT @Count1  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPesoDetalle ap 
				WHERE ap.idMuestreo =@id

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPesoDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idMuestreo    = de.idMuestreo
				AND ap.idPiscina    = de.idPiscina
				WHERE ap.idMuestreo = @id
				AND de.zona         = @idZona
				AND de.camaronera   = @CodCamaronera
				AND de.sector       = @CodSector
				AND de.CODIGOZONA_NEW        = @idZona_NEW
				AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN

				  print 'INGRESO'
				  print 'INGRESO MOD SIMPLE'    +  
							 + '|' + cast(@id as varchar(15))    
						     + '|' + cast(@Count as varchar(15))
							 + '|' + cast(@Count1 as varchar(15))

				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera           = mp.CODIGOCAMARONERA_NEW,
						  A.sector               = mp.CODIGOSECTOR_NEW, 
				          A.estacionModificacion = @Modifica+'_MODCAB'
				   FROM    proMuestreoPeso A
				   inner join #idsControlDetalle mp
				     ON   A.zona                 = MP.zona
					 AND  A.camaronera           = MP.camaronera
					 AND  A.sector               = MP.sector
					 AND  A.idMuestreo           = MP.idMuestreo
			       WHERE  a.idMuestreo           = @id
				   	AND A.zona                   = @idZona
					AND A.camaronera             = @CodCamaronera
					AND A.sector                 = @CodSector
					AND mp.CODIGOZONA_NEW        = @idZona_NEW
				    AND mp.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				    AND mp.CODIGOSECTOR_NEW      = @CodSector_NEW
				END

				  IF(@Count != @Count1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0, @ultimaSecuenciaDetalle INT =0,@ultimaSecuenciaNueva INT=0, @IdsNecesarios INT=0;

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'MuestreoPeso'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'MuestreoPeso'  

						SET @IdsNecesarios         = (SELECT COUNT(1)
						                              FROM proMuestreoPesoDetalle 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idMuestreo            = de.idMuestreo
													     AND ap.idMuestreoDetalle = de.idMuestreoDetalle
				                                         AND ap.idPiscina         = de.idPiscina
				                                      WHERE ap.idMuestreo          = @id
													  AND zona                     = @idZona
					                                  AND camaronera               = @CodCamaronera
					                                  AND sector                   = @CodSector
													  AND de.CODIGOZONA_NEW        = @idZona_NEW
													  AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
													  AND de.CODIGOSECTOR_NEW      = @CodSector_NEW)

						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE  tabla = 'MuestreoPesoDetalle'

					print 
							 ''    + cast(@ultimaSecuenciaCabecera as varchar(15))    
							 + '|' + cast(@id as varchar(15))   
							 + '|' + cast(@ultimaSecuenciaDetalle as varchar(15))  
						     + '|' + cast(@Count as varchar(15))
							 + '|' + cast(@Count1 as varchar(15))

						--select @ultimaSecuenciaCabecera, @id, @IdsNecesarios
						--select @ultimaSecuenciaDetalle, @Count
						--crear la cabecera con los nuevos campos 
						
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
								,empresa
								,division
								,CODIGOZONA_NEW 
								,@ultimaSecuenciaCabecera
								,fechaRegistro
								,fechaMuestreo
								,CODIGOCAMARONERA_NEW 
								,CODIGOSECTOR_NEW 
								,descripcion
								,idResponsable
								,usuarioResponsable
								,tipoMuestreoDetalle
								,tipoMuestreo
								,estado
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,usuarioModificacion
								,@Modifica+'_CRE'
								,fechaHoraModificacion
								,responsable 
								,codigoRolPiscina
						FROM 	proMuestreoPeso A
					    INNER JOIN #idsControlDetalle MP 
						ON   A.idMuestreo = Mp.idMuestreo
						WHERE A.idMuestreo          = @id
						AND a.zona                  = @idZona
					    AND a.camaronera            = @CodCamaronera
					    AND a.sector                = @CodSector
						AND mp.CODIGOZONA_NEW        = @idZona_NEW
				        AND mp.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				        AND mp.CODIGOSECTOR_NEW      = @CodSector_NEW

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
		             SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoDetalle)  + @ultimaSecuenciaDetalle) 
								  ,@ultimaSecuenciaCabecera
								  ,orden
								  ,ap.idPiscina
								  ,cantidadTotal
								  ,longitudPromedio
								  ,longitudPromedioAnterior
								  ,fechaPesoAnterior
								  ,pesoLongitudTotal
								  ,pesoGramosTotal
								  ,pesoGramosAnterior
								  ,horaMuestreo
								  ,idPiscinaEjecucion
								  ,observacion
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica+'CRE'
								  ,fechaHoraModificacion
								  ,pesoPromedioReportado
						FROM    proMuestreoPesoDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idMuestreo         = de.idMuestreo
						AND ap.idMuestreoDetalle = de.idMuestreoDetalle
				        AND ap.idPiscina         = de.idPiscina
				        WHERE ap.idMuestreo      = @id
						AND zona                 = @idZona
					    AND camaronera           = @CodCamaronera
					    AND sector               = @CodSector
						AND de.CODIGOZONA_NEW        = @idZona_NEW
				        AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				        AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

					             
					--inactivo los detalle antiguo migrado a la nueva transaccion
						UPDATE  d SET activo               = 0, 
									  estacionModificacion = @Modifica+'_ANU'
						FROM  proMuestreoPesoDetalle d 
						INNER JOIN #idsControlDetalle de 
						ON d.idMuestreo         = de.idMuestreo
						AND d.idMuestreoDetalle = de.idMuestreoDetalle
						AND d.idPiscina         = de.idPiscina
						WHERE d.idMuestreo = @id
						AND zona           = @idZona
						AND camaronera     = @CodCamaronera
						AND sector         = @CodSector
						AND de.CODIGOZONA_NEW        = @idZona_NEW
				        AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				        AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

					UPDATE d
					SET d.idDetActual=(SELECT idMuestreoDetalle
					                   FROM  proMuestreoPesoDetalle de WITH (NOLOCK) 
					                   WHERE de.idMuestreo = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina),
					    d.idCabActual  = @ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idMuestreo = @id 
					AND zona           = @idZona
					AND camaronera     = @CodCamaronera
					AND sector         = @CodSector
					AND d.CODIGOZONA_NEW        = @idZona_NEW
				    AND d.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				    AND d.CODIGOSECTOR_NEW      = @CodSector_NEW
					
				IF(EXISTS(SELECT TOP 1 1 FROM proMuestreoPeso WHERE idMuestreo  = @id AND tipoMuestreo='PLONG'))
				BEGIN
                	DECLARE @IdsLong INT = (SELECT COUNT(1)
						                     FROM proMuestreoPesoLongitudDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle  = de.idMuestreoDetalle
				                             WHERE de.idMuestreo          = @id
											 AND zona					  = @idZona
					                         AND camaronera				  = @CodCamaronera
					                         AND sector					  = @CodSector
											 AND de.CODIGOZONA_NEW        = @idZona_NEW
											 AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
											 AND de.CODIGOSECTOR_NEW      = @CodSector_NEW), @ultimaSecuenciaL INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaL = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsLong  -- Valor arbitrario pero seguro
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
		              SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoLongitudDetalle)  + @ultimaSecuenciaL) 
								  ,de.idDetActual
								  ,orden
								  ,longitud
								  ,medidaLongitud
								  ,peso
								  ,medidaPeso
								  ,cantidadMuestra
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica+'_CRE'
								  ,fechaHoraModificacion
						FROM    proMuestreoPesoLongitudDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idMuestreoDetalle    = de.idMuestreoDetalle
				        WHERE de.idMuestreo        = @id
						AND zona                   = @idZona
					    AND camaronera             = @CodCamaronera
					    AND sector                 = @CodSector
					    AND de.CODIGOZONA_NEW        = @idZona_NEW
				        AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				        AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPesoLongitudDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle = de.idMuestreoDetalle
				    WHERE de.idMuestreo    = @id
					AND zona               = @idZona
					AND camaronera         = @CodCamaronera
					AND sector             = @CodSector
				    AND de.CODIGOZONA_NEW        = @idZona_NEW
				    AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				    AND de.CODIGOSECTOR_NEW      = @CodSector_NEW
			  END 
			  ELSE
			  BEGIN
                	DECLARE @IdsTalla INT = (SELECT COUNT(1)
						                     FROM proMuestreoPesoTallaDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle = de.idMuestreoDetalle
				                             WHERE de.idMuestreo     = @id
											 AND zona           = @idZona
					                         AND camaronera     = @CodCamaronera
					                         AND sector         = @CodSector
											 AND de.CODIGOZONA_NEW        = @idZona_NEW
											 AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
											 AND de.CODIGOSECTOR_NEW      = @CodSector_NEW), @ultimaSecuenciaT INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaT = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsTalla  -- Valor arbitrario pero seguro
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
		            SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoTallaDetalle)  + @ultimaSecuenciaT) 
								,de.idDetActual
								,orden
								,talla
								,cantidadMuestra
								,pesoGramos
								,activo
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,usuarioModificacion
								,@Modifica+'_CRE'
								,fechaHoraModificacion
					FROM    proMuestreoPesoTallaDetalle ap		
					INNER JOIN #idsControlDetalle de 
				    ON ap.idMuestreoDetalle    = de.idMuestreoDetalle
				    WHERE de.idMuestreo        = @id
					AND zona           = @idZona
					AND camaronera     = @CodCamaronera
					AND sector         = @CodSector
				    AND de.CODIGOZONA_NEW        = @idZona_NEW
				    AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				    AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPesoTallaDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle    = de.idMuestreoDetalle
				    WHERE de.idMuestreo       = @id
					AND zona           = @idZona
					AND camaronera     = @CodCamaronera
					AND sector         = @CodSector
					AND de.CODIGOZONA_NEW        = @idZona_NEW
				    AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				    AND de.CODIGOSECTOR_NEW      = @CodSector_NEW
			  END
             END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idMuestreo = @id	AND 
															  procesado	 = 0
															  AND zona           = @idZona
					                                          AND camaronera     = @CodCamaronera
					                                          AND sector         = @CodSector
															  AND  CODIGOZONA_NEW        = @idZona_NEW
															  AND  CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
															  AND  CODIGOSECTOR_NEW      = @CodSector_NEW


		END
--ROLLBACK TRAN
END 
