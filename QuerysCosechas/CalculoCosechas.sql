

select * from proPiscinaEjecucion
where idPiscinaEjecucion = 3551

select pc.idPiscinaEjecucion, pe.cantidadEntrada, pe.cantidadSalida, pe.cantidadPerdida, sum(cantidadCosechada) as cantidadSalidaNueva , cantidadEntrada - sum(cantidadCosechada) as mortalidad
into #recalculoEjecucion
from proPiscinaCosecha pc
 inner join proPiscinaEjecucion pe on pc.idPiscinaEjecucion = pe.idPiscinaEjecucion
where pc.estado = 'APR' and pc.idPiscinaEjecucion = 3551
group by pc.idPiscinaEjecucion, cantidadEntrada, cantidadPerdida, cantidadSalida



--begin tran
--updedate pe
--set pe.cantidadSalida = r.cantidadSalidaNueva,
--	pe.cantidadPerdida = r.mortalidad
--	from proPiscinaEjecucion as pe
--	inner join #recalculoEjecucion r on pe.idPiscinaEjecucion = r.idPiscinaEjecucion
--	--where pe.idPiscinaEjecucion = (select idPiscinaEjecucion from #recalculoEjecucion)
	
--	select * from proPiscinaEjecucion
--	where idPiscinaEjecucion = 462

--rollback




select pc.idPiscinaEjecucion, pe.cantidadEntrada, pe.cantidadSalida, pe.cantidadPerdida, sum(cantidadCosechada) as cantidadSalidaNueva , cantidadEntrada - sum(cantidadCosechada) as mortalidad
--into #recalculoEjecucion
from proPiscinaCosecha pc
 inner join proPiscinaEjecucion pe on pc.idPiscinaEjecucion = pe.idPiscinaEjecucion
where pc.estado = 'APR' and pc.idPiscinaEjecucion = 3551
group by pc.idPiscinaEjecucion, cantidadEntrada, cantidadPerdida, cantidadSalida



select pc.* from proPiscinaCosecha pc
 inner join proPiscinaEjecucion pe on pc.idPiscinaEjecucion = pe.idPiscinaEjecucion
where pc.estado = 'APR' and pc.idPiscinaEjecucion = 3551
--group by pc.idPiscinaEjecucion, cantidadEntrada, cantidadPerdida, cantidadSalida


select * from audit_proPiscinaCosecha
where idPiscinaCosecha = 3127


