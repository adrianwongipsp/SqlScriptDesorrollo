DECLARE @zona VARCHAR(10) = '20';

-- ========================================
-- LIMPIEZA DE TABLAS TEMPORALES
-- ========================================
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatoSiembra') IS NOT NULL DROP TABLE #ProcesamientoInicialDatoSiembra;
IF OBJECT_ID('tempdb..#PresentacionDatoSiembra') IS NOT NULL DROP TABLE #PresentacionDatoSiembra;
IF OBJECT_ID('tempdb..#zonas') IS NOT NULL DROP TABLE #zonas;
IF OBJECT_ID('tempdb..#piscinas') IS NOT NULL DROP TABLE #piscinas;

-- ========================================
-- ZONAS Y PISCINAS
-- ========================================
SELECT 
    zo.codigo AS CodigoZona,
    zo.nombre AS Zona,
    ca.codigo AS CodigoCamaronera,
    ca.nombre AS Camaronera,
    se.codigo AS CodigoSector,
    se.nombre AS Sector,
	me.nombre AS MegaZona
INTO #zonas
FROM parZona zo
INNER JOIN parCamaronera ca ON zo.idZona = ca.idZona
INNER JOIN parSector se ON ca.idCamaronera = se.idCamaronera
INNER JOIN parMegaZona me ON zo.idMegaZona = me.idMegaZona
WHERE zo.codigo = COALESCE(@zona, zo.codigo);

SELECT 
    pis.idPiscina,
    pis.nombre,
    pis.superficieValor,
    pis.profundidadValor,
    pis.zona,
    pis.camaronera,
    pis.sector
	INTO #piscinas
FROM maePiscina pis
--INNER JOIN #zonas zo ON zo.CodigoZona = pis.zona AND zo.CodigoCamaronera = pis.camaronera AND zo.CodigoSector = pis.sector
WHERE EXISTS (
    SELECT 1
    FROM #zonas zo
    WHERE zo.CodigoZona = pis.zona
      AND zo.CodigoCamaronera = pis.camaronera
      AND zo.CodigoSector = pis.sector
);

-- ========================================
-- PROCESAMIENTO INICIAL DE DATOS DE SIEMBRA
-- ========================================
SELECT 
	zo.MegaZona,
    zo.Zona,
    zo.Sector,
    pis.nombre AS Piscina,
    ec.nombre AS Rol,
    pej.estado AS Estado,
    pis.superficieValor AS Hectarea,
    pis.profundidadValor AS Profundidad,
    DATEDIFF(DAY, pej.fechaInicio, pej.fechaSiembra) + 1 AS DiasSeco,
    COALESCE(COALESCE(MAX(re.idEspecie), MAX(tra.idEspecie)), NULL) AS idEspecie,
    pej.ciclo AS Ciclo,
    pej.fechaSiembra AS FechaSiembra,
    COALESCE(CONVERT(VARCHAR(10), pej.fechaCierre, 103), ' ') AS FechaCierre,
    pej.fechaInicio AS FechaInicioSecado,
    pej.cantidadEntrada AS CantidadRecibida,
    COALESCE(
        SUM(COALESCE(1.0 / red.plGramoCam, 0) * COALESCE(red.cantidadRecibida, 0)) 
        / NULLIF(SUM(COALESCE(red.cantidadRecibida, 0)), 0), 0
    ) AS PesoSiembra,
    MAX(COALESCE(trad.tipoTransferencia, '')) AS TipoTransferencia,
    COALESCE(
        SUM(COALESCE(trad.pesoPromedioTransferencia, 0) * COALESCE(trad.cantidadTransferida, 0)) 
        / NULLIF(SUM(COALESCE(trad.cantidadTransferida, 0)), 0), 0
    ) AS PesoTransferido,
    (((pej.cantidadEntrada - pej.cantidadSalida) * 100) / pej.cantidadEntrada) AS Supervivencia,
    SUM(COALESCE(trad.librasDeclaradas, 0)) AS LibrasTransferidas,
    MAX(re.idLaboratorio) AS idLaboratorio,
    MAX(re.idLaboratorioLarva) AS idLaboratorioLarva,
    MAX(red.idLaboratorioMaduracion) AS idLaboratorioMaduracion,
    MAX(red.idCodigoGenetico) AS idCodigoGenetico,
    pej.cantidadAdicional AS CantidadAdicional,
    SUM(COALESCE(trad.cantidadDeclarada, 0)) AS CantidadReal,
    pej.idPiscinaEjecucion,
	tra.fechaTransferencia,
	ISNULL(Destinos.Destino1,'') AS Destino1,
	ISNULL(Destinos.Destino2,'') AS Destino2,
	ISNULL(Destinos.Destino3,'') AS Destino3,
	ISNULL(Destinos.Destino4,'') AS Destino4,
	ISNULL(Destinos.Destino5,'') AS Destino5,
	ISNULL(Destinos.Destino6,'') AS Destino6,
	ISNULL(Destinos.Destino7,'') AS Destino7,
	ISNULL(Destinos.Destino8,'') AS Destino8,
	tra.idTransferencia
	,SUM(trad.numeroViajes) AS NumeroViajes
