--EXEC SP_GetDatosSiembraZona_Multiple @zona = null

create procedure SP_GetDatosSiembraZona_Multiple
 	@zona varchar(10) = null
as
begin
---------------------variable codigo de zona (insigne)----------------------------------------------------------------------------------------------------------
---------------------parametro de entrada (nullable)------------------------------------------------------------------------------------------------------------
 --declare @zona varchar(10) = null
 --set     @zona = null
IF(COALESCE(@zona,'') = '')
BEGIN
	SET @zona = null
END
--------------------validación de objetos temporales------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatoSiembra') IS NOT NULL
	drop table #ProcesamientoInicialDatoSiembra

IF OBJECT_ID('tempdb..#PresentacionDatoSiembra') IS NOT NULL
	drop table #PresentacionDatoSiembra

IF OBJECT_ID('tempdb..#zonas') IS NOT NULL
	drop table #zonas	

IF OBJECT_ID('tempdb..#piscinas') IS NOT NULL
	drop table #piscinas	

IF OBJECT_ID('tempdb..#laboratorioMarca') IS NOT NULL
	drop table #laboratorioMarca	

IF OBJECT_ID('tempdb..#codigoGenetico') IS NOT NULL
	drop table #codigoGenetico

IF OBJECT_ID('tempdb..#tipoTransferencia') IS NOT NULL
	drop table #tipoTransferencia
	 
--------------------procesamiento de data --------------------------------------------------------------------------------------------------------
--------------------(1) Generacion de  data - tabla temporales -----------------------------------------------------------------------------------
--------------------(1.1) Tabla zona -------------------------------------------------------------------------------------------------------------
	select
		zo.codigo as CodigoZona,       zo.nombre as Zona, 
	    ca.codigo as CodigoCamaronera, ca.nombre as Camaronera, 
		se.codigo as CodigoSector,     se.nombre as Sector
	into #zonas
		from  parZona zo
			inner join parCamaronera ca on zo.idZona       = ca.idZona
			inner join parSector     se on ca.idCamaronera = se.idCamaronera 
        where  zo.codigo   = coalesce(@zona, zo.codigo)

--------------------(1.2) Tabla piscina ------------------------------------------------------------------------------------------------------------
	select 
        pis.idPiscina,		  pis.nombre , 
		pis.superficieValor,  pis.profundidadValor, 
		pis.zona,             pis.camaronera, 
		pis.sector
	into #piscinas 
		from maePiscina pis 
		where exists (select 1 from #zonas zo where zo.CodigoZona       = pis.zona 
												and zo.CodigoCamaronera = pis.camaronera 
												and zo.CodigoSector     = pis.sector)
--------------------(1.3) Tabla Laboratorio Marca -----------------------------------------------------------------------------------------------------
 select 
		idLaboratorio,  idLaboratorioMarca, razonComercial  
   into #laboratorioMarca
 from maeLaboratorioMarca

 --------------------(1.4) Tabla Código Genetico -------------------------------------------------------------------------------------------------------
 select 
		idCodigoGenetico, nombre
   into #codigoGenetico
 from maeCodigoGenetico

 select idTipoTransferencia,	codigo,	nombre
	into #tipoTransferencia 
	 from maeTipoTransferencia


