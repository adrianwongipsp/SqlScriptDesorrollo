

DROP TABLE IF EXISTS #DatosPiscina;
DROP TABLE IF EXISTS #tmp_muestreos_filtrados_max
 
  SELECT  pu.nombreSector      AS Sector
	   ,pu.idSector          AS IdSector
       ,pu.KeyPiscina        AS NombrePiscina
	   ,pu.nombrePiscina	 AS Piscina
	   ,ej.idPiscina
	   ,ej.idPiscinaEjecucion 
		,ej.FechaSiembra
		,ej.FechaInicio
		,ej.Ciclo AS 'Ciclo'
	   INTO #DatosPiscina
  FROM PiscinaUbicacion pu 
  INNER JOIN EjecucionesPiscinaView ej ON
  pu.idPiscina = ej.idPiscina
  WHERE 
    pu.idPiscina = ej.idPiscina
  AND ej.estado in('INI', 'EJE') 
  ORDER BY pu.nombreSector,pu.nombrePiscina



   -- Verificar si la tabla temporal ya existe y eliminarla
IF OBJECT_ID('tempdb..#tmp_recepciones_transferencias') IS NOT NULL
    DROP TABLE #tmp_recepciones_transferencias;

-- Crear la tabla temporal
CREATE TABLE #tmp_recepciones_transferencias (
    idPiscina INT,
    idPiscinaEjecucion INT, 
	fechaMuestreo date,
	TipoOrigenMov char(1),
	ciclo int null,
	KeyPiscina varchar(50)
);

-- Insertar datos en la tabla temporal desde recepciones
INSERT INTO #tmp_recepciones_transferencias (idPiscina, idPiscinaEjecucion, fechaMuestreo, TipoOrigenMov,ciclo,KeyPiscina)
SELECT
    det.idPiscina,
    det.idPiscinaEjecucion,
	ca.fechaRecepcion,
	'R',
	ej.Ciclo,
	ej.NombrePiscina
FROM
    proRecepcionEspecieDetalle det
    INNER JOIN proRecepcionEspecie ca ON det.idRecepcion = ca.idRecepcion
    INNER JOIN #DatosPiscina ej ON ej.idPiscinaEjecucion = det.idPiscinaEjecucion AND ej.idPiscina = det.idPiscina
WHERE ej.idPiscinaEjecucion = det.idPiscinaEjecucion AND ej.idPiscina = det.idPiscina AND det.activo = 1 and ca.estado ='APR';

-- Insertar datos en la tabla temporal desde transferencias
INSERT INTO #tmp_recepciones_transferencias (idPiscina, idPiscinaEjecucion, fechaMuestreo, TipoOrigenMov,ciclo,KeyPiscina)
SELECT
    det.idPiscina,
    det.idPiscinaEjecucion, 
	ca.fechaTransferencia,
	'T',
    ej.Ciclo,
	ej.NombrePiscina
FROM
    proTransferenciaEspecieDetalle det
    INNER JOIN proTransferenciaEspecie ca ON det.idTransferencia = ca.idTransferencia
    INNER JOIN #DatosPiscina ej ON ej.idPiscinaEjecucion = det.idPiscinaEjecucion AND ej.idPiscina = det.idPiscina
WHERE ej.idPiscinaEjecucion = det.idPiscinaEjecucion AND ej.idPiscina = det.idPiscina AND det.activo = 1 and ca.estado ='APR' ;

 

INSERT INTO #tmp_recepciones_transferencias (idPiscina, idPiscinaEjecucion, fechaMuestreo, TipoOrigenMov,ciclo,KeyPiscina)
  SELECT 
                 det.idPiscina
                ,det.idPiscinaEjecucion
				,ca.fechaMuestreo 
				,'M' AS TipoOrigenMov 
				,ej.Ciclo
	            ,ej.NombrePiscina
FROM 
   proMuestreoPesoDetalle det
   INNER JOIN proMuestreoPeso ca on det.idMuestreo=ca.idMuestreo
   INNER JOIN #DatosPiscina ej on ej.idPiscinaEjecucion = det.idPiscinaEjecucion
   AND ej.idPiscina = det.idPiscina
WHERE 
    ca.fechaMuestreo=(
                         SELECT MAX(z.fechaMuestreo) 
                         FROM proMuestreoPesoDetalle x 
						 INNER JOIN proMuestreoPeso z on x.idMuestreo=z.idMuestreo
                         WHERE  x.idPiscinaEjecucion = ej.idPiscinaEjecucion AND x.idPiscina = ej.idPiscina
						 AND  z.estado='APR' AND X.activo =1
				     )
	AND ca.estado='APR' 
	AND det.activo= 1 
ORDER BY idPiscinaEjecucion, fechaMuestreo ASC

SELECT DISTINCT idPiscina,	idPiscinaEjecucion,	max(fechaMuestreo) as fechaMuestreoMaxima,Ciclo
	            ,KeyPiscina
	into   #tmp_muestreos_filtrados_max
FROM #tmp_recepciones_transferencias
group by  idPiscina,	idPiscinaEjecucion,Ciclo
	            ,KeyPiscina

select x.idPiscina,	x.idPiscinaEjecucion	,x.fechaMuestreoMaxima  ,DATEPART(week, x.fechaMuestreoMaxima)AS Semana
	   ,DATEPART(YEAR, x.fechaMuestreoMaxima)AS Año, x.ciclo, x.KeyPiscina, y.*
  from #tmp_muestreos_filtrados_max x
  LEFT JOIN (
  SELECT 
        vw.Zona		AS 'ZonaVista'
       ,vw.Sector	AS 'SectorVista'
	   ,vw.Piscina	AS 'PiscinaVista'
	   ,vw.Ciclo    AS 'CicloVista'
	   ,vw.semana   AS 'SemanaVista'
	   ,vw.año      AS 'AñoVista'
  FROM [192.168.1.160].[ProduccionBI].[dbo].Vw_variables_reporte_insigne vw  with(nolock) 
  WHERE  
 
  (vw.año *100 + vw.semana ) = (SELECT max(x.año *100 + x.semana) 
                      FROM [192.168.1.160].[ProduccionBI].[dbo].Vw_variables_reporte_insigne x  with(nolock) 
					  WHERE x.Piscina=  vw.Piscina
					  ) ) y
  ON x.KeyPiscina=y.[PiscinaVista]
  ORDER BY x.KeyPiscina, ciclo, [CicloVista] 
 
   

  