INTO #ProcesamientoInicialDatoSiembra
FROM #zonas zo
INNER JOIN #piscinas pis ON zo.CodigoZona = pis.zona 
                        AND zo.CodigoCamaronera = pis.camaronera 
                        AND zo.CodigoSector = pis.sector
INNER JOIN proPiscinaEjecucion pej ON pis.idPiscina = pej.idPiscina
INNER JOIN parElementoCatalogo ec ON ec.codigo = pej.rolPiscina AND ec.idCatalogo = 5
LEFT JOIN proRecepcionEspecieDetalle red ON red.idPiscinaEjecucion = pej.idPiscinaEjecucion
LEFT JOIN proRecepcionEspecie re ON red.idRecepcion = re.idRecepcion AND re.estado = 'APR'
LEFT JOIN proTransferenciaEspecie tra ON tra.idPiscinaEjecucion = pej.idPiscinaEjecucion AND tra.estado = 'APR'
LEFT JOIN proTransferenciaEspecieDetalle trad ON trad.idTransferencia = tra.idTransferencia
LEFT JOIN (
    SELECT
        idTransferencia,
        MAX(CASE WHEN rn = 1 THEN nombre ELSE NULL END) AS Destino1,
        MAX(CASE WHEN rn = 2 THEN nombre ELSE NULL END) AS Destino2,
        MAX(CASE WHEN rn = 3 THEN nombre ELSE NULL END) AS Destino3,
        MAX(CASE WHEN rn = 4 THEN nombre ELSE NULL END) AS Destino4,
        MAX(CASE WHEN rn = 5 THEN nombre ELSE NULL END) AS Destino5,
        MAX(CASE WHEN rn = 6 THEN nombre ELSE NULL END) AS Destino6,
        MAX(CASE WHEN rn = 7 THEN nombre ELSE NULL END) AS Destino7,
        MAX(CASE WHEN rn = 8 THEN nombre ELSE NULL END) AS Destino8
    FROM (
        SELECT
            te.idTransferencia,
            ted.idPiscina,
            CONCAT(s.nombre,p.nombre) as nombre,
            ROW_NUMBER() OVER (PARTITION BY te.idTransferencia ORDER BY ted.idTransferenciaDetalle) AS rn
        FROM proTransferenciaEspecie te
        INNER JOIN proTransferenciaEspecieDetalle ted ON te.idTransferencia = ted.idTransferencia AND ted.activo = 1
        INNER JOIN maePiscina p ON ted.idPiscina = p.idPiscina
		INNER JOIN parSector s ON p.sector = s.codigo
		WHERE te.estado = 'APR'
    ) AS destinos
    GROUP BY idTransferencia
) AS Destinos ON Destinos.idTransferencia = tra.idTransferencia
WHERE pej.estado IN ('INI', 'EJE', 'PRE', 'CER')
GROUP BY zo.MegaZona,
    zo.Zona, zo.Camaronera, zo.Sector, pis.nombre, ec.nombre, pej.estado,
    pis.superficieValor, pis.profundidadValor, pej.fechaInicio, pej.fechaSiembra,
    pej.ciclo, pej.idPiscinaEjecucion, pej.fechaCierre,
    pej.cantidadEntrada, pej.cantidadSalida, pej.cantidadAdicional, tra.fechaTransferencia,
	Destino1,Destino2,Destino3,Destino4,Destino5,Destino6,Destino7,Destino8, tra.idTransferencia;
