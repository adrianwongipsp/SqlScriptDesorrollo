ALTER PROCEDURE SP_MIGRACION_PISCINA_PEDIDO_BINES
AS
BEGIN
--BEGIN TRAN
		 DROP TABLE IF EXISTS #idsPedidoDetalle
		 DROP TABLE IF EXISTS #idsPedido
		   /*PROCESO  DE MUESTREOS DE POBLACION */
          DECLARE @id     INT = 0,
		          @Count  INT = 0,
		          @Count1 INT = 0,
			      @idZona      CHAR(3)  = '',
				  @idZona_NEW  CHAR(3)  = '',
				  @Modifica VARCHAR(75) = 'MIGRACION_PISCINA_20250505';
		
		--Procesamiento en bloques para evitar ciclos extensos
		CREATE TABLE #idsPedido (idPedidoBin INT, codigoZona CHAR(5), procesado bit, CODIGOZONA_NEW CHAR(5));

		  SELECT DISTINCT  
		           de.idPedidoBin
		          ,0 procesado
		          ,de.idPedidoBinDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
				  ,ca.zona AS codigoZona
				  ,mp.CODIGOZONA_NEW 
		  INTO #idsPedidoDetalle
		  FROM proPedidoBinDetalle de 
		  INNER JOIN proPedidoBin ca          ON de.idPedidoBin = ca.idPedidoBin AND de.activo=1
		  INNER JOIN tempMigracionPiscina mp  ON de.idPiscina   = mp.IDPISCINA  
		  where ca.zona <> mp.CODIGOZONA_NEW
		  --and de.idPedidoBin = 6373


			INSERT INTO #idsPedido
			SELECT distinct idPedidoBin, codigoZona, 0, CODIGOZONA_NEW
			FROM #idsPedidoDetalle

		  --SELECT COUNT(1) AS PEDIDOS_INICIALES FROM #idsPedido
		  --SELECT * FROM  #idsPedidoDetalle
		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsPedido where procesado = 0)
		  BEGIN
				SELECT TOP 1	
				     @id         = idPedidoBin,
					 @idZona     = codigoZona,
					 @idZona_NEW = CODIGOZONA_NEW
		        FROM #idsPedido 
				WHERE procesado  = 0
				ORDER BY idPedidoBin

				SELECT @Count1        =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proPedidoBinDetalle ap 
				WHERE ap.idPedidoBin  = @id 

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proPedidoBinDetalle ap 
				INNER JOIN #idsPedidoDetalle de 
				ON ap.idPedidoBin    = de.idPedidoBin
				AND ap.idPiscina     = de.idPiscina
				WHERE ap.idPedidoBin = @id 
				AND de.codigoZona    = @idZona
				AND de.CODIGOZONA_NEW= @idZona_NEW

				--print '@Count1: ' + cast(@Count1 as varchar(10))
				--print '@Count: '  + cast(@Count  as varchar(10))

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN

				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
				          A.estacionModificacion = @Modifica + '_MOD'
				   FROM    proPedidoBin A
				   inner join #idsPedidoDetalle mp
				   ON    A.idPedidoBin       = mp.idPedidoBin
			       WHERE  mp.idPedidoBin     = @id
				   AND    mp.codigoZona      = @idZona
				   AND    mp.CODIGOZONA_NEW  = @idZona_NEW

				END

				  IF(@Count != @Count1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0, @ultimaSecuenciaDetalle INT =0,@ultimaSecuenciaNueva INT=0, @IdsDeta INT=0;

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'PedidoBin'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'PedidoBin'  

						SET @IdsDeta         = (SELECT COUNT(1)
						                              FROM proPedidoBinDetalle 	ap		
						                                INNER JOIN #idsPedidoDetalle de 
															ON ap.idPedidoBin = de.idPedidoBin
															AND ap.idPiscina  = de.idPiscina
				                                      WHERE ap.idPedidoBin    = @id
													  AND de.codigoZona       = @idZona
													  AND de.CODIGOZONA_NEW   = @idZona_NEW)

						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + @IdsDeta  -- Valor arbitrario pero seguro
						WHERE  tabla = 'PedidoBinDetalle'


						--print '@ultimaSecuenciaCabecera: '+cast(@ultimaSecuenciaCabecera as varchar(10)) +', @id: ' + cast(@id as varchar(10)) + ' ,@IdsDeta: ' + cast(@IdsDeta as varchar(10))
						--print '@ultimaSecuenciaDetalle: '+ cast(@ultimaSecuenciaDetalle   as varchar(10)) +', @Count: ' +  cast(@Count as varchar(10))
						--crear la cabecera con los nuevos campos 
						

					INSERT INTO [dbo].[proPedidoBin]
							   ([idPedidoBin]
							   ,[empresa]
							   ,[division]
							   ,[zona]
							   ,[fechaPedido]
							   ,[idEspecie]
							   ,[idTipoIngreso]
							   ,[descripcion]
							   ,[fechaRegistro]
							   ,[usuarioResponsable]
							   ,[tipoPedido]
							   ,[idMotivoAuditoria]
							   ,[estado]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion])
	                SELECT TOP 1  @ultimaSecuenciaCabecera 
								,empresa
								,division
								,mp.CODIGOZONA_NEW 
								,fechaPedido
								,idEspecie
								,idTipoIngreso
								,descripcion 
								,fechaRegistro 
								,usuarioResponsable
								,tipoPedido
								,idMotivoAuditoria
								,estado
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,usuarioModificacion
								,@Modifica+'_CRE'
								,fechaHoraModificacion
						FROM 	proPedidoBin A
						 INNER JOIN #idsPedidoDetalle mp 
						  ON  A.idPedidoBin     = mp.idPedidoBin
						WHERE mp.idPedidoBin    = @id
						  AND mp.codigoZona     = @idZona
						  AND mp.CODIGOZONA_NEW = @idZona_NEW


					INSERT INTO [dbo].[proPedidoBinDetalle]
							   ([idPedidoBinDetalle]
							   ,[idPedidoBin]
							   ,[idPiscina]
							   ,[idPiscinaEjecucion]
							   ,[tipoPesca]
							   ,[cantidadPesca]
							   ,[tipoUnidadMedida]
							   ,[unidadMedida]
							   ,[cantidadBinesRequerido]
							   ,[numeroCompuertas]
							   ,[idHistograma]
							   ,[pesoHistograma]
							   ,[horaInicio]
							   ,[observacion]
							   ,[motivoAuditoria]
							   ,[activo]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion]
							   ,[numeroTinas])
		             SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idPedidoBinDetalle)  + @ultimaSecuenciaDetalle) 
								  ,@ultimaSecuenciaCabecera
								  ,ap.idPiscina
								  ,idPiscinaEjecucion
								  ,tipoPesca
								  ,cantidadPesca
								  ,tipoUnidadMedida
								  ,unidadMedida
								  ,cantidadBinesRequerido
								  ,numeroCompuertas
								  ,idHistograma
								  ,pesoHistograma
								  ,horaInicio
								  ,observacion
								  ,motivoAuditoria
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica +'_CRE'
								  ,fechaHoraModificacion
								  ,numeroTinas
						FROM    proPedidoBinDetalle ap		
						INNER JOIN #idsPedidoDetalle de 
				                   ON ap.idPedidoBin   = de.idPedidoBin
						   AND ap.idPedidoBinDetalle   = de.idPedidoBinDetalle
								   AND ap.idPiscina    = de.idPiscina
				        WHERE de.idPedidoBin           = @id
						AND de.codigoZona              = @idZona
						AND de.CODIGOZONA_NEW          = @idZona_NEW
			

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo  = 0, 
					 estacionModificacion = @Modifica+'_ANU'
					FROM  proPedidoBinDetalle d 
					INNER JOIN #idsPedidoDetalle de 
				    ON d.idPedidoBin      = de.idPedidoBin
				    AND d.idPiscina       = de.idPiscina	
				    WHERE d.idPedidoBin   = @id
					AND de.codigoZona     = @idZona
					AND de.CODIGOZONA_NEW = @idZona_NEW

				   UPDATE A SET     
				   a.estacionModificacion = @Modifica +'_MODCAB'
				   FROM   proPedidoBin A 
			       WHERE  idPedidoBin     = @id

					
					UPDATE d
					SET d.idDetActual   = (SELECT idPedidoBinDetalle
					                        FROM  proPedidoBinDetalle de WITH (NOLOCK) 
					                       WHERE de.idPedidoBin = @ultimaSecuenciaCabecera 
					                        AND de.idPiscina   = d.idPiscina),
					    d.idCabActual    = @ultimaSecuenciaCabecera
					FROM   #idsPedidoDetalle d
					WHERE d.idPedidoBin  = @id 
					AND d.codigoZona     = @idZona
					AND d.CODIGOZONA_NEW = @idZona_NEW


					UPDATE  d SET idPedidoBinDetalle   = de.idDetActual,
					              estacionModificacion = @Modifica+'_MOD'
					FROM  proPedidoCosecha d 
					INNER JOIN #idsPedidoDetalle de 
				    ON d.idPedidoBinDetalle = de.idPedidoBinDetalle
				    WHERE de.idPedidoBin    = @id
					AND de.codigoZona       = @idZona
					AND de.CODIGOZONA_NEW   = @idZona_NEW
				   END 

				   IF ((select count(1) from proPedidoBinDetalle where idPedidoBin = @id) = (select count(1) from proPedidoBinDetalle where idPedidoBin = @id and activo = 0))
				   BEGIN
					 update  proPedidoBin set estado ='ANU', estacionModificacion=@Modifica + '_ANU' WHERE idPedidoBin = @id
				   END

					UPDATE #idsPedido SET procesado = 1 WHERE idPedidoBin         = @id	AND 
								  							  procesado	          = 0  
								  							  AND codigoZona      = @idZona
															  AND CODIGOZONA_NEW  = @idZona_NEW


		END

													  --select * from proPedidoBin where idPedidoBin = 6373
													  --select * from proPedidoBinDetalle where idPedidoBin = 6373
													-- SELECT COUNT(*) AS PEDIDOS_ANULADOS FROM proPedidoBin WITH(NOLOCK) WHERE estacionModificacion=@Modifica+'_ANU'
													-- SELECT COUNT(*) AS PEDIDOS_CREADOS  FROM proPedidoBin WITH(NOLOCK) WHERE estacionCreacion = @Modifica
													 --SELECT COUNT(*) AS PEDIDOS_ACTUALIZADOS  FROM proPedidoBin WITH(NOLOCK) WHERE estacionModificacion = @Modifica +'_MOD' --AND estacionCreacion <> @Modifica AND ESTADO <> 'ANU'
													  --select * from proPedidoBinDetalle where idPedidoBin in(
													  --select idPedidoBin from proPedidoBin where estacionModificacion=@Modifica)
--COMMIT TRAN
END 