
	drop table if exists #idsMuestreosDetalles
	drop table if exists #MuestreoPoblacionTempCaracte
	go
	
	--Extraemos los ids de muestreos detalles que estén duplicados en carácteristicas filtrando por los muestreos aprobados
	SELECT DISTINCT idMuestreoDetalle
	INTO #idsMuestreosDetalles
	FROM proMuestreoPoblacionDetalleCaracteristica pdc
	inner join proMuestreoPoblacion p on pdc.idMuestreo = p.idMuestreo
	where p.estado <> 'ANU' and pdc.activo = 1
	GROUP BY idMuestreoDetalle, pdc.idMuestreo, idParametroControl, activo
	HAVING COUNT(1) > 1
	ORDER BY idMuestreoDetalle
	go


	--Detalles de caracteristicas duplicados
	select p.estado, pdc.* from proMuestreoPoblacionDetalleCaracteristica pdc
	inner join proMuestreoPoblacion p on pdc.idMuestreo = p.idMuestreo
	where pdc.idMuestreoDetalle in (select * from #idsMuestreosDetalles) and  estado <> 'ANU' and pdc.activo = 1
	order by pdc.idMuestreo, idMuestreoDetalle, idParametroControl, activo
	go
	

	select max(idMuestreoCaracteristica) as idMuestreoCaracteristica, idMuestreo, idMuestreoDetalle, idParametroControl
	into #MuestreoPoblacionTempCaracte
	from proMuestreoPoblacionDetalleCaracteristica
	where idMuestreoDetalle in (select * from #idsMuestreosDetalles) 
	group by idMuestreo, idMuestreoDetalle, idParametroControl, activo
	having count(idMuestreoDetalle) > 1

	
	--updadte mpdc
	--set mpdc.activo = 0
	----select * 
	--from proMuestreoPoblacionDetalleCaracteristica mpdc
	--where idMuestreoCaracteristica in(select idMuestreoCaracteristica from #MuestreoPoblacionTempCaracte)

	go
	select max(idMuestreoProfundidadDetalle) as idMuestreoProfundidadDetalle,
		   idMuestreoDetalle,
		   max(orden)  as orden, 
		   activo 
		   --into #poblacionLanceTemp 
		   from proMuestreoPoblacionProfundidadDetalle
		   where idMuestreoDetalle in (select * from #idsMuestreosDetalles)
		   group by idMuestreoDetalle, idProfundidad, cantidadLance, activo,ubicacionCodigo, 
		   idParametroControlFresco, idParametroControlViejo, valorFresco, valorViejo
		   having  count(idMuestreoDetalle) > 1 
		   
		   select * from proMuestreoPoblacionProfundidadDetalle
		   where idMuestreoDetalle in (select * from #idsMuestreosDetalles)
		   order by idMuestreoDetalle, idProfundidad, ubicacionCodigo, cantidadLance, orden 
	
		--upsssdate p
		--set p.activo = 0
		----select *
		--from proMuestreoPoblacionProfundidadDetalle as p
		--where idMuestreoProfundidadDetalle in (select idMuestreoProfundidadDetalle from  #poblacionLanceTemp ) 
	go



	--select * from proMuestreoPoblacionProfundidadDetalle ppd
	--inner join proMuestreoPoblacionDetalleLance pd on ppd.idMuestreoDetalle = pd.idMuestreo
	--inner join proMuestreoPoblacion p on pd.idMuestreo = p.idMuestreo
	--where estado <> 'ANU' and ppd.idMuestreoDetalle in (select * from #idsMuestreosDetalles) and ppd.activo = 1
	--order by pd.idMuestreoDetalle
	--go
