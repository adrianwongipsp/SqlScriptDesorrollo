
drop table if exists #tmp_regularizacion_pesos
drop table if exists #tmp_regularizacion_pesos_faltantes
drop table if exists #tmp_regularizacion_pesos_faltantes_recepcion
drop table if exists #tmp_regularizacion_pesos_faltantes_transferencia
drop table if exists #Camarones
drop table if exists #PesoSiembras

go

WITH CTE AS (
			SELECT 
				c.idMuestreo, 
				d.idMuestreoDetalle, 
				c.tipoMuestreo, 
				d.idPiscina, 
				d.idPiscinaEjecucion, 
				c.fechaMuestreo AS fechaPeso, 
				LAG(c.fechaMuestreo, 1) OVER (ORDER BY c.fechaMuestreo ASC) AS fechaPesoAnterior,
				d.longitudPromedio,
				LAG(d.longitudPromedio, 1) OVER (ORDER BY c.fechaMuestreo ASC) AS longitudPromedioAnterior,
				COALESCE(d.pesoPromedioReportado, d.pesoLongitudTotal) as peso,
				LAG(COALESCE(d.pesoPromedioReportado, d.pesoLongitudTotal), 1) OVER (ORDER BY c.fechaMuestreo ASC) AS  pesoAnterior,
				ROW_NUMBER() OVER (PARTITION BY c.idMuestreo ORDER BY c.fechaMuestreo DESC) AS rn
			FROM  
				proMuestreoPeso c 
			INNER JOIN 
				proMuestreoPesoDetalle d ON c.idMuestreo = d.idMuestreo 
			WHERE 
				tipoMuestreoDetalle = 'PLONG' 
				AND c.estado		= 'APR'
				AND activo			= 1 
		)

-----1) Modelo de homologación de pesos anteirores por control de peso
		

	SELECT 
		idMuestreo,
		idMuestreoDetalle,
		tipoMuestreo,
		idPiscina,
		idPiscinaEjecucion,
		fechaPeso,
		( SELECT TOP 1 fechaPeso
				FROM CTE c2
				WHERE c2.idPiscinaEjecucion = c.idPiscinaEjecucion and c2.idPiscina = c.idPiscina AND c2.fechaPeso < c.fechaPeso AND c2.tipoMuestreo = 'PES'
				ORDER BY c2.fechaPeso DESC) AS  fechaPesoAnterior,
		longitudPromedio,
		( SELECT TOP 1 longitudPromedio
				FROM CTE c2
				WHERE c2.idPiscinaEjecucion = c.idPiscinaEjecucion and c2.idPiscina = c.idPiscina AND c2.fechaPeso < c.fechaPeso AND c2.tipoMuestreo = 'PES'
				ORDER BY c2.fechaPeso DESC)  AS longitudPromedioAnterior ,
		  peso,
		  ( SELECT TOP 1 peso
				FROM CTE c2
				WHERE c2.idPiscinaEjecucion = c.idPiscinaEjecucion and c2.idPiscina = c.idPiscina  AND c2.fechaPeso < c.fechaPeso AND c2.tipoMuestreo = 'PES'
				ORDER BY c2.fechaPeso DESC)  AS pesoAnterior 
	INTO #tmp_regularizacion_pesos
	FROM CTE c
	order by c.idPiscina, c.idPiscinaEjecucion,  c.fechaPeso desc

