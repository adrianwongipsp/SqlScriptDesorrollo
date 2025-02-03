--select * from proPiscinaEjecucion
--where idPiscinaEjecucion = 4138

--select * from EjecucionesPiscinaView
--where idPiscinaEjecucion in (4035,3514,3514,3574,3529,3830)

--select * from maePiscina
--where idPiscina = 1847

select idPiscinaOrigen, fechaInicio, fechaFin, idPlanificacionSiembra
into #piscinasPlanificadas
from proPlanificacionSiembraDetallePiscinaPorReceptar
where idPlanificacionSiembra = 244

select pu.nombreSector, pu.nombrePiscina, pr.cantidadTotal, PR.cantidadRecibida, PR.cantidadPendiente
--into #idPiscinaReceptar
from proPlanificacionSiembraPiscinaPorReceptar pr
inner join #piscinasPlanificadas pp on pr.idPiscinaOrigen = pp.idPiscinaOrigen and  pr.fechaInicio = pp.fechaInicio and pr.fechaFin = pp.fechaFin
inner join PiscinaUbicacion pu on pr.idPiscinaOrigen = pu.idPiscina
where idPiscinaPorReceptar = 2740

--select pu.nombreSector, pu.nombrePiscina, red.* from proRecepcionEspecieDetalle red
--inner join PiscinaUbicacion pu on red.idPiscina = pu.idPiscina
--where idPiscinaPlanificacion in (select idPiscinaPorReceptar from #idPiscinaReceptar)
--and idPiscinaPlanificacion = 2740

select pu.nombreSector, pu.nombrePiscina, SUM(cantidadRecibida) as CANTIDAD_RECEPTADA from proRecepcionEspecieDetalle red
inner join PiscinaUbicacion pu on red.idPiscina = pu.idPiscina
where idPiscinaPlanificacion = 2740
GROUP BY  pu.nombreSector, pu.nombrePiscina



select pu.nombreZona , pu.nombreSector, pur.nombrePiscina as PiscinaPlanificada,  pu.nombrePiscina as PiscinaReceptada, red.idPiscinaEjecucion,
red.cantidadRecibida,cantidadAdicional,  red.idRecepcion as NumeroRecepcion, re.fechaRecepcion, re.usuarioResponsable, 
re.usuarioCreacion, re.estacionCreacion,re.usuarioModificacion, re.estacionModificacion from proRecepcionEspecieDetalle red
inner join PiscinaUbicacion pu on red.idPiscina = pu.idPiscina 
inner join proPlanificacionSiembraPiscinaPorReceptar pspr on pspr.idPiscinaPorReceptar = red.idPiscinaPlanificacion
inner join PiscinaUbicacion pur on pspr.idPiscinaOrigen = pur.idPiscina 
inner join proRecepcionEspecie re on re.idRecepcion = red.idRecepcion
where --idRecepcion in (3334,3335)
 --and 
 idPiscinaPlanificacion in (2656,2657,2658)

 
select sum(red.cantidadRecibida) as cantidadReceptada  from proRecepcionEspecieDetalle red
--inner join proPlanificacionSiembraPiscinaPorReceptar pspr on pspr.idPiscinaPorReceptar = red.idPiscinaPlanificacion
where idPiscinaPlanificacion in (2656,2657,2658)
group by red.idPiscinaPlanificacion

 
select  pu.nombreZona , pu.nombreSector, pu.nombrePiscina as PiscinaPlanificada, cantidadTotal as cantidadPlanificada, cantidadRecibida, cantidadPendiente,
		fechaInicio, fechaFin
from proPlanificacionSiembraPiscinaPorReceptar ppr
inner join PiscinaUbicacion pu on ppr.idPiscinaOrigen = pu.idPiscina 
where fechaInicio = '2024-04-08' and fechaFin = '2024-04-14'
and 
idPiscinaOrigen in (1847,1848,1837)


