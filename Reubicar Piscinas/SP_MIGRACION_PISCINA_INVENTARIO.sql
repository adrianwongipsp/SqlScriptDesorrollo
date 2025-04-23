CREATE PROCEDURE SP_MIGRACION_PISCINA_INVENTARIO
AS
BEGIN
		 ----Maestro: BODEGAS 
		  UPDATE B SET
				B.zona       = MP.CODIGOZONA_NEW,
				B.camaronera = MP.CODIGOCAMARONERA_NEW,
				B.sector     = MP.CODIGOSECTOR_NEW,
				B.nombre     = MP.SECTOR_NEW + NOMBREPISCINA
		 FROM  
				 tempMigracionPiscina MP INNER JOIN INVBODEGA B 
		  ON     B.zona       = MP.CODIGOZONA_OLD
		  AND    B.camaronera = MP.CODIGOCAMARONERA_OLD
		  AND    B.sector     = MP.CODIGOSECTOR_OLD
		  AND    B.idPiscina  = MP.IDPISCINA

		--Proceso: aplicacion de item------------------------------------------------------------------------------------------------
          DECLARE @idAplicacionItem         INT; 
		  --DECLARE @idAplicacionItemDetalle  INT; 
		  DECLARE @IdplicacionItemPiscina   INT; 
		  DECLARE @ContarDetalle			INT;  

		  SELECT  distinct ap.idAplicacionItem,--, ap.idAplicacionItemDetalle, 
				  ap.idPiscina ,		0 procesado
			INTO #idsAplicacionItem 
		  FROM invAplicacionItemDetalle ap INNER JOIN tempMigracionPiscina mp ON ap.idPiscina = mp.IDPISCINA   

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsAplicacionItem WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@idAplicacionItem          = idAplicacionItem, 
								---@idAplicacionItemDetalle   = idAplicacionItemDetalle,
								@IdplicacionItemPiscina    = idPiscina 
					    FROM	#idsAplicacionItem  
						WHERE	procesado = 0 

			    SELECT @ContarDetalle  =  COUNT(DISTINCT idPiscina) FROM  invAplicacionItemDetalle ap WHERE idAplicacionItem = @idAplicacionItem --and activo = 1 

				IF(@ContarDetalle = 1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				  BEGIN
				   UPDATE A SET    
						  A.codigoZONA       = mp.CODIGOZONA_NEW,
						  A.codigocamaronera = mp.CODIGOCAMARONERA_NEW,
						  A.codigosector     = mp.CODIGOSECTOR_NEW  
					 FROM 
							tempMigracionPiscina MP INNER JOIN invAplicacionItem A
					   ON   A.codigoZONA       = MP.CODIGOZONA_OLD
					   AND   A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
					   AND   A.codigosector     = MP.CODIGOSECTOR_OLD
					 WHERE 
						    idAplicacionItem   = @idAplicacionItem
				  END

				  IF(@ContarDetalle > 1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT
						DECLARE @ultimaSecuenciaDetalle  INT
						DECLARE @ultimaSecuenciaNueva    INT

						UPDATE invSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'AplicacionItem'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM invSecuencial WHERE tabla = 'AplicacionItem'  

						DECLARE @IdsNecesarios INT = (SELECT COUNT(1) FROM invAplicacionItemDetalle WHERE idAplicacionItem = @idAplicacionItem AND idPiscina = @IdplicacionItemPiscina)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'AplicacionItemDetalle'

						--crear la cabecera con los nuevos campos 
						INSERT INTO invAplicacionItem ( idAplicacionItem
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
					    SELECT                          @ultimaSecuenciaCabecera idAplicacionItem
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
														,usuarioModificacion
														,estacionModificacion
														,fechaHoraModificacion
														,responsable 
						FROM 	 tempMigracionPiscina MP INNER JOIN invAplicacionItem A
								  ON   A.codigoZONA         = MP.CODIGOZONA_OLD
								  AND   A.codigocamaronera  = MP.CODIGOCAMARONERA_OLD
								  AND   A.codigosector      = MP.CODIGOSECTOR_OLD
								 WHERE A.idAplicacionItem   = @idAplicacionItem

					  --crear los detalles por piscina con los nuevos campos 
						INSERT INTO invAplicacionItemDetalle(        idAplicacionItemDetalle
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

					    SELECT                                       (ROW_NUMBER() OVER(ORDER BY idAplicacionItemDetalle)  + @ultimaSecuenciaDetalle) AS idAplicacionItemDetalle
																	,@ultimaSecuenciaCabecera idAplicacionItem
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
																	,numeroLote
						FROM 		  invAplicacionItemDetalle WHERE idPiscina = @IdplicacionItemPiscina AND idAplicacionItem = @idAplicacionItem 

					--actualizo los SECUENCIALES DE DETALLE 
					SELECT @ultimaSecuenciaNueva = MAX(idAplicacionItemDetalle)
					FROM invAplicacionItemDetalle  WITH (NOLOCK) 
					WHERE idAplicacionItem = @ultimaSecuenciaCabecera 

					UPDATE invSecuencial SET ultimaSecuencia = @ultimaSecuenciaNueva  WHERE tabla = 'AplicacionItemDetalle'--ahora si se cuantos ids utilizare 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0 FROM  invAplicacionItemDetalle d WHERE idPiscina = @IdplicacionItemPiscina AND idAplicacionItem =  @idAplicacionItem --AND idAplicacionItemDetalle = @idAplicacionItemDetalle
				   END 
			
			       UPDATE #idsAplicacionItem SET procesado = 1 WHERE idAplicacionItem        = @idAplicacionItem		 AND 
															         --idAplicacionItemDetalle = @idAplicacionItemDetalle  AND 
															         idPiscina				 = @IdplicacionItemPiscina   AND
															         procesado				 = 0  
		  END



		  /*PROCESO DE PEDIDOS */

		  --SELECT TOP 1 * FROM invPedido
		  --SELECT TOP 1 * FROM invPedidoDetalle
          DECLARE @idPedido         INT;  
		  DECLARE @idPedidoPiscina  INT;
		  DECLARE @Count		INT;  

		  SELECT DISTINCT  de.idPedido,  
				  de.idPiscina ,  0 procesado
			INTO #idsPedido
		  FROM invPedidoDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina = mp.IDPISCINA   

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsPedido WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@idPedido          = idPedido, 
								@idPedidoPiscina    = idPiscina 
					    FROM	#idsPedido  
						WHERE	procesado = 0 

			    SELECT @Count  =  COUNT(DISTINCT idPiscina) FROM  invPedidoDetalle ap WHERE idPedido = @idPedido

				 IF(@Count = 1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				  BEGIN
				   UPDATE  A SET    
						   A.codigoZONA       = mp.CODIGOZONA_NEW,
						   A.codigocamaronera = mp.CODIGOCAMARONERA_NEW,
						   A.codigosector     = mp.CODIGOSECTOR_NEW  
				   FROM    tempMigracionPiscina MP INNER JOIN invPedido A
					  ON   A.codigoZONA       = MP.CODIGOZONA_OLD
					  AND  A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
					  AND  A.codigosector     = MP.CODIGOSECTOR_OLD
				   WHERE idPedido   = @idPedido
				  END

				  IF(@Count > 1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    SET @ultimaSecuenciaCabecera=0;
						SET @ultimaSecuenciaDetalle=0;
						SET @ultimaSecuenciaNueva=0;

						UPDATE invSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'Pedido'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM invSecuencial WHERE tabla = 'Pedido'  

						DECLARE @Ids INT = (SELECT COUNT(1) FROM invPedidoDetalle WHERE idPedido = @idPedido AND idPiscina = @idPedidoPiscina)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'PedidoDetalle'

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
		                 SELECT         @ultimaSecuenciaCabecera
										,codigo
										,codigoEmpresa
										,codigoDivision
										,CODIGOZONA_NEW 
										,CODIGOCAMARONERA_NEW 
										,CODIGOSECTOR_NEW 
										,fechaPedido
										,linea
										,idBodega
										,usuarioSolicitante
										,estado
										,a.activo
										,usuarioCreacion
										,estacionCreacion
										,fechaHoraCreacion
										,usuarioModificacion
										,estacionModificacion
										,fechaHoraModificacion
										,estadoProceso
										,responsable
										,codigoRolPiscina
										,estadoRecepcion
						FROM 	   tempMigracionPiscina MP INNER JOIN invPedido A
								   ON   A.codigoZONA        = MP.CODIGOZONA_OLD
								   AND   A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
								   AND   A.codigosector     = MP.CODIGOSECTOR_OLD
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
															,idPiscina
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
															,estacionModificacion
															,fechaHoraModificacion
															,motivoExtraordinario
															,observacion
															,estadoPedidoDetalle
						FROM 	 invPedidoDetalle 
						WHERE    idPiscina = @idPedidoPiscina 
						     AND idPedido  = @idPedido 

					--actualizo los SECUENCIALES DE DETALLE 
					SELECT @ultimaSecuenciaNueva = MAX(idPedidoDetalle) FROM invPedidoDetalle  WITH (NOLOCK) WHERE idPedido = @ultimaSecuenciaCabecera 
					UPDATE invSecuencial SET ultimaSecuencia = @ultimaSecuenciaNueva  WHERE tabla = 'PedidoDetalle'--ahora si se cuantos ids utilizare 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0 FROM  invPedidoDetalle d WHERE idPedido        = @idPedido
					                                                    AND idPiscina       = @IdplicacionItemPiscina 
					                                                      
																	  
				   END 
			
			       UPDATE #idsPedido SET procesado = 1 WHERE  idPedido        = @idPedido		  AND 
															  idPiscina		  = @IdPedidoPiscina  AND
															  procesado		  = 0  
		  END




		  		  /*PROCESO DE RECEPCION */

		  --SELECT TOP 1 * FROM invRecepcionItems
		  --SELECT TOP 1 * FROM invRecepcionItemsCabecera
		  --select top 100 * from invBodega where tipoBodega='00003'

          DECLARE @id         INT; 
		  DECLARE @idDetalle  INT; 
		  DECLARE @idPiscina  INT;
		  DECLARE @idBodega INT;
		  SET @Count=0;  

		  SELECT DISTINCT de.idRecepcionItemsCabecera,
				  bo.idPiscina,		           0 procesado        , de.idBodegaDestino 
		  INTO #idsRecepcion
		  FROM invRecepcionItems de 
		  INNER JOIN  invBodega bo on de.idBodegaDestino=bo.idBodega AND  tipoBodega='00003'
		  INNER JOIN tempMigracionPiscina mp on bo.idPiscina = mp.IDPISCINA   

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsRecepcion WHERE procesado = 0)
		  BEGIN
				        SELECT TOP 1	@id          = idRecepcionItemsCabecera, 
								        @idPiscina   = idPiscina,
								        @idBodega    = idBodegaDestino
					    FROM	#idsRecepcion  
						WHERE	procesado = 0 

			     SELECT @Count  =  COUNT(distinct idBodegaDestino) FROM  invRecepcionItems ap WHERE idRecepcionItemsCabecera = @id --and activo = 1 

				 IF(@Count = 1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				  BEGIN
				   UPDATE A SET    
						  A.codigoZONA       = mp.CODIGOZONA_NEW,
						  A.codigocamaronera = mp.CODIGOCAMARONERA_NEW,
						  A.codigosector     = mp.CODIGOSECTOR_NEW  
				  FROM   tempMigracionPiscina MP INNER JOIN invRecepcionItemsCabecera A
					ON    A.codigoZONA       = MP.CODIGOZONA_OLD
					AND   A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
					AND   A.codigosector     = MP.CODIGOSECTOR_OLD
				  WHERE   idRecepcionItemsCabecera   = @id
				  END

				  IF(@Count > 1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   BEGIN
						 --separamaos los secuenciles para la creacion
					    SET @ultimaSecuenciaCabecera=0;
						SET @ultimaSecuenciaDetalle=0;
						SET @ultimaSecuenciaNueva=0;

						UPDATE invSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'RecepcionItemsCabecera'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM invSecuencial WHERE tabla = 'RecepcionItemsCabecera'  

						DECLARE @IdsR INT = (SELECT COUNT(1) FROM invRecepcionItems x
						                                    INNER JOIN  invBodega bo 
															ON    x.idBodegaDestino = bo.idBodega 
														    AND   bo.tipoBodega     = '00003'
															WHERE x.idRecepcionItemsCabecera = @id 
															AND   bo.idPiscina               = @idPiscina)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'RecepcionItems'

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
						SELECT       @ultimaSecuenciaCabecera
									,codigoEmpresa
									,codigoDivision
									,CODIGOZONA_NEW 
									,CODIGOCAMARONERA_NEW 
									,CODIGOSECTOR_NEW 
									,fechaRecepcion
									,linea
									,usuarioResponsable
									,estado
									,a.activo
									,usuarioCreacion
									,estacionCreacion
									,fechaHoraCreacion
									,usuarioModificacion
									,estacionModificacion
									,fechaHoraModificacion
						FROM  tempMigracionPiscina MP INNER JOIN invRecepcionItemsCabecera A
						ON    A.codigoZONA       = MP.CODIGOZONA_OLD
						AND   A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
						AND   A.codigosector     = MP.CODIGOSECTOR_OLD
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
								,idBodegaDestino
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
								,estacionModificacion
								,fechaHoraModificacion
								,idPedidoDetalle
								,unidadMedida
								,cantidadAplicada
								,cantidadSobrante
								,numeroLote
								,linea
								,@ultimaSecuenciaCabecera 
						FROM 	 invRecepcionItems
						WHERE idBodegaDestino = @idBodega 
						AND idRecepcionItemsCabecera = @id 

					--actualizo los SECUENCIALES DE DETALLE 
					SELECT @ultimaSecuenciaNueva = MAX(idRecepcionItems) FROM invRecepcionItems  WITH (NOLOCK) WHERE idRecepcionItemsCabecera = @ultimaSecuenciaCabecera 
					UPDATE invSecuencial set ultimaSecuencia = @ultimaSecuenciaNueva  WHERE tabla = 'RecepcionItems'--ahora si se cuantos ids utilizare 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					 UPDATE  d SET activo = 0  FROM  invRecepcionItems d
					                           INNER JOIN  invBodega bo on d.idBodegaDestino=bo.idBodega AND  tipoBodega='00003'
					                           WHERE idPiscina                 = @IdPiscina 
					                           AND   idRecepcionItemsCabecera  = @id
											   AND   idRecepcionItems          = @idDetalle
				   END 
			
			       UPDATE #idsRecepcion SET procesado = 1 WHERE  idRecepcionItemsCabecera    = @id	       AND 
															     idPiscina		                 = @IdPiscina  AND
															     procesado		                 = 0  
		  END   
END