USE IPSPCamaroneraProduccion
GO
/*
select * from maePiscinaCiclo
where idPiscina = 1809
ORDER BY fecha DESC,Origen asc, idPiscinaCiclo ASC
*/
begin tran

	drop table if exists #CiclosTemporales;

	WITH CTE AS (
		SELECT
			idPiscinaCiclo,
			idPiscina,
			ciclo,
			fecha,
			origen,
			LAG(ciclo) OVER (PARTITION BY idPiscina ORDER BY fecha DESC,Origen ASC) AS ciclo_anterior,
			LAG(origen) OVER (PARTITION BY idPiscina ORDER BY fecha DESC,Origen  ASC) AS origen_anterior
		FROM
			maePiscinaCiclo
			where activo = 1
	)
	SELECT
		idPiscinaCiclo,
		idPiscina,
		ciclo,
		fecha,
		origen,
		ciclo_anterior,
		origen_anterior,
		ciclo - ciclo_anterior diferenciaCiclo,
		ciclo_anterior - 1 cicloManual
	into #CiclosTemporales
	FROM
		CTE
	WHERE
		origen = 'MAN'
		AND 
		ciclo_anterior IS NOT NULL
		AND origen_anterior = 'EJE'
		--   AND ciclo <> ciclo_anterior + 1
		and ciclo - ciclo_anterior != -1
		AND ciclo_anterior - 1 != -1

		select * from #CiclosTemporales
		ORDER BY idPiscina

		UPDATE P
		SET P.CICLO = C.cicloManual
		from maePiscinaCiclo P
		INNER JOIN #CiclosTemporales C ON P.idPiscinaCiclo = C.idPiscinaCiclo
		WHERE ciclo_anterior != 1
		
		--where idPiscina = 300
		UPDATE P
		SET P.activo = 0
		from maePiscinaCiclo P
		INNER JOIN #CiclosTemporales C ON P.idPiscinaCiclo = C.idPiscinaCiclo
		WHERE cicloManual = 0

		SELECT * FROM maePiscinaCiclo
		where idPiscinaCiclo IN (SELECT idPiscinaCiclo FROM #CiclosTemporales);

		WITH CTE AS (
		SELECT
			idPiscinaCiclo,
			idPiscina,
			ciclo,
			fecha,
			origen,
			LAG(ciclo) OVER (PARTITION BY idPiscina ORDER BY fecha) AS ciclo_anterior,
			LAG(origen) OVER (PARTITION BY idPiscina ORDER BY fecha) AS origen_anterior
		FROM
			maePiscinaCiclo
			where activo = 1
	)
	SELECT
		idPiscinaCiclo,
		idPiscina,
		ciclo,
		fecha,
		origen,
		ciclo_anterior,
		origen_anterior,
		ciclo - ciclo_anterior diferenciaCiclo,
		ciclo_anterior - 1 cicloManual
	FROM
		CTE
	WHERE
		origen = 'MAN'
		AND ciclo_anterior IS NOT NULL
		AND origen_anterior = 'EJE'
		--   AND ciclo <> ciclo_anterior + 1
		and ciclo - ciclo_anterior != -1

rollback
--COMMIT


--select * from maePiscinaCiclo
--where idPiscina = 105
--order by fecha

--select * from proPiscinaEjecucion
--where idPiscina = 105
--order by fechaInicio

--select * from PiscinaUbicacion
--where idPiscina = 105