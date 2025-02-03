--EXEC SP_GetDatosSiembraZona_Multiple @zona = null

create procedure SP_GetDatosSiembraZona  
 @zona varchar(10) = null  
as  
begin  
---------------------variable codigo de zona (insigne)------------------------------------  
---------------------parametro de entrada (nullable)--------------------------------------  
-- declare @zona varchar(10) = null  
IF(COALESCE(@zona,'') = '')
BEGIN
	SET @zona = null
END
--------------------objetos temporales----------------------------------------------------  
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatoSiembra') IS NOT NULL  
 drop table #ProcesamientoInicialDatoSiembra  
  
IF OBJECT_ID('tempdb..#PresentacionDatoSiembra') IS NOT NULL  
 drop table #PresentacionDatoSiembra  
  
IF OBJECT_ID('tempdb..#zonas') IS NOT NULL  
 drop table #zonas   
  
IF OBJECT_ID('tempdb..#piscinas') IS NOT NULL  
 drop table #piscinas   
  
--------------------procesamiento de data ------------------------------------------------------------------------------------------------------  
select  zo.codigo CodigoZona, zo.nombre as Zona, ca.codigo as CodigoCamaronera , ca.nombre as Camaronera, se.codigo as CodigoSector,  se.nombre as Sector  
 into #zonas  
  from  parZona zo  
   inner join parCamaronera        ca on zo.idZona       = ca.idZona  
   inner join parSector            se on ca.idCamaronera = se.idCamaronera   
where  zo.codigo   = coalesce(@zona, zo.codigo)  
  
select pis.idPiscina, pis.nombre , pis.superficieValor, pis.profundidadValor, pis.zona, pis.camaronera, pis.sector  
 into #piscinas   
 from maePiscina pis where exists   
