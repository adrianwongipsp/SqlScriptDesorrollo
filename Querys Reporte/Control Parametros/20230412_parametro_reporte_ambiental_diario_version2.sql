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
SET @ColumnToPivot    =  'Parametro'--'NombreHoraControl'
SET @Empresa          =   '01' 
SET @FechaInicio      =   '2024-09-01 00:00:00.000'
SET @FechaFin         =   '2024-09-15 23:59:59.000'
SET @VerDetalle       =  1
----------------------VALORES OPCIONALES---------------------------
SET @NombrePiscina    =   null
SET @codigocamaronera =   '00001' --TAURA A
SET @Codigosector     =   null --'00001'
SET @codigozona       =   '01'    --TAURA  
SET @IdTipoParametro  =   '002'   --TABLA DE CATALOGO (AMBIENTALES)
 
	if object_id('tempdb..#tomaControl') is not null
		drop table #tomaControl

	if object_id('tempdb..#temp_ambientales') is not null
		drop table #temp_ambientales

	if object_id('tempdb..#ColumnsPivot') is not null
		drop table #ColumnsPivot

	if object_id('tempdb..#temp_no_ambientales') is not null
		drop table #temp_no_ambientales	 

	 
	 create table #ColumnsPivot(
		nombre varchar(200)
	)

	SELECT  *
	  INTO  #tomaControl
	  FROM
	  (
			SELECT  c.fechaControl,								c.division  , 
					c.zona,										c.camaronera, 
					c.sector,									d.idPiscina , 
					ejv.Ciclo,									ejv.rolPiscina, 
					ejv.estado,
					dv.idParametroControl,						mp.nombre   ,   
					idCualidad,								    mpc.cualidad,	
					cat.codigo  as IdTipoParametro,				cat.Nombre as NombreTipoParametro,
					c.horaControl ,                             cath.Nombre as NombreHoraControl  ,
					min(mpc.cualidad) conteoParametroAgrupado
			FROM proControlParametro c
				inner join proControlParametroDetalle d
							on c.idControlParametro = d.idControlParametro
				inner join proControlParametroValorDetalle dv 
							on dv.idControlParametroDetalle = d.idControlParametroDetalle
				inner join maeParametroControl mp  
							on mp.idParametroControl = dv.idParametroControl and 
							   mp.empresa            = c.empresa
				inner join maeParametroControlCualidad mpc 
							on mpc.idParametroControl        = dv.idParametroControl and 
							   mpc.idParametroControlDetalle = idCualidad
			   inner join parElementoCatalogo cat 
						 on cat.codigo           = mp.tipoParametro and 
							cat.idcatalogo       =  6 
			   inner join parElementoCatalogo cath 
						 on cath.codigo			 = c.horaControl          and 
							cath.idcatalogo      = 9  
			    inner join EjecucionesPiscinaView ejv on ejv.idPiscina = d.idPiscina and 
							ejv.idPiscinaEjecucion = d.idPiscinaEjecucion
			WHERE  			
				
			    mp.tipoParametro	  = @IdTipoParametro             and
				c.fechaControl		  >=  @FechaInicio				 and 
				c.fechaControl		  <=  @FechaFin					 and  
				c.empresa	          =    @Empresa				     and 
				c.estado			  NOT IN ('ANU')				 and
				d.activo			  = 1
			GROUP BY c.fechaControl,			c.division  , 
					 c.zona,					c.camaronera, 
					 c.sector,				    d.idPiscina , 
					 dv.idParametroControl,     mp.nombre   ,
					 idCualidad ,				mpc.cualidad,
					 cat.codigo,				cat.Nombre  ,
					 c.horaControl ,            cath.Nombre ,
					 ejv.Ciclo,                 ejv.rolPiscina, 
					 ejv.estado
					 
	UNION ALL

			SELECT  c.fechaControl,							c.division  , 
					c.zona,								    c.camaronera, 
					c.sector,							    d.idPiscina , 
					ejv.Ciclo,                              ejv.rolPiscina, 
					ejv.estado,
					dv.idParametroControl,					mp.nombre   ,  
					0 idCualidad,							'' cualidad,	
					cat.codigo  as IdTipoParametro,			cat.Nombre as NombreTipoParametro ,
					c.horaControl ,                         cath.Nombre as NombreHoraControl  ,
					cast(round(avg(dv.valor), 2) as varchar(20)) conteoParametroAgrupado
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
				inner join EjecucionesPiscinaView ejv on ejv.idPiscina = d.idPiscina and 
											ejv.idPiscinaEjecucion = d.idPiscinaEjecucion
			WHERE 
				mp.tipoParametro	  = @IdTipoParametro             and
				c.fechaControl		  >=  @FechaInicio				 and 
				c.fechaControl		  <=  @FechaFin					 and  	
				c.empresa	          =   @Empresa				     and 
				c.estado			  NOT IN ('ANU')				 and
				d.activo			  = 1
			GROUP BY c.fechaControl,			c.division  , 
					 c.zona,					c.camaronera, 
					 c.sector,				    d.idPiscina , 
					 dv.idParametroControl,     mp.nombre   ,
					 cat.codigo   ,             cat.Nombre  ,
					 c.horaControl ,            cath.Nombre ,
					 ejv.Ciclo,                 ejv.rolPiscina, 
					 ejv.estado
		) AS toma_control



