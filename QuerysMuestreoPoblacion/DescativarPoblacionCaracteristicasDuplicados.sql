declare @idMuestreoDetalle int = 6713

--select max(idMuestreoCaracteristica) as idMuestreoCaracteristica, idMuestreo, 
--idMuestreoDetalle, idParametroControl
--from proMuestreoPoblacionDetalleCaracteristica
--where idMuestreoDetalle in (6713)
--group by idMuestreo, idMuestreoDetalle, idParametroControl, activo
--having count(idMuestreoDetalle) >1



begin tran

drop table if exists #MuestreoPoblacionTempCaracte

select max(idMuestreoCaracteristica) as idMuestreoCaracteristica, idMuestreo, idMuestreoDetalle, idParametroControl
into #MuestreoPoblacionTempCaracte
from proMuestreoPoblacionDetalleCaracteristica
where idMuestreoDetalle in (@idMuestreoDetalle)
group by idMuestreo, idMuestreoDetalle, idParametroControl, activo
having count(idMuestreoDetalle) >1

update mpdc
set mpdc.activo = 0
--select * 
from proMuestreoPoblacionDetalleCaracteristica mpdc
where idMuestreoCaracteristica in(select idMuestreoCaracteristica from #MuestreoPoblacionTempCaracte)

select max(idMuestreoCaracteristica) as idMuestreoCaracteristica, idMuestreo, idMuestreoDetalle, idParametroControl, activo 
from proMuestreoPoblacionDetalleCaracteristica
where idMuestreoDetalle in (@idMuestreoDetalle)--,6713,6714)
group by idMuestreo, idMuestreoDetalle, idParametroControl, activo
having count(idMuestreoDetalle) >1

select * from proMuestreoPoblacionDetalleCaracteristica
where idMuestreoDetalle in (@idMuestreoDetalle) and activo = 1--,6713,6714)

rollback
--commit