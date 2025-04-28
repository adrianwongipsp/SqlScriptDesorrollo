--CREATE PROCEDURE SP_MIGRACION_PISCINA_PEDIDO_BINES
--AS
--BEGIN
BEGIN TRAN

		 
		   /*PROCESO  DE MUESTREOS DE POBLACION */
          DECLARE @id INT = 0,
		       @Count INT = 0,
		      @Count1 INT = 0,
    @Modifica varchar(75) = 'HOLAMUNDO';

		  SELECT DISTINCT  
		           de.idPedidoBin
		          ,0 procesado
		          ,de.idPedidoBinDetalle
				  ,de.idPiscina  
				  ,0 idCabActual
				  ,0 idDetActual
		  INTO #idsControlDetalle
		  FROM proPedidoBinDetalle de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA   


		  SELECT DISTINCT 
		           idPedidoBin
		          ,0 procesado
		  INTO #idsControl
		  FROM #idsControlDetalle

		  SELECT * FROM  #idsControl
		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				     @id = idPedidoBin
		        FROM #idsControl 
				WHERE procesado = 0
				order by idPedidoBin

				SELECT @Count1       =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proPedidoBinDetalle ap 
				WHERE ap.idPedidoBin = @id

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proPedidoBinDetalle ap 
				INNER JOIN #idsControlDetalle de 
				ON ap.idPedidoBin    = de.idPedidoBin
				AND ap.idPiscina     = de.idPiscina
				WHERE ap.idPedidoBin = @id

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  --A.camaronera           = mp.CODIGOCAMARONERA_NEW,
						  --A.sector               = mp.CODIGOSECTOR_NEW, 
				          A.estacionModificacion = @Modifica
				   FROM    tempMigracionPiscina MP 
				   INNER JOIN  proPedidoBin A
				     ON   A.zona               = MP.CODIGOZONA_OLD
					 --AND  A.camaronera       = MP.CODIGOCAMARONERA_OLD
					 --AND  A.sector           = MP.CODIGOSECTOR_OLD
			       WHERE  idPedidoBin          = @id
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
				                                      ON ap.idPedidoBin       = de.idPedidoBin
				                                         AND ap.idPiscina     = de.idPiscina
				                                      WHERE ap.idPedidoBin    = @id)

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
								,CODIGOZONA_NEW 
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
							      INNER JOIN #idsControlDetalle MP 
								  ON   A.idPedidoBin = Mp.idPedidoBin
						          INNER JOIN tempMigracionPiscina d
								  ON mp.idPiscina    = d.IDPISCINA
						WHERE A.idPedidoBin          = @id


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
			

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica
					FROM  proPedidoBinDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idPedidoBin    = de.idPedidoBin
				    AND d.idPiscina     = de.idPiscina
				    WHERE d.idPedidoBin = @id

					
					UPDATE d
					SET d.idDetActual  = (SELECT idPedidoBinDetalle
					                        FROM  proPedidoBinDetalle de WITH (NOLOCK) 
					                      WHERE de.idPedidoBin = @ultimaSecuenciaCabecera 
					                        AND de.idPiscina   = d.idPiscina),
					    d.idCabActual  = @ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idPedidoBin = @id 


					UPDATE  d SET idPedidoBinDetalle   = de.idDetActual,
					              estacionModificacion = @Modifica
					FROM  proPedidoCosecha d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idPedidoBinDetalle    = de.idPedidoBinDetalle
				    WHERE de.idPedidoBin       = @id
				   END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idPedidoBin     = @id	AND 
															  procesado	      = 0  
		END
ROLLBACK TRAN