-- Declaración de parámetro de zona
DECLARE @zona VARCHAR(10) = '21';      

IF(COALESCE(@zona, '') = '')    
BEGIN    
    SET @zona = NULL;    
END    

-- Eliminación de tablas temporales si existen
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatoSDestinoTrans') IS NOT NULL DROP TABLE #ProcesamientoInicialDatoSDestinoTrans;
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatosOrigenTrans') IS NOT NULL DROP TABLE #ProcesamientoInicialDatosOrigenTrans;
IF OBJECT_ID('tempdb..#PresentacionDatoSiembra') IS NOT NULL DROP TABLE #PresentacionDatoSiembra;
IF OBJECT_ID('tempdb..#zonas') IS NOT NULL DROP TABLE #zonas;
IF OBJECT_ID('tempdb..#zonasDestino') IS NOT NULL DROP TABLE #zonasDestino;
IF OBJECT_ID('tempdb..#piscinas') IS NOT NULL DROP TABLE #piscinas;

-- Zonas de origen
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

-- Piscinas (usadas en origen y destino)
SELECT 
    pis.idPiscina, 
    pis.nombre, 
    pis.superficieValor, 
    pis.profundidadValor, 
    pis.zona, 
    pis.camaronera, 
    pis.sector
INTO #piscinas       
FROM maePiscina pis;

-- Datos de transferencia origen
SELECT     
    tra.fechaTransferencia AS FechaTransferencia,
	CONCAT(zo.Sector,pis.nombre,'.',pej.ciclo) AS CodCicloOrigen,
    zo.Zona AS ZonaOrigen,     
    --zo.Camaronera AS CamaroneraOrigen,     
    zo.Sector AS SectorOrigen,       
    pis.nombre AS PiscinaOrigen,       
    pej.ciclo AS CicloOrigen,     
    ec.nombre AS RolOrigen,      
    CASE pej.Estado
        WHEN 'INI' THEN 'INICIADO'
        WHEN 'EJE' THEN 'EJECUCIÓN'
        WHEN 'PRE' THEN 'PRECERRADO'
        WHEN 'CER' THEN 'CERRADO'
        ELSE pej.Estado
    END AS EstadoOrigen, 
    pis.superficieValor AS HectareaOrigen,      
    pej.fechaSiembra,    
    pej.cantidadEntrada AS CantidadSembrada,       
    CAST((pej.cantidadEntrada / pis.superficieValor) AS INT) AS Densidad,     
    COALESCE(
        SUM(COALESCE(1.0 / red.plGramoCam, 0) * COALESCE(red.cantidadRecibida, 0)) 
        / NULLIF(SUM(COALESCE(red.cantidadRecibida, 0)), 0), 0
    ) AS PesoSiembra,      
    CASE 
        WHEN tra.esTotal = 0 THEN 'PARCIAL'    
        WHEN tra.esTotal = 1 THEN 'TOTAL'    
        ELSE ''    
    END AS EstatusTransfrencia,
	-- consumo balanceado (proviende de vista)
    tra.guiaTransferencia,    
    tra.tipoTransferencia,     
    pej.idPiscinaEjecucion,    
    tra.idTransferencia,    
    tra.secuencia
INTO #ProcesamientoInicialDatosOrigenTrans      
FROM #zonas zo      
INNER JOIN #piscinas pis ON 
    zo.CodigoZona = pis.zona AND 
    zo.CodigoCamaronera = pis.camaronera AND 
    zo.CodigoSector = pis.sector      
INNER JOIN proPiscinaEjecucion pej ON pis.idPiscina = pej.idPiscina      
INNER JOIN parElementoCatalogo ec ON ec.codigo = pej.rolPiscina AND ec.idCatalogo = 5      
INNER JOIN proTransferenciaEspecie tra ON tra.idPiscinaEjecucion = pej.idPiscinaEjecucion AND tra.estado = 'APR'     
LEFT JOIN proRecepcionEspecieDetalle red ON red.idPiscinaEjecucion = pej.idPiscinaEjecucion       
LEFT JOIN proRecepcionEspecie re ON red.idRecepcion = re.idRecepcion AND re.estado = 'APR'      
WHERE pej.estado IN ('INI','EJE','PRE','CER')      
GROUP BY 
    zo.Zona, zo.Camaronera, zo.Sector, pis.nombre, ec.nombre, pej.estado,
    pis.superficieValor, pis.profundidadValor, pej.fechaInicio, pej.fechaSiembra, 
    pej.ciclo, pej.idPiscinaEjecucion, pej.fechaCierre, pej.cantidadEntrada, 
    pej.cantidadSalida, pej.cantidadAdicional, tra.fechaTransferencia,    
    tra.esTotal, tra.guiaTransferencia, tra.tipoTransferencia,  
    tra.idTransferencia, tra.secuencia;