--------------------Tablas de ejecuciones, recepciones y transferencias---------------------------------------------------------------------------------------
--------------------Procesamiento de datos -------------------------------------------------------------------------------------------------------------------
	select  
			zo.Zona, 
			zo.Camaronera, 
			zo.Sector, 
			pis.nombre			 as Piscina, 
			ec.nombre			 as Rol,
			pej.estado			 as Estado,
			pis.superficieValor  as Hectarea,
			pis.profundidadValor as Profundidad,
			DATEDIFF(DAY, pej.fechaInicio, pej.fechaSiembra)			  as DiasSeco,
			COALESCE(COALESCE(MAX(re.idEspecie),MAX(tra.idEspecie)),NULL) as idEspecie,
			pej.ciclo            as Ciclo,  
			pej.fechaSiembra     as FechaSiembra, 
			COALESCE(convert(varchar(10), pej.fechaCierre,103 ) ,' ')     as FechaCierre, 
			pej.fechaInicio      as FechaInicioSecado,  
			pej.cantidadEntrada  as CantidadRecibida, 
			COALESCE(SUM(COALESCE(1 / red.plGramoCam, 0) 
							* COALESCE(red.cantidadRecibida, 0)) 
							/ NULLIF(SUM(coalesce(red.cantidadRecibida, 0)), 0),0)        as PesoSiembra,
			STRING_AGG(CONCAT(COALESCE(trad.tipoTransferencia, ''), ''), '|')		      as TipoTransferencia,
			COALESCE(SUM(COALESCE(trad.pesoPromedioTransferencia, 0) 
							* COALESCE(trad.cantidadTransferida, 0)) 
							/ NULLIF(SUM(COALESCE(trad.cantidadTransferida, 0)), 0),0)     as PesoTransferido,
			(((cantidadEntrada-cantidadSalida)*100)/cantidadEntrada)				       as Supervivencia,
			SUM(COALESCE(trad.librasDeclaradas,0))									       as LibrasTransferidas,
			STRING_AGG(COALESCE(CAST(re.idLaboratorio            AS VARCHAR(10)),''),'|')  as idLaboratorio, 
			STRING_AGG(COALESCE(CAST(re.idLaboratorioLarva       AS VARCHAR(10)),''),'|')  as idLaboratorioLarva,
			STRING_AGG(COALESCE(CAST(red.idLaboratorioMaduracion AS VARCHAR(10)),''),'|')  as idLaboratorioMaduracion,
			STRING_AGG(COALESCE(CAST(red.idCodigoGenetico        AS VARCHAR(10)),''),'|')  as idCodigoGenetico,
			pej.cantidadAdicional				    as CantidadAdicional,
			SUM(COALESCE(trad.cantidadDeclarada,0)) as CantidadReal, 
			pej.idPiscinaEjecucion
	into #ProcesamientoInicialDatoSiembra
		from	#zonas zo
				inner join #piscinas		   pis on zo.CodigoZona       = pis.zona         and zo.CodigoCamaronera = pis.camaronera and zo.CodigoSector = pis.sector
				inner join proPiscinaEjecucion pej on pis.idPiscina       = pej.idPiscina
				inner join parElementoCatalogo ec  on ec.codigo           = pej.rolPiscina   and ec.idCatalogo = 5

				left join proRecepcionEspecieDetalle red on  red.idPiscinaEjecucion      = pej.idPiscinaEjecucion 
				left join proRecepcionEspecie         re on red.idRecepcion              =   re.idRecepcion     and re.estado='APR'

				left join proTransferenciaEspecieDetalle trad on trad.idPiscinaEjecucion = pej.idPiscinaEjecucion
				left join proTransferenciaEspecie         tra on tra.idTransferencia     = trad.idTransferencia  and tra.estado='APR'

		where pej.estado in ('INI','EJE','PRE','CER') 
		group by  zo.Zona,          zo.Camaronera,       zo.Sector,           pis.nombre,            
				  ec.nombre,        pej.estado,          pis.superficieValor, pis.profundidadValor,
				  pej.fechaInicio,  pej.fechaSiembra,    pej.ciclo,           pej.idPiscinaEjecucion, 
				  pej.fechaCierre,  pej.cantidadEntrada, pej.cantidadSalida,  pej.cantidadAdicional
  
