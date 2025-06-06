DECLARE @codigozona        VARCHAR(2), 
        @IdTipoParametro   VARCHAR(3), 
        @fechaParametro    DATE = NULL

SET @codigozona = '29'
SET @IdTipoParametro = '001'
SET @fechaParametro = '2023-09-26'

DECLARE @ColumnToPivot        NVARCHAR(MAX)
DECLARE @ListToPivot          NVARCHAR(MAX)
DECLARE @Empresa              VARCHAR(3)
DECLARE @FechaInicio          DATETIME
DECLARE @FechaFin             DATETIME
DECLARE @NombrePiscina        VARCHAR(15)
DECLARE @Codigosector         VARCHAR(15)
DECLARE @Codigocamaronera     VARCHAR(15)
--DECLARE @Codigozona        VARCHAR(15)
--DECLARE @IdTipoParametro    VARCHAR(3)
DECLARE @VerDetalle           BIT

----------------------VALORES OBLIGATORIOS---------------------------
--'NombreHoraControl' para horas
--'Parametro'        para nombres de parametros
SET @ColumnToPivot = 'Parametro' --'NombreHoraControl'
SET @Empresa = '01'

IF(@fechaParametro IS NULL)
BEGIN
    SELECT @fechaParametro = GETDATE()
END

-- Generar la fecha de inicio y fin usando @fechaParametro
--SET @FechaInicio = CAST(CONVERT(VARCHAR, @fechaParametro, 23) AS DATETIME) -- 2024-09-15 00:00:00.000 
SET @FechaInicio = CAST(@fechaParametro AS DATETIME)
SET @FechaFin = DATEADD(SECOND, -1, DATEADD(DAY, 1, @FechaInicio)) -- 2024-09-15 23:59:59.000

SET @VerDetalle = 1

----------------------VALORES OPCIONALES---------------------------
SET @NombrePiscina = null
SET @codigocamaronera = null --TAURA A
SET @Codigosector = null --'00001'
--SET @codigozona = '01'    --TAURA        
--SET @IdTipoParametro = '001'   --TABLA DE CATALOGO (AMBIENTALES)      

IF OBJECT_ID('tempdb..#tomaControl') IS NOT NULL DROP TABLE #tomaControl
IF OBJECT_ID('tempdb..#temp_ambientales') IS NOT NULL DROP TABLE #temp_ambientales
IF OBJECT_ID('tempdb..#ColumnsPivot') IS NOT NULL DROP TABLE #ColumnsPivot
IF OBJECT_ID('tempdb..#temp_no_ambientales') IS NOT NULL DROP TABLE #temp_no_ambientales

CREATE TABLE #ColumnsPivot(nombre VARCHAR(200))

