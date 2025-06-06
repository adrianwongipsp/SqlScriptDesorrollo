DECLARE @zona VARCHAR(2) = '03'

DROP TABLE IF EXISTS 
	#muestreos_poblacional_zona_sincarac,
	#muestreos_poblacional_solocarac,
	#usuarios_poblacional,
	#columnasCaracteristicas

SELECT idParametroControl, nombre
INTO #columnasCaracteristicas
FROM maeParametroControl 
WHERE tipoParametro = '003' 
  AND activo = 1 
  AND soloPoblacion = 1


SELECT userId, userLogin, description AS nombreLogin
INTO #usuarios_poblacional
FROM IPSPLightweightCore_Produccion.dbo.secUser
WHERE active = 1

SELECT 
    pu.nombreSector AS Sector,  
    pu.nombrePiscina AS Unidad,
    pc.fechaMuestreo,
    FLOOR(
        CASE 
            WHEN ISNULL(pd.poblacionReportada, 0) > 0
                THEN pd.poblacionReportada / pd.areaSuperficiehectarea
            ELSE pd.poblacionEstimada / pd.areaSuperficiehectarea
        END
    ) AS densidadPoblacional,
    pd.promedioNivelAgua,
    pd.areaAtarraya,
    COUNT(ppd.orden) AS numeroLances,
    pd.numeroAnimales,
    t.nombre AS tiempo,
    ata.nombre AS atarraya,
    tm.nombre AS tipoMarea,
    fl.nombre AS faseLunar,
    COALESCE(upa.nombreLogin, pc.atarrayador) AS nombreAtarrayador,
    COALESCE(upb.nombreLogin, pc.bogador) AS nombreBogador,
    COALESCE(upr.nombreLogin, pc.responsable) AS nombreResponsable,
    pd.idMuestreoDetalle,
    pc.idMuestreo
INTO #muestreos_poblacional_zona_sincarac
FROM proMuestreoPoblacion pc 
INNER JOIN proMuestreoPoblacionDetalleLance pd ON pd.idMuestreo = pc.idMuestreo
INNER JOIN PiscinaUbicacion pu ON pu.idPiscina = pd.idPiscina
INNER JOIN proMuestreoPoblacionProfundidadDetalle ppd ON ppd.idMuestreoDetalle = pd.idMuestreoDetalle
INNER JOIN maeTiempo t ON t.idTiempo = pc.idTiempo
INNER JOIN maeAtarraya ata ON ata.idAtarraya = pc.idAtarraya
INNER JOIN parElementoCatalogo tm ON tm.codigo = pc.idMarea AND tm.idCatalogo = 27
INNER JOIN parElementoCatalogo fl ON fl.codigo = pc.idFaseLunar AND fl.idCatalogo = 26
LEFT JOIN #usuarios_poblacional upr ON upr.userLogin = pc.responsable
LEFT JOIN #usuarios_poblacional upa ON upa.userLogin = pc.atarrayador
LEFT JOIN #usuarios_poblacional upb ON upb.userLogin = pc.bogador
WHERE 
    pc.estado = 'apr' 
    AND pd.activo = 1 
    AND ppd.activo = 1 
    AND pc.zona = @zona
GROUP BY  
    pu.nombreSector, pu.nombrePiscina, pc.fechaMuestreo,
    pd.promedioNivelAgua, pd.areaAtarraya, pd.numeroAnimales, pc.idTiempo,
    t.nombre, pc.idAtarraya, ata.nombre, tm.nombre, fl.nombre,
    pc.atarrayador, pc.bogador, pc.responsable,
    upr.nombreLogin, upa.nombreLogin, upb.nombreLogin,
    pd.idMuestreoDetalle, pc.idMuestreo,
    pd.poblacionReportada, pd.areaSuperficiehectarea, pd.poblacionEstimada

SELECT 
    pdc.idMuestreo,
    pdc.idMuestreoDetalle,
    mpc.nombre AS nombreParametroContorl,
    pdc.idParametroControl,
    pdc.valor,
    pdc.idCualidad,
    COALESCE(cl.cualidad, '') AS cualidad
INTO #muestreos_poblacional_solocarac
FROM proMuestreoPoblacionDetalleCaracteristica pdc  
INNER JOIN maeParametroControl mpc ON mpc.idParametroControl = pdc.idParametroControl
LEFT JOIN maeParametroControlCualidad cl 
       ON cl.idParametroControl = pdc.idParametroControl 
      AND cl.idParametroControlDetalle = pdc.idCualidad
WHERE 
    pdc.idMuestreoDetalle IN (
        SELECT idMuestreoDetalle FROM #muestreos_poblacional_zona_sincarac
    )
    AND pdc.activo = 1

-- CREAR EL PIVOT DINÁMICO
DECLARE @sql NVARCHAR(MAX)
DECLARE @columns NVARCHAR(MAX)

-- Obtener las columnas de características dinámicamente
SELECT @columns = STUFF((
    SELECT DISTINCT ',' + QUOTENAME(nombre)
    FROM #columnasCaracteristicas
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

-- Construir la consulta pivot dinámica completa (crear pivot y hacer join en una sola operación)
SET @sql = N'
SELECT 
    m.*,
    ' + @columns + ',
    CAST(CAST(NULLIF(TRY_CAST([N° Tilapias] AS FLOAT), 0) AS FLOAT) / NULLIF(m.numeroLances, 0) AS DECIMAL(10,2)) AS TilapiaXLance
FROM #muestreos_poblacional_zona_sincarac m
LEFT JOIN (
    SELECT 
        idMuestreoDetalle,
        ' + @columns + '
    FROM (
        SELECT 
            idMuestreoDetalle,
            nombreParametroContorl,
            CASE 
                WHEN cualidad != '''' THEN cualidad
                ELSE CAST(valor AS VARCHAR(50))
            END as valorFinal
        FROM #muestreos_poblacional_solocarac
    ) AS SourceTable
    PIVOT (
        MAX(valorFinal)
        FOR nombreParametroContorl IN (' + @columns + ')
    ) AS PivotTable
) p ON m.idMuestreoDetalle = p.idMuestreoDetalle'

-- Ejecutar la consulta completa
EXEC sp_executesql @sql

-- Limpiar tablas temporales
DROP TABLE IF EXISTS 
    #muestreos_poblacional_zona_sincarac,
    #muestreos_poblacional_solocarac,
    #usuarios_poblacional,
    #columnasCaracteristicas