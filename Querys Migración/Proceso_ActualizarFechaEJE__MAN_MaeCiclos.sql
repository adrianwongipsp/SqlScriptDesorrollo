begin tran
 
select 1;

WITH CTE AS (
    SELECT 
        idPiscina,
        idPiscinaCiclo,
        ciclo,
        origen,
        fecha,
        ROW_NUMBER() OVER (PARTITION BY idPiscina, origen ORDER BY ciclo ASC) AS rn,
        COUNT(CASE WHEN origen = 'MAN' THEN 1 END) OVER (PARTITION BY idPiscina) AS count_man,
        COUNT(CASE WHEN origen = 'EJE' THEN 1 END) OVER (PARTITION BY idPiscina) AS count_eje
    FROM 
        maePiscinaCiclo
    WHERE 
        ciclo > 0 
        AND activo = 1
),
FilteredCTE AS (
    SELECT 
        idPiscina,
        idPiscinaCiclo,
        ciclo,
        origen,
        fecha,
        rn,
        ROW_NUMBER() OVER (PARTITION BY idPiscina ORDER BY CASE WHEN origen = 'MAN' THEN 1 ELSE 2 END, ciclo ASC) AS overall_rn
    FROM 
        CTE
    WHERE 
        (origen = 'MAN' AND rn = 1) OR (origen = 'EJE' AND rn = 1)
        AND count_man > 0 
        AND count_eje > 0
),
DistinctDatesCTE AS (
    SELECT 
        idPiscina,
        COUNT(DISTINCT fecha) AS distinct_dates
    FROM 
        FilteredCTE
    GROUP BY 
        idPiscina
)
SELECT 
    f.idPiscina,
    f.idPiscinaCiclo,
    f.ciclo,
    f.origen,
    f.fecha
  into #temporalUpdateCiclo
FROM 
    FilteredCTE f
JOIN 
    DistinctDatesCTE d
    ON f.idPiscina = d.idPiscina
WHERE 
    f.overall_rn <= 2
    AND d.distinct_dates > 1
ORDER BY 
    f.idPiscina,
    f.overall_rn;

		select * from maePiscinaCiclo where idPiscinaCiclo in (	select idPiscinaCiclo from #temporalUpdateCiclo);

		 

WITH TemporalUpdateRanked AS (
    SELECT 
        temp.idPiscina,
        temp.idPiscinaCiclo,
        temp.fecha,
        ROW_NUMBER() OVER (PARTITION BY temp.idPiscina ORDER BY temp.idPiscinaCiclo) AS rn
    FROM 
        #temporalUpdateCiclo temp
    WHERE 
        temp.origen = 'EJE'
)
--select mae.idPiscina,
--mae.fecha , temp.fecha
update mae set 
 mae.fecha = temp.fecha,
 mae.estacionModificacion = '::99',
 mae.fechaHoraModificacion = GETDATE()
FROM maePiscinaCiclo mae
JOIN TemporalUpdateRanked temp
    ON mae.idPiscina = temp.idPiscina
   -- AND mae.idPiscinaCiclo = temp.idPiscinaCiclo
    AND mae.origen = 'MAN'
    AND temp.rn = 1; -- Garantiza que solo se actualice la primera fila de EJE por cada idPiscina


select * from maePiscinaCiclo where idPiscinaCiclo in (	select idPiscinaCiclo from #temporalUpdateCiclo);
--select * from maePiscinaCiclo where idpiscina = 105
		-- Eliminar la tabla temporal
DROP TABLE #temporalUpdateCiclo;
rollback
--commit