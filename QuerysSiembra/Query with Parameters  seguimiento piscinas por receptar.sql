--Query planificación cabecera
declare @secuenciaPlanificacion int
set		@secuenciaPlanificacion = 356

declare @idPiscina int
set		@idPiscina = 297

declare @fechaInicio date
declare @fechaFin    date

drop table if exists #idPiscinaPorReceptar
drop table if exists #RepcionDetalle

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------Planificaciones (Tablas)----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select 'planificacionSiembra' as tabla,  * from proPlanificacionSiembra
where  secuencia = @secuenciaPlanificacion
-------------------------------------------------------------------------------------------------------
--query panificacion detalle (Piscinas de destinos)
select 'proPlanificacionSiembraDetalle' as tabla, * from proPlanificacionSiembraDetalle
where idPlanificacionSiembra = @secuenciaPlanificacion
-------------------------------------------------------------------------------------------------------
--query panificacion detalle de piscinas (Piscinas de origen a sembrar)
select  'proPlanificacionSiembraDetallePiscina' as tabla, pu.nombrePiscina, psd.* from proPlanificacionSiembraDetallePiscina psd
inner join PiscinaUbicacion pu on psd.idPiscina = pu.idPiscina 
where idPlanificacionSiembraDetalle in (select idPlanificacionSiembraDetalle from proPlanificacionSiembraDetalle where idPlanificacionSiembra = @secuenciaPlanificacion)
-------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------Recepciones en Planificaciones (Tablas)----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--query detalles de piscinas por receptar (proPlanificacionSiembraPiscinaPorReceptar tabla que contiene saldos2, )
SELECT 'proPlanificacionSiembraPiscinaPorReceptar'			as TablaCab  ,
       'proPlanificacionSiembraDetallePiscinaPorReceptar' 	as TablaDet  ,
	    P.nombre,  c.idPiscinaPorReceptar, c.cantidadTotal, c.cantidadRecibida, c.cantidadPendiente, C.activo,' - ' [-], d.* 
FROM proPlanificacionSiembraPiscinaPorReceptar  C
	INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
			ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
	INNER JOIN maePiscina P
			ON P.idPiscina = c.idPiscinaOrigen
WHERE  
P.idPiscina = isnull(@idPiscina,P.idPiscina) and D.idPlanificacionSiembra  = @secuenciaPlanificacion 
--and
--c.idPiscinaPorReceptar in (3516)

SELECT  c.idPiscinaPorReceptar , D.fechaEntrega, D.fechaInicio, D.fechaFin
into #idPiscinaPorReceptar
FROM proPlanificacionSiembraPiscinaPorReceptar C
 INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
 ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
 INNER JOIN maePiscina P ON P.idPiscina = c.idPiscinaOrigen
WHERE  
P.idPiscina = isnull(@idPiscina,P.idPiscina) and D.idPlanificacionSiembra  = @secuenciaPlanificacion 

select '#idPiscinaPorReceptar' Tabla,* from #idPiscinaPorReceptar  --3516

set @fechaInicio = (select top 1   fechaInicio from #idPiscinaPorReceptar)
set @fechaFin    = (select top 1   fechaFin    from #idPiscinaPorReceptar)
-------------------------------------------------------------------------------------------------------

--query detalles de piscinas por receptar por planificación
select 'proPlanificacionSiembraDetallePiscinaPorReceptar'  as tabla, pu.nombrePiscina, pdpr.* from proPlanificacionSiembraDetallePiscinaPorReceptar pdpr
inner join PiscinaUbicacion pu on pdpr.idPiscinaOrigen = pu.idPiscina 
where idPlanificacionSiembra = @secuenciaPlanificacion

--query piscinas por receptar por semana
select sum(cantidadRecibida)  totalReceptadoEnSemana
from proPlanificacionSiembraPiscinaPorReceptar
where fechaInicio = @fechaInicio and fechaFin = @fechaFin
and 
idPiscinaOrigen in (@idPiscina)

select  'proPlanificacionSiembraPiscinaPorReceptar' as tabla, pu.nombrePiscina, ppr.* from proPlanificacionSiembraPiscinaPorReceptar ppr
inner join PiscinaUbicacion pu on ppr.idPiscinaOrigen = pu.idPiscina 
where fechaInicio = @fechaInicio and fechaFin =  @fechaFin
and 
idPiscinaOrigen in (@idPiscina)
-------------------------------------------------------------------------------------------------------
--Piscinas recepcionadas
select 'proRecepcionEspecieDetalle' as tabla, * 
into #RepcionDetalle
from proRecepcionEspecieDetalle 
where --idRecepcion = 326
--and 
idPiscinaPlanificacion in (
	SELECT DISTINCT c.idPiscinaPorReceptar FROM proPlanificacionSiembraPiscinaPorReceptar C
	 INNER JOIN  proPlanificacionSiembraDetallePiscinaPorReceptar D
	 ON C.idPiscinaOrigen = D.idPiscinaOrigen AND D.fechaInicio = C.fechaInicio  AND D.fechaFin = C.fechaFin  
	 INNER JOIN maePiscina P ON P.idPiscina = c.idPiscinaOrigen
	WHERE  c.idPiscinaPorReceptar in (select idPiscinaPorReceptar from #idPiscinaPorReceptar )
	--and 
	--C.idPiscinaOrigen in (1847,1848,1837)
	-- and C.fechaInicio = '2023-03-20' 
) order by 1, idPiscina desc
-------------------------------------------------------------------------------------------------------
select * from #RepcionDetalle
 SELECT 'proRecepcionEspecie' as tabla  FROM proRecepcionEspecie WHERE idRecepcion IN (select idRecepcion from #RepcionDetalle)