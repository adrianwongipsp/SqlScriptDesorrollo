-- Script para reversar el cerrado de una planificaci�n
update proPlanificacionSiembra
set cierrePedido = 0,
	estado = 'ING'
where idPlanificacionSiembra = 18;

update proPlanificacionSiembraDetallePiscinaPorReceptar
set cierrePedido = 0
where idPlanificacionSiembra = 18 


