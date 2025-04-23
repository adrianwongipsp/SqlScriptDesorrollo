CREATE PROCEDURE SP_MIGRACION_PISCINA_CONTROL
AS
BEGIN
		  /*PROCESO DE PARAMETROS DE CONTROL */
          DECLARE @id             INT=0; 
		  DECLARE @Count INT=0;  

		  SELECT DISTINCT  de.idControlParametro
		          ,0 procesado
		          ,de.idControlParametroDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #idsControlDetalle
		  FROM proControlParametroDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA   
		  ORDER BY de.idControlParametro

		  SELECT DISTINCT  idControlParametro
		          ,0 procesado
		  INTO #idsControl
		  FROM #idsControlDetalle
		  ORDER BY idControlParametro

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@id = idControlParametro
		        FROM #idsControl 
				WHERE procesado=0

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proControlParametroDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idControlParametro=de.idControlParametro
				AND ap.idPiscina=de.idPiscina
				WHERE ap.idControlParametro =@id

				IF(@Count = 1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona       = mp.CODIGOZONA_NEW,
						  A.camaronera = mp.CODIGOCAMARONERA_NEW,
						  A.sector     = mp.CODIGOSECTOR_NEW  
				   FROM    tempMigracionPiscina MP 
				   INNER JOIN  proControlParametro A
				     ON   A.zona               = MP.CODIGOZONA_OLD
					 AND  A.camaronera         = MP.CODIGOCAMARONERA_OLD
					 AND  A.sector             = MP.CODIGOSECTOR_OLD
			       WHERE  idControlParametro   = @id
				END

				  IF(@Count > 1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT
						DECLARE @ultimaSecuenciaDetalle  INT
						DECLARE @ultimaSecuenciaNueva    INT

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'ControlParametro'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'ControlParametro'  

						DECLARE @IdsNecesarios INT = (SELECT COUNT(1)
						                              FROM proControlParametroDetalle 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idControlParametro       = de.idControlParametro
				                                         AND ap.idPiscina            = de.idPiscina
				                                      WHERE ap.idControlParametro = @id)

						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'ControlParametroDetalle'
						--proControlParametroValorDetalle
						--crear la cabecera con los nuevos campos 
						
						INSERT INTO [dbo].[proControlParametro]
								   ([idControlParametro]
								   ,[empresa]
								   ,[division]
								   ,[zona]
								   ,[secuencia]
								   ,[fechaRegistro]
								   ,[fechaControl]
								   ,[horaControl]
								   ,[camaronera]
								   ,[sector]
								   ,[longitud]
								   ,[latitud]
								   ,[idResponsable]
								   ,[usuarioResponsable]
								   ,[tiposParametro]
								   ,[descripcion]
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
									,fechaControl
									,horaControl
									,CODIGOCAMARONERA_NEW 
									,CODIGOSECTOR_NEW 
									,longitud
									,latitud
									,idResponsable
									,usuarioResponsable
									,tiposParametro
									,descripcion
									,estado
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,estacionModificacion
									,fechaHoraModificacion
									,responsable 
									,codigoRolPiscina
						FROM 	  tempMigracionPiscina MP INNER JOIN proControlParametro A
								  ON   A.zona                 = MP.CODIGOZONA_OLD
								  AND  A.camaronera           = MP.CODIGOCAMARONERA_OLD
								  AND  A.sector               = MP.CODIGOSECTOR_OLD
						WHERE A.idControlParametro            = @id

						--select top 1 * From proControlParametro order by idControlParametro desc
					    --crear los detalles por piscina con los nuevos campos 
						INSERT INTO [dbo].[proControlParametroDetalle]
								   ([idControlParametroDetalle]
								   ,[idControlParametro]
								   ,[orden]
								   ,[idParametroControl]
								   ,[idPiscina]
								   ,[horaRegistro]
								   ,[valor]
								   ,[idPiscinaEjecucion]
								   ,[observacion]
								   ,[activo]
								   ,[usuarioCreacion]
								   ,[estacionCreacion]
								   ,[fechaHoraCreacion]
								   ,[usuarioModificacion]
								   ,[estacionModificacion]
								   ,[fechaHoraModificacion]
								   ,[IdPiscinaPuntosToma])
                         SELECT   (ROW_NUMBER() OVER(ORDER BY idControlParametroDetalle)  + @ultimaSecuenciaDetalle) 
								  ,@ultimaSecuenciaCabecera
								  ,orden
								  ,idParametroControl
								  ,ap.idPiscina
								  ,horaRegistro
								  ,valor
								  ,idPiscinaEjecucion
								  ,observacion
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,estacionModificacion
								  ,fechaHoraModificacion
								  ,IdPiscinaPuntosToma
						FROM    proControlParametroDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idControlParametro    = de.idControlParametro
				        AND ap.idPiscina            = de.idPiscina
				        WHERE ap.idControlParametro = @id

					--actualizo los SECUENCIALES DE DETALLE 
					SELECT @ultimaSecuenciaNueva = MAX(idControlParametroDetalle)
					FROM  proControlParametroDetalle  WITH (NOLOCK) 
					WHERE idControlParametro = @ultimaSecuenciaCabecera 


					UPDATE proSecuencial SET ultimaSecuencia = @ultimaSecuenciaNueva  
					WHERE tabla = 'ControlParametroDetalle'--ahora si se cuantos ids utilizare 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0 
					FROM  proControlParametroDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idControlParametro    = de.idControlParametro
				    AND d.idPiscina            = de.idPiscina
				    WHERE d.idControlParametro = @id

					
					UPDATE d
					SET d.idDetActual=(SELECT idControlParametroDetalle
					                   FROM  proControlParametroDetalle de WITH (NOLOCK) 
					                   WHERE de.idControlParametro = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina),
					    d.idCabActual=@ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idControlParametro = @id 


                	DECLARE @IdsValor INT = (SELECT COUNT(1)
						                     FROM proControlParametroValorDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idControlParametroDetalle    = de.idControlParametroDetalle
				                             WHERE de.idControlParametro = @id), @ultimaSecuenciaV INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaV = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsValor  -- Valor arbitrario pero seguro
					WHERE tabla = 'ControlParametroValorDetalle'


					
				INSERT INTO [dbo].[proControlParametroValorDetalle]
						   ([idControlParametroValorDetalle]
						   ,[idControlParametroDetalle]
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
		              SELECT   (ROW_NUMBER() OVER(ORDER BY de.idDetActual)  + @ultimaSecuenciaV) 
								  ,de.idDetActual
								  ,orden
								  ,idParametroControl
								  ,valor
								  ,idCualidad
								  ,valor
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,estacionModificacion
								  ,fechaHoraModificacion
						FROM    proControlParametroValorDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idControlParametroDetalle    = de.idControlParametroDetalle
				        WHERE de.idControlParametro = @id

					UPDATE  d SET activo = 0 
					FROM  proControlParametroValorDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idControlParametroDetalle    = de.idControlParametroDetalle
				    WHERE de.idControlParametro = @id

				   END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idControlParametro     = @id		    AND 
															  procesado				 = 0  
		  END




		  DROP TABLE #idsControlDetalle;
		  DROP TABLE #idsControl;
		 
		   /*PROCESO  DE MUESTREOS DE PESOS */
           SET @id    =0; 
		   SET @Count =0;  

		  SELECT DISTINCT  de.idMuestreo
		          ,0 procesado
		          ,de.idMuestreoDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #idsControlDetalle
		  FROM proMuestreoPesoDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA   
		  ORDER BY de.idMuestreo

		  SELECT DISTINCT  idMuestreo
		          ,0 procesado
		  INTO #idsControl
		  FROM #idsControlDetalle
		  ORDER BY idMuestreo

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@id = idMuestreo
		        FROM #idsControl 
				WHERE procesado=0

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPesoDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idMuestreo=de.idMuestreo
				AND ap.idPiscina=de.idPiscina
				WHERE ap.idMuestreo =@id

				IF(@Count = 1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona       = mp.CODIGOZONA_NEW,
						  A.camaronera = mp.CODIGOCAMARONERA_NEW,
						  A.sector     = mp.CODIGOSECTOR_NEW  
				   FROM    tempMigracionPiscina MP 
				   INNER JOIN  proMuestreoPeso A
				     ON   A.zona               = MP.CODIGOZONA_OLD
					 AND  A.camaronera         = MP.CODIGOCAMARONERA_OLD
					 AND  A.sector             = MP.CODIGOSECTOR_OLD
			       WHERE  idMuestreo           = @id
				END

				  IF(@Count > 1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    SET @ultimaSecuenciaCabecera =0;
						SET @ultimaSecuenciaDetalle  =0;
						SET @ultimaSecuenciaNueva    =0;

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'MuestreoPeso'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'MuestreoPeso'  

						SET @IdsNecesarios         = (SELECT COUNT(1)
						                              FROM proMuestreoPesoDetalle 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idMuestreo       = de.idMuestreo
				                                         AND ap.idPiscina    = de.idPiscina
				                                      WHERE ap.idMuestreo    = @id)

						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'MuestreoPesoDetalle'
						--proControlParametroValorDetalle
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
									,estacionModificacion
									,fechaHoraModificacion
									,responsable 
									,codigoRolPiscina
						FROM 	  tempMigracionPiscina MP INNER JOIN proMuestreoPeso A
								  ON   A.zona                 = MP.CODIGOZONA_OLD
								  AND  A.camaronera           = MP.CODIGOCAMARONERA_OLD
								  AND  A.sector               = MP.CODIGOSECTOR_OLD
						WHERE A.idMuestreo                    = @id
			END
		END
END