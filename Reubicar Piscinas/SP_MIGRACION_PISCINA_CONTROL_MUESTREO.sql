
CREATE PROCEDURE SP_MIGRACION_PISCINA_CONTROL_MUESTREO
AS
BEGIN
--BEGIN TRAN
		 DROP TABLE IF EXISTS #idsControlDetalle
		 DROP TABLE IF EXISTS #idsControl
		 
		   /*PROCESO  DE MUESTREOS DE PESOS */
          DECLARE @id INT = 0,
		       @Count INT = 0,
		      @Count1 INT = 0,
    @Modifica varchar(75) = 'MIGRACION_PISCINA_20250505';

		  SELECT DISTINCT  
		           de.idMuestreo
		          ,0 procesado
		          ,de.idMuestreoDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #idsControlDetalle
		  FROM proMuestreoPesoDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA 


		  SELECT DISTINCT 
		           idMuestreo
		          ,0 procesado
		  INTO #idsControl
		  FROM #idsControlDetalle


		  --SELECT * FROM  #idsControl
		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				     @id = idMuestreo
		        FROM #idsControl 
				WHERE procesado=0
				order by idMuestreo

				SELECT @Count1  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPesoDetalle ap 
				WHERE ap.idMuestreo =@id

				--if(@id=1284)
				--begin
				--SELECT *
				--FROM  proMuestreoPesoDetalle ap 
				--WHERE ap.idMuestreo =@id
				--end

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPesoDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idMuestreo    = de.idMuestreo
				AND ap.idPiscina    = de.idPiscina
				WHERE ap.idMuestreo = @id

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera           = mp.CODIGOCAMARONERA_NEW,
						  A.sector               = mp.CODIGOSECTOR_NEW, 
				          A.estacionModificacion = @Modifica+'_MOD'
				   FROM    tempMigracionPiscina MP 
				   INNER JOIN  proMuestreoPeso A
				     ON   A.zona                = MP.CODIGOZONA_OLD
					 AND  A.camaronera          = MP.CODIGOCAMARONERA_OLD
					 AND  A.sector              = MP.CODIGOSECTOR_OLD
			       WHERE  idMuestreo            = @id
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
				                                      WHERE ap.idMuestreo         = @id)

						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE  tabla = 'MuestreoPesoDetalle'


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
						          INNER JOIN tempMigracionPiscina d
								  ON mp.idPiscina   = d.IDPISCINA
						WHERE A.idMuestreo          = @id


							               

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
				                   ON ap.idMuestreo    = de.idMuestreo
				                   AND ap.idPiscina    = de.idPiscina
				        WHERE ap.idMuestreo            = @id
			

					             
			

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPesoDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreo    = de.idMuestreo
				    AND d.idPiscina    = de.idPiscina
				    WHERE d.idMuestreo = @id

				--if(@id=1284)
				--begin
				--				SELECT *
				--FROM  proMuestreoPesoDetalle ap 
				--WHERE ap.idMuestreo =@ultimaSecuenciaCabecera
				--end


					
					UPDATE d
					SET d.idDetActual=(SELECT idMuestreoDetalle
					                   FROM  proMuestreoPesoDetalle de WITH (NOLOCK) 
					                   WHERE de.idMuestreo = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina),
					    d.idCabActual  = @ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idMuestreo = @id 

			 --   if(@id=1284)
				--begin
				--				SELECT *
				--FROM  proMuestreoPesoDetalle ap 
				--WHERE ap.idMuestreo =@ultimaSecuenciaCabecera
				--end

                	DECLARE @IdsLong INT = (SELECT COUNT(1)
						                     FROM proMuestreoPesoLongitudDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle  = de.idMuestreoDetalle
				                             WHERE de.idMuestreo      = @id), @ultimaSecuenciaL INT=0;

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

					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPesoLongitudDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle = de.idMuestreoDetalle
				    WHERE de.idMuestreo    = @id


                	DECLARE @IdsTalla INT = (SELECT COUNT(1)
						                     FROM proMuestreoPesoTallaDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle = de.idMuestreoDetalle
				                             WHERE de.idMuestreo     = @id), @ultimaSecuenciaT INT=0;

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

					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPesoTallaDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle    = de.idMuestreoDetalle
				    WHERE de.idMuestreo       = @id

				   END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idMuestreo = @id	AND 
															  procesado	 = 0  


		END
--ROLLBACK TRAN
END