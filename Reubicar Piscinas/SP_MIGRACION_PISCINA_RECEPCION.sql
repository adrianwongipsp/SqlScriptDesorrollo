 
 ALTER PROCEDURE SP_MIGRACION_PISCINA_RECEPCION
	@mostrarResultados bit  
 AS
 BEGIN 
	 
          DECLARE @idRecepcion         INT; 
		  DECLARE @idRecepcionDetalle  INT, 
				  @idZona CHAR(3)        = '',
				  @CodCamaronera CHAR(5) = '',
				  @CodSector CHAR(5)     = '',
				  @idZona_NEW  CHAR(3)   = '',
				  @CodCamaronera_NEW  CHAR(5) = '',
				  @CodSector_NEW  CHAR(5)     = '';

		  DECLARE @ContarDetalle			INT;  
		  DECLARE @CountPiscinasMigrar      INT;
		  DECLARE @Modifica varchar(75)  = 'MIGRACION_PISCINA_20250505';

		  DROP TABLE IF EXISTS #cabRecepcionItem;
		  DROP TABLE IF EXISTS #idsControlDetalle;


		  SELECT  distinct   de.idRecepcion 	
				           , de.idRecepcionDetalle 
				           , de.idPiscina 	
						   , 0 idRecepcionNuevo
					       , 0 idRecepcionDetalleNuevo
						   , ca.zona
						   , ca.camaronera
						   , ca.sector
						   , mp.CODIGOZONA_NEW
						   , mp.CODIGOCAMARONERA_NEW
						   , mp.CODIGOSECTOR_NEW
			 INTO #idsControlDetalle 
		  FROM proRecepcionEspecieDetalle de
			INNER JOIN tempMigracionPiscina mp on de.idPiscina = mp.IDPISCINA    
			INNER JOIN proRecepcionEspecie ca 
		     ON de.idRecepcion = ca.idRecepcion

           SELECT  distinct    idRecepcion
							  ,zona
							  ,camaronera
							  ,sector
							  ,0 procesado
							  ,CODIGOZONA_NEW
							  ,CODIGOCAMARONERA_NEW
							  ,CODIGOSECTOR_NEW
					 into #cabRecepcionItem
		  FROM #idsControlDetalle  
		   
		  WHILE EXISTS(SELECT TOP 1 1 FROM #cabRecepcionItem WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	   @idRecepcion                 = idRecepcion,  
								   @idZona = zona,
								   @CodCamaronera = camaronera,
								   @CodSector     = sector,
								   @idZona_NEW        = CODIGOZONA_NEW,
								   @CodCamaronera_NEW =	CODIGOCAMARONERA_NEW,
								   @CodSector_NEW	  =	CODIGOSECTOR_NEW
					    FROM	#cabRecepcionItem  
						WHERE	procesado = 0 
				ORDER BY idRecepcion
				--select * FROM  proRecepcionEspecieDetalle ap inner join tempMigracionPiscina p WHERE idRecepcion = @idRecepci

				SELECT @CountPiscinasMigrar  =  COUNT(DISTINCT ap.idPiscina) 
												FROM  proRecepcionEspecieDetalle ap 
												WHERE 
													ap.idRecepcion = @idRecepcion

				SELECT @ContarDetalle  =  COUNT(distinct ap.idPiscina) 
											FROM  proRecepcionEspecieDetalle ap 
											INNER JOIN #idsControlDetalle de 
											ON ap.idRecepcion         = de.idRecepcion
											--AND ap.idControlParametroDetalle = de.idControlParametroDetalle
											AND ap.idPiscina                 = de.idPiscina 
											WHERE de.idRecepcion = @idRecepcion 
													AND de.zona                  = @idZona
													AND de.camaronera            = @CodCamaronera
													AND de.sector                = @CodSector
													AND de.CODIGOZONA_NEW        = @idZona_NEW
													AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
													AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

				IF(@ContarDetalle = @CountPiscinasMigrar)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				  BEGIN

				    UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera			 = mp.CODIGOCAMARONERA_NEW,
						  A.sector				 = mp.CODIGOSECTOR_NEW  ,
						  A.estacionModificacion = @Modifica +'_MOD'
						  FROM    proRecepcionEspecie A
						   inner join #idsControlDetalle mp
							 ON   A.zona                 = MP.zona
							 AND  A.camaronera           = MP.camaronera
							 AND  A.sector               = MP.sector
							 AND A.idRecepcion			 = MP.idRecepcion
						  WHERE mp.idRecepcion			    = @idRecepcion
				   			AND mp.zona                     = @idZona
							AND mp.camaronera               = @CodCamaronera
							AND mp.sector                   = @CodSector
							AND mp.CODIGOZONA_NEW		    = @idZona_NEW
							AND mp.CODIGOCAMARONERA_NEW	    = @CodCamaronera_NEW
							AND mp.CODIGOSECTOR_NEW		    = @CodSector_NEW
				  END
				  ELSE
				  BEGIN 
					  --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera			   INT  =0;
						DECLARE @ultimaSecuenciaCabeceraCambioPlus	   INT  =0; 
					    DECLARE @ultimaSecuenciaCabeceraSecuencial     INT  =0;
						DECLARE @ultimaSecuenciaDetalle				   INT  =0;
						DECLARE @ultimaSecuenciaDetalleCaracteristicas INT  =0;
						DECLARE @ultimaSecuenciaDetalleParametros      INT  =0; 
						--DECLARE @ultimaSecuenciaNuevaDetalle						  INT
						--DECLARE @ultimaSecuenciaNuevaDetalleCaracteristicas         INT
						--DECLARE @ultimaSecuenciaNuevaDetalleParametros              INT 

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'recepcionEspecie'
						SELECT TOP 1 @ultimaSecuenciaCabecera = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'recepcionEspecie'  
				
						DECLARE @IdsNecesarios INT =  (SELECT COUNT(1)
						                              FROM proRecepcionEspecieDetalle 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idRecepcion       = de.idRecepcion
				                                         AND ap.idPiscina            = de.idPiscina
				                                      WHERE de.idRecepcion			 = @idRecepcion
													  	AND zona                     = @idZona
					                                    AND camaronera               = @CodCamaronera
					                                    AND sector                   = @CodSector
														AND de.CODIGOZONA_NEW		   = @idZona_NEW
														AND de.CODIGOCAMARONERA_NEW	   = @CodCamaronera_NEW
														AND de.CODIGOSECTOR_NEW		   = @CodSector_NEW)

						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia			= ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieDetalle' 

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
								    @Modifica +'_CRE',        fechaHoraModificacion,
									reprocesoContable  
							FROM 		 proRecepcionEspecie A
											INNER JOIN #idsControlDetalle mp     
											ON A.idRecepcion = mp.idRecepcion  
							 WHERE   mp.idRecepcion = @idRecepcion
							     AND mp.zona                   = @idZona
					             AND mp.camaronera             = @CodCamaronera
					             AND mp.sector                 = @CodSector
								 AND mp.CODIGOZONA_NEW		   = @idZona_NEW
								 AND mp.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
								 AND mp.CODIGOSECTOR_NEW       = @CodSector_NEW

						--detalle
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
							usuarioCreacion,         estacionCreacion,     fechaHoraCreacion,         usuarioModificacion,      @Modifica +'_CRE',
							fechaHoraModificacion,   origenPlGramo
						FROM proRecepcionEspecieDetalle D 
						INNER JOIN #idsControlDetalle DT 
								ON D.idRecepcion =DT.idRecepcion 
								AND D.idPiscina = DT.idPiscina
								AND D.idRecepcionDetalle = DT.idRecepcionDetalle 
						WHERE D.idRecepcion = @idRecepcion
								AND DT.zona                   = @idZona
								AND DT.camaronera             = @CodCamaronera
								AND DT.sector                 = @CodSector
								AND DT.CODIGOZONA_NEW		  = @idZona_NEW
								AND DT.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
								AND DT.CODIGOSECTOR_NEW       = @CodSector_NEW
											--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proRecepcionEspecieDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idRecepcion    = de.idRecepcion
					AND d.idRecepcionDetalle = de.idRecepcionDetalle
				    AND d.idPiscina					= de.idPiscina
				    WHERE d.idRecepcion				= @idRecepcion
					AND de.zona						= @idZona
					AND de.camaronera				= @CodCamaronera
					AND de.sector					= @CodSector
					AND de.CODIGOZONA_NEW			= @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW		= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW			= @CodSector_NEW

				   IF ((SELECT COUNT(1) FROM proRecepcionEspecieDetalle WHERE idRecepcion = @idRecepcion) = 
						(SELECT COUNT(1) FROM proRecepcionEspecieDetalle WHERE idRecepcion = @idRecepcion AND activo = 0))
				   BEGIN
					 UPDATE  proRecepcionEspecie SET estado ='ANU', estacionModificacion=@Modifica + '_ANUCAB' WHERE idRecepcion = @idRecepcion
				   END
				  ELSE 
				   BEGIN
				   		UPDATE A SET     
						  a.estacionModificacion  = @Modifica +'_MODCAB'
				        FROM      proRecepcionEspecie A 
			            WHERE   idRecepcion = @idRecepcion
				   END
						--actualizo cab y det con sus id nuevos
						UPDATE d
							SET d.idRecepcionDetalleNuevo =(SELECT idRecepcionDetalle
												   FROM  proRecepcionEspecieDetalle de WITH (NOLOCK) 
												   WHERE de.idRecepcion = @ultimaSecuenciaCabecera 
												   AND de.idPiscina=d.idPiscina),
								d.idRecepcionNuevo = @ultimaSecuenciaCabecera
							FROM   #idsControlDetalle d
							WHERE d.idRecepcion				= @idRecepcion 
							AND d.zona						= @idZona
							AND d.camaronera				= @CodCamaronera
							AND d.sector					= @CodSector
							AND d.CODIGOZONA_NEW			= @idZona_NEW
							AND d.CODIGOCAMARONERA_NEW		= @CodCamaronera_NEW
							AND d.CODIGOSECTOR_NEW			= @CodSector_NEW


					--plus
					    DECLARE @IdsNecesariosPlus INT =  (SELECT COUNT(1)
						                              FROM proRecepcionEspecieDetalleCambioPlus	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idRecepcion       = de.idRecepcion
				                                      WHERE de.idRecepcion			 = @idRecepcion
													  	AND zona                     = @idZona
					                                    AND camaronera               = @CodCamaronera
					                                    AND sector                   = @CodSector
														AND de.CODIGOZONA_NEW		   = @idZona_NEW
														AND de.CODIGOCAMARONERA_NEW	   = @CodCamaronera_NEW
														AND de.CODIGOSECTOR_NEW		   = @CodSector_NEW)

						UPDATE proSecuencial SET @ultimaSecuenciaCabeceraCambioPlus = ultimaSecuencia ,
												ultimaSecuencia = ultimaSecuencia + @IdsNecesariosPlus WHERE tabla = 'recepcionEspecieDetalleCambioPlus'
					  
						INSERT INTO proRecepcionEspecieDetalleCambioPlus
							    (idRecepcionEspecieDetalleCambioPlus,   
								 idRecepcion,			fechaCambioPlus,	
							     porcentajePlusAnterior,				porcentajePlusActual,   usuarioCreacion, 
							     estacionCreacion,						fechaHoraCreacion,		usuarioModificacion, 
							     estacionModificacion,					fechaHoraModificacion)
						SELECT 
							  ROW_NUMBER() OVER (ORDER BY A.idRecepcionEspecieDetalleCambioPlus) +  @ultimaSecuenciaCabeceraCambioPlus,  
							  @ultimaSecuenciaCabecera,				fechaCambioPlus,	
							  porcentajePlusAnterior,				porcentajePlusActual,     usuarioCreacion, 
							  estacionCreacion,						fechaHoraCreacion,		  usuarioModificacion, 
							  @Modifica,							fechaHoraModificacion
						FROM 
						   proRecepcionEspecieDetalleCambioPlus A 	
						   INNER JOIN #idsControlDetalle mp     
											ON A.idRecepcion = mp.idRecepcion  
							 WHERE   mp.idRecepcion = @idRecepcion
							     AND mp.zona                   = @idZona
					             AND mp.camaronera             = @CodCamaronera
					             AND mp.sector                 = @CodSector
								 AND mp.CODIGOZONA_NEW		   = @idZona_NEW
								 AND mp.CODIGOCAMARONERA_NEW   = @CodCamaronera_NEW
								 AND mp.CODIGOSECTOR_NEW       = @CodSector_NEW 
					  
						---SECUENCIAL RECEPCION
						    DECLARE @IdsNecesariosSecuencial INT =  (SELECT COUNT(1)
						                              FROM proRecepcionEspecieSecuencial	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON    de.idRecepcion              = ap.idRecepcion   
				                                      WHERE de.idRecepcion			    = @idRecepcion
													  	AND de.zona                     = @idZona
					                                    AND de.camaronera               = @CodCamaronera
					                                    AND de.sector                   = @CodSector
														AND de.CODIGOZONA_NEW		    = @idZona_NEW
														AND de.CODIGOCAMARONERA_NEW	    = @CodCamaronera_NEW
														AND de.CODIGOSECTOR_NEW		    = @CodSector_NEW)

						UPDATE proSecuencial SET @ultimaSecuenciaCabeceraSecuencial  = ultimaSecuencia ,
												ultimaSecuencia = ultimaSecuencia + @IdsNecesariosSecuencial WHERE tabla = 'recepcionEspecieSecuencial'
					    
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
							 usuarioModificacion,	@Modifica,          fechaHoraModificacion 
						FROM proRecepcionEspecieSecuencial A 
						WHERE A.idRecepcion = @idRecepcion

							UPDATE  d SET activo               = 0,
										  estacionModificacion = @Modifica+'_ANU'
							FROM  proRecepcionEspecieSecuencial d 
							INNER JOIN #idsControlDetalle de 
							ON d.idRecepcion    = de.idRecepcion 
							WHERE d.idRecepcion				= @idRecepcion
							AND de.zona						= @idZona
							AND de.camaronera				= @CodCamaronera
							AND de.sector					= @CodSector
							AND de.CODIGOZONA_NEW			= @idZona_NEW
							AND de.CODIGOCAMARONERA_NEW		= @CodCamaronera_NEW
							AND de.CODIGOSECTOR_NEW			= @CodSector_NEW
					    --SUBDETALLE DE PARAMETROS
						DECLARE @IdsNecesariosParametros INT =0;
						SELECT  @IdsNecesariosParametros =  (SELECT COUNT(1)
															 FROM proRecepcionEspecieParametros 	ap		
															 INNER JOIN #idsControlDetalle          de 
															 ON ap.idRecepcionDetalle    = de.idRecepcionDetalle
															 WHERE de.idRecepcion        = @idRecepcion
															 AND de.zona                 = @idZona
															 AND de.camaronera           = @CodCamaronera
															 AND de.sector               = @CodSector
															 AND de.CODIGOZONA_NEW			= @idZona_NEW
															 AND de.CODIGOCAMARONERA_NEW    = @CodCamaronera_NEW
															 AND de.CODIGOSECTOR_NEW        = @CodSector_NEW)

						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalleParametros   = ultimaSecuencia,
							ultimaSecuencia						= ultimaSecuencia + @IdsNecesariosParametros  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieParametros'  
						 
						 	INSERT INTO proRecepcionEspecieParametros
					    (   idRecepcionParametro,       
							idRecepcion,			    idRecepcionDetalle,       
							orden,                      idParametroControl,
							valorEnPreparacion,         valorTinaPromedio,         valorPSInicio,            valorPSFin,              idCualidadEnPreparacion,
							idCualidadTinaPromedio,     idCualidadPSInicio,        idCualidadPSFin,          activo,                  usuarioCreacion,
							estacionCreacion,           fechaHoraCreacion,         usuarioModificacion,      estacionModificacion,    fechaHoraModificacion)
					SELECT 
						ROW_NUMBER() OVER (ORDER BY AP.idRecepcionParametro) +@ultimaSecuenciaDetalleParametros,    
							@ultimaSecuenciaCabecera,       de.idRecepcionDetalleNuevo,       
							orden,                      idParametroControl,
							valorEnPreparacion,         valorTinaPromedio,         valorPSInicio,            valorPSFin,      idCualidadEnPreparacion,
							idCualidadTinaPromedio,     idCualidadPSInicio,        idCualidadPSFin,          activo,          usuarioCreacion,
							estacionCreacion,           fechaHoraCreacion,         usuarioModificacion,      @Modifica,		  fechaHoraModificacion
					FROM proRecepcionEspecieParametros  ap 
					INNER JOIN #idsControlDetalle de 
				    ON ap.idRecepcionDetalle    = de.idRecepcionDetalle
				        WHERE de.idRecepcion        = @idRecepcion
						AND de.zona                 = @idZona
					    AND de.camaronera           = @CodCamaronera
					    AND de.sector               = @CodSector
						AND de.CODIGOZONA_NEW		= @idZona_NEW
					    AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					    AND de.CODIGOSECTOR_NEW		= @CodSector_NEW
					
					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proRecepcionEspecieParametros d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idRecepcion    = de.idRecepcion
					AND d.idRecepcionDetalle = de.idRecepcionDetalle
				    WHERE d.idRecepcion				= @idRecepcion
					AND de.zona						= @idZona
					AND de.camaronera				= @CodCamaronera
					AND de.sector					= @CodSector
					AND de.CODIGOZONA_NEW			= @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW		= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW			= @CodSector_NEW

							    --SUBDETALLE DE CARACTERISTICA
						DECLARE @IdsNecesariosCaracteristicas INT =0;
						SELECT  @IdsNecesariosCaracteristicas =  (SELECT COUNT(1)
															 FROM proRecepcionEspecieCaracteristica 	ap		
															 INNER JOIN #idsControlDetalle          de 
															 ON ap.idRecepcionDetalle    = de.idRecepcionDetalle
															 WHERE de.idRecepcion        = @idRecepcion
															 AND de.zona                 = @idZona
															 AND de.camaronera           = @CodCamaronera
															 AND de.sector               = @CodSector
															 AND de.CODIGOZONA_NEW			= @idZona_NEW
															 AND de.CODIGOCAMARONERA_NEW    = @CodCamaronera_NEW
															 AND de.CODIGOSECTOR_NEW        = @CodSector_NEW)

						UPDATE proSecuencial 
						SET @ultimaSecuenciaDetalleCaracteristicas   = ultimaSecuencia,
							ultimaSecuencia						= ultimaSecuencia + @IdsNecesariosCaracteristicas  -- Valor arbitrario pero seguro
						WHERE tabla = 'recepcionEspecieCaracteristica'  

					INSERT INTO proRecepcionEspecieCaracteristica
					    (idRecepcionCaracteristica,    
						 idRecepcion,                  idRecepcionDetalle,       
						 orden,                        idParametroControl,
						 valorEnLaboratorio,           valorEnCamaronera,         idCualidadEnLaboratorio,  idCualidadEnCamaronera,   activo,
						 usuarioCreacion,              estacionCreacion,          fechaHoraCreacion,        usuarioModificacion,      estacionModificacion,
						 fechaHoraModificacion)
					SELECT 
						ROW_NUMBER() OVER (ORDER BY AP.idRecepcionCaracteristica) +@ultimaSecuenciaDetalleCaracteristicas,    
						@ultimaSecuenciaCabecera,     DE.idRecepcionDetalleNuevo,       
						orden,						  idParametroControl,
						valorEnLaboratorio,           valorEnCamaronera,         idCualidadEnLaboratorio,  idCualidadEnCamaronera,   activo,
						usuarioCreacion,              estacionCreacion,          fechaHoraCreacion,        usuarioModificacion,      @Modifica,
						fechaHoraModificacion
					FROM proRecepcionEspecieCaracteristica  AP 
					INNER JOIN #idsControlDetalle de 
				    ON ap.idRecepcionDetalle    = de.idRecepcionDetalle
				        WHERE de.idRecepcion        = @idRecepcion
						AND de.zona                 = @idZona
					    AND de.camaronera           = @CodCamaronera
					    AND de.sector               = @CodSector
						AND de.CODIGOZONA_NEW		= @idZona_NEW
					    AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					    AND de.CODIGOSECTOR_NEW		= @CodSector_NEW 
				
					 			--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proRecepcionEspecieCaracteristica d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idRecepcion    = de.idRecepcion
					AND d.idRecepcionDetalle = de.idRecepcionDetalle
				    WHERE d.idRecepcion				= @idRecepcion
					AND de.zona						= @idZona
					AND de.camaronera				= @CodCamaronera
					AND de.sector					= @CodSector
					AND de.CODIGOZONA_NEW			= @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW		= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW			= @CodSector_NEW
				  END


			           UPDATE #cabRecepcionItem SET procesado = 1 WHERE idRecepcion  = @idRecepcion		    AND 
															  procesado			  = 0  
														 AND zona                 = @idZona
					                                     AND camaronera           = @CodCamaronera
					                                     AND sector               = @CodSector
														 AND CODIGOZONA_NEW		  = @idZona_NEW
														 AND CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
														 AND CODIGOSECTOR_NEW	   = @CodSector_NEW

	      END 
END