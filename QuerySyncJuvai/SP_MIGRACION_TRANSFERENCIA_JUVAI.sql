
CREATE PROCEDURE [dbo].[SP_MIGRACION_TRANSFERENCIA_JUVAI]    
  @fechaParametro DATE
AS   
BEGIN
--DECLARE  @fechaParametro DATE
--SET	   @fechaParametro = '2025-07-02' 
SET DATEFIRST 1;
   DECLARE     @FechaFin DATE = @fechaParametro,-- Hoy
		       @FechaInicio DATE = DATEADD(DAY, -2, @fechaParametro), -- Ayer
		  
		  /*PROCESO DE TRANFERENCIAS */ 
		  @Modifica VARCHAR(75) = 'MIGRACION_JUVAI_MOD' +FORMAT(GETDATE(), 'yyyy-MM-dd'),
		  @empresa   VARCHAR(5),
		  @division  VARCHAR(5),
		  @idPiscina INT,
		  @idPiscinaEje INT,
		  @fecha   DATETIME,
		  @IdJuvai INT = 0,
		  @Hora    TIME;

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
		);

		INSERT INTO #tmp_transferencia (idPiscina,idPiscinaEjecucion, Ciclo, keyPiscina, Rol, procesado, Fecha , Hora ,nbIdImagen, FechaTransaccion, FechaRegistro, PlGramoCamJuvai, Cantidad )
		SELECT DISTINCT ej.idPiscina, ej.idPiscinaEjecucion,
             ej.Ciclo, ej.keyPiscina, ej.rolPiscina, 0
			, CAST(x.dtFechaRegistro AS DATE) AS fecha
			, CAST(x.dtFechaRegistro AS TIME  ) AS  hora 		
			, x.nbIdImagen
			, x.dtFechaRegistro
			, x.dtFechaRegistroEnvio
			, ((1.0 / NULLIF(x.nbAverageWeight, 0)) *1000)
			, x.nbNumeroAnimales
		FROM  EjecucionesPiscinaView ej
		     INNER JOIN [192.168.1.83].[IPSP_JUVAI].DBO.VW_BASEPESOMUESTRA x 
		     ON x.txtClavePiscina COLLATE SQL_Latin1_General_CP1_CI_AS = ej.keyPiscina 
				AND x.nbIdPiscinaEjecucion = ej.idPiscinaEjecucion
			 INNER JOIN proTransferenciaEspecie c     with(nolock)   on c.idPiscina = ej.idPiscina and c.idPiscinaEjecucion = ej.idPiscinaEjecucion
			 INNER JOIN proTransferenciaEspecieDetalle d with(nolock) on c.idTransferencia = d.idTransferencia
			 INNER JOIN PiscinaUbicacion pu  on pu.idPiscina = ej.idPiscina
		WHERE ej.estado IN('EJE', 'INI') 
		      AND d.pesoPromedioTransferencia <=0
	          AND c.estado IN('ING', 'APR') AND D.activo = 1 
			  AND CAST(x.dtFechaRegistro AS DATE) BETWEEN @FechaInicio AND @FechaFin
		      AND x.nbidtipomuestra = 3 
			  AND ej.Ciclo          > 0
		      AND NOT EXISTS (SELECT * FROM AuditoriaMigracionJuvai y  with (nolock)
						      WHERE  y.IdJuvai = x.nbIdImagen and  y.TipoTransaccion = 'TRANSFERENCIA')

			 AND EXISTS (select top 1 1  from parZona z where z.codigo = pu.codigoZona and z.activo = 1 and (z.aplicaJuvaiPrecria = 1 or z.aplicaJuvaiEngorde = 1))

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

				--SELECT       @idPiscina    AS [@idPiscina  ]
				--			,@idPiscinaEje AS [@idPiscinaEje]      
				--			,@fecha        AS [@fecha       ]      
				--			,@IdJuvai      AS [@IdJuvai     ]      
				--			,@Hora         AS [@Hora        ]      

				  IF EXISTS(
					  SELECT 
							*
					  FROM proTransferenciaEspecieDetalle  d WITH(NOLOCK)
					  INNER JOIN proTransferenciaEspecie   c WITH(NOLOCK) ON d.idTransferencia = c.idTransferencia 
					  INNER JOIN #tmp_transferencia x ON c.idPiscina= x.idPiscina AND c.idPiscinaEjecucion=x.idPiscinaEjecucion
					  WHERE --x.nbIdImagen               = @IdJuvai
					        c.idPiscina = @idPiscina AND c.idPiscinaEjecucion= @idPiscinaEje and c.fechaTransferencia = @fecha
						AND x.Fecha BETWEEN d.fechaInicioTransferencia AND d.fechaFinTransferencia
						AND x.Hora BETWEEN d.horaInicioTransferencia AND d.horaFinTransferencia
						AND d.activo = 1  
						AND c.estado='APR')
				  BEGIN

				  		IF OBJECT_ID('tempdb..#tmp_transferencia_agrupado') IS NOT NULL
							DROP TABLE #tmp_transferencia_agrupado;

									IF OBJECT_ID('tempdb..#idTransferenciaIdImagen') IS NOT NULL
							DROP TABLE #idTransferenciaIdImagen;

				     SELECT 
						 x.nbIdImagen, d.idTransferenciaDetalle, d.idTransferencia
							into #idTransferenciaIdImagen
					  FROM proTransferenciaEspecieDetalle  d WITH(NOLOCK)
					  INNER JOIN proTransferenciaEspecie   c WITH(NOLOCK) ON d.idTransferencia = c.idTransferencia 
					  INNER JOIN #tmp_transferencia x ON c.idPiscina= x.idPiscina AND c.idPiscinaEjecucion=x.idPiscinaEjecucion
					  WHERE --x.nbIdImagen               = @IdJuvai
					         c.idPiscina= @idPiscina AND c.idPiscinaEjecucion= @idPiscinaEje and c.fechaTransferencia = @fecha
						AND x.Fecha BETWEEN d.fechaInicioTransferencia AND d.fechaFinTransferencia
						AND x.Hora BETWEEN d.horaInicioTransferencia AND d.horaFinTransferencia
						AND d.activo = 1  
						AND c.estado='APR'

						SELECT x.idPiscina,			x.idPiscinaEjecucion,	x.keyPiscina, 
							   x.Fecha,				y.idTransferencia,		y.idTransferenciaDetalle,
						       avg(x.PlGramoCamJuvai) as PlGramoCamJuvai
							   into #tmp_transferencia_agrupado
						FROM #tmp_transferencia x INNER JOIN #idTransferenciaIdImagen y on x.nbIdImagen = y.nbIdImagen
						group by x.idPiscina,			x.idPiscinaEjecucion,	x.keyPiscina, 
							     x.Fecha,				y.idTransferencia,		y.idTransferenciaDetalle

					  UPDATE d
							SET  @idTransferencia            = c.idTransferencia,
								d.pesoPromedioTransferencia  = x.PlGramoCamJuvai,
								d.cantidadDeclarada          = FLOOR((d.librasDeclaradas * 454) / NULLIF(x.PlGramoCamJuvai,0)),
								d.fechaHoraModificacion      = GETDATE(),
								d.estacionModificacion       = @Modifica
					  FROM proTransferenciaEspecieDetalle  d WITH(NOLOCK)
					  INNER JOIN proTransferenciaEspecie c WITH(NOLOCK) ON d.idTransferencia = c.idTransferencia 
					  INNER JOIN #tmp_transferencia_agrupado x ON C.idPiscina = x.idPiscina AND C.idPiscinaEjecucion = x.idPiscinaEjecucion
								and x.idTransferenciaDetalle = d.idTransferenciaDetalle
				  
				INSERT INTO AuditoriaMigracionJuvai(IdInsigne, IdJuvai, TipoTransaccion, Fecha)
				SELECT @idTransferencia, mp.nbIdImagen, 'TRANSFERENCIA', GETDATE() 
						    FROM  #tmp_transferencia mp  
				            WHERE mp.nbIdImagen  in (select x.nbIdImagen from #idTransferenciaIdImagen x)
								AND mp.procesado = 0
			END
			    
				UPDATE #tmp_transferencia SET procesado = 1 
				WHERE --nbIdImagen  in (select x.nbIdImagen from #idTransferenciaIdImagen x )
				idPiscina  = @idPiscina 
				AND idPiscinaEjecucion  = @idPiscinaEje       
				AND fecha			    = @fecha      
				AND procesado	        = 0
		END		
	    
		DROP TABLE #tmp_transferencia; 

		SELECT * FROM AuditoriaMigracionJuvai with(nolock) WHERE TipoTransaccion='TRANSFERENCIA';
END
GO


