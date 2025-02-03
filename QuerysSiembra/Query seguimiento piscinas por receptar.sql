--Query planificación cabecera

select * from proPlanificacionSiembra
where secuencia = 244
-------------------------------------------------------------------------------------------------------
--query panificacion detalle
select * from proPlanificacionSiembraDetalle
where idPlanificacionSiembra = 244
-------------------------------------------------------------------------------------------------------
--query piscina detalle de piscinas
select  pu.nombrePiscina, psd.* from proPlanificacionSiembraDetallePiscina psd
inner join PiscinaUbicacion pu on psd.idPiscina = pu.idPiscina 
where idPlanificacionSiembraDetalle in (select idPlanificacionSiembraDetalle from proPlanificacionSiembraDetalle where idPlanificacionSiembra = 244)
-------------------------------------------------------------------------------------------------------

--query detalles de piscinas por receptar
SELECT P.nombre, c.idPiscinaPorReceptar, c.cantidadTotal, c.cantidadRecibida, c.cantidadPendiente, d.* FROM proPlanificacionSiembraPiscinaPorReceptar C
 INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
 ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
 INNER JOIN maePiscina P ON P.idPiscina = c.idPiscinaOrigen
WHERE  c.idPiscinaPorReceptar in (1847,1848,1837)
-------------------------------------------------------------------------------------------------------

--query detalles de piscinas por receptar por planificación
select pu.nombrePiscina, pdpr.* from proPlanificacionSiembraDetallePiscinaPorReceptar pdpr
inner join PiscinaUbicacion pu on pdpr.idPiscinaOrigen = pu.idPiscina 
where idPlanificacionSiembra = 227

--query piscinas por receptar por semana
select sum(cantidadRecibida) from proPlanificacionSiembraPiscinaPorReceptar
where fechaInicio = '2024-04-08' and fechaFin = '2024-04-14'
and 
idPiscinaOrigen in (1847,1848,1837)

select  pu.nombrePiscina, ppr.* from proPlanificacionSiembraPiscinaPorReceptar ppr
inner join PiscinaUbicacion pu on ppr.idPiscinaOrigen = pu.idPiscina 
where fechaInicio = '2024-04-08' and fechaFin = '2024-04-14'
and 
idPiscinaOrigen in (1847,1848,1837)
-------------------------------------------------------------------------------------------------------
--Piscinas recepcionadas
 select * from proRecepcionEspecieDetalle 
where --idRecepcion = 326
--and 
idPiscinaPlanificacion in (
	SELECT DISTINCT c.idPiscinaPorReceptar FROM proPlanificacionSiembraPiscinaPorReceptar C
	 INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
	 ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
	 INNER JOIN maePiscina P ON P.idPiscina = c.idPiscinaOrigen
	WHERE  c.idPiscinaPorReceptar in (2656,2657,2658)
	--and 
	--C.idPiscinaOrigen in (1847,1848,1837)
	-- and C.fechaInicio = '2023-03-20' 
) order by 1, idPiscina desc
-------------------------------------------------------------------------------------------------------