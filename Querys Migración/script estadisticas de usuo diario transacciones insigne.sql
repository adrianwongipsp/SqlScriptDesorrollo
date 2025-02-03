--CREATE PROCEDURE sp_CalcularPromedioDiario
--    @TableName NVARCHAR(128)
--AS
-- Drop the temporary table if it exists                      
IF OBJECT_ID('tempdb..#EstadisticaDiaria') IS NOT NULL                      
    DROP TABLE #EstadisticaDiaria; 

CREATE TABLE #EstadisticaDiaria
(
    tabla VARCHAR(128),
    promedioDiario INT,
    Tipo VARCHAR(10),
    FechaInicio DATE
)

-- Drop the temporary table if it exists                      
IF OBJECT_ID('tempdb..#tablaTransaccionales') IS NOT NULL                      
    DROP TABLE #tablaTransaccionales;  

CREATE TABLE #tablaTransaccionales
(
    id INT IDENTITY(1,1),
    tableName VARCHAR(128),
    procesado BIT
)

INSERT INTO #tablaTransaccionales  
    (tableName, procesado) 
SELECT name, 0 procesado 
FROM sys.tables 
WHERE name IN ('proControlParametro','proHistograma','proMuestreoPeso',
               'proMuestreoPoblacion','proPedidoBin','proPiscinaCosecha','proPlanificacionSiembra',
               'proRecepcionEspecie','proTransferenciaEspecie')

BEGIN
    DECLARE @id INT

    WHILE EXISTS (SELECT TOP 1 1 FROM #tablaTransaccionales WHERE procesado = 0)
    BEGIN
        SET @id = (SELECT TOP 1 id FROM #tablaTransaccionales WHERE procesado = 0)
        
        --****************************inicio de proceso**********************************--
        DECLARE @TableName NVARCHAR(128)
        DECLARE @sql NVARCHAR(MAX)
        
        SET @TableName = (SELECT TOP 1 tableName FROM #tablaTransaccionales WHERE procesado = 0 AND id = @id)

        -- Paso 1: Contar los registros por día para toda la historia y obtener la fecha de inicio
        SET @sql = N'
        WITH DailyCounts AS (
            SELECT 
                CAST(fechaRegistro AS DATE) AS Fecha,
                COUNT(*) AS NumRegistros
            FROM ' + QUOTENAME(@TableName) + N'
            GROUP BY 
                CAST(fechaRegistro AS DATE)
        )
        SELECT 
            ''' + @TableName + ''' AS tabla, 
            AVG(NumRegistros) AS PromedioDiario, 
            ''Historico'' AS Tipo,
            (SELECT MIN(CAST(fechaRegistro AS DATE)) FROM ' + QUOTENAME(@TableName) + N') AS FechaInicio
        FROM DailyCounts;

        -- Paso 2: Contar los registros por día para el último mes y obtener la fecha de inicio del mes actual
        WITH DailyCounts AS (
            SELECT 
                CAST(fechaRegistro AS DATE) AS Fecha,
                COUNT(*) AS NumRegistros
            FROM ' + QUOTENAME(@TableName) + N'
            WHERE 
                fechaRegistro >= DATEADD(MONTH, -1, GETDATE()) 
                AND fechaRegistro < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0)
            GROUP BY 
                CAST(fechaRegistro AS DATE)
        )
        SELECT 
            ''' + @TableName + ''' AS tabla, 
            AVG(NumRegistros) AS PromedioDiario, 
            ''Mes'' AS Tipo,
            CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) AS DATE) AS FechaInicio
        FROM DailyCounts;
        '

        -- Ejecutar el SQL dinámico
        INSERT INTO #EstadisticaDiaria
        EXEC sp_executesql @sql;

        --****************************fin de proceso**********************************--

        UPDATE #tablaTransaccionales 
        SET procesado = 1 
        WHERE procesado = 0 AND id = @id
    END
END

-- select * from #EstadisticaDiaria
