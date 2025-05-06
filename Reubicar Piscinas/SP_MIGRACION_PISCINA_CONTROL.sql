--CREATE PROCEDURE SP_MIGRACION_PISCINA_PARAMETROS_CONTROL
--AS
--BEGIN
BEGIN TRAN
		  /*PROCESO DE PARAMETROS DE CONTROL */
          DECLARE @id INT = 0,
		  @idZona CHAR(3) = '',
   @CodCamaronera CHAR(5) = '',
       @CodSector CHAR(5) = '',
		       @Count INT = 0,
		      @Count1 INT = 0,
   @Modifica varchar(75)  = 'MIGRACION_20250505_PISCINA';

		  SELECT DISTINCT 
		           de.idControlParametro
		          ,0 procesado
		          ,de.idControlParametroDetalle
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
		  FROM proControlParametroDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		     ON de.idPiscina          = mp.IDPISCINA  
		  INNER JOIN proControlParametro ca 
		     ON de.idControlParametro = ca.idControlParametro
		 
		  --WHERE (ca.zona <> mp.CODIGOZONA_NEW) OR ca.sector <> mp.CODIGOSECTOR_NEW)

		  SELECT DISTINCT 
		           idControlParametro
			      ,zona
				  ,camaronera
				  ,sector
		          ,0 procesado
		  INTO #idsControl
		  FROM #idsControlDetalle


		  --SELECT * FROM #idsControlDetalle
		  --SELECT * FROM #idsControl

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				         @id = idControlParametro,
			         @idZona = zona,
			  @CodCamaronera = camaronera,
			      @CodSector = sector
		        FROM #idsControl 
				WHERE procesado = 0 
				ORDER BY idControlParametro

				SELECT @Count1  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proControlParametroDetalle ap 
				WHERE ap.idControlParametro = @id

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proControlParametroDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idControlParametro         = de.idControlParametro
				--AND ap.idControlParametroDetalle = de.idControlParametroDetalle
				AND ap.idPiscina                 = de.idPiscina
				WHERE ap.idControlParametro      = @id
					AND de.zona                  = @idZona
					AND de.camaronera            = @CodCamaronera
					AND de.sector                = @CodSector

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera           = mp.CODIGOCAMARONERA_NEW,
						  A.sector               = mp.CODIGOSECTOR_NEW,
						  a.estacionModificacion = @Modifica +'_MOD'
				   FROM    tempMigracionPiscina MP 
				   INNER JOIN  proControlParametro A
				     ON   A.zona                 = MP.CODIGOZONA_OLD
					 AND  A.camaronera           = MP.CODIGOCAMARONERA_OLD
					 AND  A.sector               = MP.CODIGOSECTOR_OLD
			       WHERE  idControlParametro     = @id
				   	AND zona                     = @idZona
					AND camaronera               = @CodCamaronera
					AND sector                   = @CodSector
				END

				  IF(@Count != @Count1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT
						DECLARE @ultimaSecuenciaDetalle  INT
						DECLARE @ultimaSecuenciaNueva    INT

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'ControlParametro'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'ControlParametro'  

						DECLARE @IdsNecesarios INT = (SELECT COUNT(1)
						                              FROM proControlParametroDetalle 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idControlParametro       = de.idControlParametro
				                                         AND ap.idPiscina            = de.idPiscina
				                                      WHERE ap.idControlParametro    = @id
													  	AND zona                     = @idZona
					                                    AND camaronera               = @CodCamaronera
					                                    AND sector                   = @CodSector)

						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'ControlParametroDetalle'

						--select @ultimaSecuenciaCabecera, @id, @IdsNecesarios
						--select @ultimaSecuenciaDetalle, @Count
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
									,@Modifica +'_CRE'
									,fechaHoraModificacion
									,responsable 
									,codigoRolPiscina
					    FROM  proControlParametro A
							      INNER JOIN #idsControlDetalle MP 
								  ON   A.idControlParametro   = Mp.idControlParametro
						WHERE A.idControlParametro            = @id
							     AND a.zona                   = @idZona
					             AND a.camaronera             = @CodCamaronera
					             AND a.sector                 = @CodSector
						                


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
                         SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idControlParametroDetalle)  + @ultimaSecuenciaDetalle) 
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
								  ,@Modifica +'_CRE'
								  ,fechaHoraModificacion
								  ,IdPiscinaPuntosToma
						FROM    proControlParametroDetalle ap		
						INNER JOIN #idsControlDetalle de 
				                   ON ap.idControlParametro    = de.idControlParametro
				                   AND ap.idPiscina            = de.idPiscina
				        WHERE ap.idControlParametro            = @id
			                     AND de.zona                   = @idZona
					             AND de.camaronera             = @CodCamaronera
					             AND de.sector                 = @CodSector


						   

					--actualizo los SECUENCIALES DE DETALLE 
					--SELECT @ultimaSecuenciaNueva = MAX(idControlParametroDetalle)
					--FROM  proControlParametroDetalle  WITH (NOLOCK) 
					--WHERE idControlParametro = @ultimaSecuenciaCabecera 


					--UPDATE proSecuencial SET ultimaSecuencia = @ultimaSecuenciaNueva  
					--WHERE tabla = 'ControlParametroDetalle'--ahora si se cuantos ids utilizare 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proControlParametroDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idControlParametro    = de.idControlParametro
				    AND d.idPiscina            = de.idPiscina
				    WHERE d.idControlParametro = @id
					AND de.zona                = @idZona
					AND de.camaronera          = @CodCamaronera
					AND de.sector              = @CodSector

					
					UPDATE d
					SET d.idDetActual=(SELECT idControlParametroDetalle
					                   FROM  proControlParametroDetalle de WITH (NOLOCK) 
					                   WHERE de.idControlParametro = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina),
					    d.idCabActual          = @ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idControlParametro = @id 
				    AND d.zona                 = @idZona
					AND d.camaronera           = @CodCamaronera
					AND d.sector               = @CodSector



                	DECLARE @IdsValor INT = (SELECT COUNT(1)
						                     FROM proControlParametroValorDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idControlParametroDetalle    = de.idControlParametroDetalle
				                             WHERE de.idControlParametro        = @id
											 AND de.zona                 = @idZona
					                         AND de.camaronera           = @CodCamaronera
					                         AND de.sector               = @CodSector), @ultimaSecuenciaV INT=0;

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
		              SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idControlParametroValorDetalle)  + @ultimaSecuenciaV) 
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
								  ,@Modifica +'_CRE'
								  ,fechaHoraModificacion
						FROM    proControlParametroValorDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idControlParametroDetalle    = de.idControlParametroDetalle
				        WHERE de.idControlParametro        = @id

					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proControlParametroValorDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idControlParametroDetalle     = de.idControlParametroDetalle
				    WHERE de.idControlParametro        = @id

				   END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idControlParametro     = @id		    AND 
															  procesado				 = 0  
		  END

ROLLBACK TRAN
--END