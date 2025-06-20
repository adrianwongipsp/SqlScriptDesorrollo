--TRUNCATE TABLE tmp_Recepcion_Siembra

DECLARE @fecha DATE='2025-05-26', @fechaIni DATE,@fechaFin DATE;
DECLARE      @idPiscina INT = 0,
	       @idEjecucion INT = 0,
       @piscina VARCHAR(20) = '',
                 @Ciclo INT = 0,
		         @Count INT = 0,
		        @Count1 INT = 0,
      @Modifica varchar(75) = 'MIGRACION_JUVAI_' + FORMAT(GETDATE(), 'yyyyMMdd');
	 SET @fechaIni = DATEADD(DAY, -2, '2025-03-01'); -- Lunes de la semana anterior
	 SET @fechaFin  = DATEADD(DAY, 2, GETDATE());
	 select @fechaIni, @fechaFin


	   IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AuditoriaMigracionJuvai' AND xtype='U')
		CREATE TABLE AuditoriaMigracionJuvai (
			IdJuvai INT NULL,
			IdInsigne INT NULL,
			TipoTransaccion VARCHAR(60),
			Fecha DATE,
		);

		IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tmp_Recepcion_Siembra' AND xtype='U')
		CREATE TABLE tmp_Recepcion_Siembra (
			Piscina VARCHAR(50),
			FechaInsigne DATE NULL,
			FechaJuvai DATE NULL,
			PlGramoCamJuvai DECIMAL(18,6) NULL,
			PlGramoCamInsigne DECIMAL(18,6) NULL,
			IdRecepcion INT NULL,
			Ciclo INT NULL,
			IdPiscina INT NULL,
			IdPiscinaEjecucion INT NULL,
			GuiaRemision VARCHAR(60),
			IdJuvai INT NULL,
		);

		-- Verificar si la tabla temporal ya existe y eliminarla
		IF OBJECT_ID('tempdb..#tmp_recepcion_siembra') IS NOT NULL
			DROP TABLE #tmp_recepcion_siembra;

		-- Crear la tabla temporal
		CREATE TABLE #tmp_recepcion_siembra (
			procesado BIT,
			idPiscina INT,
			idPiscinaEjecucion INT,
			idPiscinaEjecucionSig INT,
			Ciclo INT,
			Piscina VARCHAR(60),
			Rol VARCHAR(6),
		);

		INSERT INTO #tmp_recepcion_siembra (idPiscina,idPiscinaEjecucion, idPiscinaEjecucionSig, Ciclo, Piscina, Rol, procesado)
		SELECT DISTINCT ej.idPiscina, ej.idPiscinaEjecucion, ej.idPiscinaEjecucionSiguiente, ej.Ciclo, ej.keyPiscina, ej.rolPiscina, 0
		FROM  EjecucionesPiscinaView ej
		     INNER JOIN [192.168.1.83].[IPSP_JUVAI].DBO.VW_BASEPESOMUESTRA x 
		     ON x.txtClavePiscina COLLATE SQL_Latin1_General_CP1_CI_AS = ej.keyPiscina 
		     AND x.nbIdPiscinaEjecucion=ej.idPiscinaEjecucion
		WHERE ej.estado IN('EJE', 'INI') --AND CAST(x.dtFechaRegistro AS DATE)=@fecha
		      AND x.nbidtipomuestra      = 1
		      AND NOT EXISTS (SELECT * FROM AuditoriaMigracionJuvai x 
		                  INNER JOIN tmp_Recepcion_Siembra y on x.IdInsigne=y.IdRecepcion
						  WHERE x.TipoTransaccion='RECEPCION')

		
		  SELECT * FROM #tmp_recepcion_siembra
		  WHILE EXISTS(SELECT TOP 1 1 FROM #tmp_recepcion_siembra WHERE procesado = 0)
		  BEGIN
		       				SELECT TOP 1	
	                    @idPiscina = idPiscina,
				      @idEjecucion = idPiscinaEjecucion,
		                    @Ciclo = Ciclo,
			              @piscina = Piscina
		        FROM #tmp_recepcion_siembra 
				WHERE procesado=0
				order by idPiscina
		   

						--SELECT (1.0 /NULLIF(nbSampleWeight,0)) AS PlGramoCamJuvai, CAST(x.dtFechaRegistro AS DATE) AS FechaJuvai 
						--FROM [192.168.1.83].[IPSP_JUVAI].DBO.VW_BASEPESOMUESTRA x
						--WHERE  CAST(x.dtFechaRegistro AS DATE)  = @fecha AND  txtClavePiscina=@piscina AND nbIdPiscinaEjecucion= @idEjecucion 
						--AND x.nbidtipomuestra = 1

					    --  SELECT @piscina    AS Piscina
						-- , r.fechaRecepcion AS  FechaRecepcion
						-- , plGramoCam       AS PlGramoCamInsigne
						-- , r.idRecepcion    AS IdRecepcion
						-- , @Ciclo           AS Ciclo 
						-- , rd.idPiscina     AS IdPiscina
						-- , rd.idPiscinaEjecucion AS IdPiscinaEjecucion
						-- FROM proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
						-- WHERE idPiscina=@idPiscina  and rd.idPiscinaEjecucion = @idEjecucion and r.estado='APR' AND rd.activo=1

						-- Datos de INSIGNE
						INSERT INTO tmp_Recepcion_Siembra (Piscina,FechaInsigne,FechaJuvai,PlGramoCamJuvai,PlGramoCamInsigne,IdRecepcion,Ciclo,IdPiscina,IdPiscinaEjecucion, GuiaRemision, IdJuvai)
						SELECT 
							@piscina,
							r.fechaRecepcion,
							z.FechaJuvai,
							z.PlGramoCamJuvai,
							plGramoCam,
							r.idRecepcion,
							@Ciclo,
							rd.idPiscina,
							rd.idPiscinaEjecucion,
							r.guiasRemision,
							z.Id
						FROM proRecepcionEspecieDetalle rd WITH(NOLOCK) 
							INNER JOIN proRecepcionEspecie r WITH(NOLOCK) 
							  ON r.idRecepcion = rd.idRecepcion
							LEFT JOIN(SELECT 
									  CAST(x.dtFechaRegistro AS DATE) AS FechaJuvai,
								      (1.0 / NULLIF(x.nbAverageWeight, 0)) *1000 AS PlGramoCamJuvai,
									--nbAverageLength
									--nbAverageWeight
									--(1.0 / NULLIF(x.nbSampleWeight, 0)) AS PlGramoCamJuvai,
									--x.txtClavePiscina AS ClavePiscina,
									   y.idPiscina,
									   x.nbIdPiscinaEjecucion AS IdPiscinaEjecucion,
							           x.nbIdImagen AS Id
								    FROM [192.168.1.83].[IPSP_JUVAI].DBO.VW_BASEPESOMUESTRA x
								    INNER JOIN PiscinaUbicacion y 
									ON x.txtClavePiscina  COLLATE SQL_Latin1_General_CP1_CI_AS=y.KeyPiscina
								    WHERE --CAST(x.dtFechaRegistro AS DATE) BETWEEN  @fechaIni AND @fechaFin 
										--AND 
										x.txtClavePiscina COLLATE SQL_Latin1_General_CP1_CI_AS = @piscina 
										AND x.nbIdPiscinaEjecucion = @idEjecucion 
										AND x.nbidtipomuestra      = 1
						     ) z ON z.idPiscina=rd.idPiscina AND z.IdPiscinaEjecucion=rd.idPiscinaEjecucion 
						WHERE rd.idPiscina              = @idPiscina 
							  AND rd.idPiscinaEjecucion = @idEjecucion 
							  AND r.estado              = 'APR' 
							  AND rd.activo             = 1
							  AND z.FechaJuvai IS NOT NULL;
		
					UPDATE #tmp_recepcion_siembra SET procesado          = 1 
					                              WHERE idPiscina        = @idPiscina
												  AND idPiscinaEjecucion = @idEjecucion              	
				                                  AND procesado	         = 0 

				   INSERT INTO AuditoriaMigracionJuvai(IdInsigne, IdJuvai, TipoTransaccion, Fecha)
				   SELECT IdRecepcion, IdJuvai, 'RECEPCION', GETDATE() 
				   FROM tmp_Recepcion_Siembra WHERE idPiscina        = @idPiscina
											  AND idPiscinaEjecucion = @idEjecucion 
		  END
DROP TABLE #tmp_recepcion_siembra
SELECT * FROM tmp_Recepcion_Siembra
SELECT * FROM AuditoriaMigracionJuvai

--TRUNCATE  TABLE tmp_Recepcion_Siembra
--TRUNCATE  TABLE AuditoriaMigracionJuvai