-----1) Modelo de homologación de pesos anteirores por control de peso
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

-----2) Modelo de homologación de pesos anteirores por control de peso
----2.1) Busqueda de pesos faltantes que deberian ser los pesos de siembra (rerepcion o transferencia)
	 select * 
		into  #tmp_regularizacion_pesos_faltantes
	 from   #tmp_regularizacion_pesos tp 
	 where  fechaPesoAnterior IS NULL;


----2.2) Procesar las recepciones
	select tp.*, min(r.fechaRecepcion) as fechaRecepcion
		into #tmp_regularizacion_pesos_faltantes_recepcion
	 from #tmp_regularizacion_pesos_faltantes tp
	 INNER JOIN 
		proRecepcionEspecieDetalle rd ON rd.idPiscina = tp.idPiscina 
									  AND rd.idPiscinaEjecucion = tp.idPiscinaEjecucion 
	INNER JOIN 
		proRecepcionEspecie r ON r.idRecepcion = rd.idRecepcion  
	WHERE 
		fechaPesoAnterior IS NULL
	group by idMuestreo,	idMuestreoDetalle,	tipoMuestreo,	tp.idPiscina,
	 tp.idPiscinaEjecucion,	fechaPeso,	fechaPesoAnterior,	longitudPromedio,	longitudPromedioAnterior,	peso,	pesoAnterior;

	update  tp set tp.pesoAnterior =  rd.plGramoCam, tp.fechaPesoAnterior = r.fechaRecepcion
		from #tmp_regularizacion_pesos_faltantes_recepcion tp
		INNER JOIN 
		proRecepcionEspecieDetalle rd ON rd.idPiscina = tp.idPiscina 
									  AND rd.idPiscinaEjecucion = tp.idPiscinaEjecucion 
		INNER JOIN 
		proRecepcionEspecie r ON r.idRecepcion = rd.idRecepcion  and tp.fechaRecepcion = r.fechaRecepcion

----2.3) Finalizar las recepciones
	update tp set   tp.fechaPesoAnterior = tpd.fechaPesoAnterior,
					tp.pesoAnterior      = tpd.pesoAnterior
	from #tmp_regularizacion_pesos_faltantes tp inner join
		#tmp_regularizacion_pesos_faltantes_recepcion tpd on tpd.idMuestreo =tp.idMuestreo and tpd.idMuestreoDetalle = tp.idMuestreoDetalle

 
----2.4) Procesar las transferencias 
	 select tp.*,  min(r.fechaTransferencia) as fechaTransferencia
	  into  #tmp_regularizacion_pesos_faltantes_transferencia
	 from #tmp_regularizacion_pesos_faltantes tp
	  INNER JOIN 
		proTransferenciaEspecieDetalle rd ON rd.idPiscina = tp.idPiscina 
									  AND rd.idPiscinaEjecucion = tp.idPiscinaEjecucion 
	 INNER JOIN 
		proTransferenciaEspecie r ON r.idTransferencia = rd.idTransferencia  
	 WHERE 
		fechaPesoAnterior IS NULL
	 group by idMuestreo,	            idMuestreoDetalle,	tipoMuestreo,	    tp.idPiscina,
	          tp.idPiscinaEjecucion,	fechaPeso,	        fechaPesoAnterior,	longitudPromedio,	
			  longitudPromedioAnterior,	peso,	            pesoAnterior


	 update  tp set tp.pesoAnterior =  rd.pesoPromedioTransferencia, 
			 tp.fechaPesoAnterior = r.fechaTransferencia
		from #tmp_regularizacion_pesos_faltantes_transferencia tp
		INNER JOIN 
		proTransferenciaEspecieDetalle rd ON rd.idPiscina = tp.idPiscina 
									  AND rd.idPiscinaEjecucion = tp.idPiscinaEjecucion 
		INNER JOIN 
		   proTransferenciaEspecie r ON r.idTransferencia = rd.idTransferencia    and tp.fechaTransferencia = r.fechaTransferencia

----2.5) Finalizar las transferencias
	   	update tp set   tp.fechaPesoAnterior = tpd.fechaPesoAnterior,
					tp.pesoAnterior      = tpd.pesoAnterior
		from #tmp_regularizacion_pesos_faltantes tp inner join
			#tmp_regularizacion_pesos_faltantes_transferencia tpd on tpd.idMuestreo =tp.idMuestreo and tpd.idMuestreoDetalle = tp.idMuestreoDetalle


---2.6)  finalizacion del proceso tabla final
	update tp set   tp.fechaPesoAnterior = tpd.fechaPesoAnterior,
					tp.pesoAnterior      = tpd.pesoAnterior
	from #tmp_regularizacion_pesos  tp inner join
		#tmp_regularizacion_pesos_faltantes tpd on tpd.idMuestreo =tp.idMuestreo and tpd.idMuestreoDetalle = tp.idMuestreoDetalle 
 

 select mpd.fechaPesoAnterior , p.fechaPesoAnterior,
		mpd.pesoGramosAnterior , p.pesoAnterior,
		mpd.longitudPromedioAnterior , p.longitudPromedioAnterior,
		mpd.idMuestreoDetalle,  p.idMuestreoDetalle
 from #tmp_regularizacion_pesos p inner join proMuestreoPesoDetalle mpd on mpd.idMuestreo = p.idMuestreo and mpd.idMuestreoDetalle = p.idMuestreoDetalle and
	mpd.idPiscina = p.idPiscina and mpd.idPiscinaEjecucion = p.idPiscinaEjecucion



	/*
		 UPDATE mpd set mpd.fechaPesoAnterior = p.fechaPesoAnterior,
		mpd.pesoGramosAnterior = p.pesoAnterior,
		mpd.longitudPromedioAnterior = p.longitudPromedioAnterior 
			from #tmp_regularizacion_pesos p inner join proMuestreoPesoDetalle mpd on mpd.idMuestreo = p.idMuestreo and mpd.idMuestreoDetalle = p.idMuestreoDetalle and
		 mpd.idPiscina = p.idPiscina and mpd.idPiscinaEjecucion = p.idPiscinaEjecucion

	*/ 