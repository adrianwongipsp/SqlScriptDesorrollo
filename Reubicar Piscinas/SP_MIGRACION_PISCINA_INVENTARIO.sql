ALTER PROCEDURE [dbo].[SP_MIGRACION_PISCINA_INVENTARIO]
AS
BEGIN

DECLARE @Modifica VARCHAR(75)   = 'MIGRACION_PISCINA_20250505'       
		,@ContarDetalle	    INT = 0
		,@Count             INT = 0
		,@idZona CHAR(3)        = ''
        ,@CodCamaronera CHAR(5) = ''
        ,@CodSector CHAR(5)     = ''
		,@idZona_NEW  CHAR(3)   = ''
   ,@CodCamaronera_NEW  CHAR(5) = ''
       ,@CodSector_NEW  CHAR(5) = ''
 --BEGIN TRAN

		--Proceso: aplicacion de item------------------------------------------------------------------------------------------------
          DECLARE @idAplicacionItem   INT=0;
		    
		  SELECT DISTINCT  
		           de.idAplicacionItem
		          ,0 procesado
		          ,de.idAplicacionItemDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
				  ,ca.codigoZona AS zona
				  ,ca.codigoCamaronera AS camaronera
				  ,ca.codigoSector  AS sector
				  ,mp.CODIGOZONA_NEW
				  ,mp.CODIGOCAMARONERA_NEW
				  ,mp.CODIGOSECTOR_NEW
		  INTO #idsDetalle
		  FROM invAplicacionItemDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA 
		  INNER JOIN invAplicacionItem ca 
		  ON de.idAplicacionItem = ca.idAplicacionItem
		  

		  SELECT  DISTINCT 
		          ap.idAplicacionItem
				  ,zona
				  ,camaronera
				  ,sector
                  ,0 procesado
				  ,CODIGOZONA_NEW
				  ,CODIGOCAMARONERA_NEW
				  ,CODIGOSECTOR_NEW
		  INTO #idsAplicacionItem 
		  FROM #idsDetalle ap

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsAplicacionItem WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@idAplicacionItem  = idAplicacionItem, 
				                @idZona            = zona,
			                    @CodCamaronera     = camaronera,
			                    @CodSector         = sector,
								@idZona_NEW        = CODIGOZONA_NEW,
	                            @CodCamaronera_NEW = CODIGOCAMARONERA_NEW,
	                            @CodSector_NEW     = CODIGOSECTOR_NEW
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
				WHERE de.idAplicacionItem   = @idAplicacionItem
				AND de.zona                 = @idZona
				AND de.camaronera           = @CodCamaronera
				AND de.sector               = @CodSector
				AND de.CODIGOZONA_NEW		= @idZona_NEW
				AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				AND de.CODIGOSECTOR_NEW	    = @CodSector_NEW

				IF(@ContarDetalle = @Count)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
					 --print 'INGRESO'
				  --	 print 
						--	 'INGRESO MOD SIMPLE'    +  
						--	 + '|' + cast(@idAplicacionItem as varchar(15))    
						--     + '|' + cast(@Count as varchar(15))
						--	 + '|' + cast(@ContarDetalle as varchar(15))

				   UPDATE A SET    
						  A.codigoZONA           = mp.CODIGOZONA_NEW,
						  A.codigocamaronera     = mp.CODIGOCAMARONERA_NEW,
						  A.codigosector         = mp.CODIGOSECTOR_NEW,
						  a.estacionModificacion = @Modifica+'_MODCAB'
				   FROM    invAplicacionItem A
				   INNER JOIN #idsDetalle mp
				     ON  A.idAplicacionItem      = MP.idAplicacionItem
					 AND A.codigoZona            = MP.zona
					 AND A.codigoCamaronera      = MP.camaronera
					 AND A.codigoSector          = MP.sector
				   WHERE mp.idAplicacionItem     = @idAplicacionItem
				   	AND  mp.zona				 = @idZona
					AND  mp.camaronera			 = @CodCamaronera
					AND  mp.sector				 = @CodSector
					AND  mp.CODIGOZONA_NEW		 = @idZona_NEW
				    AND  mp.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				    AND  mp.CODIGOSECTOR_NEW	 = @CodSector_NEW

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
													  ON ap.idAplicacionItem      = de.idAplicacionItem
													  AND ap.idPiscina            = de.idPiscina
													  WHERE de.idAplicacionItem   = @idAplicacionItem
													  AND de.zona                 = @idZona
				                                      AND de.camaronera           = @CodCamaronera
				                                      AND de.sector               = @CodSector
													  AND de.CODIGOZONA_NEW		  = @idZona_NEW
													  AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
													  AND de.CODIGOSECTOR_NEW	  = @CodSector_NEW)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla                 = 'AplicacionItemDetalle'

						--PRINT 
						--	 'APLICACION'    + cast(@ultimaSecuenciaCabecera as varchar(15))    
						--	 + '|' + cast(@idAplicacionItem as varchar(15))   
						--	 + '|' + cast(@ultimaSecuenciaDetalle as varchar(15))  
						--     + '|' + cast(@Count as varchar(15))
						--	 + '|' + cast(@ContarDetalle as varchar(15))

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
								,@Modifica+'_CRE'
								,estacionModificacion
								,fechaHoraModificacion
								,responsable 
						 FROM 	invAplicacionItem A
					     INNER JOIN #idsDetalle de 
					     ON   A.idAplicacionItem	  = de.idAplicacionItem
						 WHERE de.idAplicacionItem	  = @idAplicacionItem
						 AND de.zona				  = @idZona
				         AND de.camaronera			  = @CodCamaronera
				         AND de.sector				  = @CodSector
						 AND de.CODIGOZONA_NEW		  = @idZona_NEW
						 AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
						 AND de.CODIGOSECTOR_NEW      = @CodSector_NEW
						

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
					    SELECT     (ROW_NUMBER() OVER(ORDER BY ap.idAplicacionItemDetalle)  + @ultimaSecuenciaDetalle) 
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
									,@Modifica+'_CRE'
									,fechaHoraModificacion
									,idBodegaDestino
									,numeroLote
						FROM    invAplicacionItemDetalle ap		
						INNER JOIN #idsDetalle de 
				        ON ap.idAplicacionItem         = de.idAplicacionItem
						AND ap.idAplicacionItemDetalle = de.idAplicacionItemDetalle
				        AND ap.idPiscina               = de.idPiscina
				        WHERE de.idAplicacionItem      = @idAplicacionItem
						AND de.zona                    = @idZona
				        AND de.camaronera              = @CodCamaronera
				        AND de.sector                  = @CodSector
						AND de.CODIGOZONA_NEW		   = @idZona_NEW
						AND de.CODIGOCAMARONERA_NEW    = @CodCamaronera_NEW
						AND de.CODIGOSECTOR_NEW        = @CodSector_NEW


					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0,
                    estacionModificacion = @Modifica+'_ANU'
					FROM  invAplicacionItemDetalle d 
					INNER JOIN #idsDetalle de 
				    ON d.idAplicacionItem         = de.idAplicacionItem
					AND d.idAplicacionItemDetalle = de.idAplicacionItemDetalle
				    AND d.idPiscina               = de.idPiscina
				    WHERE de.idAplicacionItem     = @idAplicacionItem
					AND de.zona                   = @idZona
				    AND de.camaronera             = @CodCamaronera
				    AND de.sector                 = @CodSector
					AND de.CODIGOZONA_NEW		  = @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW       = @CodSector_NEW


				  IF ((SELECT COUNT(1) FROM invAplicacionItemDetalle WHERE idAplicacionItem = @idAplicacionItem) = (SELECT COUNT(1) FROM invAplicacionItemDetalle WHERE idAplicacionItem = @idAplicacionItem AND activo = 0))
				   BEGIN
					 UPDATE  invAplicacionItem SET estado ='ANU', estacionModificacion=@Modifica + '_ANUCAB' WHERE idAplicacionItem = @idAplicacionItem
				   END
				  ELSE 
				   BEGIN
				   		UPDATE A SET     
						  a.estacionModificacion  = @Modifica +'_MODCAB'
				        FROM      invAplicacionItem A 
			            WHERE   idAplicacionItem  = @idAplicacionItem
				   END
				END
			
			       UPDATE #idsAplicacionItem SET procesado = 1 
				   WHERE idAplicacionItem    = @idAplicacionItem AND 
						 procesado			 = 0 
					AND zona                 = @idZona
				    AND camaronera           = @CodCamaronera
				    AND sector               = @CodSector
					AND CODIGOZONA_NEW		 = @idZona_NEW
					AND CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					AND CODIGOSECTOR_NEW     = @CodSector_NEW
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
				  ,ca.codigoZona AS zona
				  ,ca.codigoCamaronera AS camaronera
				  ,ca.codigoSector  AS sector
				  ,mp.CODIGOZONA_NEW
				  ,mp.CODIGOCAMARONERA_NEW
				  ,mp.CODIGOSECTOR_NEW
		  INTO #ids2Detalle
		  FROM invPedidoDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA  
		  INNER JOIN invPedido ca 
		  ON de.idPedido    = ca.idPedido


		  SELECT DISTINCT  idPedido
		  			       ,zona
				           ,camaronera
				           ,sector
                           ,0 procesado
						   ,CODIGOZONA_NEW
				           ,CODIGOCAMARONERA_NEW
				           ,CODIGOSECTOR_NEW
		  INTO #idsPedido
		  FROM #ids2Detalle 

		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsPedido WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1 @idPedido  = idPedido,
				            	@idZona = zona,
			             @CodCamaronera = camaronera,
			                 @CodSector = sector,
							@idZona_NEW = CODIGOZONA_NEW,
	                 @CodCamaronera_NEW = CODIGOCAMARONERA_NEW,
	                     @CodSector_NEW = CODIGOSECTOR_NEW
					    FROM	#idsPedido  
						WHERE	procesado = 0 
						ORDER BY idPedido;

				SELECT @ContarDetalle  =  COUNT(DISTINCT idPiscina) 
				FROM  invPedidoDetalle ap 
				WHERE idPedido = @idPedido; 

				SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  invPedidoDetalle ap 
				INNER JOIN #ids2Detalle de 
				ON ap.idPedidoDetalle       = de.idPedidoDetalle
				AND ap.idPiscina            = de.idPiscina
				WHERE de.idPedido           = @idPedido
				AND de.zona                 = @idZona
				AND de.camaronera           = @CodCamaronera
				AND de.sector               = @CodSector
			    AND de.CODIGOZONA_NEW       = @idZona_NEW
				AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				AND de.CODIGOSECTOR_NEW     = @CodSector_NEW;


				 IF(@ContarDetalle=@Count)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				 BEGIN
				 	 --print 'INGRESO'
				  	-- print 
							-- 'INGRESO MOD SIMPLE'    +  
							-- + '|' + cast(@idPedido as varchar(15))    
						 --    + '|' + cast(@Count as varchar(15))
							-- + '|' + cast(@ContarDetalle as varchar(15))

					   UPDATE  A SET    
							   A.codigoZONA           = mp.CODIGOZONA_NEW,
							   A.codigocamaronera     = mp.CODIGOCAMARONERA_NEW,
							   A.codigosector         = mp.CODIGOSECTOR_NEW,
							   A.estacionModificacion = @Modifica+'_MODCAB'
					   FROM    invPedido A
					   INNER JOIN #ids2Detalle mp
						  ON   A.codigoZONA           = MP.zona
						  AND  A.codigocamaronera     = MP.camaronera
						  AND  A.codigosector         = MP.sector
					   WHERE mp.idPedido              = @idPedido
				   		AND mp.zona                   = @idZona
						AND mp.camaronera             = @CodCamaronera
						AND mp.sector                 = @CodSector
						AND mp.CODIGOZONA_NEW         = @idZona_NEW
						AND mp.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
						AND mp.CODIGOSECTOR_NEW       = @CodSector_NEW
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
				                             ON ap.idPedido              = de.idPedido
											 AND ap.idPedidoDetalle      = de.idPedidoDetalle
				                             AND ap.idPiscina            = de.idPiscina
				                             WHERE de.idPedido           = @idPedido
											 AND de.zona                 = @idZona
					                         AND de.camaronera           = @CodCamaronera
					                         AND de.sector               = @CodSector
											 AND de.CODIGOZONA_NEW       = @idZona_NEW
				                             AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				                             AND de.CODIGOSECTOR_NEW     = @CodSector_NEW)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @Ids  -- Valor arbitrario pero seguro
						WHERE tabla                 = 'PedidoDetalle'

				    --     PRINT 
							 --'PEDIDO'    + cast(@ultimaSecuenciaCabecera as varchar(15))    
							 --+ '|' + cast(@idPedido as varchar(15))   
							 --+ '|' + cast(@ultimaSecuenciaDetalle as varchar(15))  
						  --   + '|' + cast(@Count as varchar(15))
							 --+ '|' + cast(@ContarDetalle as varchar(15))

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
										,RIGHT('0000000000'+ cast(@ultimaSecuenciaCabecera as varchar(10)), 9)
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
										,@Modifica+'_CRE'
										,fechaHoraModificacion
										,estadoProceso
										,responsable
										,codigoRolPiscina
										,estadoRecepcion
						FROM 	   invPedido A
					    INNER JOIN #ids2Detalle MP 
					    ON   a.idPedido             = mp.idPedido
						WHERE mp.idPedido           = @idPedido
						AND mp.zona                 = @idZona
					    AND mp.camaronera           = @CodCamaronera
					    AND mp.sector               = @CodSector
						AND mp.CODIGOZONA_NEW       = @idZona_NEW
				        AND mp.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				        AND mp.CODIGOSECTOR_NEW     = @CodSector_NEW

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
					    SELECT      (ROW_NUMBER() OVER(ORDER BY ap.idPedidoDetalle)  + @ultimaSecuenciaDetalle) 
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
									,@Modifica+'_CRE'
									,fechaHoraModificacion
									,motivoExtraordinario
									,observacion
									,estadoPedidoDetalle
						FROM    invPedidoDetalle ap		
						INNER JOIN #ids2Detalle de 
				        ON ap.idPedido              = de.idPedido
						AND ap.idPedidoDetalle      = de.idPedidoDetalle
				        AND ap.idPiscina            = de.idPiscina
				        WHERE de.idPedido           = @idPedido  														   
			            AND de.zona                 = @idZona
					    AND de.camaronera           = @CodCamaronera
					    AND de.sector               = @CodSector
						AND de.CODIGOZONA_NEW       = @idZona_NEW
				        AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				        AND de.CODIGOSECTOR_NEW     = @CodSector_NEW

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo = 0,
                    estacionModificacion = @Modifica+'_ANU'
					FROM  invPedidoDetalle d 
					INNER JOIN #ids2Detalle de 
				    ON d.idPedido               = de.idPedido
					AND d.idPedidoDetalle       = de.idPedidoDetalle
				    AND d.idPiscina             = de.idPiscina
				    WHERE de.idPedido           = @idPedido
					AND de.zona                 = @idZona
					AND de.camaronera           = @CodCamaronera
					AND de.sector               = @CodSector
					AND de.CODIGOZONA_NEW       = @idZona_NEW
				    AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				    AND de.CODIGOSECTOR_NEW     = @CodSector_NEW

				  IF ((SELECT COUNT(1) FROM invPedidoDetalle WHERE idPedido = @idPedido) = (SELECT COUNT(1) FROM invPedidoDetalle WHERE idPedido = @idPedido AND activo = 0))
				   BEGIN
					 UPDATE  invPedido SET estado ='ANU', estacionModificacion=@Modifica + '_ANUCAB' WHERE idPedido = @idPedido
				   END
				  ELSE 
				   BEGIN
				   		UPDATE A SET     
						  a.estacionModificacion  = @Modifica +'_MODCAB'
				        FROM      invPedido A 
			            WHERE   idPedido = @idPedido
				   END
					                                                      
																	  
				END 
			
			       UPDATE #idsPedido SET procesado = 1 
				   WHERE  idPedido           = @idPedido AND 
						  procesado	         = 0 
					AND zona                 = @idZona
					AND camaronera           = @CodCamaronera
					AND sector               = @CodSector
					AND CODIGOZONA_NEW       = @idZona_NEW
				    AND CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				    AND CODIGOSECTOR_NEW     = @CodSector_NEW
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
				  ,ca.codigoZona AS zona
				  ,ca.codigoCamaronera AS camaronera
				  ,ca.codigoSector  AS sector
				  ,mp.CODIGOZONA_NEW
				  ,mp.CODIGOCAMARONERA_NEW
				  ,mp.CODIGOSECTOR_NEW
		  INTO #ids3Detalle
		  FROM invRecepcionItems de 
		  INNER JOIN  invBodega bo on de.idBodegaDestino=bo.idBodega AND  tipoBodega='00003'
		  INNER JOIN tempMigracionPiscina mp on bo.idPiscina = mp.IDPISCINA 
		  INNER JOIN  invRecepcionItemsCabecera ca ON de.idRecepcionItemsCabecera=ca.idRecepcionItemsCabecera


		  SELECT DISTINCT  idRecepcionItemsCabecera
		  			      ,zona
				          ,camaronera
				          ,sector
				          ,0 procesado
						  ,CODIGOZONA_NEW
				          ,CODIGOCAMARONERA_NEW
				          ,CODIGOSECTOR_NEW
		  INTO #idsRecepcion
		  FROM #ids3Detalle 


		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsRecepcion WHERE procesado = 0)
		  BEGIN
				        SELECT TOP 1	@id = idRecepcionItemsCabecera,
									@idZona = zona,
			                 @CodCamaronera = camaronera,
			                     @CodSector = sector,
								@idZona_NEW = CODIGOZONA_NEW,
	                     @CodCamaronera_NEW = CODIGOCAMARONERA_NEW,
	                         @CodSector_NEW = CODIGOSECTOR_NEW
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
				WHERE ap.idRecepcionItemsCabecera = @id
				AND de.zona                       = @idZona
			    AND de.camaronera                 = @CodCamaronera
			    AND de.sector                     = @CodSector
				AND de.CODIGOZONA_NEW		      = @idZona_NEW
				AND de.CODIGOCAMARONERA_NEW       = @CodCamaronera_NEW
				AND de.CODIGOSECTOR_NEW	          = @CodSector_NEW;

				 IF(@ContarDetalle=@Count)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				 BEGIN

				 	--print 'INGRESO'
				  --	 print 
						--	 'INGRESO MOD SIMPLE'    +  
						--	 + '|' + cast(@id as varchar(15))    
						--     + '|' + cast(@Count as varchar(15))
						--	 + '|' + cast(@ContarDetalle as varchar(15))
				   UPDATE A SET    
						  a.codigoZONA           = mp.CODIGOZONA_NEW,
						  a.codigocamaronera     = mp.CODIGOCAMARONERA_NEW,
						  a.codigosector         = mp.CODIGOSECTOR_NEW,
						  a.estacionModificacion = @Modifica+'_MODCAB'
				   FROM   invRecepcionItemsCabecera A
				    INNER JOIN #ids3Detalle mp
					ON  a.idRecepcionItemsCabecera=mp.idRecepcionItemsCabecera
					AND a.codigoZONA           = MP.zona
					AND a.codigocamaronera     = MP.camaronera
					AND a.codigosector         = MP.sector
				  WHERE mp.idRecepcionItemsCabecera  = @id
				   	AND mp.zona                   = @idZona
					AND mp.camaronera             = @CodCamaronera
					AND mp.sector                 = @CodSector
					AND mp.CODIGOZONA_NEW		  = @idZona_NEW
					AND mp.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
					AND mp.CODIGOSECTOR_NEW	      = @CodSector_NEW
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
															    x.idRecepcionItemsCabecera       = de.idRecepcionItemsCabecera 
															AND x.idBodegaDestino                = de.idBodegaDestino
															WHERE de.idRecepcionItemsCabecera = @id
															AND de.Zona                   = @idZona
					                                        AND de.camaronera             = @CodCamaronera
					                                        AND de.sector                 = @CodSector
															AND de.CODIGOZONA_NEW		  = @idZona_NEW
													        AND de.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
													        AND de.CODIGOSECTOR_NEW	      = @CodSector_NEW)

						UPDATE invSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsR  -- Valor arbitrario pero seguro
						WHERE tabla                 = 'RecepcionItems'

						--PRINT 
							 --'RECEPCION'    + cast(@ultimaSecuenciaCabecera as varchar(15))    
							 --+ '|' + cast(@id as varchar(15))   
							 --+ '|' + cast(@ultimaSecuenciaDetalle as varchar(15))  
						  --   + '|' + cast(@Count as varchar(15))
							 --+ '|' + cast(@ContarDetalle as varchar(15))

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
									,@Modifica+'_CRE'
									,fechaHoraModificacion
						FROM  invRecepcionItemsCabecera A
						INNER JOIN #ids3Detalle MP 
						ON   A.idRecepcionItemsCabecera   = Mp.idRecepcionItemsCabecera
						WHERE mp.idRecepcionItemsCabecera = @id
						AND mp.zona                 = @idZona
					    AND mp.camaronera           = @CodCamaronera
					    AND mp.sector               = @CodSector
						AND mp.CODIGOZONA_NEW		= @idZona_NEW
						AND mp.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
						AND mp.CODIGOSECTOR_NEW	    = @CodSector_NEW
		

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
					    SELECT   (row_number() over(order by ap.idRecepcionItems)  + @ultimaSecuenciaDetalle) 
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
				        ON ap.idRecepcionItemsCabecera = de.idRecepcionItemsCabecera
						AND ap.idRecepcionItems        = de.idRecepcionItems
				        AND ap.idBodegaDestino         = de.idBodegaDestino
				        WHERE de.idRecepcionItemsCabecera = @id 
						AND de.zona                 = @idZona
					    AND de.camaronera           = @CodCamaronera
					    AND de.sector               = @CodSector
						AND de.CODIGOZONA_NEW		= @idZona_NEW
						AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
						AND de.CODIGOSECTOR_NEW	    = @CodSector_NEW

					--inactivo los detalle antiguo migrado a la nueva transaccion
					 UPDATE  d SET activo = 0,
					 estacionModificacion = @Modifica+'_ANU'
					 FROM  invRecepcionItems d
					 INNER JOIN #ids3Detalle de 
				     ON d.idRecepcionItemsCabecera    = de.idRecepcionItemsCabecera
				     AND d.idBodegaDestino            = de.idBodegaDestino
				     WHERE de.idRecepcionItemsCabecera = @id 
					 AND de.zona                 = @idZona
					 AND de.camaronera           = @CodCamaronera
					 AND de.sector               = @CodSector
					 AND de.CODIGOZONA_NEW		 = @idZona_NEW
				     AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
				     AND de.CODIGOSECTOR_NEW	 = @CodSector_NEW

					 IF ((SELECT COUNT(1) FROM invRecepcionItems WHERE idRecepcionItemsCabecera = @id) = (SELECT COUNT(1) FROM invRecepcionItems WHERE idRecepcionItemsCabecera = @id AND activo = 0))
					   BEGIN
						 UPDATE  invRecepcionItemsCabecera SET estado ='ANU', estacionModificacion=@Modifica + '_ANUCAB' WHERE idRecepcionItemsCabecera = @id
					   END
					  ELSE 
					   BEGIN
				   			UPDATE A SET     
							  a.estacionModificacion  = @Modifica +'_MODCAB'
							FROM     invRecepcionItemsCabecera A 
							WHERE   idRecepcionItemsCabecera = @id
					   END


				   END
			
			       UPDATE #idsRecepcion SET procesado = 1
				   WHERE  idRecepcionItemsCabecera    = @id	 AND 
					      procesado		              = 0 
						 AND zona                 = @idZona
					     AND camaronera           = @CodCamaronera
					     AND sector               = @CodSector
						 AND CODIGOZONA_NEW		  = @idZona_NEW
						 AND CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
						 AND CODIGOSECTOR_NEW	  = @CodSector_NEW
		  END
		
--ROLLBACK TRAN
END
