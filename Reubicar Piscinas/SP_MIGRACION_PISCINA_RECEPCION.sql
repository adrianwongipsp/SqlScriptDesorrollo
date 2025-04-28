--BEGIN TRAN
--	 EX SP_MIGRACION_PISCINA_RECEPCION 1;
--ROLLBACK TRAN 

 CREATE PROCEDURE SP_MIGRACION_PISCINA_RECEPCION
	@mostrarResultados bit  
 AS
 BEGIN 
	 
          DECLARE @idRecepcion         INT; 
		  DECLARE @idRecepcionDetalle  INT;  
		  DECLARE @ContarDetalle			INT;  
		  DECLARE @CountPiscinasMigrar      INT;
		  DROP TABLE IF EXISTS #cabRecepcionItem;
		  DROP TABLE IF EXISTS #detRecepcionItem;


		  SELECT  distinct ap.idRecepcion 	
				           , ap.idRecepcionDetalle 
				           , ap.idPiscina 	
						   , 0 idrecepcionNuevo
					       , 0 idRecepcionDetalleNuevo
			 INTO #detRecepcionItem 
		  FROM proRecepcionEspecieDetalle ap inner join tempMigracionPiscina mp on ap.idPiscina = mp.IDPISCINA    

           SELECT  distinct ap.idRecepcion,	
					 0 procesado ,
					 'UMIGRACION111' as tipoMigracion
					 into #cabRecepcionItem
		  FROM #detRecepcionItem ap

		  update #cabRecepcionItem set tipoMigracion=''

		  WHILE EXISTS(SELECT TOP 1 1 FROM #cabRecepcionItem WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	@idRecepcion                 = idRecepcion  
					    FROM	#cabRecepcionItem  
						WHERE	procesado = 0 
				ORDER BY idRecepcion
				--select * FROM  proRecepcionEspecieDetalle ap inner join tempMigracionPiscina p WHERE idRecepcion = @idRecepci

				SELECT @CountPiscinasMigrar  =  COUNT(DISTINCT ap.idPiscina) 
												FROM  proRecepcionEspecieDetalle ap 
												INNER JOIN #detRecepcionItem de ON ap.idRecepcion=de.idRecepcion AND ap.idPiscina=de.idPiscina
												WHERE 
													ap.idRecepcion = @idRecepcion

				SELECT @ContarDetalle  =  COUNT(distinct idPiscina) FROM  proRecepcionEspecieDetalle ap WHERE idRecepcion = @idRecepcion --and activo = 1 
			    DECLARE @tipoMigracion varchar(15)
				IF(@ContarDetalle = @CountPiscinasMigrar)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				  BEGIN
				    set @tipoMigracion = 'UMIGRACION'
				    UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera			 = mp.CODIGOCAMARONERA_NEW,
						  A.sector				 = mp.CODIGOSECTOR_NEW  ,
						  A.estacionModificacion = @tipoMigracion
					 FROM 
							tempMigracionPiscina MP INNER JOIN proRecepcionEspecie A
						   ON   A.zona       = MP.CODIGOZONA_OLD
						  AND   A.camaronera = MP.CODIGOCAMARONERA_OLD
						  AND   A.sector     = MP.CODIGOSECTOR_OLD
					  WHERE idRecepcion = @idRecepcion 
				  END
				  ELSE
				  BEGIN
				      set @tipoMigracion = 'MIGRACION'
					  --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera			   INT
						DECLARE @ultimaSecuenciaCabeceraCambioPlus	   INT 
					    DECLARE @ultimaSecuenciaCabeceraSecuencial     INT
						DECLARE @ultimaSecuenciaDetalle				   INT
						DECLARE @ultimaSecuenciaDetalleCaracteristicas INT
						DECLARE @ultimaSecuenciaDetalleParametros      INT

						DECLARE @ultimaSecuenciaNuevaDetalle						INT
						DECLARE @ultimaSecuenciaNuevaDetalleCaracteristicas	        INT
						DECLARE @ultimaSecuenciaNuevaDetalleParametros              INT 

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'recepcionEspecie'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'recepcionEspecie'  
						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'recepcionEspecieDetalleCambioPlus'
						SELECT TOP 1 @ultimaSecuenciaCabeceraCambioPlus = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'recepcionEspecieDetalleCambioPlus'  
						 
						---select @ultimaSecuenciaCabecera as [@ultimaSecuenciaCabecera]

						DECLARE @IdsNecesarios INT = (SELECT COUNT(1) FROM  #detRecepcionItem  dt  
																		WHERE dt.idRecepcion = @idRecepcion) 
						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieDetalle'
						--select @ultimaSecuenciaDetalle as [@ultimaSecuenciaDetalle], @IdsNecesarios [@IdsNecesarios]
						DECLARE @IdsNecesariosCaracteristicas INT 
						select @IdsNecesariosCaracteristicas =  COUNT(1) from proRecepcionEspecieCaracteristica   where idRecepcionDetalle in
												(SELECT dt.idRecepcionDetalle FROM   #detRecepcionItem  dt  WHERE dt.idRecepcion = @idRecepcion) 
						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalleCaracteristicas = ultimaSecuencia,
							ultimaSecuencia						  = ultimaSecuencia + @IdsNecesariosCaracteristicas  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieCaracteristica'

						
						DECLARE @IdsNecesariosParametros INT 
						select @IdsNecesariosParametros =  COUNT(1) from proRecepcionEspecieParametros   where idRecepcionDetalle in
												(SELECT dt.idRecepcionDetalle FROM   #detRecepcionItem  dt  WHERE dt.idRecepcion = @idRecepcion)    
						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalleParametros   = ultimaSecuencia,
							ultimaSecuencia						= ultimaSecuencia + @IdsNecesariosParametros  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieParametros'  
						 
						 	
						DECLARE @IdsNecesariosSecuencial INT 
						SELECT @IdsNecesariosSecuencial =  COUNT(1) FROM proRecepcionEspecieSecuencial WHERE  idRecepcion = @idRecepcion    
						UPDATE proSecuencial 
						SET @ultimaSecuenciaCabeceraSecuencial   = ultimaSecuencia,
							ultimaSecuencia						= ultimaSecuencia + @IdsNecesariosSecuencial  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieSecuencial'  
						--cabecera
							INSERT INTO proRecepcionEspecie
								   (idRecepcion,           
								    empresa,		       division,		
									zona,		           camaronera,	     
									sector,			       secuencia,        origen, 
									idOrdenCompra,	       idDespacho,       idPlanificacionSiembra, idLaboratorio,       idLaboratorioLarva, fechaRegistro,     fechaDespacho,
									fechaRecepcion,        horaDespacho,     horaRecepcion,			 idResponsableSiembra,idEspecie,          tipoLarva,         cantidad,
									cantidadPlus,          porcentajePlus,   unidadMedida,			 cantidadRecibida,    guiasRemision,      tieneFactura,      descripcion,
									responsableEntrega,    estado,			 usuarioResponsable,     usuarioCreacion,     estacionCreacion,   fechaHoraCreacion, usuarioModificacion,
									estacionModificacion,  fechaHoraModificacion,
									reprocesoContable)
							SELECT  TOP 1 
							        @ultimaSecuenciaCabecera,           
							        empresa,		       division,		
									MP.CODIGOZONA_NEW,     MP.CODIGOCAMARONERA_NEW,
									MP.CODIGOSECTOR_NEW,   @ultimaSecuenciaCabecera,           origen, 
									idOrdenCompra,	       idDespacho,       idPlanificacionSiembra, idLaboratorio,       idLaboratorioLarva, fechaRegistro,     fechaDespacho,
									fechaRecepcion,        horaDespacho,     horaRecepcion,			 idResponsableSiembra,idEspecie,          tipoLarva,         cantidad,
									cantidadPlus,          porcentajePlus,   unidadMedida,			 cantidadRecibida,    guiasRemision,      tieneFactura,      descripcion,
									responsableEntrega,    estado,			 usuarioResponsable,     usuarioCreacion,     estacionCreacion,   fechaHoraCreacion, usuarioModificacion,
									@tipoMigracion,        fechaHoraModificacion,
									reprocesoContable  
							FROM 		 proRecepcionEspecie A
											INNER JOIN #detRecepcionItem B     ON A.idRecepcion = B.idRecepcion 
											INNER JOIN tempMigracionPiscina MP ON  MP.IDPISCINA = B.idPiscina 
							 WHERE A.idRecepcion = @idRecepcion
								   
						INSERT INTO proRecepcionEspecieDetalleCambioPlus
							    (idRecepcionEspecieDetalleCambioPlus,   idRecepcion,			fechaCambioPlus,	
							     porcentajePlusAnterior,				porcentajePlusActual,   usuarioCreacion, 
							     estacionCreacion,						fechaHoraCreacion,		usuarioModificacion, 
							     estacionModificacion,					fechaHoraModificacion)
						SELECT 
							  @ultimaSecuenciaCabeceraCambioPlus,  @ultimaSecuenciaCabecera, fechaCambioPlus,	
							  porcentajePlusAnterior,				porcentajePlusActual,     usuarioCreacion, 
							  estacionCreacion,						fechaHoraCreacion,		  usuarioModificacion, 
							  @tipoMigracion,                       fechaHoraModificacion
						FROM 
						   proRecepcionEspecieDetalleCambioPlus A 
						WHERE A.idRecepcion = @idRecepcion
						   
						INSERT INTO proRecepcionEspecieSecuencial
							(idRecepcionSecuencial,	idRecepcion, 
							 idLaboratorioLarva,    idLaboratorioMaduracion, idsLaboratorioMaduracion,
							 secuencia,				activo,		 
							 usuarioCreacion,	    estacionCreacion,	     fechaHoraCreacion,
							 usuarioModificacion,	estacionModificacion,    fechaHoraModificacion )
						SELECT 
							  ROW_NUMBER() OVER (ORDER BY A.idRecepcionSecuencial) + @ultimaSecuenciaCabeceraSecuencial,   	@ultimaSecuenciaCabecera, 
							 idLaboratorioLarva,    idLaboratorioMaduracion, idsLaboratorioMaduracion,
							 secuencia,				activo,		 
							 usuarioCreacion,	    estacionCreacion,	     fechaHoraCreacion,
							 usuarioModificacion,	@tipoMigracion,          fechaHoraModificacion 
						FROM proRecepcionEspecieSecuencial A 
						WHERE A.idRecepcion = @idRecepcion

						-- After parent record insert
						IF NOT EXISTS (SELECT 1 FROM proRecepcionEspecie WHERE idRecepcion = @ultimaSecuenciaCabecera)
						BEGIN
							RAISERROR('Failed to insert parent record with ID %d ID ORIGINAL %d', 16, 1, @ultimaSecuenciaCabecera, @idRecepcion)
							-- Handle the error appropriately
							SELECT 'REGISTRO TEMPORAL ANTES DE PROCESAR', @idRecepcion   
							select * from #cabRecepcionItem WHERE idRecepcion = @idRecepcion
							select * from #detRecepcionItem WHERE idRecepcion = @idRecepcion
							ROLLBACK TRAN
							RETURN
						END

						 
					INSERT INTO proRecepcionEspecieDetalle	
						(idRecepcionDetalle,     
						idRecepcion,          
						idPiscinaPlanificacion,    orden,              idPiscina,
						rolPiscina,              cantidad,             unidadMedida,              cantidadRecibida,   cantidadAdicional,
						idPiscinaEjecucion,      idCodigoGenetico,     idLaboratorioMaduracion,   codigoLarva,        biomasa,
						oxigeno,                 salinidad,            temperatura,               costoLarva,         costoServiciosPrestados,
						costoFlete,              amonio,               ph,                        alcalinidad,        conteoAlgas,
						descripcion,             numeroCajas,          numeroTinas,               tanqueOrigen,       plGramoLab,
						plGramoCam,              numeroArtemia,        calidadAgua,               tanqueCalidadAguaBuena, tanqueCalidadAguaRegular,
						tanqueCalidadAguaMala,   observacionParametro, observacionCaracteristica, activo,                  idMotivoAuditoria,
						usuarioCreacion,         estacionCreacion,     fechaHoraCreacion,         usuarioModificacion,     estacionModificacion,
						fechaHoraModificacion,   origenPlGramo)
					SELECT 
						ROW_NUMBER() OVER (ORDER BY D.idRecepcionDetalle) + @ultimaSecuenciaDetalle,  
						@ultimaSecuenciaCabecera, 
						idPiscinaPlanificacion,   orden,              D.idPiscina,
						rolPiscina,              cantidad,             unidadMedida,              cantidadRecibida,			cantidadAdicional,
						idPiscinaEjecucion,      idCodigoGenetico,     idLaboratorioMaduracion,   codigoLarva,				biomasa,
						oxigeno,                 salinidad,            temperatura,               costoLarva,				costoServiciosPrestados,
						costoFlete,              amonio,               ph,                        alcalinidad,				conteoAlgas,
						descripcion,             numeroCajas,          numeroTinas,               tanqueOrigen,				plGramoLab,
						plGramoCam,              numeroArtemia,        calidadAgua,               tanqueCalidadAguaBuena,   tanqueCalidadAguaRegular,
						tanqueCalidadAguaMala,   observacionParametro, observacionCaracteristica, activo,                   idMotivoAuditoria,
						usuarioCreacion,         estacionCreacion,     fechaHoraCreacion,         usuarioModificacion,      @tipoMigracion,
						fechaHoraModificacion,   origenPlGramo
					FROM proRecepcionEspecieDetalle D INNER JOIN #detRecepcionItem DT ON D.idRecepcion =DT.idRecepcion AND D.idPiscina = DT.idPiscina AND D.idRecepcionDetalle = DT.idRecepcionDetalle 
					WHERE D.idRecepcion = @idRecepcion

						;WITH CTE AS (
							SELECT 
								DT.idRecepcionDetalle,
								@ultimaSecuenciaCabecera as idRecepcionNuevo,
								ROW_NUMBER() OVER (ORDER BY D.idRecepcionDetalle) + @ultimaSecuenciaDetalle AS idRecepcionDetalleNuevo
							FROM proRecepcionEspecieDetalle D 
							INNER JOIN #detRecepcionItem DT ON D.idRecepcion = DT.idRecepcion 
															AND D.idPiscina = DT.idPiscina 
															AND D.idRecepcionDetalle = DT.idRecepcionDetalle
							WHERE D.idRecepcion = @idRecepcion
						)
						UPDATE DT
						SET DT.idRecepcionDetalleNuevo = CTE.idRecepcionDetalleNuevo,
							DT.idRecepcionNuevo		   = CTE.idRecepcionNuevo
						FROM #detRecepcionItem DT
						INNER JOIN CTE ON DT.idRecepcionDetalle = CTE.idRecepcionDetalle
								WHERE Dt.idRecepcion = @idRecepcion

					INSERT INTO proRecepcionEspecieCaracteristica
					    (idRecepcionCaracteristica,    
						 idRecepcion,                  idRecepcionDetalle,       
						 orden,                        idParametroControl,
						 valorEnLaboratorio,           valorEnCamaronera,         idCualidadEnLaboratorio,  idCualidadEnCamaronera,   activo,
						 usuarioCreacion,              estacionCreacion,          fechaHoraCreacion,        usuarioModificacion,      estacionModificacion,
						 fechaHoraModificacion)
					SELECT 
						ROW_NUMBER() OVER (ORDER BY D.idRecepcionCaracteristica) +@ultimaSecuenciaDetalleCaracteristicas,    
						@ultimaSecuenciaCabecera,     dt.idRecepcionDetalleNuevo,       
						orden,						  idParametroControl,
						valorEnLaboratorio,           valorEnCamaronera,         idCualidadEnLaboratorio,  idCualidadEnCamaronera,   activo,
						usuarioCreacion,              estacionCreacion,          fechaHoraCreacion,        usuarioModificacion,      @tipoMigracion,
						fechaHoraModificacion
					FROM proRecepcionEspecieCaracteristica  D INNER JOIN #detRecepcionItem DT ON D.idRecepcion =DT.idRecepcion  AND D.idRecepcionDetalle = DT.idRecepcionDetalle 
					WHERE D.idRecepcion = @idRecepcion
						 
					
					INSERT INTO proRecepcionEspecieParametros
					    (   idRecepcionParametro,       
							idRecepcion,			    idRecepcionDetalle,       
							orden,                      idParametroControl,
							valorEnPreparacion,         valorTinaPromedio,         valorPSInicio,            valorPSFin,              idCualidadEnPreparacion,
							idCualidadTinaPromedio,     idCualidadPSInicio,        idCualidadPSFin,          activo,                  usuarioCreacion,
							estacionCreacion,           fechaHoraCreacion,         usuarioModificacion,      estacionModificacion,    fechaHoraModificacion)
					SELECT 
						ROW_NUMBER() OVER (ORDER BY D.idRecepcionParametro) +@ultimaSecuenciaDetalleParametros,    
						@ultimaSecuenciaCabecera,       dt.idRecepcionDetalleNuevo,       
							orden,                      idParametroControl,
							valorEnPreparacion,         valorTinaPromedio,         valorPSInicio,            valorPSFin,              idCualidadEnPreparacion,
							idCualidadTinaPromedio,     idCualidadPSInicio,        idCualidadPSFin,          activo,                  usuarioCreacion,
							estacionCreacion,           fechaHoraCreacion,         usuarioModificacion,      @tipoMigracion,		fechaHoraModificacion
					FROM proRecepcionEspecieParametros  D INNER JOIN #detRecepcionItem DT ON D.idRecepcion =DT.idRecepcion  AND D.idRecepcionDetalle = DT.idRecepcionDetalle 
					WHERE D.idRecepcion = @idRecepcion

				  END


			    UPDATE #cabRecepcionItem SET procesado = 1, tipoMigracion = @tipoMigracion WHERE  idRecepcion        = @idRecepcion      and  procesado           = 0  
	      END
		  IF(@mostrarResultados = 1)
		  BEGIN
	 	   select D.*, C.procesado, c.tipoMigracion from #detRecepcionItem D INNER JOIN #cabRecepcionItem C ON C.idRecepcion = D.idRecepcion 
		   ORDER BY C.idRecepcion

	       select COUNT(1) registrosAfectado, 'proRecepcionEspecie' as tabla from proRecepcionEspecie
						where estacionModificacion IN ('MIGRACION','UMIGRACION')
	       union select COUNT(1) registrosAfectado, 'proRecepcionEspecieSecuencial' as tabla from proRecepcionEspecieSecuencial      
						where estacionModificacion ='MIGRACION'
	       union select COUNT(1) registrosAfectado, 'proRecepcionEspecieDetalle' as tabla from proRecepcionEspecieDetalle
						where estacionModificacion ='MIGRACION'
	       union select COUNT(1) registrosAfectado, 'proRecepcionEspecieCaracteristica' as tabla from proRecepcionEspecieCaracteristica  
							where estacionModificacion ='MIGRACION'
	       union select COUNT(1) registrosAfectado, 'proRecepcionEspecieParametros' as tabla from proRecepcionEspecieParametros      
							where estacionModificacion ='MIGRACION'		
		   
		   select max(idRecepcion)           idTabla, (select top 1 ultimaSecuencia from proSecuencial where tabla ='recepcionEspecie')           secuencial ,'recepcionEspecie'           as tabla from proRecepcionEspecie			 
	       union select max(idRecepcionSecuencial) idTabla, (select top 1 ultimaSecuencia from proSecuencial where tabla ='recepcionEspecieSecuencial') secuencial ,'recepcionEspecieSecuencial' as tabla from proRecepcionEspecieSecuencial  
	       union select max(idRecepcionDetalle)    idTabla, (select top 1 ultimaSecuencia from proSecuencial where tabla ='recepcionEspecieDetalle')    secuencial ,'recepcionEspecieDetalle'    as tabla from proRecepcionEspecieDetalle         where estacionModificacion ='MIGRACION'
	       union select max(idRecepcionCaracteristica)  idTabla,
		       (select top 1 ultimaSecuencia from proSecuencial where tabla ='recepcionEspecieCaracteristica')    secuencial ,'recepcionEspecieCaracteristica'    as tabla 
		   from proRecepcionEspecieCaracteristica  where estacionModificacion ='MIGRACION' 
		   union select max(idRecepcionParametro)       idTabla,
		       (select top 1 ultimaSecuencia from proSecuencial where tabla ='recepcionEspecieParametros')    secuencial ,'recepcionEspecieParametros'    as tabla 
		   from proRecepcionEspecieParametros  where estacionModificacion ='MIGRACION'
		 END
END