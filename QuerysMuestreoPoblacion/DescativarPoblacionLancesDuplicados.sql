
--select duplicados.idMuestreoDetalle, COUNT(duplicados.idMuestreoDetalle)
-- , (select COUNT(idMuestreoDetalle) / 2 from proMuestreoPoblacionProfundidadDetalle 
--		 where idMuestreoDetalle = duplicados.idMuestreoDetalle) as total 
--from (
--	select  max(idMuestreoProfundidadDetalle) as idMuestreoProfundidadDetalle,
--			idMuestreoDetalle,
--			max(orden)  as orden, 
--			activo 
--			--into #poblacionTemp 
--			from proMuestreoPoblacionProfundidadDetalle
--			where idMuestreoDetalle in (6713) --and idMuestreoProfundidadDetalle = max(idMuestreoProfundidadDetalle)
--			group by idMuestreoDetalle, idProfundidad, cantidadLance, activo,ubicacionCodigo, 
--			idParametroControlFresco, idParametroControlViejo, valorFresco, valorViejo
--			having  count(idMuestreoDetalle) > 1 
--			) as duplicados
--			group by idMuestreoDetalle 


begin tran
 drop table if exists #poblacionLanceTemp
	select  max(idMuestreoProfundidadDetalle) as idMuestreoProfundidadDetalle,
			idMuestreoDetalle,
			max(orden)  as orden, 
			activo 
			into #poblacionLanceTemp 
			from proMuestreoPoblacionProfundidadDetalle
			where idMuestreoDetalle in (6713) --and idMuestreoProfundidadDetalle = max(idMuestreoProfundidadDetalle)
			group by idMuestreoDetalle, idProfundidad, cantidadLance, activo,ubicacionCodigo, 
			idParametroControlFresco, idParametroControlViejo, valorFresco, valorViejo
			having  count(idMuestreoDetalle) > 1 

		upsssdate p
		set p.activo = 0
		--select *
		from proMuestreoPoblacionProfundidadDetalle as p
		where idMuestreoProfundidadDetalle in (select idMuestreoProfundidadDetalle from  #poblacionLanceTemp ) 

select * from proMuestreoPoblacionProfundidadDetalle
where idMuestreoDetalle in (6713) and activo = 1
order by idMuestreoDetalle, ubicacionCodigo,  cantidadLance, orden

rollback

--select max(idMuestreoCaracteristica) as idMuestreoCaracteristica, idMuestreo, idMuestreoDetalle, idParametroControl, valor, idCualidad, activo 
--from proMuestreoPoblacionDetalleCaracteristica
--where idMuestreoDetalle in (6713)
--group by idMuestreo, idMuestreoDetalle, idParametroControl, valor, idCualidad, activo
