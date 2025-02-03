DECLARE @ColumnToPivot     NVARCHAR(MAX) 
DECLARE @ListToPivot       NVARCHAR(MAX)
DECLARE @Empresa		   VARCHAR(3)
DECLARE @FechaInicio	   DATETIME
DECLARE @FechaFin    	   DATETIME
DECLARE @NombrePiscina     VARCHAR(15)
DECLARE @Codigosector	   VARCHAR(15)
DECLARE @Codigocamaronera  VARCHAR(15)
DECLARE @Codigozona		   VARCHAR(15)
DECLARE @IdTipoParametro   VARCHAR(3)
DECLARE @VerDetalle        BIT
----------------------VALORES OBLIGATORIOS---------------------------
--'NombreHoraControl' para horas
--'Parametro'        para nombres de parametros
SET @ColumnToPivot    =  'NombreHoraControl'
SET @Empresa          =   '01' 
SET @FechaInicio      =   '2024-01-01 00:00:00.000'
SET @FechaFin         =   '2024-06-30 23:59:59.000'
SET @VerDetalle       =  0
----------------------VALORES OPCIONALES---------------------------
SET @NombrePiscina    =   null
SET @codigocamaronera =   null --TAURA A
SET @Codigosector     =   null --'00001'
SET @codigozona       =   null    --TAURA  
SET @IdTipoParametro  =   '001'   --TABLA DE CATALOGO (AMBIENTALES)
 
	if object_id('tempdb..#tomaControl') is not null
		drop table #tomaControl

	if object_id('tempdb..#temp_ambientales') is not null
		drop table #temp_ambientales

	if object_id('tempdb..#ColumnsPivot') is not null
		drop table #ColumnsPivot

	if object_id('tempdb..##temp_ambientales_horas') is not null
		drop table ##temp_ambientales_horas
		
	 create table #ColumnsPivot(
		nombre varchar(200)
	)

	SELECT  *
	  INTO  #tomaControl
	  FROM
	  (  SELECT  c.fechaControl,							c.division  , 
					c.zona,								    c.camaronera, 
					c.sector,							    d.idPiscina , 
					dv.idParametroControl,					mp.nombre   ,  
					0 idCualidad,							'' cualidad,	
					cat.codigo  as IdTipoParametro,			cat.Nombre as NombreTipoParametro ,
					c.horaControl ,                         cath.Nombre as NombreHoraControl  ,
					'x' conteoParametroAgrupado
			FROM proControlParametro c
				inner join proControlParametroDetalle d
							on c.idControlParametro = d.idControlParametro
				inner join proControlParametroValorDetalle dv 
							on dv.idControlParametroDetalle = d.idControlParametroDetalle
				inner join maeParametroControl mp 
							on mp.idParametroControl = dv.idParametroControl and 
							   mp.empresa            = c.empresa
   				inner join parElementoCatalogo cat 
							on cat.codigo			= mp.tipoParametro       and 
							   cat.idcatalogo       = 6  
				inner join parElementoCatalogo cath 
							on cath.codigo			= c.horaControl          and 
							   cath.idcatalogo      = 9  
			WHERE 
				mp.tipoParametro		= @IdTipoParametro		     and
				c.fechaControl		  >=  @FechaInicio				 and 
				c.fechaControl		  <=  @FechaFin					 and  	
				c.empresa	          =   @Empresa				     and 
				c.estado			  NOT IN ('ANU')
			GROUP BY c.fechaControl,			c.division  , 
					 c.zona,					c.camaronera, 
					 c.sector,				    d.idPiscina , 
					 dv.idParametroControl,     mp.nombre   ,
					 cat.codigo   ,             cat.Nombre  ,
					 c.horaControl ,            cath.Nombre 
		) AS toma_control

 

		select  za.nombre as ZonaNombre, 
				ca.nombre as CamaroneraNombre, 
				se.nombre as NombreSector, 
				c.fechaControl as FechaControl, 
				c.IdTipoParametro,			c.NombreTipoParametro,	
				c.horaControl,				c.NombreHoraControl,	
				COALESCE(max(c.conteoParametroAgrupado),'') as conteoParametroAgrupado 
			into #temp_ambientales
				from #tomaControl c 
					inner join maePiscina p on c.idPiscina = p.idPiscina
					inner join parCamaronera ca on ca.codigo = p.camaronera and ca.idZona = p.zona 
					inner join parSector se on se.codigo = p.sector and ca.idCamaronera =  se.idCamaronera
					inner join parZona za on za.codigo =   ca.idZona 
				where IdTipoParametro		= @IdTipoParametro 
					and p.sector     = ISNULL(@Codigosector,p.sector)
					and p.camaronera = ISNULL(@codigocamaronera,p.camaronera)
					and p.zona       = ISNULL(@codigozona,p.zona)
			  group by za.nombre ,ca.nombre, se.nombre, c.fechaControl , c.IdTipoParametro, c.NombreTipoParametro,	
				c.horaControl,				c.NombreHoraControl 	

 

		-----------pivot foramcion de columnas----------------- 
		if(@ColumnToPivot=  'NombreHoraControl')
		begin 
		 insert into #ColumnsPivot
			SELECT DISTINCT 
					nombre 
			from parElementoCatalogo
			WHERE idcatalogo      = 9  AND ACTIVO = 1 AND EMPRESA='01'
		end
		-----------pivot foramcion de columnas----------------- 
		SELECT  @ListToPivot = COALESCE(''+@ListToPivot + ',', '') +'[' + nombre +']' from #ColumnsPivot
		--SELECT  @ListToPivot 
		
		DECLARE @SqlStatement  NVARCHAR(MAX)--Query dinamico
		SET @SqlStatement = N'
			SELECT * 
			  into  ##temp_ambientales_horas
			FROM ( 
					  SELECT
								ZonaNombre,
								CamaroneraNombre,
								NombreSector, 
								FechaControl, 
								NombreHoraControl, 
								conteoParametroAgrupado 
					  FROM		tempdb..#temp_ambientales
			) ParametroAmbientalesResults
			PIVOT (
			  MAX([conteoParametroAgrupado])
			  FOR ['+@ColumnToPivot+']
			  IN (
				'+@ListToPivot+'
			  )
			) AS PivotTable
		  ';
		   
		EXEC(@SqlStatement) 

		DECLARE @TableName NVARCHAR(MAX);
		DECLARE @ColumnName NVARCHAR(MAX);
		DECLARE @ColumnList NVARCHAR(MAX);

		-- Set the name of your global temporary table
		SET @TableName = '##temp_ambientales_horas';

		-- Initialize the SQL statement
		SET @SqlStatement = '';

		-- Retrieve the column names of the temporary table
		SELECT @ColumnList = STRING_AGG(
			'COALESCE(CAST([' + COLUMN_NAME + '] AS NVARCHAR(MAX)), '''') AS [' + COLUMN_NAME + ']', ', ')
		FROM tempdb.INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = '##temp_ambientales_horas';

		-- Construct the dynamic SQL to select all columns with COALESCE to replace NULLs
		SET @SqlStatement = 'SELECT ' + @ColumnList + ' FROM ' + @TableName;

		-- Print the dynamic SQL statement for debugging purposes (optional)
		PRINT @SqlStatement;

		-- Execute the dynamic SQL statement
		EXEC sp_executesql @SqlStatement;