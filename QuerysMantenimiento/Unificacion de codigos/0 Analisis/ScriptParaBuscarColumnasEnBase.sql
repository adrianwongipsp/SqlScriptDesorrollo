DECLARE @ColumnName VARCHAR(30)
SET @ColumnName = 'sector'

-- Crear una tabla temporal para almacenar los resultados
IF OBJECT_ID('tempdb..#TempResult') IS NOT NULL
    DROP TABLE #TempResult;

CREATE TABLE #TempResult (
    TableName NVARCHAR(255),
    ColumnName NVARCHAR(255),
    RecordCount INT,	
    DataType NVARCHAR(255)
)

DECLARE @sql NVARCHAR(MAX) = ''

-- Construir un script dinámico para verificar tablas con registros y columnas coincidentes
SELECT @sql = @sql + '
IF EXISTS (SELECT 1 FROM [' + s.name + '].[' + t.name + '] WITH (NOLOCK))
BEGIN
    INSERT INTO #TempResult (TableName, ColumnName, RecordCount, DataType)
    SELECT ''' + t.name + ''' AS TableName, c.name AS ColumnName, 
          (SELECT COUNT(1) FROM [' + s.name + '].[' + t.name + '] WITH (NOLOCK)) AS RecordCount,
		   tp.name AS DataType
    FROM sys.columns c
	    INNER JOIN sys.types tp ON c.user_type_id = tp.user_type_id
    WHERE c.object_id = OBJECT_ID(''' + s.name + '.' + t.name + ''')
    AND c.name LIKE ''%' + @ColumnName + '%''
END
'
FROM 
    sys.tables t
INNER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN 
    sys.columns c ON t.object_id = c.object_id
WHERE 
    t.name NOT LIKE 'audit_%'
    AND t.name NOT LIKE 'CICLOS_%'
    AND t.name NOT LIKE 'CODIGOINP_%'
    AND t.name NOT LIKE 'migracion_%'
    AND t.name NOT LIKE 'PESCA_%'
    AND t.name NOT LIKE 'TRANSFERENCIA_%'
    AND t.name NOT LIKE 'resp_%'
    AND t.name NOT LIKE 'tmp_%'
    AND t.name NOT LIKE 'temp_%'
	AND t.name NOT LIKE 'RECEPCIONES_%'
    AND t.name NOT LIKE 'PlantillaGrupoCodigo%'
    AND t.name NOT LIKE '%Temp'
	AND t.name NOT LIKE '%ZonficacionActualizacion'
	AND t.name NOT LIKE '_%reporte_insigne'
GROUP BY 
    s.name, t.name

-- Ejecutar el script dinámico para insertar los resultados en la tabla temporal
EXEC sp_executesql @sql

-- Seleccionar los resultados consolidados de la tabla temporal
SELECT * FROM #TempResult --WHERE DataType IN('varchar') 
order by TableName


-- Limpiar la tabla temporal
DROP TABLE #TempResult

 