------------------------------------------------------Eleboracion de presentacion de data--------------------------------------------------------------------------------
------------------------------------------------------se complementa con los campos finales y auxiliares-----------------------------------------------------------------

	 select pds.Zona,														  
			pds.Camaronera,							
			pds.Sector,														  
			pds.Piscina,								
			pds.Rol,														   
			CASE 
				WHEN pds.Estado = 'INI' THEN 'INCIADO'
				WHEN pds.Estado = 'EJE' THEN 'EJECUCIÓN'
				WHEN pds.Estado = 'PRE' THEN 'PRECERRADO'
				WHEN pds.Estado = 'CER' THEN 'CERRADO'
				ELSE pds.Estado
			END as Estado,
			pds.Hectarea,													  
			pds.Profundidad,						
			pds.DiasSeco,													  
			COALESCE(esp.nombre,'') as TipoCultivo,		
			pds.Ciclo,														  
			pds.FechaSiembra,
			pds.FechaCierre         as FechaPesca,								      
			pds.FechaInicioSecado,					
			DATEADD(day, -1, pds.FechaInicioSecado)           as TerminoSecado,   
			pds.CantidadRecibida					          as CantidadSembrada,  
			CAST((pds.CantidadRecibida / pds.Hectarea)as int) as Densidad,	  
			pds.PesoSiembra,
			COALESCE(
				(select STRING_AGG(CONCAT(COALESCE(tt.nombre,''),''), '-') 
				 from  #tipoTransferencia tt
				 where tt.codigo in
						(select distinct cast(value as int) 
						   from string_split(pds.TipoTransferencia,'|') 
						   where value !='')), '')			  as TipoTranferencia,	
			pds.PesoTransferido,										      
			pds.Supervivencia,
			(100 - pds.Supervivencia)						  as Mortalidad,						  
			pds.LibrasTransferidas, 
			COALESCE(
				(select STRING_AGG(CONCAT(COALESCE(lab.razonComercial,''),''),'-') 
				 from #laboratorioMarca lab
				 where lab.idLaboratorioMarca in
						(select distinct cast(value as int) 
						  from string_split(pds.idLaboratorioLarva,'|')
						   where value !='')), '')				as ProcedenciaLaboratorio, 
			COALESCE(
				(select STRING_AGG(CONCAT(COALESCE(cg.nombre, ''), ''), '-') 
				 from #CodigoGenetico cg
				 where cg.idCodigoGenetico in
						(select distinct cast(value as int) 
						  from string_split(pds.idCodigoGenetico,'|') 
						  where value !='')), '')				as Linea,
            COALESCE(
				(select STRING_AGG(CONCAT(COALESCE(labm.razonComercial, ''), ''), '-') 
				 from #laboratorioMarca labm
				 where labm.idLaboratorioMarca in
						(select distinct cast(value as int) 
						  from string_split(pds.idLaboratorioMaduracion,'|') 
						  where value !='')) , '')				as Maduracion,      
			(pds.CantidadRecibida +  pds.CantidadAdicional)     as CantidadConPlus,
			pds.CantidadReal  
			into #PresentacionDatoSiembra
	 from #ProcesamientoInicialDatoSiembra pds  
	 LEFT JOIN maeEspecie           esp on esp.idEspecie           = pds.idEspecie
	 LEFT JOIN maeTipoTransferencia  tt on tt.idTipoTransferencia   in  (select distinct cast(value as int) from string_split(pds.TipoTransferencia,'|') where value !='')     
	 GROUP BY pds.Zona,				pds.Camaronera,        pds.Sector,           pds.Piscina,          
			  pds.Rol,				pds.Estado,            pds.Hectarea,         pds.Profundidad, 
			  pds.DiasSeco,			esp.nombre,		       pds.Ciclo,             pds.FechaSiembra, 
			  pds.FechaCierre,		pds.FechaInicioSecado, pds.CantidadRecibida, pds.Hectarea,
			  pds.PesoSiembra,		pds.PesoTransferido,   pds.Supervivencia,    pds.LibrasTransferidas,
			  pds.CantidadAdicional,pds.CantidadReal  ,    pds.idLaboratorioLarva, pds.idCodigoGenetico, pds.idLaboratorioMaduracion,pds.TipoTransferencia
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 ----------------------------------------------------------------Resulados ordenados--------------------------------------------------------------------------------------------------
	 select * 
	 from  #PresentacionDatoSiembra 
	 order by Zona,    
	          Camaronera,
			  Sector, 
	          Piscina, 
			  Ciclo
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
end