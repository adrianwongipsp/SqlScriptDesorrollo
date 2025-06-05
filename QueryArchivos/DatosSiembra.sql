DECLARE @zona VARCHAR(10) = '20';

-- Normaliza valor de entrada
IF (COALESCE(@zona, '') = '')
BEGIN
    SET @zona = NULL;
END

-------------------- Limpieza de objetos temporales --------------------
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatoSiembra') IS NOT NULL DROP TABLE #ProcesamientoInicialDatoSiembra;
IF OBJECT_ID('tempdb..#PresentacionDatoSiembra') IS NOT NULL DROP TABLE #PresentacionDatoSiembra;
IF OBJECT_ID('tempdb..#zonas') IS NOT NULL DROP TABLE #zonas;
IF OBJECT_ID('tempdb..#piscinas') IS NOT NULL DROP TABLE #piscinas;

-------------------- Consulta zonas --------------------
SELECT
    zo.codigo AS CodigoZona,
    zo.nombre AS Zona,
    ca.codigo AS CodigoCamaronera,
    ca.nombre AS Camaronera,
    se.codigo AS CodigoSector,
    se.nombre AS Sector
INTO #zonas
FROM parZona zo
INNER JOIN parCamaronera ca ON zo.idZona = ca.idZona
INNER JOIN parSector se ON ca.idCamaronera = se.idCamaronera
WHERE zo.codigo = COALESCE(@zona, zo.codigo);

-------------------- Consulta piscinas asociadas --------------------
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
WHERE EXISTS (
    SELECT 1
    FROM #zonas zo
    WHERE zo.CodigoZona = pis.zona
      AND zo.CodigoCamaronera = pis.camaronera
      AND zo.CodigoSector = pis.sector
);

-------------------- Datos de siembra y recepciones --------------------
SELECT
    zo.Zona,
    --zo.Camaronera,
    zo.Sector,
    pis.nombre AS Piscina,
    pej.ciclo AS Ciclo,
	CONCAT(zo.Sector,pis.nombre,'.',pej.ciclo) AS CodCiclo,
    CASE pej.Estado
        WHEN 'INI' THEN 'INICIADO'
        WHEN 'EJE' THEN 'EJECUCIÓN'
        WHEN 'PRE' THEN 'PRECERRADO'
        WHEN 'CER' THEN 'CERRADO'
        ELSE pej.Estado
    END AS Estado,
    ec.nombre AS Rol,
    re.fechaRecepcion AS FechaSiembra,
    red.cantidadRecibida AS CantidadSembrada,
    pis.superficieValor AS Hectarea,
    CAST((red.cantidadRecibida / pis.superficieValor) AS INT) AS Densidad,
    (1.0 / red.plGramoCam) AS PesoSiembra,
    red.plGramoLab AS PlGrGuia,
    red.plGramoCam AS PlGrLLegada,
    estd.nombre AS Estadio,
    0 AS LarvasAzules,
    0 AS LarvasVacias,
    0 AS LarvasMuertas,
    ISNULL(lab.razonComercial, '') AS ProcedenciaLaboratorio,
    ISNULL(cg.nombre, '') AS Linea,
    ISNULL(labm.razonComercial, '') AS Maduracion,
    rex.guiasEmbarque,
    re.guiasRemision,
    red.tanqueOrigen AS TqRW,
    pej.idPiscinaEjecucion,
    red.idRecepcion,
    red.idRecepcionDetalle,
    re.secuencia
INTO #ProcesamientoInicialDatoSiembra
FROM #zonas zo
INNER JOIN #piscinas pis ON
    zo.CodigoZona = pis.zona AND
    zo.CodigoCamaronera = pis.camaronera AND
    zo.CodigoSector = pis.sector
INNER JOIN proPiscinaEjecucion pej ON pis.idPiscina = pej.idPiscina
INNER JOIN parElementoCatalogo ec ON ec.codigo = pej.rolPiscina AND ec.idCatalogo = 5
INNER JOIN proRecepcionEspecieDetalle red ON red.idPiscinaEjecucion = pej.idPiscinaEjecucion
INNER JOIN proRecepcionEspecie re ON red.idRecepcion = re.idRecepcion AND re.estado = 'APR'
INNER JOIN proRecepcionEspecieExtra rex ON rex.idRecepcion = re.idRecepcion
INNER JOIN maeEstadioLarva estd ON estd.codigo = rex.estadioLarva AND estd.empresa = '01'
INNER JOIN maeEspecie esp ON esp.idEspecie = re.idEspecie
INNER JOIN maeLaboratorioMarca lab ON lab.idLaboratorio = re.idLaboratorio AND lab.idLaboratorioMarca = re.idLaboratorioLarva
INNER JOIN maeLaboratorioMarca labm ON labm.idLaboratorioMarca = red.idLaboratorioMaduracion
LEFT JOIN maeCodigoGenetico cg ON cg.idCodigoGenetico = red.idCodigoGenetico
WHERE pej.estado IN ('INI', 'EJE', 'PRE', 'CER');

-------------------- Actualización de características --------------------
UPDATE r
SET
    r.LarvasAzules = ISNULL((
        SELECT TOP 1 COALESCE(valorEnCamaronera, 0)
        FROM proRecepcionEspecieCaracteristica
        WHERE idParametroControl = 16
          AND idRecepcion = r.idRecepcion
          AND idRecepcionDetalle = r.idRecepcionDetalle
          AND activo = 1
    ), 0),
    r.LarvasVacias = ISNULL((
        SELECT TOP 1 COALESCE(valorEnCamaronera, 0)
        FROM proRecepcionEspecieCaracteristica
        WHERE idParametroControl = 17
          AND idRecepcion = r.idRecepcion
          AND idRecepcionDetalle = r.idRecepcionDetalle
          AND activo = 1
    ), 0),
    r.LarvasMuertas = ISNULL((
        SELECT TOP 1 COALESCE(valorEnCamaronera, 0)
        FROM proRecepcionEspecieCaracteristica
        WHERE idParametroControl = 44
          AND idRecepcion = r.idRecepcion
          AND idRecepcionDetalle = r.idRecepcionDetalle
          AND activo = 1
    ), 0)
FROM #ProcesamientoInicialDatoSiembra r;

-------------------- Resultado final --------------------
SELECT
    Zona,
    Sector,
    Piscina,
    Ciclo,
	CodCiclo,
    Estado,
    Rol,
    FechaSiembra,
    CantidadSembrada,
    Hectarea,
    Densidad,
    PesoSiembra,
    PlGrGuia,
    PlGrLLegada,
    Estadio,
    LarvasAzules,
    LarvasVacias,
    LarvasMuertas,
    ProcedenciaLaboratorio,
    Linea,
    Maduracion,
    guiasEmbarque,
    guiasRemision,
    TqRW
FROM #ProcesamientoInicialDatoSiembra;
