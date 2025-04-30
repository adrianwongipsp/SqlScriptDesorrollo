USE [IPSPCamaroneraPre]
GO

--CREATE PROCEDURE SP_MIGRACION_PISCINA_PEDIDO_BINES
--AS
--BEGIN
BEGIN TRAN

		 
		   /*PROCESO  DE MUESTREOS DE POBLACION */
          DECLARE @id INT = 0,
		       @Count INT = 0,
		      @Count1 INT = 0,
	 @idZona varchar(20)  = '',
    @Modifica varchar(75) = 'MIGRACION_20250429_ZONA';
	  -- Procesamiento en bloques para evitar ciclos extensos
		DECLARE @idsControl TABLE (idPedidoBin INT, codigoZona VARCHAR(20));

		  SELECT DISTINCT  
		           de.idPedidoBin
		          ,0 procesado
		          ,de.idPedidoBinDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
				  ,ca.zona
				  ,mp.codigoZona
		  INTO #idsControlDetalle
		  FROM proPedidoBinDetalle de 
		  INNER JOIN proPedidoBin ca ON de.idPedidoBin=ca.idPedidoBin AND de.activo=1
		  INNER JOIN PiscinaUbicacion mp  ON de.idPiscina    =  mp.IDPISCINA  
		  where ca.zona    <> mp.codigoZona



			INSERT INTO @idsControl
			SELECT idPedidoBin, codigoZona
			FROM #idsControlDetalle

		  --SELECT DISTINCT 
		  --         idPedidoBin
		  --        ,0 procesado
				--  ,codigoZona
		  --INTO #idsControl
		  --FROM #idsControlDetalle


		  SELECT * FROM  @idsControl
		  --SELECT * FROM  #idsControlDetalle
		  WHILE EXISTS(SELECT TOP 1 1 FROM @idsControl)
		  BEGIN
				SELECT TOP 1	
				     @id     = idPedidoBin,
					 @idZona = codigoZona
		        FROM @idsControl 
				--WHERE procesado = 0
				ORDER BY idPedidoBin

				SELECT @Count1        =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proPedidoBinDetalle ap 
				WHERE ap.idPedidoBin  = @id 

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proPedidoBinDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idPedidoBin    = de.idPedidoBin
				AND ap.idPiscina     = de.idPiscina
				WHERE ap.idPedidoBin = @id 
				AND de.codigoZona    = @idZona

				select @Count1, @Count
				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona                 = mp.codigoZona,
				          A.estacionModificacion = @Modifica
				   FROM   PiscinaUbicacion MP 
				   INNER JOIN  proPedidoBinDetalle B 
				   ON MP.idPiscina= B.idPiscina
				   INNER JOIN  proPedidoBin A
				   ON     A.idPedidoBin    = B.idPedidoBin 
			       WHERE  A.idPedidoBin    = @id
				   AND    mp.codigoZona    = @idZona
				   print('hola' + CAST(@id AS varchar) )
				END

				  IF(@Count != @Count1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0, @ultimaSecuenciaDetalle INT =0,@ultimaSecuenciaNueva INT=0, @IdsDeta INT=0;

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'PedidoBin'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'PedidoBin'  

						SET @IdsDeta         = (SELECT COUNT(1)
						                              FROM proPedidoBinDetalle 	ap		
						                                INNER JOIN #idsControlDetalle de 
															ON ap.idPedidoBin          = de.idPedidoBin
															AND ap.idPiscina  = de.idPiscina
				                                      WHERE ap.idPedidoBin    = @id
													  AND de.codigoZona       = @idZona)

						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + @IdsDeta  -- Valor arbitrario pero seguro
						WHERE  tabla = 'PedidoBinDetalle'


						select @ultimaSecuenciaCabecera, @id, @IdsDeta
						select @ultimaSecuenciaDetalle, @Count
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
								,d.codigoZona 
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
								,@Modifica
								,fechaHoraModificacion
						FROM 	proPedidoBin A
						 INNER JOIN #idsControlDetalle mp 
						  ON  A.idPedidoBin  = mp.idPedidoBin
						 INNER JOIN PiscinaUbicacion d
						  ON  mp.idPiscina   = d.IDPISCINA
						WHERE A.idPedidoBin  = @id
						  AND mp.codigoZona  = @idZona


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
								  ,@Modifica
								  ,fechaHoraModificacion
								  ,numeroTinas
						FROM    proPedidoBinDetalle ap		
						INNER JOIN #idsControlDetalle de 
				                   ON ap.idPedidoBin   = de.idPedidoBin
								   AND ap.idPiscina    = de.idPiscina
				        WHERE ap.idPedidoBin           = @id
						AND de.codigoZona              = @idZona
			

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica
					FROM  proPedidoBinDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idPedidoBin    = de.idPedidoBin
				    AND d.idPiscina     = de.idPiscina	
				    WHERE d.idPedidoBin = @id
					AND de.codigoZona   = @idZona

					
					UPDATE d
					SET d.idDetActual  = (SELECT idPedidoBinDetalle
					                        FROM  proPedidoBinDetalle de WITH (NOLOCK) 
					                      WHERE de.idPedidoBin = @ultimaSecuenciaCabecera 
					                        AND de.idPiscina   = d.idPiscina),
					    d.idCabActual  = @ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idPedidoBin = @id 
					AND d.codigoZona    = @idZona


					UPDATE  d SET idPedidoBinDetalle   = de.idDetActual,
					              estacionModificacion = @Modifica
					FROM  proPedidoCosecha d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idPedidoBinDetalle = de.idPedidoBinDetalle
				    WHERE de.idPedidoBin    = @id
					AND de.codigoZona       = @idZona
				   END
			DELETE FROM @idsControl WHERE idPedidoBin = @id AND codigoZona = @idZona;
			--UPDATE #idsControl SET procesado = 1 WHERE idPedidoBin     = @id	AND 
								  --					  procesado	      = 0  
								  --					  AND codigoZona  = @idZona
		END
ROLLBACK TRAN