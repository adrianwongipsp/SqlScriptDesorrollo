
drop table if exists #detalleRepetidosTemp;
go

WITH CTE AS (
    SELECT 
        idMuestreoDetalle, 
        idProfundidad, 
        cantidadLance, 
        activo, 
        ubicacionCodigo,
        ROW_NUMBER() OVER (PARTITION BY idMuestreoDetalle ORDER BY idProfundidad) AS rn,
        COUNT(*) OVER (PARTITION BY idMuestreoDetalle) AS cnt
    FROM 
        proMuestreoPoblacionProfundidadDetalle 
    WHERE 
        activo = 1
)
SELECT 
    idMuestreoDetalle,
    SUM(CASE WHEN rn <= cnt / 2 THEN cantidadLance ELSE 0 END) AS suma_primeras,
    SUM(CASE WHEN rn > cnt / 2 THEN cantidadLance ELSE 0 END) AS suma_sobrantes
	into #detalleRepetidosTemp
FROM 
    CTE
GROUP BY 
    idMuestreoDetalle
	having SUM(CASE WHEN rn <= cnt / 2 THEN cantidadLance ELSE 0 END) = SUM(CASE WHEN rn > cnt / 2 THEN cantidadLance ELSE 0 END);
	go 

	select idMuestreoDetalle from (
	select max(idMuestreoCaracteristica) as idMuestreoCaracteristica, 
	idMuestreo, idMuestreoDetalle, idParametroControl
	from proMuestreoPoblacionDetalleCaracteristica
	where idMuestreoDetalle in (select idMuestreoDetalle from #detalleRepetidosTemp)
	group by idMuestreo, idMuestreoDetalle, idParametroControl, activo
	having count(idMuestreoDetalle) >1
	) as d
	group by idMuestreoDetalle
	go 

	/*
	Query general de muestreo repetido
	select MP.estado, pu.nombreZona, pu.nombreSector, pu.nombrePiscina,  pdl.* from proMuestreoPoblacionDetalleLance pdl
	inner join PiscinaUbicacion pu on pdl.idPiscina = pu.idPiscina
	inner join proMuestreoPoblacion mp on mp.idMuestreo = pdl.idMuestreo --and mp.estado <> 'ANU'
	where idMuestreoDetalle in (1003,1092,1093,2162,2731,3293,5002,6980,6982)
	*/