(select 1 from #zonas zo where zo.CodigoZona       = pis.zona         and zo.CodigoCamaronera   = pis.camaronera and zo.CodigoSector = pis.sector)  
--------------------tablas de ejecuciones, recepciones y transferencias--------------------------------------------------------------------------  
select zo.Zona, zo.Camaronera, zo.Sector,   
     pis.nombre as Piscina,   
     ec.nombre as Rol,  
  pej.estado as Estado,  
  pis.superficieValor as Hectarea,  
  pis.profundidadValor as Profundidad,  
  DATEDIFF(DAY, pej.fechaInicio, pej.fechaSiembra) AS DiasSeco,  
  COALESCE(COALESCE(MAX(re.idEspecie),MAX(tra.idEspecie)),NULL) as idEspecie,  
  pej.ciclo as Ciclo,    
  pej.fechaSiembra as FechaSiembra,   
  COALESCE(convert(varchar(10), pej.fechaCierre,103 ) ,' ') as FechaCierre,   
  pej.fechaInicio as FechaInicioSecado,    
  pej.cantidadEntrada as CantidadRecibida,   
  coalesce(SUM(coalesce(1 / red.plGramoCam, 0) * coalesce(red.cantidadRecibida, 0)) / NULLIF(SUM(coalesce(red.cantidadRecibida, 0)), 0),0) AS PesoSiembra,  
  MAX(coalesce(trad.tipoTransferencia,'')) as TipoTransferencia,  
  coalesce(SUM(coalesce(trad.pesoPromedioTransferencia, 0) * coalesce(trad.cantidadTransferida, 0)) / NULLIF(SUM(coalesce(trad.cantidadTransferida, 0)), 0),0) AS PesoTransferido,  
  (((cantidadEntrada-cantidadSalida)*100)/cantidadEntrada) Supervivencia,  
  SUM(coalesce(trad.librasDeclaradas,0)) as LibrasTransferidas,  
  MAX(re.idLaboratorio) as idLaboratorio,   
  MAX(re.idLaboratorioLarva) as idLaboratorioLarva,  
  MAX(red.idLaboratorioMaduracion) as idLaboratorioMaduracion,   
  MAX(red.idCodigoGenetico) as idCodigoGenetico,  
  pej.cantidadAdicional as CantidadAdicional,  
  SUM(coalesce(trad.cantidadDeclarada,0)) as CantidadReal,   
  pej.idPiscinaEjecucion  
into #ProcesamientoInicialDatoSiembra  
 from #zonas zo  
   inner join #piscinas     pis on zo.CodigoZona       = pis.zona         and zo.CodigoCamaronera   = pis.camaronera and zo.CodigoSector = pis.sector  
   inner join proPiscinaEjecucion pej on pis.idPiscina   = pej.idPiscina  
   inner join parElementoCatalogo ec  on ec.codigo       = pej.rolPiscina   and ec.idCatalogo = 5  
  
   left join proRecepcionEspecieDetalle red on  red.idPiscinaEjecucion = pej.idPiscinaEjecucion   
   left join proRecepcionEspecie         re on red.idRecepcion = re.idRecepcion and re.estado='APR'  
  
   left join proTransferenciaEspecieDetalle trad on trad.idPiscinaEjecucion = pej.idPiscinaEjecucion  
   left join proTransferenciaEspecie         tra on tra.idTransferencia = trad.idTransferencia  and tra.estado='APR'  
  
 where pej.estado in ('INI','EJE','PRE','CER')  
    
  
group by  zo.Zona,       zo.Camaronera,        zo.Sector,      pis.nombre ,            ec.nombre,       pej.estado,         pis.superficieValor, pis.profundidadValor ,  
          pej.fechaInicio, pej.fechaSiembra, pej.ciclo,        pej.idPiscinaEjecucion, pej.fechaCierre, pej.cantidadEntrada, pej.cantidadSalida, pej.cantidadAdicional  
  
------------------------------------------------------Eleboracion de presentacion de data--------------------------------------------------------------------------------  
------------------------------------------------------se complementa con los campos finales y auxiliares-----------------------------------------------------------------  
  
  select pds.Zona,                pds.Camaronera,         
   pds.Sector,                pds.Piscina,          
   pds.Rol,                   
   CASE   
   WHEN pds.Estado = 'INI' THEN 'INCIADO'  
   WHEN pds.Estado = 'EJE' THEN 'EJECUCIÓN'  
   WHEN pds.Estado = 'PRE' THEN 'PRECERRADO'  
   WHEN pds.Estado = 'CER' THEN 'CERRADO'  
   ELSE pds.Estado  
   END AS Estado,  
   pds.Hectarea,               pds.Profundidad,        
   pds.DiasSeco,               coalesce(esp.nombre,'') as TipoCultivo,    
   pds.Ciclo,                pds.FechaSiembra,  
   pds.FechaCierre  as FechaPesca ,          pds.FechaInicioSecado,       
   DATEADD(day, -1, pds.FechaInicioSecado) as TerminoSecado   ,   pds.CantidadRecibida  as CantidadSembrada,    
   cast((pds.CantidadRecibida / pds.Hectarea)as int) as Densidad ,   pds.PesoSiembra ,  
   coalesce(tt.nombre,'') as TipoTranferencia,          
   pds.PesoTransferido,                pds.Supervivencia,  
   (100 - pds.Supervivencia) as Mortalidad,        pds.LibrasTransferidas,  
   coalesce(lab.razonComercial,'') as ProcedenciaLaboratorio,          coalesce(cg.nombre,'') AS Linea,  
   coalesce(labm.razonComercial,'') as Maduracion,                  (pds.CantidadRecibida +  pds.CantidadAdicional) CantidadConPlus,  
   pds.CantidadReal    
   into #PresentacionDatoSiembra  
  from #ProcesamientoInicialDatoSiembra pds    
  LEFT JOIN maeEspecie           esp on esp.idEspecie           = pds.idEspecie  
  LEFT JOIN maeTipoTransferencia  tt on tt.idTipoTransferencia  = pds.TipoTransferencia  
  left join maeLaboratorioMarca  lab on lab.idLaboratorio       = pds.idLaboratorio         and lab.idLaboratorioMarca = pds.idLaboratorioLarva  
  left join maeCodigoGenetico     cg on cg.idCodigoGenetico     = pds.idCodigoGenetico    
  left join maeLaboratorioMarca labm on labm.idLaboratorioMarca = pds.idLaboratorioMaduracion  
---------------------------------------------------------------------------------------------------------------------------------------------------------    
   
  
 ----------------------------------------------------------------Resulados ordenados----------------------------------------------------------------------  
  select *   
  from  #PresentacionDatoSiembra   
  order by Zona,    Camaronera, Sector,   
           Piscina, Ciclo  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------  
   
  
end