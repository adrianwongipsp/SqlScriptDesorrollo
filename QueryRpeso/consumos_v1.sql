
    SET DATEFIRST 1;
	-- Lunes de la semana de la fecha enviada;
	DECLARE @fecha DATE        = '2025-07-09', @idMegaZona  INT   = 0, @idZona  INT   = 0, @idSector INT  = 0, @tipo VARCHAR(5) = '', @dia INT = 0, @conversion DECIMAL(18,5)=2.20462;
	DECLARE @diaDeLaSemana INT = DATEPART(WEEKDAY, @fecha)    , @fechaFin DATE = DATEADD(DAY, -1, @fecha);
	--SELECT @fecha,  @fechaFin, @diaDeLaSemana;

	SELECT  0 procesado, idMegaZona ,idZona, idSector, tipoMuestreo, diaNumeros
	INTO #diasMuestreo
	FROM parDiasMuestreoEngorde 
	WHERE diaNumeros = @diaDeLaSemana;


	--SELECT * FROM #diasMuestreo
	WHILE EXISTS(SELECT TOP 1 1 FROM #diasMuestreo WHERE procesado = 0)
	BEGIN

		SELECT TOP 1
		    @idMegaZona = idMegaZona,
			@idZona     = idZona,
			@idSector   = idSector,
			@tipo       = tipoMuestreo
		FROM #diasMuestreo 
		WHERE procesado = 0
		ORDER BY idZona;

		DECLARE @fechaIniAnterior DATE = null;
		IF(@tipo='PRE')
		BEGIN 
		   SELECT @dia = diaNumeros 
		   FROM parDiasMuestreoEngorde 
		   WHERE idZona = @idZona 
		   AND idSector = @idSector 
		   AND tipoMuestreo='PES' 
		   AND activo=1;

		   SET @fechaIniAnterior = DATEADD(DAY, @diaDeLaSemana-@dia,  @fechaFin); -- día  de la semana anterior;
		   --DATEADD(DAY, -@diaDeLaSemana, DATEADD(DAY, @dia, @fecha)); -- día  de la semana actual-futura;
		END
		ELSE
		BEGIN
			--Buscar el lunes de la semana anterior
			SET @fechaIniAnterior = DATEADD(WEEK, -1, @fecha); -- día  de la semana anterior;
		END
			--SELECT @fechaIniAnterior, @fechaFin;

			SELECT
			ROW_NUMBER() OVER (PARTITION BY a.Piscina ORDER BY a.Cantidad DESC) AS Fila,
			* INTO #Valores FROM
            (SELECT 0          AS Procesado
			      , @fecha     AS fechaActual
			      , @idZona    AS idZona
				  , x.Zona     AS Zona
				  , @idSector  AS idSector
				  , x.Sector   AS Sector
				  , x.Piscina  AS Piscina
				  , SUM(x.Cantidad) AS Cantidad
				  , x.fecha    AS fechaAlimentacion
				  , 0          AS Consumo1
				  , 0          AS Consumo2
				  , 0          AS Consumo3
			FROM [192.168.1.160].[ProduccionBI].dbo.Vw_Alimento_diario_tipo_bal x
			          INNER JOIN parZona y ON x.Zona     = y.nombre
					  INNER JOIN parSector z ON x.Sector = z.nombre
			WHERE x.fecha BETWEEN @fechaIniAnterior AND @fechaFin
			      AND y.idZona   = @idZona 
				  AND z.idSector = @idSector
			GROUP BY x.fecha, x.Piscina, x.Sector, x.Zona 
			) AS a
			


			--SELECT * FROM #Valores;
			WHILE EXISTS(SELECT TOP 1 1 FROM #Valores WHERE procesado = 0)
	        BEGIN
			   DECLARE @Piscina VARCHAR(30)='',  @idPiscina INT=0, @porcentaje INT=0, @hectarias DECIMAL(18,5)=0, @diasP INT=0;

				   SELECT TOP 1	
						  @Piscina    = Piscina
					FROM #Valores 
					WHERE procesado = 0
					ORDER BY Piscina;

					SELECT TOP 1
					       @hectarias  = superficieValor,
						   @idPiscina  = idPiscina
					FROM PiscinaUbicacion 
					WHERE KeyPiscina = @Piscina; 

					SELECT TOP 1 
					       @porcentaje = Cantidad/2 
					FROM #Valores 
					WHERE Piscina     = @Piscina 
					ORDER BY Cantidad DESC;

					SELECT
					       @diasP = COUNT(DISTINCT fechaAlimentacion) 
					FROM #Valores 
					WHERE Piscina     = @Piscina
					AND  Cantidad > @porcentaje;

					--SELECT @porcentaje AS porcentaje , @hectarias AS hectarias, @Piscina AS Piscina, @diasP AS diasP, * FROM #Valores WHERE Piscina = @Piscina ;

					WITH TopConsumos AS (
						SELECT 	
						    Fila,
							Piscina,
							Cantidad
						FROM #Valores
						WHERE Piscina = @Piscina 
					)				
					UPDATE x
					SET x.Consumo1 = ISNULL((((SELECT SUM(Cantidad) FROM TopConsumos WHERE Cantidad > @porcentaje)/NULLIF(@diasP,0))/ NULLIF(@conversion,0))/NULLIF(@hectarias,0),0)					                                       ,
                        x.Consumo2 = ISNULL((SELECT Cantidad FROM TopConsumos WHERE Fila = 2 AND  Cantidad > @porcentaje)/NULLIF((@conversion*@hectarias),0),
						                    (SELECT Cantidad FROM TopConsumos WHERE Fila = 1 AND  Cantidad > @porcentaje)/NULLIF((@conversion*@hectarias),0)),
                        x.Consumo3 = ISNULL((SELECT Cantidad FROM TopConsumos WHERE Fila = 3 AND  Cantidad > @porcentaje)/NULLIF((@conversion*@hectarias),0),
						                    (SELECT Cantidad FROM TopConsumos WHERE Fila = 1 AND  Cantidad > @porcentaje)/NULLIF((@conversion*@hectarias),0))
					FROM #Valores x
					WHERE x.Piscina = @Piscina;

					DECLARE @idmax INT=ISNULL((SELECT MAX(idConsumosKgHa) from proConsumosKgHa),0);
               
					INSERT INTO proConsumosKgHa(idConsumosKgHa, idMegaZona, idZona, zona, idSector, sector, idPiscina, piscina, cantidades
					                             , porcentaje, ha, diasAlimentacion, semana, anio, Consumo1, Consumo2, Consumo3, tipoMuestreo,
												  activo, fechaHoraCreacion, usuarioCreacion, estacionCreacion)
					SELECT  @idmax + ROW_NUMBER() OVER (ORDER BY Piscina)
						  , @idMegaZona AS idMegaZona
						  , idZona
						  , Zona
						  , idSector
						  , Sector
						  , @idPiscina
						  , Piscina
						  , (SELECT 
							  STRING_AGG(CAST(Cantidad AS VARCHAR), ';') 
							 FROM #Valores
							 WHERE Piscina = @Piscina
							 ) AS Cantidades 
						, @porcentaje AS porcentaje
						, @hectarias AS ha
						, @diasP AS diasAlimentacion
						, ISNULL(DATEPART(WEEK, fechaActual), 0) AS semana
						, YEAR(fechaActual) AS anio
						, Consumo1
						, Consumo2
						, Consumo3
						, @tipo As tipoMuestreo 
						, 1
						, GETDATE()
						, 'dbo'
						, ''
					FROM #Valores WHERE Piscina = @Piscina AND Fila=1;

					
					UPDATE #Valores 
					SET procesado    = 1 
					WHERE Piscina    = @Piscina
					AND procesado	 = 0;
	
			END

			UPDATE #diasMuestreo 
			SET procesado    = 1 
			WHERE idZona     = @idZona 
			AND idSector     = @idSector
			AND tipoMuestreo = @tipo
			AND procesado	 = 0;

			DROP TABLE #Valores;
    END
DROP TABLE #diasMuestreo;