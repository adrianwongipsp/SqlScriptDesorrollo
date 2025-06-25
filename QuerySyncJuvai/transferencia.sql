
BEGIN TRAN
SET DATEFIRST 1;
DECLARE  @FechaFin DATE = GETDATE();-- Hoy
DECLARE @FechaInicio DATE = DATEADD(DAY, -10, @FechaFin); -- Ayer

/*PROCESO DE TRANFERENCIAS */
          DECLARE 
		  @Modifica VARCHAR(75) = 'MIGRACION_JUVAI_MOD' +FORMAT(GETDATE(), 'yyyy-MM-dd'),
		  @empresa VARCHAR(5),
		  @division VARCHAR(5),
		  @idPiscina INT,
		  @idPiscinaEje INT,
		  @fecha DATETIME,
		  @IdJuvai INT = 0,
		  @Hora TIME;

--Verificar si la tabla temporal ya existe y eliminarla
		IF OBJECT_ID('tempdb..#tmp_transferencia') IS NOT NULL
			DROP TABLE #tmp_transferencia;

		-- Crear la tabla temporal
		CREATE TABLE #tmp_transferencia (
			procesado BIT,
			idPiscina INT,
			idPiscinaEjecucion INT,
			Ciclo INT,
			keyPiscina VARCHAR(60),
			Rol VARCHAR(6) NULL,
			nbIdImagen  INT,
            FechaTransaccion DATETIME NULL,
			FechaRegistro DATETIME NULL,
			PlGramoCamJuvai DECIMAL(18,5),
			Cantidad INT NULL,
			Fecha DATETIME NULL,
		    Hora TIME NULL,
            --FechaTransferencia DATETIME NULL,
			--Fregistro DATETIME NULL,
			--UsuarioResponsable VARCHAR(60) NULL, 
			--idUsuario INT NULL,
			--Descripcion VARCHAR(300) NULL, 
			--Cantidad INT NULL,
			--PlGramoCamJuvai DECIMAL(18,5),
			--nbIdImagen  INT,
			--nombreSector  VARCHAR(60) NULL,
			--pesopromedio DECIMAL(18,5) NULL,
			--longitudpromedio DECIMAL(18,5) NULL,
			--idDetalle INT NULL,
			--nbIdPiscinaEjecucionDestino INT NULL,
			--txtIdPiscinaDestino VARCHAR(10) NULL,
			--txtClavePiscinaDestino VARCHAR(60) NULL,
			--Piscina VARCHAR(60) NULL,
		);

		INSERT INTO #tmp_transferencia (idPiscina,idPiscinaEjecucion, Ciclo, keyPiscina, Rol, procesado, Fecha , Hora ,nbIdImagen, FechaTransaccion, FechaRegistro, PlGramoCamJuvai, Cantidad 
		--FechaTransferencia,Fregistro, UsuarioResponsable, idUsuario, Descripcion, Cantidad, PlGramoCamJuvai, nbIdImagen, nombreSector, 
		--pesopromedio, longitudpromedio, nbIdPiscinaEjecucionDestino, txtIdPiscinaDestino, txtClavePiscinaDestino
		)
		SELECT DISTINCT ej.idPiscina, ej.idPiscinaEjecucion,
             ej.Ciclo, ej.keyPiscina, ej.rolPiscina, 0
			, CAST(x.dtFechaRegistro AS DATE) AS fecha
			, CAST(x.dtFechaRegistro AS TIME  ) AS  hora 
			--x.dtFechaRegistro AS FMuestreo,
			--x.dtFechaRegistroEnvio AS Fregistro,
			--x.txtUsuarioRegistro AS UsuarioResponsable,
			--x.nbIdUsuario AS idUsuario,
			--x.txtNombreMuestra AS Descripcion,
			--x.nbNumeroAnimales AS Cantidad,
			--(1.0 / NULLIF(x.nbAverageWeight, 0)) *1000 AS PlGramoCamJuvai,
			--x.nbIdImagen,
			--ej.nombreSector,
			--x.nbAverageWeight AS  pesopromedio,
            --x.nbAverageLength AS longitudpromedio,	
			--x.nbIdPiscinaEjecucionDestino,
			--x.txtIdPiscinaDestino,
			--x.txtClavePiscinaDestino
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
		     -- AND CAST(x.dtFechaRegistro AS DATE) BETWEEN @FechaInicio AND @FechaFin
		      AND x.nbidtipomuestra = 3 
			  AND ej.Ciclo          > 0
		      AND NOT EXISTS (SELECT * FROM AuditoriaMigracionJuvai y 
						      WHERE y.IdJuvai         = x.nbIdImagen 
							    AND y.TipoTransaccion = 'TRANSFERENCIA')
		
		  SELECT * FROM #tmp_transferencia
		  WHILE EXISTS(SELECT TOP 1 1 FROM #tmp_transferencia WHERE procesado = 0)
		  BEGIN

				SELECT TOP 1	
				   @idPiscina         = idPiscina,
				   @idPiscinaEje      = idPiscinaEjecucion,
			       @fecha             = Fecha,
				   @IdJuvai           = nbIdImagen,
				   @Hora              = Hora
		        FROM #tmp_transferencia 
				WHERE procesado      = 0
				ORDER BY nbIdImagen;
				DECLARE @idTransferencia INT=0;


				  SELECT 
				        *
				  FROM proTransferenciaEspecieDetalle  d WITH(NOLOCK)
				  INNER JOIN proTransferenciaEspecie c WITH(NOLOCK) ON d.idTransferencia = c.idTransferencia 
				  --INNER JOIN #tmp_transferencia x ON d.idPiscina= x.idPiscina AND d.idPiscinaEjecucion=x.idPiscinaEjecucion
			      WHERE d.idPiscina = @idPiscina AND d.idPiscinaEjecucion = @idPiscinaEje 
					AND @fecha BETWEEN d.fechaInicioTransferencia AND d.fechaFinTransferencia
					AND @Hora BETWEEN d.horaInicioTransferencia AND d.horaFinTransferencia
					AND d.activo = 1  
					AND c.estado='APR'

			--	  IF EXISTS(
			--	  SELECT 
			--	        *
			--	  FROM proTransferenciaEspecieDetalle  d WITH(NOLOCK)
			--	  INNER JOIN proTransferenciaEspecie c WITH(NOLOCK) ON d.idTransferencia = c.idTransferencia 
			--	  INNER JOIN #tmp_transferencia x ON d.idPiscina= x.idPiscina AND d.idPiscinaEjecucion=x.idPiscinaEjecucion
			--      WHERE x.nbIdImagen               = @IdJuvai
			--		AND x.Fecha BETWEEN d.fechaInicioTransferencia AND d.fechaFinTransferencia
			--		AND x.Hora BETWEEN d.horaInicioTransferencia AND d.horaFinTransferencia
			--		AND d.activo = 1  
			--		AND c.estado='APR')
			--	  BEGIN
						
			--	--UPDATE x SET x.Piscina = (SELECT TOP 1 y.nombre from maePiscina y where y.idPiscina=x.idPiscina AND y.activo=1) 
			--	--FROM #tmp_transferencia x
			--	--WHERE x.nbIdImagen = @id AND x.procesado	 = 0
				  
			--	  UPDATE d
			--			SET  @idTransferencia            = c.idTransferencia,
			--				d.pesoPromedioTransferencia  = x.PlGramoCamJuvai,
			--				d.fechaHoraModificacion      = GETDATE(),
			--				d.estacionModificacion       = @Modifica
			--	  FROM proTransferenciaEspecieDetalle  d WITH(NOLOCK)
			--	  INNER JOIN proTransferenciaEspecie c WITH(NOLOCK) ON d.idTransferencia = c.idTransferencia 
			--	  INNER JOIN #tmp_transferencia x ON d.idPiscina = x.idPiscina AND d.idPiscinaEjecucion = x.idPiscinaEjecucion
			--      WHERE x.nbIdImagen               = @IdJuvai
			--		AND x.Fecha BETWEEN d.fechaInicioTransferencia AND d.fechaFinTransferencia
			--		AND x.Hora BETWEEN d.horaInicioTransferencia AND d.horaFinTransferencia
			--		AND d.activo = 1  
			--		AND c.estado='APR'

				
			--	INSERT INTO AuditoriaMigracionJuvai(IdInsigne, IdJuvai, TipoTransaccion, Fecha)
			--	SELECT @idTransferencia, mp.nbIdImagen, 'TRANSFERENCIA', GETDATE() 
			--			    FROM  #tmp_transferencia mp  
			--	            WHERE mp.nbIdImagen  = @IdJuvai 
			--					AND mp.procesado = 0

			    UPDATE #tmp_transferencia SET procesado = 1 
				WHERE nbIdImagen     = @IdJuvai 
				      AND procesado	 = 0
			--END
		END			
SELECT * FROM #tmp_transferencia
DROP TABLE #tmp_transferencia
SELECT * FROM AuditoriaMigracionJuvai WHERE TipoTransaccion='TRANSFERENCIA';
ROLLBACK TRAN