-----2) Modelo de homologación de pesos anteriores por control de peso
----2.1) Busqueda de pesos faltantes que deberian ser los pesos de siembra (rerepcion o transferencia)
	 select * 
		into  #tmp_regularizacion_pesos_faltantes
	 from   #tmp_regularizacion_pesos tp 
	 where  fechaPesoAnterior IS NULL;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			

		SELECT idPiscinaEjecucion as idPiscinaEjecucion, max(r.fechaRecepcion) as fecha, SUM(rd.cantidadRecibida+cantidadAdicional) as cantidad, SUM(1.00/plGramoCam) as peso
		into #Camarones
		FROM proRecepcionEspecieDetalle rd
		inner join proRecepcionEspecie r on rd.idRecepcion = r.idRecepcion 
		where idPiscinaEjecucion in (select idPiscinaEjecucion from #tmp_regularizacion_pesos_faltantes)
		group by rd.idPiscina, rd.idPiscinaEjecucion

		insert into #Camarones 
		SELECT td.idPiscinaEjecucion as idPiscinaEjecucion, max(t.fechaTransferencia) as fecha, td.cantidadTransferida as cantidad, pesoPromedioTransferencia as peso 
		FROM proTransferenciaEspecieDetalle td
		inner join proTransferenciaEspecie t on td.idTransferencia = t.idTransferencia
		where td.idPiscinaEjecucion in (select idPiscinaEjecucion from #tmp_regularizacion_pesos_faltantes)
		group by td.idPiscina, td.idPiscinaEjecucion, td.cantidadTransferida, td.pesoPromedioTransferencia

		select idPiscinaEjecucion, max(fecha) as FechaSiembra, SUM(cantidad * peso) / sum(cantidad) as pesoPromedioSiembra 
		into #PesoSiembras
		from #Camarones 
		where fecha is not null and cantidad is not null and peso is not null
		group by idPiscinaEjecucion


			-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
---2.7)  finalizacion del proceso tabla final
	update tp set   tp.fechaPesoAnterior =  ps.FechaSiembra,
					tp.pesoAnterior      = ps.pesoPromedioSiembra
	from #tmp_regularizacion_pesos_faltantes  tp inner join
		#PesoSiembras ps on tp.idPiscinaEjecucion = ps.idPiscinaEjecucion and pesoAnterior is null and fechaPesoAnterior is null

---2.6)  finalizacion del proceso tabla final
	update tp set   tp.fechaPesoAnterior = tpd.fechaPesoAnterior,
					tp.pesoAnterior      = tpd.pesoAnterior
	from #tmp_regularizacion_pesos  tp inner join
		#tmp_regularizacion_pesos_faltantes tpd on tpd.idMuestreo = tp.idMuestreo and tpd.idMuestreoDetalle = tp.idMuestreoDetalle 
		
		
 --select * from #tmp_regularizacion_pesos_faltantes
 --where idPiscinaEjecucion in (
 --select idPiscinaEjecucion from #tmp_regularizacion_pesos_faltantes
 --group by idPiscinaEjecucion
 --having COUNT(idPiscinaEjecucion) >1
 --) 

 /*idPiscinaEjecucion in (
 select idPiscinaEjecucion from #tmp_regularizacion_pesos_faltantes
 group by idPiscinaEjecucion
 having COUNT(idPiscinaEjecucion) >1
 ) and */

 select p.idPiscina, p.idPiscinaEjecucion, mp.tipoMuestreoDetalle, mp.tipoMuestreo, mp.fechaMuestreo, mpd.fechaPesoAnterior , p.fechaPesoAnterior AS fechaPesoAnteriorNuevo,
		mpd.pesoGramosAnterior , p.pesoAnterior as pesoAnteriorNuevo,
		mpd.longitudPromedioAnterior , p.longitudPromedioAnterior,
		mpd.idMuestreoDetalle,  p.idMuestreoDetalle
 from #tmp_regularizacion_pesos p inner join proMuestreoPesoDetalle mpd on mpd.idMuestreo = p.idMuestreo and mpd.idMuestreoDetalle = p.idMuestreoDetalle and
	mpd.idPiscina = p.idPiscina and mpd.idPiscinaEjecucion = p.idPiscinaEjecucion
	inner join proMuestreoPeso mp on mpd.idMuestreo = mp.idMuestreo
	order by p.idPiscina, p.idPiscinaEjecucion, mp.fechaMuestreo

	/*
		 UPDATE mpd set mpd.fechaPesoAnterior = p.fechaPesoAnterior,
		mpd.pesoGramosAnterior = p.pesoAnterior,
		mpd.longitudPromedioAnterior = p.longitudPromedioAnterior 
			from #tmp_regularizacion_pesos p inner join proMuestreoPesoDetalle mpd on mpd.idMuestreo = p.idMuestreo and mpd.idMuestreoDetalle = p.idMuestreoDetalle and
		 mpd.idPiscina = p.idPiscina and mpd.idPiscinaEjecucion = p.idPiscinaEjecucion

	*/ 