select  za.nombre as ZonaNombre, 
		ca.nombre as CamaroneraNombre, 
		se.nombre as NombreSector, 
		p.nombre as PiscinaNombre,
		c.Ciclo, c.estado AS EstadoPiscina,
		c.rolPiscina AS rolPiscina,
		c.fechaControl,				c.division,	
		c.zona,						c.camaronera,	
		c.sector,					c.idPiscina,	
		c.idParametroControl,		c.nombre as Parametro,	
		c.idCualidad,				c.cualidad,	
		c.IdTipoParametro,			c.NombreTipoParametro,	
		c.horaControl,				c.NombreHoraControl,	
		c.conteoParametroAgrupado,  
		cast(0.000 as Decimal) as Peso 

	into #temp_ambientales
		from #tomaControl c 
			inner join maePiscina p on c.idPiscina = p.idPiscina
			inner join parCamaronera ca on ca.codigo = p.camaronera and ca.idZona = p.zona 
			inner join parSector se on se.codigo = p.sector and ca.idCamaronera =  se.idCamaronera
			inner join parZona za on za.codigo =   ca.idZona 
		where IdTipoParametro		= @IdTipoParametro
			--and idParametroControl  IN (1,3,5)   
			and p.nombre	 = ISNULL(@NombrePiscina,p.nombre)
			and p.sector     = ISNULL(@Codigosector,p.sector)
			and p.camaronera = ISNULL(@codigocamaronera,p.camaronera)
			and p.zona       = ISNULL(@codigozona,p.zona)

	

		if(@ColumnToPivot =  'Parametro')
		begin
		  insert into #ColumnsPivot
			SELECT DISTINCT 
					nombre 
			from maeParametroControl
			WHERE tipoParametro=  @IdTipoParametro and  ACTIVO = 1 AND EMPRESA='01'
		end

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
			FROM ( 
					  SELECT
								ZonaNombre,
								CamaroneraNombre,
								NombreSector,
								PiscinaNombre,
								Ciclo, 
								EstadoPiscina,
								RolPiscina,
								Peso,
								fechaControl,
								NombreHoraControl,
								Parametro,
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
		   
   exec (@SqlStatement)

	IF(@VerDetalle = 1)
	BEGIN
		select  za.nombre as ZonaNombre, 
				ca.nombre as CamaroneraNombre, 
				se.nombre as NombreSector, 
				p.nombre as PiscinaNombre,
				c.fechaControl,				c.division,	
				c.zona,						c.camaronera,	
				c.sector,					c.idPiscina,	
				c.idParametroControl,		c.nombre as Parametro,	
				c.idCualidad,				c.cualidad,	
				c.IdTipoParametro,			c.NombreTipoParametro,	
				c.horaControl,				c.NombreHoraControl,	
				c.conteoParametroAgrupado
		into #temp_no_ambientales
			from #tomaControl c 
				inner join maePiscina p on c.idPiscina = p.idPiscina
				inner join parCamaronera ca on ca.codigo = p.camaronera and ca.idZona = p.zona 
				inner join parSector se on se.codigo = p.sector and ca.idCamaronera =  se.idCamaronera
				inner join parZona za on za.codigo =   ca.idZona 
			where IdTipoParametro		not in( @IdTipoParametro) 
				and p.nombre	 = ISNULL(@NombrePiscina,p.nombre)
			    --and p.sector     = ISNULL(@Codigosector,p.sector)
				and p.camaronera = ISNULL(@codigocamaronera,p.camaronera)
				and p.zona       = ISNULL(@codigozona,p.zona)
	END

 