SELECT * 
INTO #tomaControl 
FROM (
    SELECT 
        c.fechaControl, c.division, 
        c.zona, c.camaronera, 
        c.sector, d.idPiscina, 
        d.idPiscinaEjecucion,
        dv.idParametroControl, 
        mp.nombre + CASE WHEN mp.unidad = '' OR mp.unidad IS NULL THEN '' ELSE ' (' + mp.unidad + ')' END AS nombre,
        idCualidad, mpc.cualidad,
        cat.codigo AS IdTipoParametro, cat.Nombre AS NombreTipoParametro,
        c.horaControl, cath.Nombre AS NombreHoraControl,
        c.fechaRegistro, CONVERT(VARCHAR(10), d.horaRegistro, 108) AS horaRegistro,
        MIN(mpc.cualidad) conteoParametroAgrupado, d.observacion,
        IIF(ISNULL(c.responsable,'') = '', c.usuarioCreacion, c.responsable) AS Responsable,
        IIF(ISNULL(c.responsable,'') = '', 0, 1) AS ExisteResponsable
    FROM proControlParametro c
    INNER JOIN proControlParametroDetalle d ON c.idControlParametro = d.idControlParametro
    INNER JOIN proControlParametroValorDetalle dv ON dv.idControlParametroDetalle = d.idControlParametroDetalle
    INNER JOIN maeParametroControl mp ON mp.idParametroControl = dv.idParametroControl AND mp.empresa = c.empresa
    INNER JOIN maeParametroControlCualidad mpc ON mpc.idParametroControl = dv.idParametroControl AND mpc.idParametroControlDetalle = idCualidad
    INNER JOIN parElementoCatalogo cat ON cat.codigo = mp.tipoParametro AND cat.idcatalogo = 6
    INNER JOIN parElementoCatalogo cath ON cath.codigo = c.horaControl AND cath.idcatalogo = 9
    WHERE mp.tipoParametro = @IdTipoParametro
        AND c.fechaControl >= @FechaInicio
        AND c.fechaControl <= @FechaFin
        AND c.empresa = @Empresa
        AND c.estado NOT IN ('ANU')
        AND d.activo = 1
    GROUP BY 
        c.fechaControl, c.division, c.zona, c.camaronera, c.sector, 
        d.idPiscina, d.idPiscinaEjecucion, dv.idParametroControl, 
        mp.nombre, mp.unidad, idCualidad, mpc.cualidad, 
        cat.codigo, cat.Nombre, c.horaControl, cath.Nombre, 
        d.observacion, c.fechaRegistro, c.fechaHoraCreacion, 
        d.horaRegistro, c.responsable, c.usuarioCreacion

    UNION ALL

    SELECT 
        c.fechaControl, c.division, 
        c.zona, c.camaronera, 
        c.sector, d.idPiscina, 
        d.idPiscinaEjecucion,
        dv.idParametroControl, 
        mp.nombre + CASE WHEN mp.unidad = '' OR mp.unidad IS NULL THEN '' ELSE ' (' + mp.unidad + ')' END AS nombre,
        0 idCualidad, '' cualidad,
        cat.codigo AS IdTipoParametro, cat.Nombre AS NombreTipoParametro,
        c.horaControl, cath.Nombre AS NombreHoraControl,
        c.fechaRegistro, CONVERT(VARCHAR(10), d.horaRegistro, 108) AS horaRegistro,
        CAST(ROUND(AVG(dv.valor), 2) AS VARCHAR(20)) conteoParametroAgrupado, d.observacion,
        IIF(ISNULL(c.responsable,'') = '', c.usuarioCreacion, c.responsable) AS Responsable,
        IIF(ISNULL(c.responsable,'') = '', 0, 1) AS ExisteResponsable
    FROM proControlParametro c
    INNER JOIN proControlParametroDetalle d ON c.idControlParametro = d.idControlParametro
    INNER JOIN proControlParametroValorDetalle dv ON dv.idControlParametroDetalle = d.idControlParametroDetalle
    INNER JOIN maeParametroControl mp ON mp.idParametroControl = dv.idParametroControl AND mp.empresa = c.empresa
    INNER JOIN parElementoCatalogo cat ON cat.codigo = mp.tipoParametro AND cat.idcatalogo = 6
    INNER JOIN parElementoCatalogo cath ON cath.codigo = c.horaControl AND cath.idcatalogo = 9
    WHERE mp.tipoParametro = @IdTipoParametro
        AND c.fechaControl >= @FechaInicio
        AND c.fechaControl <= @FechaFin
        AND c.empresa = @Empresa
        AND c.estado NOT IN ('ANU')
        AND d.activo = 1
    GROUP BY 
        c.fechaControl, c.division, c.zona, c.camaronera, c.sector, 
        d.idPiscina, d.idPiscinaEjecucion, dv.idParametroControl, 
        mp.nombre, mp.unidad, cat.codigo, cat.Nombre, 
        c.horaControl, cath.Nombre, d.idPiscinaEjecucion, 
        d.observacion, c.fechaRegistro, c.fechaHoraCreacion, 
        d.horaRegistro, c.responsable, c.usuarioCreacion
) AS toma_control


SELECT  
    za.nombre AS ZonaNombre,       
    ca.nombre AS CamaroneraNombre,       
    se.nombre AS NombreSector,       
    p.nombre AS PiscinaNombre,      
    c.idPiscinaEjecucion,      
    ejv.Ciclo,       
    CASE      
        WHEN ejv.estado = 'EJE' THEN 'Ejecución'      
        WHEN ejv.estado = 'PRE' THEN 'Pre Cerrada'      
        WHEN ejv.estado = 'INI' THEN 'Iniciada'      
        WHEN ejv.estado = 'CER' THEN 'Cerrada'      
        WHEN ejv.estado = 'MAN' THEN 'Mantenimiento'      
        ELSE ''  
    END AS EstadoPiscina,      
    catrol.nombre AS rolPiscina,      
    c.fechaControl,    
    c.division,       
    c.zona,      
    c.camaronera,       
    c.sector,     
    c.idPiscina,       
    c.idParametroControl,  
    c.nombre AS Parametro,       
    c.idCualidad,    
    c.cualidad,       
    c.IdTipoParametro,   
    c.NombreTipoParametro,       
    c.horaControl,    
    c.NombreHoraControl,       
    c.conteoParametroAgrupado,        
    CAST(0.000 AS DECIMAL) AS Peso,      
    c.fechaRegistro,       
    c.horaRegistro,      
    c.observacion,      
    c.Responsable,      
    c.ExisteResponsable      
