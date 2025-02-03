--EXEC SP_GetDatosTransferenciaZona @zona = '01'  
  
create OR ALTER procedure [dbo].[SP_GetDatosTransferenciaZona]    
 @zona varchar(10) = null    
as    
begin    
---------------------variable codigo de zona (insigne)------------------------------------    
---------------------parametro de entrada (nullable)--------------------------------------    
--declare @zona varchar(10) = '01'    
IF(COALESCE(@zona,'') = '')  
BEGIN  
 SET @zona = null  
END  
--------------------objetos temporales----------------------------------------------------    
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatoSDestinoTrans') IS NOT NULL    
 drop table #ProcesamientoInicialDatoSDestinoTrans    
    
IF OBJECT_ID('tempdb..#ProcesamientoInicialDatosOrigenTrans') IS NOT NULL    
 drop table #ProcesamientoInicialDatosOrigenTrans    
    
    
IF OBJECT_ID('tempdb..#PresentacionDatoSiembra') IS NOT NULL    
 drop table #PresentacionDatoSiembra    
    
IF OBJECT_ID('tempdb..#zonas') IS NOT NULL    
 drop table #zonas     
    
IF OBJECT_ID('tempdb..#zonasDestino') IS NOT NULL    
 drop table #zonasDestino     
    
IF OBJECT_ID('tempdb..#piscinas') IS NOT NULL    
 drop table #piscinas     
   
 --------------------procesamiento de data origen--------------------------------------------------------------------------------------------------------------  
select  zo.codigo CodigoZona, zo.nombre as Zona, ca.codigo as CodigoCamaronera , ca.nombre as Camaronera, se.codigo as CodigoSector,  se.nombre as Sector    
 into #zonas    
  from  parZona zo    
   inner join parCamaronera        ca on zo.idZona       = ca.idZona    
   inner join parSector            se on ca.idCamaronera = se.idCamaronera     
where  zo.codigo   = coalesce(@zona, zo.codigo)    
  
--se usa para destino y orifgen  
select pis.idPiscina, pis.nombre , pis.superficieValor, pis.profundidadValor, pis.zona, pis.camaronera, pis.sector    
 into #piscinas     
 from maePiscina pis   
