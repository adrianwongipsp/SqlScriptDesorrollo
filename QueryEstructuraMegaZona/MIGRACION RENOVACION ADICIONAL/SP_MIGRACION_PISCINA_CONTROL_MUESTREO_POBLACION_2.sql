 
 
CREATE PROCEDURE [dbo].[SP_MIGRACION_PISCINA_CONTROL_MUESTREO_POBLACION_2]
AS
BEGIN
--BEGIN TRAN	 
SET NOCOUNT ON;
		   /*PROCESO  DE MUESTREOS DE POBLACION */
          DECLARE   @id INT = 0,
		    @idZona CHAR(3) = '',
     @CodCamaronera CHAR(5) = '',
         @CodSector CHAR(5) = '',
       @idZona_NEW  CHAR(3) = '',
@CodCamaronera_NEW  CHAR(5) = '',
    @CodSector_NEW  CHAR(5) = '',
		         @Count INT = 0,
		        @Count1 INT = 0,
      @Modifica varchar(75) = 'MIGRACION_PISCINA_20250505';

	  	/*Unificar*/
		UPDATE p
		SET    p.zona   = c.CODIGOZONA_NEW,
			   p.camaronera = c.CODIGOCAMARONERA_NEW,
			   p.sector     = c.CODIGOSECTOR_NEW,
			   p.estacionModificacion = @Modifica + '_UNI'
		FROM   dbo.proMuestreoPoblacion p
		JOIN   tempMigracionPiscina c ON
				p.zona               = c.CODIGOZONA_OLD
			  AND p.camaronera         = c.CODIGOCAMARONERA_OLD
			  AND p.sector             = c.CODIGOSECTOR_OLD
		WHERE  c.unificacion = 1;

		  SELECT DISTINCT  
		           de.idMuestreo
		          ,0 procesado
		          ,de.idMuestreoDetalle
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
		  FROM proMuestreoPoblacionDetalleLance de 
		  INNER JOIN tempMigracionPiscina mp 
		  ON de.idPiscina    =  mp.IDPISCINA  
		  INNER JOIN proMuestreoPoblacion ca 
		  ON de.idMuestreo = ca.idMuestreo
          WHERE  ISNULL(unificacion,0) = 0 and de.idPiscina > 0;

		  SELECT DISTINCT 
		           idMuestreo
				   ,zona
				  ,camaronera
				  ,sector
		          ,0 procesado
				  ,CODIGOZONA_NEW
				  ,CODIGOCAMARONERA_NEW
				  ,CODIGOSECTOR_NEW
		  INTO #idsControl
		  FROM #idsControlDetalle

		  SELECT COUNT(*) FROM  #idsControl
		  WHILE EXISTS(SELECT TOP 1 1 FROM #idsControl WHERE procesado = 0)
		  BEGIN
				SELECT TOP 1	
				     @id = idMuestreo,
				 @idZona = zona,
		  @CodCamaronera = camaronera,
			  @CodSector = sector,
		     @idZona_NEW = CODIGOZONA_NEW,
	  @CodCamaronera_NEW = CODIGOCAMARONERA_NEW,
	      @CodSector_NEW = CODIGOSECTOR_NEW
		        FROM #idsControl 
				WHERE procesado=0
				order by idMuestreo

				SELECT @Count1  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPoblacionDetalleLance ap 
				WHERE ap.idMuestreo =@id
				  AND ap.idPiscina > 0;

			    SELECT @Count  =  COUNT(DISTINCT ap.idPiscina) 
				FROM  proMuestreoPoblacionDetalleLance ap 
				INNER JOIN #idsControlDetalle de 
				ON  ap.idMuestreo=de.idMuestreo
				AND ap.idPiscina=de.idPiscina
				WHERE ap.idMuestreo = @id
				AND de.zona         = @idZona
			    AND de.camaronera   = @CodCamaronera
			    AND de.sector       = @CodSector
				AND de.CODIGOZONA_NEW        = @idZona_NEW
				AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
				AND de.CODIGOSECTOR_NEW      = @CodSector_NEW

				IF(@Count = @Count1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				BEGIN
				  	 print 'INGRESO'
				  	 print 
							 'INGRESO MOD SIMPLE'    +  
							 + '|' + cast(@id as varchar(15))    
						     + '|' + cast(@Count as varchar(15))
							 + '|' + cast(@Count1 as varchar(15))

				   UPDATE A SET    
						  A.zona                 = mp.CODIGOZONA_NEW,
						  A.camaronera           = mp.CODIGOCAMARONERA_NEW,
						  A.sector               = mp.CODIGOSECTOR_NEW, 
				          A.estacionModificacion = @Modifica +'_MODCAB'
				   FROM    proMuestreoPoblacion A
				   INNER JOIN #idsControlDetalle MP
				     ON   A.zona               = MP.zona
					 AND  A.camaronera         = MP.camaronera
					 AND  A.sector             = MP.sector
					 AND  A.idMuestreo         = mp.idMuestreo
			       WHERE  A.idMuestreo         = @id
				   	AND A.zona                 = @idZona
					AND A.camaronera           = @CodCamaronera
					AND A.sector               = @CodSector
					AND mp.CODIGOZONA_NEW	   = @idZona_NEW
				    AND mp.CODIGOCAMARONERA_NEW= @CodCamaronera_NEW
				    AND mp.CODIGOSECTOR_NEW	   = @CodSector_NEW
				END

				  IF(@Count != @Count1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				  BEGIN
						 --separamaos los secuenciles para la creacion
					    DECLARE @ultimaSecuenciaCabecera INT=0, @ultimaSecuenciaDetalle INT =0,@ultimaSecuenciaNueva INT=0, @IdsDeta INT=0;

						UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'MuestreoPoblacion'
						SELECT TOP 1 @ultimaSecuenciaCabecera    = ultimaSecuencia  FROM proSecuencial WHERE tabla = 'MuestreoPoblacion'  

						SET @IdsDeta         = (SELECT COUNT(1)
						                              FROM proMuestreoPoblacionDetalleLance 	ap		
						                                   INNER JOIN #idsControlDetalle de 
				                                      ON ap.idMuestreo            = de.idMuestreo
				                                         AND ap.idPiscina         = de.idPiscina
				                                      WHERE ap.idMuestreo         = @id
													  AND de.zona                 = @idZona
			                                          AND de.camaronera           = @CodCamaronera
			                                          AND de.sector               = @CodSector
													  AND de.CODIGOZONA_NEW		  = @idZona_NEW
													  AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
													  AND de.CODIGOSECTOR_NEW	  = @CodSector_NEW													  )

						UPDATE proSecuencial 
						SET    @ultimaSecuenciaDetalle  = ultimaSecuencia,
							   ultimaSecuencia			= ultimaSecuencia + @IdsDeta  -- Valor arbitrario pero seguro
						WHERE  tabla = 'MuestreoPoblacionDetalleLance'


						--select @ultimaSecuenciaCabecera, @id, @IdsDeta
						--select @ultimaSecuenciaDetalle, @Count
							print 
							 'MODO DETALLE: @ultimaSecuenciaCabecera: '    + cast(@ultimaSecuenciaCabecera as varchar(15))    
							 + '|@id: ' + cast(@id as varchar(15))   
							 + '|@ultimaSecuenciaDetalle: ' + cast(@ultimaSecuenciaDetalle as varchar(15))  
						     + '|@Count: ' + cast(@Count as varchar(15))
							 + '|@Count1: ' + cast(@Count1 as varchar(15))
						--crear la cabecera con los nuevos campos 
						
					INSERT INTO [dbo].[proMuestreoPoblacion]
							   ([idMuestreo]
							   ,[empresa]
							   ,[division]
							   ,[zona]
							   ,[secuencia]
							   ,[fechaRegistro]
							   ,[fechaMuestreo]
							   ,[camaronera]
							   ,[sector]
							   ,[idTiempo]
							   ,[idResponsable]
							   ,[usuarioResponsable]
							   ,[porLance]
							   ,[porMuestra]
							   ,[descripcion]
							   ,[estado]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion]
							   ,[idAtarraya]
							   ,[idMarea]
							   ,[idFaseLunar]
							   ,[responsable]
							   ,[atarrayador]
							   ,[bogador])
	                SELECT TOP 1  @ultimaSecuenciaCabecera 
								,empresa
								,division
								,CODIGOZONA_NEW 
								,@ultimaSecuenciaCabecera
								,fechaRegistro
								,fechaMuestreo
								,CODIGOCAMARONERA_NEW 
								,CODIGOSECTOR_NEW 
								,idTiempo
								,idResponsable
								,usuarioResponsable
								,porLance
								,porMuestra
								,descripcion
								,estado
								,usuarioCreacion
								,estacionCreacion
								,fechaHoraCreacion
								,usuarioModificacion
								,@Modifica +'_CRE'
								,fechaHoraModificacion
								,idAtarraya
								,idMarea
								,idFaseLunar
								,responsable
								,atarrayador
								,bogador
						FROM 	proMuestreoPoblacion A
						INNER JOIN #idsControlDetalle MP 
						ON   A.idMuestreo             = Mp.idMuestreo
						WHERE A.idMuestreo            = @id
						 AND a.zona                   = @idZona
					     AND a.camaronera             = @CodCamaronera
					     AND a.sector                 = @CodSector
						 AND mp.CODIGOZONA_NEW		  = @idZona_NEW
						 AND mp.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
						 AND mp.CODIGOSECTOR_NEW      = @CodSector_NEW



			    INSERT INTO [dbo].[proMuestreoPoblacionDetalleLance]
								   ([idMuestreoDetalle]
								   ,[idMuestreo]
								   ,[orden]
								   ,[idPiscina]
								   ,[idPiscinaEjecucion]
								   ,[areaSuperficiehectarea]
								   ,[horaMuestreo]
								   ,[cantidadMuertos]
								   ,[cantidadMudados]
								   ,[cantidadBlandos]
								   ,[cantidadFlacidos]
								   ,[cantidadHongos]
								   ,[cantidadBacterias]
								   ,[cantidadBranqueasSucias]
								   ,[cantidadOtros]
								   ,[areaAtarraya]
								   ,[factorAtarrayador]
								   ,[numeroAnimales]
								   ,[porcentajeApertura]
								   ,[poblacionEstimada]
								   ,[observacion]
								   ,[activo]
								   ,[usuarioCreacion]
								   ,[estacionCreacion]
								   ,[fechaHoraCreacion]
								   ,[usuarioModificacion]
								   ,[estacionModificacion]
								   ,[fechaHoraModificacion]
								   ,[ubicacionCodigo]
								   ,[promedioNivelAgua]
								   ,[poblacionReportada])
		             SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoDetalle)  + @ultimaSecuenciaDetalle) 
								  ,@ultimaSecuenciaCabecera
								  ,orden
								  ,ap.idPiscina
								  ,idPiscinaEjecucion
								  ,areaSuperficiehectarea
								  ,horaMuestreo
								  ,cantidadMuertos
								  ,cantidadMudados
								  ,cantidadBlandos
								  ,cantidadFlacidos
								  ,cantidadHongos
								  ,cantidadBacterias
								  ,cantidadBranqueasSucias
								  ,cantidadOtros
								  ,areaAtarraya
								  ,factorAtarrayador
								  ,numeroAnimales
								  ,porcentajeApertura
								  ,poblacionEstimada
								  ,observacion
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica+'_CRE'
								  ,fechaHoraModificacion
								  ,ubicacionCodigo
								  ,promedioNivelAgua
								  ,poblacionReportada
						FROM    proMuestreoPoblacionDetalleLance ap		
						INNER JOIN #idsControlDetalle de 
				                   ON ap.idMuestreo    = de.idMuestreo
							  AND ap.idMuestreoDetalle = de.idMuestreoDetalle
				              AND ap.idPiscina    = de.idPiscina
				        WHERE ap.idMuestreo            = @id
						 AND de.zona                   = @idZona
					     AND de.camaronera             = @CodCamaronera
					     AND de.sector                 = @CodSector
						 AND de.CODIGOZONA_NEW		  = @idZona_NEW
						 AND de.CODIGOCAMARONERA_NEW  = @CodCamaronera_NEW
						 AND de.CODIGOSECTOR_NEW      = @CodSector_NEW
			

					--inactivo los detalle antiguo migrado a la nueva transaccion
					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPoblacionDetalleLance d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreo         = de.idMuestreo
					AND d.idMuestreoDetalle = de.idMuestreoDetalle
				    AND d.idPiscina         = de.idPiscina
				    WHERE d.idMuestreo      = @id
					AND de.zona             = @idZona
					AND de.camaronera       = @CodCamaronera
					AND de.sector           = @CodSector
					AND de.CODIGOZONA_NEW	= @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW	= @CodSector_NEW

					
					UPDATE d
					SET d.idDetActual=(SELECT idMuestreoDetalle
					                   FROM  proMuestreoPoblacionDetalleLance de WITH (NOLOCK) 
					                   WHERE de.idMuestreo = @ultimaSecuenciaCabecera 
					                   AND de.idPiscina=d.idPiscina),
					    d.idCabActual=@ultimaSecuenciaCabecera
					FROM   #idsControlDetalle d
					WHERE d.idMuestreo         = @id 
					AND d.zona                 = @idZona
					AND d.camaronera           = @CodCamaronera
					AND d.sector               = @CodSector
					AND d.CODIGOZONA_NEW	   = @idZona_NEW
					AND d.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					AND d.CODIGOSECTOR_NEW	   = @CodSector_NEW

				   UPDATE A SET     
						  a.estacionModificacion = @Modifica +'_MODCAB'
				   FROM   proMuestreoPoblacion A 
			       WHERE  idMuestreo             = @id



                	DECLARE @IdsC INT = (SELECT COUNT(1)
						                     FROM proMuestreoPoblacionDetalleCaracteristica 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle     = de.idMuestreoDetalle
				                             WHERE de.idMuestreo         = @id
											 AND de.zona                 = @idZona
					                         AND de.camaronera           = @CodCamaronera
					                         AND de.sector               = @CodSector
                                             AND de.CODIGOZONA_NEW	     = @idZona_NEW
											 AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
											 AND de.CODIGOSECTOR_NEW     = @CodSector_NEW											 ), @ultimaSecuenciaC INT=0;
			  
					UPDATE proSecuencial 
					SET @ultimaSecuenciaC = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsC -- Valor arbitrario pero seguro
					WHERE tabla           = 'MuestreoPoblacionDetalleCaracteristica'
					 
					INSERT INTO[dbo].[proMuestreoPoblacionDetalleCaracteristica]
							   ([idMuestreoCaracteristica]
							   ,[idMuestreo]
							   ,[idMuestreoDetalle]
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
		              SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoCaracteristica)  + @ultimaSecuenciaC) 
								  ,@ultimaSecuenciaCabecera
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
								  ,@Modifica+'_CRE'
								  ,fechaHoraModificacion
						FROM    proMuestreoPoblacionDetalleCaracteristica ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idMuestreoDetalle     = de.idMuestreoDetalle
				        WHERE de.idMuestreo         = @id
						AND de.zona                 = @idZona
					    AND de.camaronera           = @CodCamaronera
					    AND de.sector               = @CodSector
						AND de.CODIGOZONA_NEW		= @idZona_NEW
					    AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					    AND de.CODIGOSECTOR_NEW		= @CodSector_NEW

					UPDATE  d SET activo               = 0, 
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPoblacionDetalleCaracteristica d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle      = de.idMuestreoDetalle
				    WHERE de.idMuestreo         = @id
				    AND de.zona                 = @idZona
					AND de.camaronera           = @CodCamaronera
					AND de.sector               = @CodSector
					AND de.CODIGOZONA_NEW	    = @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW	= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW		= @CodSector_NEW


                	DECLARE @IdsP INT = (SELECT COUNT(1)
						                     FROM proMuestreoPoblacionProfundidadDetalle 	ap		
						                     INNER JOIN #idsControlDetalle de 
				                             ON ap.idMuestreoDetalle     = de.idMuestreoDetalle
				                             WHERE de.idMuestreo         = @id
											 AND de.zona                 = @idZona
					                         AND de.camaronera           = @CodCamaronera
					                         AND de.sector               = @CodSector
					                         AND de.CODIGOZONA_NEW	     = @idZona_NEW
					                         AND de.CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					             AND de.CODIGOSECTOR_NEW	 = @CodSector_NEW	), @ultimaSecuenciaP INT=0;

					UPDATE proSecuencial 
					SET @ultimaSecuenciaP = ultimaSecuencia,
						ultimaSecuencia	  = ultimaSecuencia + @IdsP  -- Valor arbitrario pero seguro
					WHERE tabla           = 'MuestreoPoblacionProfundidadDetalle'


					
					
						INSERT INTO [dbo].[proMuestreoPoblacionProfundidadDetalle]
							   ([idMuestreoProfundidadDetalle]
							   ,[idMuestreoDetalle]
							   ,[orden]
							   ,[idProfundidad]
							   ,[cantidadLance]
							   ,[activo]
							   ,[usuarioCreacion]
							   ,[estacionCreacion]
							   ,[fechaHoraCreacion]
							   ,[usuarioModificacion]
							   ,[estacionModificacion]
							   ,[fechaHoraModificacion]
							   ,[ubicacionCodigo]
							   ,[idParametroControlFresco]
							   ,[idParametroControlViejo]
							   ,[valorFresco]
							   ,[valorViejo])
		              SELECT   (ROW_NUMBER() OVER(ORDER BY ap.idMuestreoProfundidadDetalle)  + @ultimaSecuenciaP) 
								  ,de.idDetActual
								  ,orden
								  ,idProfundidad
								  ,cantidadLance
								  ,activo
								  ,usuarioCreacion
								  ,estacionCreacion
								  ,fechaHoraCreacion
								  ,usuarioModificacion
								  ,@Modifica+'_CRE'
								  ,fechaHoraModificacion
								  ,ubicacionCodigo
								  ,idParametroControlFresco
								  ,idParametroControlViejo
								  ,valorFresco
								  ,valorViejo
						FROM    proMuestreoPoblacionProfundidadDetalle ap		
						INNER JOIN #idsControlDetalle de 
				        ON ap.idMuestreoDetalle = de.idMuestreoDetalle
				        WHERE de.idMuestreo     = @id
						AND de.zona             = @idZona
					    AND de.camaronera       = @CodCamaronera
					    AND de.sector           = @CodSector
					AND de.CODIGOZONA_NEW		= @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW	= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW		= @CodSector_NEW

					UPDATE  d SET activo               = 0,
					              estacionModificacion = @Modifica+'_ANU'
					FROM  proMuestreoPoblacionProfundidadDetalle d 
					INNER JOIN #idsControlDetalle de 
				    ON d.idMuestreoDetalle = de.idMuestreoDetalle
				    WHERE de.idMuestreo    = @id
					AND de.zona            = @idZona
					AND de.camaronera      = @CodCamaronera
					AND de.sector          = @CodSector
					AND de.CODIGOZONA_NEW			= @idZona_NEW
					AND de.CODIGOCAMARONERA_NEW		= @CodCamaronera_NEW
					AND de.CODIGOSECTOR_NEW			= @CodSector_NEW

				   END
			
			       UPDATE #idsControl SET procesado = 1 WHERE idMuestreo               = @id	
				                                              AND procesado	           = 0 
															  AND zona                 = @idZona
					                                          AND camaronera           = @CodCamaronera
					                                          AND sector               = @CodSector
															  AND CODIGOZONA_NEW	   = @idZona_NEW
					                                          AND CODIGOCAMARONERA_NEW = @CodCamaronera_NEW
					                                          AND CODIGOSECTOR_NEW	   = @CodSector_NEW


 
            

 
		END
		 --  SELECT COUNT(*) AS CONTROLES_ANULADOS      FROM proMuestreoPoblacion WITH(NOLOCK) WHERE estacionModificacion = @Modifica+'_ANU'
			--SELECT COUNT(*) AS CONTROLES_CREADOS       FROM proMuestreoPoblacion WITH(NOLOCK) WHERE estacionModificacion = @Modifica+'_CRE'
		 --   SELECT COUNT(*) AS CONTROLES_ACTUALIZADOS  FROM proMuestreoPoblacion WITH(NOLOCK) WHERE estacionModificacion = @Modifica +'_MOD' --AND estacionCreacion <> @Modifica AND ESTADO <> 'ANU'
			--SELECT COUNT(*) AS CONTROLES_ACTUALIZADOS  FROM proMuestreoPoblacion WITH(NOLOCK) WHERE estacionModificacion = @Modifica +'_MODCAB' 
			SET NOCOUNT OFF;
--ROLLBACK TRAN
END 
