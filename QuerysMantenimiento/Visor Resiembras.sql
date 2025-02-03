use IPSPCamaroneraProduccion
go
--select * from PiscinaUbicacion where idPiscina = 1722
 declare @dias int
 set @dias =30 

 drop table if exists #temporalRecepcionEspecie
 drop table if exists #temporalTransferenciaEspecie
 drop table if exists #PiscinasEjecucion
 drop table if exists #PiscinasEjecucion_EST_EJECUCION
 drop table if exists #PiscinasEjecucion_EST_INICIADA
 drop table if exists #PiscinasEjecucion_final
 drop table if exists #temporalControlParametro
 drop table if exists #temporalMuestreoPeso

select  PU.nombreZona,         PU.nombreCamaronera,    
        PU.nombreSector,       rolPiscina,   
        PE.idPiscinaEjecucion, PE.idPiscina,   
        nombrePiscina,         PE.ciclo,
        fechaInicio,           fechaSiembra,           
		fechaCierre,           DATEDIFF(day, FECHASIEMBRA, GETDATE())  dias_sin_cerrar
INTO #PiscinasEjecucion
from proPiscinaEjecucion PE 
INNER JOIN PiscinaUbicacion PU ON PE.idPiscina = PU.idPiscina
where estado = 'EJE' AND (cantidadEntrada - cantidadSalida) > 0
and PE.activo = 1
AND    DATEDIFF(day, FECHASIEMBRA, GETDATE()) > @dias
order by 7

select r.fechaRecepcion, 
       r.secuencia , 
	   rd.idPiscina, 
	   rd.idPiscinaEjecucion 
	   into #temporalRecepcionEspecie
from proRecepcionEspecie r 
    inner join proRecepcionEspecieDetalle rd on r.idRecepcion          = rd.idRecepcion
	inner join #PiscinasEjecucion         pe on pe.idPiscinaEjecucion  = rd.idPiscinaEjecucion and pe.idPiscina = rd.idPiscina
where r.estado = 'APR' and rd.activo = 1

select r.fechaTransferencia, 
       r.secuencia , 
	   rd.idPiscina, 
	   rd.idPiscinaEjecucion 
	into #temporalTransferenciaEspecie
from proTransferenciaEspecie r 
    inner join proTransferenciaEspecieDetalle rd on r.idTransferencia          = rd.idTransferencia
	inner join #PiscinasEjecucion         pe on pe.idPiscinaEjecucion  = rd.idPiscinaEjecucion and pe.idPiscina = rd.idPiscina
where r.estado = 'APR' and rd.activo = 1


select 'EN EJECUCION'AS Estado, pe.*, 
(select COUNT(1) from #temporalRecepcionEspecie r where r.idPiscina = pe.idPiscina and  r.idPiscinaEjecucion = pe.idPiscinaEjecucion) as NumeroRecepcionIngreso,
(select STRING_AGG(CAST(secuencia as varchar(10)) + '(' +CAST(r.fechaRecepcion as varchar(10)) + ')', ', ')
	from #temporalRecepcionEspecie r where r.idPiscina = pe.idPiscina and  r.idPiscinaEjecucion = pe.idPiscinaEjecucion) as SecuenciasRecepcionIngreso,
(select COUNT(1) from #temporalTransferenciaEspecie r where r.idPiscina = pe.idPiscina and  r.idPiscinaEjecucion = pe.idPiscinaEjecucion) as NumeroTransferenciaIngreso,
(select STRING_AGG(CAST(secuencia as varchar(10)) + '(' +CAST(r.fechaTransferencia as varchar(10)) + ')', ', ')
	from #temporalTransferenciaEspecie r where r.idPiscina = pe.idPiscina and  r.idPiscinaEjecucion = pe.idPiscinaEjecucion) as SecuenciasTransferenciaIngreso
	INTO #PiscinasEjecucion_EST_EJECUCION
from
#PiscinasEjecucion pe
 
 select 'INICIADA'AS Estado,
        PU.nombreZona,         PU.nombreCamaronera,    
        PU.nombreSector,       rolPiscina,   
        PE.idPiscinaEjecucion, PE.idPiscina,   
        nombrePiscina,         PE.ciclo,
        fechaInicio,           fechaSiembra,           
		fechaCierre,           DATEDIFF(day, fechaInicio, GETDATE())  dias_sin_cerrar,
		0 NumeroRecepcionIngreso,	
		'' SecuenciasRecepcionIngreso,	
		0 NumeroTransferenciaIngreso,	
		'' SecuenciasTransferenciaIngreso
		INTO #PiscinasEjecucion_EST_INICIADA
from proPiscinaEjecucion PE 
INNER JOIN PiscinaUbicacion PU ON PE.idPiscina = PU.idPiscina
where estado IN( 'INI') AND (cantidadEntrada - cantidadSalida) = 0
and PE.activo = 1
AND    DATEDIFF(day, fechaInicio, GETDATE()) > @dias

SELECT PE.*
INTO #PiscinasEjecucion_final
from
(SELECT * FROM #PiscinasEjecucion_EST_EJECUCION
UNION
SELECT * FROM #PiscinasEjecucion_EST_INICIADA) as PE 


select cd.idPiscina, cd.idPiscinaEjecucion, c.fechaControl, c.secuencia, c.estado
INTO #temporalControlParametro
from proControlParametro c inner join proControlParametroDetalle cd on c.idControlParametro = cd.idControlParametro
									inner join  #PiscinasEjecucion_final  pf on pf.idPiscina = cd.idPiscina and pf.idPiscinaEjecucion = cd.idPiscinaEjecucion
									where cd.activo = 1 and c.estado in ('ING', 'APR')

select cd.idPiscina, cd.idPiscinaEjecucion, c.fechaMuestreo, c.secuencia, c.estado
INTO #temporalMuestreoPeso
from proMuestreoPeso c inner join proMuestreoPesoDetalle cd on c.idMuestreo = cd.idMuestreo
									inner join  #PiscinasEjecucion_final  pf on pf.idPiscina = cd.idPiscina and pf.idPiscinaEjecucion = cd.idPiscinaEjecucion
									where cd.activo = 1 and c.estado in ('ING', 'APR')


select pe.* , 
		(select COUNT(distinct secuencia) from #temporalControlParametro r where r.idPiscina = pe.idPiscina and  r.idPiscinaEjecucion = pe.idPiscinaEjecucion) as NumeroControlParametro,
		(select COUNT(distinct secuencia)  from #temporalMuestreoPeso r     where r.idPiscina = pe.idPiscina and  r.idPiscinaEjecucion = pe.idPiscinaEjecucion) as NumeroMuestreoPeso
from #PiscinasEjecucion_final pe
where Estado = 'EN EJECUCION' and nombreZona = 'CALIFORNIA'
order by 18 desc
 