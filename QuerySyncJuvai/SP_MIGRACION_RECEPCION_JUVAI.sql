
CREATE PROCEDURE [dbo].[SP_MIGRACION_RECEPCION_JUVAI]    
  @fechaParametro DATE
AS   
BEGIN
	DECLARE  @fechaIni DATE = DATEADD(DAY, -2,  @fechaParametro),
			 @fechaFin DATE = @fechaParametro,
			 @idPiscina INT = 0,
		   @idEjecucion INT = 0,
				@fecha DATE,
			   @IdJuvai INT = 0,
	  @Modifica varchar(75) = 'MIGRACION_JUVAI_MOD' + FORMAT(GETDATE(), 'yyyyMMdd');

			---- Verificar si la tabla temporal ya existe y eliminarla
			IF OBJECT_ID('tempdb..#tmp_recepcion_siembra') IS NOT NULL
				DROP TABLE #tmp_recepcion_siembra;

			-- Crear la tabla temporal
			CREATE TABLE #tmp_recepcion_siembra (
				procesado BIT,
				idPiscina INT,
				idPiscinaEjecucion INT,
				Ciclo INT,
				Piscina VARCHAR(60),
				Rol VARCHAR(6),
				nbIdImagen  INT,
				FechaTransaccion DATETIME NULL,
				FechaRegistro DATETIME NULL,
				PlGramoCamJuvai DECIMAL(18,5),
				Cantidad INT NULL,
			);

			INSERT INTO #tmp_recepcion_siembra (idPiscina,idPiscinaEjecucion, Ciclo, Piscina, Rol, procesado, nbIdImagen, FechaTransaccion, FechaRegistro, PlGramoCamJuvai, Cantidad )
			SELECT DISTINCT  ej.idPiscina
						   , ej.idPiscinaEjecucion
						   , ej.Ciclo
						   , ej.keyPiscina
						   , ej.rolPiscina
						   , 0
						   , x.nbIdImagen
						   , x.dtFechaRegistro
						   , x.dtFechaRegistroEnvio
						   , ((1.0 / NULLIF(x.nbAverageWeight, 0)) *1000)
						   , x.nbNumeroAnimales
			FROM  EjecucionesPiscinaView ej
				 INNER JOIN [192.168.1.83].[IPSP_JUVAI].DBO.VW_BASEPESOMUESTRA x 
				 ON x.txtClavePiscina COLLATE SQL_Latin1_General_CP1_CI_AS = ej.keyPiscina 
				 AND x.nbIdPiscinaEjecucion = ej.idPiscinaEjecucion
			WHERE ej.estado IN('EJE', 'INI') 
			AND CAST(x.dtFechaRegistro AS DATE) BETWEEN @FechaIni AND @FechaFin
				  AND x.nbidtipomuestra      = 1
				  AND ej.Ciclo               > 0
				  AND NOT EXISTS (SELECT * FROM AuditoriaMigracionJuvai y
								   WHERE y.IdJuvai=x.nbIdImagen  
								   AND y.TipoTransaccion='RECEPCION')

		
			  --SELECT * FROM #tmp_recepcion_siembra
			  WHILE EXISTS(SELECT TOP 1 1 FROM #tmp_recepcion_siembra WHERE procesado = 0)
			  BEGIN
					SELECT TOP 1	
							@idPiscina = idPiscina,
						  @idEjecucion = idPiscinaEjecucion,
								@fecha = FechaTransaccion,
							  @IdJuvai = nbIdImagen
					FROM #tmp_recepcion_siembra 
					WHERE procesado=0
					ORDER BY idPiscina;
					DECLARE @idRecepcion INT=0;
		   

					  IF EXISTS (SELECT   *
								FROM proRecepcionEspecieDetalle d WITH(NOLOCK) 
								INNER JOIN proRecepcionEspecie c WITH(NOLOCK) ON d.idRecepcion=c.idRecepcion
								INNER JOIN #tmp_recepcion_siembra x ON d.idPiscina= x.idPiscina AND d.idPiscinaEjecucion=x.idPiscinaEjecucion
								WHERE x.nbIdImagen    = @IdJuvai 
								 AND c.fechaRecepcion = CAST(@fecha AS DATE)
								 AND c.estado         = 'APR' 
								 AND d.activo        = 1)
						BEGIN
								UPDATE d
								 SET  @idRecepcion           = c.idRecepcion,
									 d.plGramoCam            = x.PlGramoCamJuvai,
									 d.fechaHoraModificacion = GETDATE(),
									 d.estacionModificacion  = @Modifica							 
								FROM proRecepcionEspecieDetalle d WITH(NOLOCK) 
								INNER JOIN proRecepcionEspecie c WITH(NOLOCK) ON d.idRecepcion=c.idRecepcion
								INNER JOIN #tmp_recepcion_siembra x ON d.idPiscina= x.idPiscina AND d.idPiscinaEjecucion=x.idPiscinaEjecucion
								WHERE x.nbIdImagen    = @IdJuvai 
								 AND c.fechaRecepcion = CAST(@fecha AS DATE)
								 AND c.estado         = 'APR' 
								 AND d.activo        = 1

						   INSERT INTO AuditoriaMigracionJuvai(IdInsigne, IdJuvai, TipoTransaccion, Fecha)
						   SELECT @idRecepcion, nbIdImagen, 'RECEPCION', GETDATE() 
						   FROM #tmp_recepcion_siembra WHERE nbIdImagen = @IdJuvai 
														 AND procesado	= 0 

						END
						UPDATE #tmp_recepcion_siembra SET procesado    = 1 
													  WHERE nbIdImagen = @IdJuvai            	
													  AND procesado	   = 0 

			  END
	DROP TABLE #tmp_recepcion_siembra;
	SELECT * FROM AuditoriaMigracionJuvai WHERE TipoTransaccion='RECEPCION';
END
