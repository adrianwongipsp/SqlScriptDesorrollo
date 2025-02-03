

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

