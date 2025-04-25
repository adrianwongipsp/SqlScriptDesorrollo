--CREATE PROCEDURE SP_MIGRACION_PISCINA_INVENTARIO
--AS
 

        DECLARE @Modifica VARCHAR(75)   = 'HOLAMUNDO'       
		        ,@ContarDetalle	    INT = 0
				,@Count             INT = 0;
 BEGIN TRY
		 ----Maestro: BODEGAS 
		  UPDATE B SET
				B.zona                 = MP.CODIGOZONA_NEW,
				B.camaronera           = MP.CODIGOCAMARONERA_NEW,
				B.sector               = MP.CODIGOSECTOR_NEW,
				B.nombre               = MP.SECTOR_NEW + NOMBREPISCINA,
				B.estacionModificacion = @Modifica
		 FROM   tempMigracionPiscina MP INNER JOIN INVBODEGA B 
		  ON    B.zona                 = MP.CODIGOZONA_OLD
		  AND   B.camaronera           = MP.CODIGOCAMARONERA_OLD
		  AND   B.sector               = MP.CODIGOSECTOR_OLD
		  AND   B.idPiscina            = MP.IDPISCINA

		--Proceso: aplicacion de item------------------------------------------------------------------------------------------------
          DECLARE @idAplicacionItem   INT=0;
		    
		  SELECT DISTINCT  
		           de.idAplicacionItem
		          ,0 procesado
		          ,de.idAplicacionItemDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #idsDetalle
		  FROM invAplicacionItemDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA   
		  

		  SELECT  DISTINCT 
		          ap.idAplicacionItem,
                  0 procesado
		  INTO #idsAplicacionItem 
		  FROM #idsDetalle ap

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsAplicacionItem WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@idAplicacionItem          = idAplicacionItem 
					    FROM	#idsAplicacionItem  
						WHERE	procesado = 0 
						ORDER BY idAplicacionItem;

			    SELECT @ContarDetalle  =  COUNT(DISTINCT idPiscina) 
				FROM  invAplicacionItemDetalle ap 
				WHERE idAplicacionItem = @idAplicacionItem; 

				SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  invAplicacionItemDetalle ap 
				INNER JOIN #idsDetalle de 
				ON ap.idAplicacionItem=de.idAplicacionItem
				AND ap.idPiscina=de.idPiscina
				WHERE ap.idAplicacionItem =@idAplicacionItem;

				IF(@ContarDetalle = @Count)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.codigoZONA           = mp.CODIGOZONA_NEW,
						  A.codigocamaronera     = mp.CODIGOCAMARONERA_NEW,
						  A.codigosector         = mp.CODIGOSECTOR_NEW,
						  a.estacionModificacion = @Modifica
				   FROM   tempMigracionPiscina MP INNER JOIN invAplicacionItem A
					 ON   A.codigoZona           = MP.CODIGOZONA_OLD
					AND   A.codigocamaronera     = MP.CODIGOCAMARONERA_OLD
					AND   A.codigosector         = MP.CODIGOSECTOR_OLD
				   WHERE  idAplicacionItem       = @idAplicacionItem
				END

				  IF(@ContarDetalle != @Count)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0,
						        @ultimaSecuenciaDetalle  INT=0,
						        @ultimaSecuenciaNueva    INT=0;

						UPDATE invSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'AplicacionItem'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM invSecuencial WHERE tabla = 'AplicacionItem'  

						DECLARE @IdsNecesarios INT = (SELECT COUNT(1) 
						                              FROM invAplicacionItemDetalle ap
													  INNER JOIN #idsDetalle de 
													  ON ap.idAplicacionItem    = de.idAplicacionItem
													  AND ap.idPiscina          = de.idPiscina
													  WHERE ap.idAplicacionItem = @idAplicacionItem)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla                 = 'AplicacionItemDetalle'

						--crear la cabecera con los nuevos campos 
						INSERT INTO invAplicacionItem ( 
						            idAplicacionItem
									,codigo
									,codigoEmpresa
									,codigoDivision
									,codigoZona
									,codigoCamaronera
									,codigoSector
									,fechaConsumo
									,linea
									,usuarioResponsable
									,estado
									,activo
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,estacionModificacion
									,fechaHoraModificacion
									,responsable)
                       SELECT TOP 1   @ultimaSecuenciaCabecera 
								,codigo
								,codigoEmpresa
								,codigoDivision
								,CODIGOZONA_NEW codigoZona
								,CODIGOCAMARONERA_NEW codigoCamaronera
								,CODIGOSECTOR_NEW codigoSector
								,fechaConsumo
								,linea
								,usuarioResponsable
								,estado
								,a.activo
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,@Modifica
								,estacionModificacion
								,fechaHoraModificacion
								,responsable 
						 FROM 	invAplicacionItem A
					     INNER JOIN #idsDetalle MP 
					     ON   A.idAplicacionItem            = Mp.idAplicacionItem
						 INNER JOIN tempMigracionPiscina d
						 ON mp.idPiscina= d.IDPISCINA
						 WHERE A.idAplicacionItem            = @idAplicacionItem
						

					  --crear los detalles por piscina con los nuevos campos 
						INSERT INTO invAplicacionItemDetalle(       
						             idAplicacionItemDetalle
									,idAplicacionItem
									,idPiscina
									,idPiscinaEjecucion
									,idItem
									,idRecepcionItems
									,idUsoItem
									,tipoOrigen
									,idMovimientoDetalle
									,cantidadDisponible
									,cantidadConsumida
									,cantidadSobrante
									,idPiscinaDestino
									,idPiscinaEjecucionDestino
									,activo
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,estacionModificacion
									,fechaHoraModificacion
									,idBodegaDestino
									,numeroLote)
					    SELECT     (ROW_NUMBER() OVER(ORDER BY idAplicacionItemDetalle)  + @ultimaSecuenciaDetalle) 
									,@ultimaSecuenciaCabecera 
									,ap.idPiscina
									,idPiscinaEjecucion
									,idItem
									,idRecepcionItems
									,idUsoItem
									,tipoOrigen
									,idMovimientoDetalle
									,cantidadDisponible
									,cantidadConsumida
									,cantidadSobrante
									,idPiscinaDestino
									,idPiscinaEjecucionDestino
									,activo
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,@Modifica
									,fechaHoraModificacion
									,idBodegaDestino
									,numeroLote
						FROM    invAplicacionItemDetalle ap		
						INNER JOIN #idsDetalle de 
				        ON ap.idAplicacionItem      = de.idAplicacionItem
				        AND ap.idPiscina            = de.idPiscina
				        WHERE ap.idAplicacionItem   = @idAplicacionItem


					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0,
                    estacionModificacion = @Modifica
					FROM  invAplicacionItemDetalle d 
					INNER JOIN #idsDetalle de 
				    ON d.idAplicacionItem    = de.idAplicacionItem
				    AND d.idPiscina          = de.idPiscina
				    WHERE d.idAplicacionItem = @idAplicacionItem
				   END
			
			       UPDATE #idsAplicacionItem SET procesado = 1 
				   WHERE idAplicacionItem        = @idAplicacionItem AND 
						 procesado				 = 0  
		  END


		  --DROP TABLE #idsDetalle
		  /*PROCESO DE PEDIDOS */

		  --SELECT TOP 1 * FROM invPedido
		  --SELECT TOP 1 * FROM invPedidoDetalle
          DECLARE @idPedido         INT=0;  

		  SELECT DISTINCT  
		           de.idPedido
		          ,0 procesado
		          ,de.idPedidoDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #ids2Detalle
		  FROM invPedidoDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA  


		  SELECT DISTINCT  idPedido,  
                           0 procesado
		  INTO #idsPedido
		  FROM #ids2Detalle 

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsPedido WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@idPedido          = idPedido
					    FROM	#idsPedido  
						WHERE	procesado = 0 
						ORDER BY idPedido;

				SELECT @ContarDetalle  =  COUNT(DISTINCT idPiscina) 
				FROM  invPedidoDetalle ap 
				WHERE idPedido = @idPedido; 

				SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  invPedidoDetalle ap 
				INNER JOIN #ids2Detalle de 
				ON ap.idPedidoDetalle=de.idPedidoDetalle
				AND ap.idPiscina=de.idPiscina
				WHERE ap.idPedido =@idPedido;


				 IF(@ContarDetalle=@Count)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				 BEGIN
				   UPDATE  A SET    
						   A.codigoZONA           = mp.CODIGOZONA_NEW,
						   A.codigocamaronera     = mp.CODIGOCAMARONERA_NEW,
						   A.codigosector         = mp.CODIGOSECTOR_NEW,
						   A.estacionModificacion = @Modifica
				   FROM    tempMigracionPiscina MP INNER JOIN invPedido A
					  ON   A.codigoZONA           = MP.CODIGOZONA_OLD
					  AND  A.codigocamaronera     = MP.CODIGOCAMARONERA_OLD
					  AND  A.codigosector         = MP.CODIGOSECTOR_OLD
				   WHERE idPedido                 = @idPedido
				  END

				  IF(@ContarDetalle!=@Count)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    SET @ultimaSecuenciaCabecera=0;
						SET @ultimaSecuenciaDetalle=0;
						SET @ultimaSecuenciaNueva=0;

						UPDATE invSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'Pedido'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM invSecuencial WHERE tabla = 'Pedido'  

						DECLARE @Ids INT = (SELECT COUNT(1) FROM invPedidoDetalle ap
						                     INNER JOIN #ids2Detalle de 
				                             ON ap.idPedido           = de.idPedido
				                             AND ap.idPiscina         = de.idPiscina
				                             WHERE ap.idPedidoDetalle = @idPedido)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @Ids  -- Valor arbitrario pero seguro
						WHERE tabla                 = 'PedidoDetalle'

						--crear la cabecera con los nuevos campos 
						INSERT INTO [dbo].[invPedido]
									   ([idPedido]
									   ,[codigo]
									   ,[codigoEmpresa]
									   ,[codigoDivision]
									   ,[codigoZona]
									   ,[codigoCamaronera]
									   ,[codigoSector]
									   ,[fechaPedido]
									   ,[codigoTipoPedido]
									   ,[linea]
									   ,[idBodega]
									   ,[usuarioSolicitante]
									   ,[estado]
									   ,[activo]
									   ,[usuarioCreacion]
									   ,[estacionCreacion]
									   ,[fechaHoraCreacion]
									   ,[usuarioModificacion]
									   ,[estacionModificacion]
									   ,[fechaHoraModificacion]
									   ,[estadoProceso]
									   ,[responsable]
									   ,[codigoRolPiscina]
									   ,[estadoRecepcion])
		                 SELECT  TOP 1   @ultimaSecuenciaCabecera
										,codigo
										,codigoEmpresa
										,codigoDivision
										,CODIGOZONA_NEW 
										,CODIGOCAMARONERA_NEW 
										,CODIGOSECTOR_NEW 
										,fechaPedido
										,codigoTipoPedido
										,linea
										,idBodega
										,usuarioSolicitante
										,estado
										,a.activo
										,usuarioCreacion
										,estacionCreacion
										,fechaHoraCreacion
										,usuarioModificacion
										,@Modifica
										,fechaHoraModificacion
										,estadoProceso
										,responsable
										,codigoRolPiscina
										,estadoRecepcion
						FROM 	   invPedido A
					    INNER JOIN #ids2Detalle MP 
					    ON   A.idPedido  = Mp.idPedido
						INNER JOIN tempMigracionPiscina d
					    ON mp.idPiscina  = d.IDPISCINA
						WHERE A.idPedido = @idPedido

					  --crear los detalles por piscina con los nuevos campos 
						INSERT INTO [dbo].[invPedidoDetalle]
									([idPedidoDetalle]
									,[idPedido]
									,[idPiscina]
									,[idPiscinaEjecucion]
									,[idLugarEntrega]
									,[idItem]
									,[idUsoItem]
									,[cantidadEnPiscina]
									,[cantidadPedida]
									,[idMovimientoDetalle]
									,[activo]
									,[usuarioCreacion]
									,[estacionCreacion]
									,[fechaHoraCreacion]
									,[usuarioModificacion]
									,[estacionModificacion]
									,[fechaHoraModificacion]
									,[motivoExtraordinario]
									,[observacion]
									,[estadoPedidoDetalle])
					    SELECT      (ROW_NUMBER() OVER(ORDER BY idPedidoDetalle)  + @ultimaSecuenciaDetalle) 
									,@ultimaSecuenciaCabecera 
									,ap.idPiscina
									,idPiscinaEjecucion
									,idLugarEntrega
									,idItem
									,idUsoItem
									,cantidadEnPiscina
									,cantidadPedida
									,idMovimientoDetalle
									,activo
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,@Modifica
									,fechaHoraModificacion
									,motivoExtraordinario
									,observacion
									,estadoPedidoDetalle
						FROM    invPedidoDetalle ap		
						INNER JOIN #ids2Detalle de 
				        ON ap.idPedido     = de.idPedido
				        AND ap.idPiscina   = de.idPiscina
				        WHERE ap.idPedido  = @idPedido  

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0,
                    estacionModificacion = @Modifica
					FROM  invPedidoDetalle d 
					INNER JOIN #ids2Detalle de 
				    ON d.idPedido        = de.idPedido
				    AND d.idPiscina      = de.idPiscina
				    WHERE d.idPedido     = @idPedido
					                                                      
																	  
				   END 
			
			       UPDATE #idsPedido SET procesado = 1 
				   WHERE  idPedido        = @idPedido AND 
						  procesado		  = 0  
		  END




		  		  /*PROCESO DE RECEPCION */

		  --SELECT TOP 1 * FROM invRecepcionItems
		  --SELECT TOP 1 * FROM invRecepcionItemsCabecera
		  --select top 100 * from invBodega where tipoBodega='00003'

          DECLARE @id         INT=0; 

		  SELECT DISTINCT  
		           de.idRecepcionItemsCabecera
		          ,0 procesado
		          ,de.idRecepcionItems
				  ,bo.idPiscina 
				  ,de.idBodegaDestino 
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #ids3Detalle
		  FROM invRecepcionItems de 
		  INNER JOIN  invBodega bo on de.idBodegaDestino=bo.idBodega AND  tipoBodega='00003'
		  INNER JOIN tempMigracionPiscina mp on bo.idPiscina = mp.IDPISCINA   


		  SELECT DISTINCT  idRecepcionItemsCabecera,  
                           0 procesado
		  INTO #idsRecepcion
		  FROM #ids3Detalle 


		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsRecepcion WHERE procesado = 0)
		  BEGIN
				        SELECT TOP 1	@id = idRecepcionItemsCabecera
					    FROM	#idsRecepcion  
						WHERE	procesado  = 0
						ORDER BY idRecepcionItemsCabecera;

				SELECT @ContarDetalle  = COUNT(DISTINCT idBodegaDestino) 
				FROM  invRecepcionItems  
				WHERE idRecepcionItemsCabecera = @id ; 

				SELECT @Count         =  COUNT(DISTINCT ap.idBodegaDestino) 
				FROM  invRecepcionItems ap 
				INNER JOIN #ids3Detalle de 
				ON ap.idRecepcionItems            = de.idRecepcionItems
				AND ap.idBodegaDestino            = de.idBodegaDestino
				WHERE ap.idRecepcionItemsCabecera = @id;

				 IF(@ContarDetalle=@Count)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				 BEGIN
				   UPDATE A SET    
						  A.codigoZONA           = mp.CODIGOZONA_NEW,
						  A.codigocamaronera     = mp.CODIGOCAMARONERA_NEW,
						  A.codigosector         = mp.CODIGOSECTOR_NEW,
						  a.estacionModificacion = @Modifica
				   FROM   tempMigracionPiscina MP INNER JOIN invRecepcionItemsCabecera A
					ON    A.codigoZONA           = MP.CODIGOZONA_OLD
					AND   A.codigocamaronera     = MP.CODIGOCAMARONERA_OLD
					AND   A.codigosector         = MP.CODIGOSECTOR_OLD
				   WHERE   idRecepcionItemsCabecera   = @id
				 END

				  IF(@ContarDetalle!=@Count)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   BEGIN
						 --separamaos los secuenciles para la creacion
					    SET @ultimaSecuenciaCabecera=0;
						SET @ultimaSecuenciaDetalle=0;
						SET @ultimaSecuenciaNueva=0;

						UPDATE invSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'RecepcionItemsCabecera'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM invSecuencial WHERE tabla = 'RecepcionItemsCabecera'  

						DECLARE @IdsR INT = (SELECT COUNT(1) FROM invRecepcionItems x
						                                    INNER JOIN  #ids3Detalle de ON
															x.idRecepcionItemsCabecera       = de.idRecepcionItemsCabecera AND
															x.idBodegaDestino                = de.idBodegaDestino
															WHERE x.idRecepcionItemsCabecera = @id)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsR  -- Valor arbitrario pero seguro
						WHERE tabla                 = 'RecepcionItems'

						--crear la cabecera con los nuevos campos 
						INSERT INTO [dbo].[invRecepcionItemsCabecera]
								   ([idRecepcionItemsCabecera]
								   ,[codigoEmpresa]
								   ,[codigoDivision]
								   ,[codigoZona]
								   ,[codigoCamaronera]
								   ,[codigoSector]
								   ,[fechaRecepcion]
								   ,[linea]
								   ,[usuarioResponsable]
								   ,[responsable]
								   ,[estado]
								   ,[activo]
								   ,[usuarioCreacion]
								   ,[estacionCreacion]
								   ,[fechaHoraCreacion]
								   ,[usuarioModificacion]
								   ,[estacionModificacion]
								   ,[fechaHoraModificacion])
						SELECT   TOP 1  @ultimaSecuenciaCabecera
									,codigoEmpresa
									,codigoDivision
									,CODIGOZONA_NEW 
									,CODIGOCAMARONERA_NEW 
									,CODIGOSECTOR_NEW 
									,fechaRecepcion
									,linea
									,usuarioResponsable
									,responsable
									,estado
									,a.activo
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,@Modifica
									,fechaHoraModificacion
						FROM  invRecepcionItemsCabecera A
						INNER JOIN #ids3Detalle MP 
						ON   A.idRecepcionItemsCabecera  = Mp.idRecepcionItemsCabecera
						INNER JOIN tempMigracionPiscina d
				        ON mp.idPiscina                  = d.IDPISCINA
						WHERE A.idRecepcionItemsCabecera = @id
		

					  --crear los detalles por piscina con los nuevos campos 
						INSERT INTO [dbo].[invRecepcionItems]
									([idRecepcionItems]
									,[idBodegaOrigen]
									,[idBodegaDestino]
									,[idItem]
									,[cantidadReceptada]
									,[idDespachoLote]
									,[idMovimientoDetalle]
									,[fechaRecepcion]
									,[estado]
									,[activo]
									,[usuarioCreacion]
									,[estacionCreacion]
									,[fechaHoraCreacion]
									,[usuarioModificacion]
									,[estacionModificacion]
									,[fechaHoraModificacion]
									,[idPedidoDetalle]
									,[unidadMedida]
									,[cantidadAplicada]
									,[cantidadSobrante]
									,[numeroLote]
									,[linea]
									,[idRecepcionItemsCabecera])
					    SELECT   (row_number() over(order by idRecepcionItems)  + @ultimaSecuenciaDetalle) 
								,idBodegaOrigen
								,de.idBodegaDestino
								,idItem
								,cantidadReceptada
								,idDespachoLote
								,idMovimientoDetalle
								,fechaRecepcion
								,estado
								,activo
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,usuarioModificacion
								,@Modifica
								,fechaHoraModificacion
								,idPedidoDetalle
								,unidadMedida
								,cantidadAplicada
								,cantidadSobrante
								,numeroLote
								,linea
								,@ultimaSecuenciaCabecera 
						FROM    invRecepcionItems ap		
						INNER JOIN #ids3Detalle de 
				        ON ap.idRecepcionItemsCabecera    = de.idRecepcionItemsCabecera
				        AND ap.idBodegaDestino    = de.idBodegaDestino
				        WHERE ap.idRecepcionItemsCabecera = @id 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					 UPDATE  d SET activo = 0,
					 estacionModificacion = @Modifica
					 FROM  invRecepcionItems d
					 INNER JOIN #ids3Detalle de 
				     ON d.idRecepcionItemsCabecera    = de.idRecepcionItemsCabecera
				     AND d.idBodegaDestino            = de.idBodegaDestino
				     WHERE d.idRecepcionItemsCabecera = @id 
				   END
			
			       UPDATE #idsRecepcion SET procesado = 1
				   WHERE  idRecepcionItemsCabecera    = @id	 AND 
					      procesado		              = 0  
		  END
		
ROLLBACK TRAN