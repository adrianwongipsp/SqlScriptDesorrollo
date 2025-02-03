
--update proPiscinaCosecha
--set estado = 'ANU' where idPiscinaCosecha = 2539
--exec viewProcessCiclos 'COSTARICAI6', 1 

	begin transaction

		DECLARE @sector varchar(15) = 'GARITA56'
		
		select ep.cod_ciclo, ep.FechaCierre, pp.Fecha_DS, pc.fechaInicio, pc.fechaFin, pc.fechaLiquidacion, pc.* 
			from proPiscinaCosecha pc
			inner join EjecucionesPiscinaView ep on pc.idPiscinaEjecucion = ep.idPiscinaEjecucion
			inner join PESCA_PRODUCCION pp on pp.Cod_ciclo = ep.cod_ciclo
			where ep.nombreSector = @sector and pc.tipoPesca = 'PES' and liquidado = 1 
				and FechaCierre != fechaLiquidacion

		update pc
		set pc.fechaInicio = pp.Fecha_DS,
			pc.fechaFin = pp.Fecha_DS,
			pc.fechaLiquidacion = pp.Fecha_DS
		--select ep.cod_ciclo, ep.FechaCierre, pp.Fecha_DS, pc.fechaInicio, pc.fechaFin, pc.fechaLiquidacion, pc.* 
		from proPiscinaCosecha pc
		inner join EjecucionesPiscinaView ep on pc.idPiscinaEjecucion = ep.idPiscinaEjecucion
		inner join PESCA_PRODUCCION pp on pp.Cod_ciclo = ep.cod_ciclo
		where ep.nombreSector = @sector and pc.tipoPesca = 'PES' and liquidado = 1 
		 and FechaCierre != fechaLiquidacion

		select ep.cod_ciclo, ep.FechaCierre, pp.Fecha_DS, pc.fechaInicio, pc.fechaFin, pc.fechaLiquidacion, pc.* 
			from proPiscinaCosecha pc
			inner join EjecucionesPiscinaView ep on pc.idPiscinaEjecucion = ep.idPiscinaEjecucion
			inner join PESCA_PRODUCCION pp on pp.Cod_ciclo = ep.cod_ciclo
			where ep.nombreSector = @sector and pc.tipoPesca = 'PES' and liquidado = 1 
				and FechaCierre != fechaLiquidacion

	rollback
	--commit

--select * from PESCA_PRODUCCION
--where keyPiscina = 'COSTARICAI6'