-- ========================================
-- PRESENTACIÓN DE DATOS
-- ========================================
SELECT 
	pds.MegaZona,
    pds.Zona,
    pds.Sector,
    pds.Piscina,
    pds.Rol,
	-- SUBTIPO
    CASE 
        WHEN pds.Estado = 'INI' THEN 'INICIADO'
        WHEN pds.Estado = 'EJE' THEN 'EJECUCIÓN'
        WHEN pds.Estado = 'PRE' THEN 'PRECERRADO'
        WHEN pds.Estado = 'CER' THEN 'CERRADO'
        ELSE pds.Estado
    END AS Estado,
	-- FORMA ALIMENT
	-- RIESGO ROBO
    pds.Hectarea,
    pds.Profundidad,
    pds.DiasSeco,
    COALESCE(esp.nombre, '') AS TipoCultivo,
    pds.Ciclo,
	-- TIPO SIEMBRA
    pds.FechaSiembra,
    pds.FechaCierre AS FechaPesca,
    pds.FechaInicioSecado,
    DATEADD(DAY, -1, pds.FechaSiembra) AS TerminoSecado,
    pds.CantidadRecibida AS CantidadSembrada,
    CAST((pds.CantidadRecibida / pds.Hectarea) AS INT) AS Densidad,
    pds.PesoSiembra,
    COALESCE(tt.nombre, '') AS TipoTranferencia,
    pds.PesoTransferido,
    pds.Supervivencia,
    (100 - pds.Supervivencia) AS Mortalidad,
    pds.LibrasTransferidas,
	--CONVERSION ALIMENTICIA
	-- LIBRAS BRUTAS
    COALESCE(lab.razonComercial, '') AS ProcedenciaLaboratorio,
    COALESCE(cg.nombre, '') AS Linea,
    COALESCE(labm.razonComercial, '') AS Maduracion,
	Destino1,
	Destino2,
	Destino3,
	Destino4,
	Destino5,
	Destino6,
	Destino7,
	Destino8,
	pds.fechaTransferencia AS FechaTransferencia,	
	pds.NumeroViajes, --CANTIDAD TANQUERO
    (pds.CantidadRecibida + pds.CantidadAdicional) AS CantidadConPlus,
    pds.CantidadReal,
	idTransferencia
INTO #PresentacionDatoSiembra
FROM #ProcesamientoInicialDatoSiembra pds
LEFT JOIN maeEspecie esp ON esp.idEspecie = pds.idEspecie
LEFT JOIN maeTipoTransferencia tt ON tt.idTipoTransferencia = pds.TipoTransferencia
LEFT JOIN maeLaboratorioMarca lab ON lab.idLaboratorio = pds.idLaboratorio AND lab.idLaboratorioMarca = pds.idLaboratorioLarva
LEFT JOIN maeCodigoGenetico cg ON cg.idCodigoGenetico = pds.idCodigoGenetico
LEFT JOIN maeLaboratorioMarca labm ON labm.idLaboratorioMarca = pds.idLaboratorioMaduracion;

-- ========================================
-- RESULTADO FINAL
-- ========================================
SELECT * 
FROM #PresentacionDatoSiembra
ORDER BY Zona, Sector, Piscina, Ciclo;