-- Zonas destino
SELECT  
    zo.codigo AS CodigoZona, 
    zo.nombre AS Zona, 
    ca.codigo AS CodigoCamaronera, 
    ca.nombre AS Camaronera, 
    se.codigo AS CodigoSector,  
    se.nombre AS Sector
INTO #zonasDestino
FROM parZona zo      
INNER JOIN parCamaronera ca ON zo.idZona = ca.idZona      
INNER JOIN parSector se ON ca.idCamaronera = se.idCamaronera;       

-- Transferencias destino
SELECT    
    zo.Zona AS ZonaDestino,
	CONCAT(zo.Sector,pis.nombre,'.',pej.ciclo) AS CodCicloDestino,
    --zo.Camaronera AS CamaroneraDestino,     
    zo.Sector AS SectorDestino,       
    pis.nombre AS PiscinaDestino,      
    pej.ciclo AS CicloDestino,
	CASE pej.Estado
        WHEN 'INI' THEN 'INICIADO'
        WHEN 'EJE' THEN 'EJECUCIÓN'
        WHEN 'PRE' THEN 'PRECERRADO'
        WHEN 'CER' THEN 'CERRADO'
        ELSE pej.Estado
    END AS EstadoDestino,
    pis.superficieValor AS HectareaDestino,    
    --ec.nombre AS RolDestino,      
    trad.cantidadTransferida,    
    trad.pesoPromedioTransferencia AS PesoTransferido,      
    ISNULL(trad.pesoDeclaradoTransferido, 0) AS PesoReal,    
    trad.librasDeclaradas AS LibrasTransferida,
	--Conversion alimenticia
	COALESCE(lab.razonComercial, '') AS ProcedenciaLaboratorio,
    COALESCE(cg.nombre, '') AS Linea,
	COALESCE(labm.razonComercial, '') AS Maduracion,
	--supery
	--balanceo
	--lb brutas
    trad.idTransferenciaDetalle,    
    trad.idTransferencia,
    mtf.nombre AS TipoTransferencia
INTO #ProcesamientoInicialDatoSDestinoTrans      
FROM #zonasDestino zo      
INNER JOIN #piscinas pis ON 
    zo.CodigoZona = pis.zona AND 
    zo.CodigoCamaronera = pis.camaronera AND 
    zo.CodigoSector = pis.sector      
INNER JOIN proPiscinaEjecucion pej ON pis.idPiscina = pej.idPiscina      
INNER JOIN parElementoCatalogo ec ON ec.codigo = pej.rolPiscina AND ec.idCatalogo = 5       
INNER JOIN proTransferenciaEspecieDetalle trad ON trad.idPiscinaEjecucion = pej.idPiscinaEjecucion      
INNER JOIN proTransferenciaEspecie tra ON tra.idTransferencia = trad.idTransferencia AND tra.estado = 'APR'    
INNER JOIN maeTipoTransferencia mtf ON mtf.codigo = trad.tipoTransferencia
LEFT JOIN proRecepcionEspecieDetalle red ON red.idPiscinaEjecucion = pej.idPiscinaEjecucion
LEFT JOIN proRecepcionEspecie re ON red.idRecepcion = re.idRecepcion AND re.estado = 'APR'
LEFT JOIN maeLaboratorioMarca lab ON lab.idLaboratorio = re.idLaboratorio AND lab.idLaboratorioMarca = re.idLaboratorioLarva
LEFT JOIN maeCodigoGenetico cg ON cg.idCodigoGenetico = red.idCodigoGenetico
LEFT JOIN maeLaboratorioMarca labm ON labm.idLaboratorioMarca = red.idLaboratorioMaduracion

WHERE pej.estado IN ('INI','EJE','PRE','CER')    
AND EXISTS (
    SELECT 1 
    FROM #ProcesamientoInicialDatosOrigenTrans o 
    WHERE o.idTransferencia = tra.idTransferencia
);

-- Resultado final
SELECT     
    o.FechaTransferencia, o.CodCicloOrigen,
    o.ZonaOrigen, o.SectorOrigen, o.PiscinaOrigen,     
    o.CicloOrigen, o.RolOrigen, o.EstadoOrigen, o.HectareaOrigen, o.fechaSiembra,    
    o.CantidadSembrada, o.Densidad, o.PesoSiembra, o.EstatusTransfrencia, 
    o.GuiaTransferencia, d.TipoTransferencia,    
    d.ZonaDestino, d.CodCicloDestino, d.SectorDestino, d.PiscinaDestino, 
    d.CicloDestino, d.HectareaDestino, 
    d.CantidadTransferida, d.PesoTransferido, d.PesoReal, d.LibrasTransferida, d.Linea, d.Maduracion, 
    (CAST(d.CantidadTransferida AS FLOAT) / o.CantidadSembrada) * 100 AS Supervivencia    
FROM #ProcesamientoInicialDatosOrigenTrans o 
INNER JOIN #ProcesamientoInicialDatoSDestinoTrans d ON o.idTransferencia = d.idTransferencia;
