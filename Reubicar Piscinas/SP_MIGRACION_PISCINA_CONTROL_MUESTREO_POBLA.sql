
CREATE PROCEDURE SP_MIGRACION_PISCINA_CONTROL_MUESTREO_POBLACION
AS
BEGIN
--BEGIN TRAN	 
		   /*PROCESO  DE MUESTREOS DE POBLACION */
          DECLARE @id INT = 0,
		       @Count INT = 0,
		      @Count1 INT = 0,
    @Modifica varchar(75) = 'HOLAMUNDO';

		  SELECT DISTINCT  
		           de.idMuestreo
		          ,0 procesado
		          ,de.idMuestreoDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #idsControlDetalle
		  FROM proMuestreoPoblacionDetalleLance de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA   
		  ORDER BY de.idMuestreo

		  SELECT DISTINCT 
		           idMuestreo
		          ,0 procesado
		  INTO #idsControl
		  FROM #idsControlDetalle
		  ORDER BY idMuestreo

		  SELECT * FROM  #idsControl
		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				     @id = idMuestreo
		        FROM #idsControl 
				WHERE procesado=0
				order by idMuestreo

				SELECT @Count1  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPoblacionDetalleLance ap 
				WHERE ap.idMuestreo =@id

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPoblacionDetalleLance ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idMuestreo=de.idMuestreo
				AND ap.idPiscina=de.idPiscina
				WHERE ap.idMuestreo =@id

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera           = mp.CODIGOCAMARONERA_NEW,
						  A.sector               = mp.CODIGOSECTOR_NEW, 
				          A.estacionModificacion = @Modifica
				   FROM    tempMigracionPiscina MP 
				   INNER JOIN  proMuestreoPoblacion A
				     ON   A.zona               = MP.CODIGOZONA_OLD
					 AND  A.camaronera         = MP.CODIGOCAMARONERA_OLD
					 AND  A.sector             = MP.CODIGOSECTOR_OLD
			       WHERE  idMuestreo           = @id
				END

				  IF(@Count != @Count1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0, @ultimaSecuenciaDetalle INT =0,@ultimaSecuenciaNueva INT=0, @IdsDeta INT=0;

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'MuestreoPoblacion'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'MuestreoPoblacion'  

						SET @IdsDeta         = (SELECT COUNT(1)
						                              FROM proMuestreoPoblacionDetalleLance 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idMuestreo       = de.idMuestreo
				                                         AND ap.idPiscina    = de.idPiscina
				                                      WHERE ap.idMuestreo    = @id)

						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + @IdsDeta  -- Valor arbitrario pero seguro
						WHERE  tabla = 'MuestreoPoblacionDetalleLance'


						select @ultimaSecuenciaCabecera, @id, @IdsDeta
						select @ultimaSecuenciaDetalle, @Count
						--crear la cabecera con los nuevos campos 
						
					INSERT INTO [dbo].[proMuestreoPoblacion]
							   ([idMuestreo]
							   ,[empresa]
							   ,[division]
							   ,[zona]
							   ,[secuencia]
							   ,[fechaRegistro]
							   ,[fechaMuestreo]
							   ,[camaronera]
							   ,[sector]
							   ,[idTiempo]
							   ,[idResponsable]
							   ,[usuarioResponsable]
							   ,[porLance]
							   ,[porMuestra]
							   ,[descripcion]
							   ,[estado]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion]
							   ,[idAtarraya]
							   ,[idMarea]
							   ,[idFaseLunar]
							   ,[responsable]
							   ,[atarrayador]
							   ,[bogador])
	                SELECT TOP 1  @ultimaSecuenciaCabecera 
								,empresa
								,division
								,CODIGOZONA_NEW 
								,@ultimaSecuenciaCabecera
								,fechaRegistro
								,fechaMuestreo
								,CODIGOCAMARONERA_NEW 
								,CODIGOSECTOR_NEW 
								,idTiempo
								,idResponsable
								,usuarioResponsable
								,porLance
								,porMuestra
								,descripcion
								,estado
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,usuarioModificacion
								,@Modifica
								,fechaHoraModificacion
								,idAtarraya
								,idMarea
								,idFaseLunar
								,responsable
								,atarrayador
								,bogador
						FROM 	proMuestreoPoblacion A
							      INNER JOIN #idsControlDetalle MP 
								  ON   A.idMuestreo=Mp.idMuestreo
						          INNER JOIN tempMigracionPiscina d
								  ON mp.idPiscina= d.IDPISCINA
						WHERE A.idMuestreo            = @id



			    INSERT INTO [dbo].[proMuestreoPoblacionDetalleLance]
								   ([idMuestreoDetalle]
								   ,[idMuestreo]
								   ,[orden]
								   ,[idPiscina]
								   ,[idPiscinaEjecucion]
								   ,[areaSuperficiehectarea]
								   ,[horaMuestreo]
								   ,[cantidadMuertos]
								   ,[cantidadMudados]
								   ,[cantidadBlandos]
								   ,[cantidadFlacidos]
								   ,[cantidadHongos]
								   ,[cantidadBacterias]
								   ,[cantidadBranqueasSucias]
								   ,[cantidadOtros]
								   ,[areaAtarraya]
								   ,[factorAtarrayador]
								   ,[numeroAnimales]
								   ,[porcentajeApertura]
								   ,[poblacionEstimada]
								   ,[observacion]
								   ,[activo]
								   ,[usuarioCreacion]
								   ,[estacionCreacion]
								   ,[fechaHoraCreacion]
								   ,[usuarioModificacion]
								   ,[estacionModificacion]
								   ,[fechaHoraModificacion]
								   ,[ubicacionCodigo]
								   ,[promedioNivelAgua]
								   ,[poblacionReportada])
		             SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoDetalle)  + @ultimaSecuenciaDetalle) 
								  ,@ultimaSecuenciaCabecera
								  ,orden
								  ,ap.idPiscina
								  ,idPiscinaEjecucion
								  ,areaSuperficiehectarea
								  ,horaMuestreo
								  ,cantidadMuertos
								  ,cantidadMudados
								  ,cantidadBlandos
								  ,cantidadFlacidos
								  ,cantidadHongos
								  ,cantidadBacterias
								  ,cantidadBranqueasSucias
								  ,cantidadOtros
								  ,areaAtarraya
								  ,factorAtarrayador
								  ,numeroAnimales
								  ,porcentajeApertura
								  ,poblacionEstimada
								  ,observacion
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica
								  ,fechaHoraModificacion
								  ,ubicacionCodigo
								  ,promedioNivelAgua
								  ,poblacionReportada
						FROM    proMuestreoPoblacionDetalleLance ap		
						INNER JOIN #idsControlDetalle de 
				                   ON ap.idMuestreo    = de.idMuestreo
				                   AND ap.idPiscina    = de.idPiscina
				        WHERE ap.idMuestreo            = @id
			

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica
					FROM  proMuestreoPoblacionDetalleLance d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreo    = de.idMuestreo
				    AND d.idPiscina    = de.idPiscina
				    WHERE d.idMuestreo = @id

					
					UPDATE d
					SET d.idDetActual=(SELECT idMuestreoDetalle
					                   FROM  proMuestreoPoblacionDetalleLance de WITH (NOLOCK) 
					                   WHERE de.idMuestreo = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina),
					    d.idCabActual=@ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idMuestreo = @id 



                	DECLARE @IdsC INT = (SELECT COUNT(1)
						                     FROM proMuestreoPoblacionDetalleLance 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle    = de.idMuestreoDetalle
				                             WHERE de.idMuestreo = @id), @ultimaSecuenciaC INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaC = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsC -- Valor arbitrario pero seguro
					WHERE tabla           = 'MuestreoPoblacionDetalleCaracteristica'


					
					INSERT INTO[dbo].[proMuestreoPoblacionDetalleCaracteristica]
							   ([idMuestreoCaracteristica]
							   ,[idMuestreo]
							   ,[idMuestreoDetalle]
							   ,[orden]
							   ,[idParametroControl]
							   ,[valor]
							   ,[idCualidad]
							   ,[activo]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion])
		              SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoCaracteristica)  + @ultimaSecuenciaC) 
								  ,@ultimaSecuenciaCabecera
								  ,de.idDetActual
								  ,orden
								  ,idParametroControl
								  ,valor
								  ,idCualidad
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica
								  ,fechaHoraModificacion
						FROM    proMuestreoPoblacionDetalleCaracteristica ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idMuestreoDetalle    = de.idMuestreoDetalle
				        WHERE de.idMuestreo        = @id

					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica
					FROM  proMuestreoPoblacionDetalleCaracteristica d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle    = de.idMuestreoDetalle
				    WHERE de.idMuestreo = @id


                	DECLARE @IdsP INT = (SELECT COUNT(1)
						                     FROM proMuestreoPoblacionProfundidadDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle    = de.idMuestreoDetalle
				                             WHERE de.idMuestreo        = @id), @ultimaSecuenciaP INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaP = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsP  -- Valor arbitrario pero seguro
					WHERE tabla           = 'MuestreoPoblacionProfundidadDetalle'


					
					
						INSERT INTO [dbo].[proMuestreoPoblacionProfundidadDetalle]
							   ([idMuestreoProfundidadDetalle]
							   ,[idMuestreoDetalle]
							   ,[orden]
							   ,[idProfundidad]
							   ,[cantidadLance]
							   ,[activo]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion]
							   ,[ubicacionCodigo]
							   ,[idParametroControlFresco]
							   ,[idParametroControlViejo]
							   ,[valorFresco]
							   ,[valorViejo])
		              SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoProfundidadDetalle)  + @ultimaSecuenciaP) 
								  ,de.idDetActual
								  ,orden
								  ,idProfundidad
								  ,cantidadLance
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica
								  ,fechaHoraModificacion
								  ,ubicacionCodigo
								  ,idParametroControlFresco
								  ,idParametroControlViejo
								  ,valorFresco
								  ,valorViejo
						FROM    proMuestreoPoblacionProfundidadDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idMuestreoDetalle    = de.idMuestreoDetalle
				        WHERE de.idMuestreo        = @id

					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica
					FROM  proMuestreoPoblacionProfundidadDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle    = de.idMuestreoDetalle
				    WHERE de.idMuestreo = @id

				   END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idMuestreo     = @id	AND 
															  procesado	     = 0  




		END
ROLLBACK TRAN
END

					