-- where exists     
-- (select 1 from #zonas zo where zo.CodigoZona       = pis.zona         and zo.CodigoCamaronera   = pis.camaronera and zo.CodigoSector = pis.sector)    
  
  
select   
    tra.fechaTransferencia as FechaTransferencia,  
    zo.Zona as ZonaOrigen,   
 zo.Camaronera as CamaroneraOrigen,   
 zo.Sector as SectorOrigen,     
    pis.nombre as PiscinaOrigen,     
 pej.ciclo as CicloOrigen,      
    ec.nombre as RolOrigen,    
    CASE     
    WHEN pej.Estado = 'INI' THEN 'INCIADO'    
    WHEN pej.Estado = 'EJE' THEN 'EJECUCIÓN'    
    WHEN pej.Estado = 'PRE' THEN 'PRECERRADO'    
    WHEN pej.Estado = 'CER' THEN 'CERRADO'    
    ELSE pej.Estado    
    END AS Estado,    
    pis.superficieValor as HectareaOrigen,    
 pej.fechaSiembra,  
 pej.cantidadEntrada as CantidadSembrada,     
    cast((pej.cantidadEntrada / pis.superficieValor) as int) Densidad,   
    coalesce(SUM(coalesce(1 / red.plGramoCam, 0) * coalesce(red.cantidadRecibida, 0)) / NULLIF(SUM(coalesce(red.cantidadRecibida, 0)), 0),0) AS PesoSiembra,    
    case   
   when tra.esTotal=0 then 'PARCIAL'  
   when tra.esTotal=1 then 'TOTAL'  
 ELSE ''  
 END AS EstatusTransfrencia,  
 tra.guiaTransferencia as GuiaTransferencia,  
 tra.tipoTransferencia as TipoTransferencia,   
    pej.idPiscinaEjecucion ,  
 tra.idTransferencia  ,  
 tra.secuencia  
into #ProcesamientoInicialDatosOrigenTrans    
 from #zonas zo    
   inner join #piscinas     pis on zo.CodigoZona       = pis.zona         and zo.CodigoCamaronera   = pis.camaronera and zo.CodigoSector = pis.sector    
   inner join proPiscinaEjecucion pej on pis.idPiscina   = pej.idPiscina    
   inner join parElementoCatalogo ec  on ec.codigo       = pej.rolPiscina   and ec.idCatalogo = 5    
   inner join proTransferenciaEspecie  tra on tra.idPiscinaEjecucion = pej.idPiscinaEjecucion  and tra.estado='APR'   
   left join proRecepcionEspecieDetalle red on  red.idPiscinaEjecucion = pej.idPiscinaEjecucion     
   left join proRecepcionEspecie         re on red.idRecepcion = re.idRecepcion and re.estado='APR'    
 where pej.estado in ('INI','EJE','PRE','CER')    
group by zo.Zona,       zo.Camaronera,        zo.Sector,      pis.nombre ,            ec.nombre,       pej.estado,         pis.superficieValor, pis.profundidadValor ,    
          pej.fechaInicio, pej.fechaSiembra, pej.ciclo,        pej.idPiscinaEjecucion, pej.fechaCierre, pej.cantidadEntrada, pej.cantidadSalida, pej.cantidadAdicional , tra.fechaTransferencia,  
    tra.esTotal, tra.guiaTransferencia, tra.tipoTransferencia,  tra.idTransferencia, tra.secuencia  
    
  
  
   
  
--------------------procesamiento de data destino--------------------------------------------------------------------------------------------------------------  
select  zo.codigo CodigoZona, zo.nombre as Zona, ca.codigo as CodigoCamaronera , ca.nombre as Camaronera, se.codigo as CodigoSector,  se.nombre as Sector    
 into #zonasDestino    
  from  parZona zo    
   inner join parCamaronera        ca on zo.idZona       = ca.idZona    
   inner join parSector            se on ca.idCamaronera = se.idCamaronera     
--where  zo.codigo   = coalesce(@zona, zo.codigo)    
    
  
--------------------tablas de  transferencias destino--------------------------------------------------------------------------------------------------------  
SELECT  
  zo.Zona       as ZonaDestino,   
  zo.Camaronera as CamaroneraDestino,   
  zo.Sector  as SectorDestino,     
  pis.nombre as PiscinaDestino,     
  pej.ciclo  as CicloDestino,   
  ec.nombre  as RolDestino,    
   trad.cantidadTransferida as CantidadTransferida,  
   trad.pesoPromedioTransferencia as PesoTransferido ,    
  isnull(trad.pesoDeclaradoTransferido,0)  as PesoReal,  
   trad.librasDeclaradas    as LibrasTransferida ,   
  CASE
        WHEN cantidadEntrada > 0 THEN (((cantidadEntrada - cantidadSalida) * 100.0) / cantidadEntrada)
        ELSE 0
    END AS Supervivencia,
 trad.idTransferenciaDetalle,  
 trad.idTransferencia  
 INTO #ProcesamientoInicialDatoSDestinoTrans    
 FROM #zonasDestino zo    
   inner join #piscinas     pis on zo.CodigoZona       = pis.zona         and zo.CodigoCamaronera   = pis.camaronera and zo.CodigoSector = pis.sector    
   inner join proPiscinaEjecucion pej on pis.idPiscina   = pej.idPiscina    
   inner join parElementoCatalogo ec  on ec.codigo       = pej.rolPiscina   and ec.idCatalogo = 5     
   inner join proTransferenciaEspecieDetalle  trad on trad.idPiscinaEjecucion = pej.idPiscinaEjecucion    
   inner join proTransferenciaEspecie         tra on tra.idTransferencia = trad.idTransferencia  and tra.estado='APR'      
 where pej.estado in ('INI','EJE','PRE','CER')    and  
       exists (  
  select  top 1 1 from #ProcesamientoInicialDatosOrigenTrans o where o.idTransferencia = tra.idTransferencia  
    )  
   
 select   
        --secuencia,   
  FechaTransferencia, ZonaOrigen,    CamaroneraOrigen, SectorOrigen,         PiscinaOrigen,   
        CicloOrigen,      RolOrigen,    Estado,            HectareaOrigen,      fechaSiembra,  
  CantidadSembrada, Densidad,    PesoSiembra,      EstatusTransfrencia, GuiaTransferencia, TipoTransferencia ,  
  ZonaDestino,     CamaroneraDestino,  SectorDestino,  PiscinaDestino,   CicloDestino,   
  RolDestino,   CantidadTransferida, PesoTransferido, PesoReal,    LibrasTransferida, Supervivencia  
 from #ProcesamientoInicialDatosOrigenTrans o inner join #ProcesamientoInicialDatoSDestinoTrans d on o.idTransferencia = d.idTransferencia  
 ---------------------------------------------------------------------------------------------------------------------------------------------------------    
     
    
end  