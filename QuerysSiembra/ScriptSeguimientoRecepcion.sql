select * from proPlanificacionSiembra 
where idPlanificacionSiembra = 21

SELECT P.nombre, c.idPiscinaPorReceptar, c.cantidadTotal, c.cantidadRecibida, c.cantidadPendiente, d.* FROM proPlanificacionSiembraPiscinaPorReceptar C
 INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
 ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
 INNER JOIN maePiscina P ON P.idPiscina = c.idPiscinaOrigen
WHERE  c.idPiscinaPorReceptar in (461)
--and 
--C.idPiscinaOrigen iN(389,397)
 --and 
 --C.fechaInicio = '2023-06-19' 
 

 select *
from proRecepcionEspecieDetalle --order by 1 desc
where --idRecepcion = 326
--and 
idPiscinaPlanificacion in (
SELECT DISTINCT c.idPiscinaPorReceptar FROM proPlanificacionSiembraPiscinaPorReceptar C
 INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
 ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
 INNER JOIN maePiscina P ON P.idPiscina = c.idPiscinaOrigen
WHERE  c.idPiscinaPorReceptar in (2656,2657,2658)
--and 
--C.idPiscinaOrigen iN(389,397)
-- and C.fechaInicio = '2023-03-20' 
)
order by 1 desc

 
SELECT DISTINCT r.estado, r.idRecepcion,
 SPRD.idPlanificacionSiembra, 
SPR.fechaInicio, SPR.fechaFin, 
R.fechaRecepcion, 
p.nombre as NombrePiscina ,
spr.cantidadTotal, spr.cantidadRecibida,  spr.cantidadPendiente  
FROM proRecepcionEspecieDetalle rd
INNER JOIN proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
INNER JOIN proPlanificacionSiembraPiscinaPorReceptar SPR ON spr.idPiscinaPorReceptar = rd.idPiscinaPlanificacion 
INNER JOIN maePiscina P ON P.idPiscina = SPR.idPiscinaOrigen
INNER JOIN proPlanificacionSiembraDetallePiscinaPorReceptar SPRD ON 
SPRD.idPiscinaOrigen = SPR.idPiscinaOrigen AND SPRD.fechaInicio = SPR.fechaInicio  AND SPRD.fechaFin = SPR.fechaFin  
and r.estado = 'ANU'