INTO #temp_ambientales      
FROM #tomaControl c       
    INNER JOIN maePiscina p ON c.idPiscina = p.idPiscina      
    INNER JOIN parCamaronera ca ON ca.codigo = p.camaronera AND ca.idZona = p.zona       
    INNER JOIN parSector se ON se.codigo = p.sector AND ca.idCamaronera = se.idCamaronera      
    INNER JOIN parZona za ON za.codigo = ca.idZona       
    INNER JOIN EjecucionesPiscinaView ejv ON ejv.idPiscina = p.idPiscina AND ejv.idPiscinaEjecucion = c.idPiscinaEjecucion      
    INNER JOIN parElementoCatalogo catrol ON catrol.codigo = ejv.rolPiscina AND catrol.idcatalogo = 5         
WHERE IdTipoParametro = @IdTipoParametro      
    --AND idParametroControl IN (1,3,5)         
    AND p.nombre = ISNULL(@NombrePiscina, p.nombre)      
    AND p.sector = ISNULL(@Codigosector, p.sector)      
    AND p.camaronera = ISNULL(@codigocamaronera, p.camaronera)      
    AND p.zona = ISNULL(@codigozona, p.zona)      
  
UPDATE tr 
SET tr.responsable = u.description  
FROM #temp_ambientales tr 
    INNER JOIN IPSPLightweightCore_Produccion.dbo.secuser u 
        ON u.userLogin = tr.responsable      
WHERE tr.ExisteResponsable = 0      
  
IF (@ColumnToPivot = 'Parametro')      
BEGIN      
    INSERT INTO #ColumnsPivot      
    SELECT DISTINCT       
        mp.nombre +         
        CASE          
            WHEN mp.unidad = '' OR mp.unidad IS NULL THEN ''          
            ELSE ' (' + mp.unidad + ')'         
        END AS nombre
        --, idParametroControl      
    FROM maeParametroControl mp      
    WHERE tipoParametro = @IdTipoParametro 
        AND ACTIVO = 1 
        AND EMPRESA = '01'      
    --ORDER BY idParametroControl
END      
  
IF (@ColumnToPivot = 'NombreHoraControl')      
BEGIN       
    INSERT INTO #ColumnsPivot      
    SELECT DISTINCT nombre       
    FROM parElementoCatalogo      
    WHERE idcatalogo = 9  
        AND ACTIVO = 1 
        AND EMPRESA = '01'      
END      

-----------pivot formación de columnas-----------------       
SELECT @ListToPivot = COALESCE('' + @ListToPivot + ',', '') + '[' + nombre + ']' 
FROM #ColumnsPivot      
--SELECT @ListToPivot       
  
DECLARE @SqlStatement NVARCHAR(MAX) -- Query dinámico      
SET @SqlStatement = N'      
SELECT       
    NombreSector AS Sector,      
    PiscinaNombre AS Unidad,      
    FechaControl AS [Fecha de control],      
    NombreHoraControl AS [Hora de control],        
    RolPiscina AS [Rol piscina],        
    ' + @ListToPivot + ', -- Aquí se insertarán las columnas pivotadas            
    Responsable   
FROM (      
    SELECT      
        ZonaNombre,      
        CamaroneraNombre,      
        NombreSector,      
        PiscinaNombre,      
        Ciclo,       
        EstadoPiscina,      
        RolPiscina,      
        Responsable,       
        FechaControl,      
        NombreHoraControl,      
        Parametro,      
        conteoParametroAgrupado,       
        FechaRegistro,       
        HoraRegistro,      
        Observacion,      
        NombreTipoParametro      
    FROM tempdb..#temp_ambientales      
) AS ParametroAmbientalesResults      
PIVOT (      
    MAX(conteoParametroAgrupado)      
    FOR ' + @ColumnToPivot + ' IN (' + @ListToPivot + ')      
) AS PivotTable;      
';      
  
EXEC sp_executesql @SqlStatement;
