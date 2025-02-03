USE IPSPCamaroneraProduccion
GO

/*
	GARITA		HOLANDA			LALUZ			NURACORP		PORTILLO
	TAURAI		TAURAII			TAURAIII		TAURAIV			TAURAIX
	TAURAV		TAURAVI			TAURAVII		TAURAVIII
*/

--DECLARE @SECTORFILTER VARCHAR(30) = 'TAURAVIII'

	DROP TABLE IF EXISTS #EJECUCIONESTEMP
	DROP TABLE IF EXISTS #TEMPTEMP		
SELECT	pu.codigoZona,	       pu.nombreZona,       pu.codigoCamaronera, pu.nombreCamaronera, 
				pu.codigoSector,       pu.nombreSector,     pu.codigoPiscina,    pu.nombrePiscina, 
				ce.codigoElemento,     ce.nombreElemento,   pe.idPiscina,        
				pu.nombreSector + pu.nombrePiscina + '.' + CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, 
				pu.nombreSector + pu.nombrePiscina AS keyPiscina, 
				pe.idPiscinaEjecucion, pe.ciclo,            pe.fechaInicio,      pe.fechaSiembra, 
				pe.fechaCierre,			pe.cantidadEntrada
		INTO #EJECUCIONESTEMP 
		FROM proPiscinaEjecucion pe 
			INNER JOIN PiscinaUbicacion  pu ON  pe.idPiscina	 = pu.idPiscina 
			INNER JOIN CATALOGO_ELEMENTS ce ON ce.codigoElemento = pe.rolPiscina AND ce.codigoCatalogo = 'maeRolPiscina' 
		WHERE estado in ('EJE', 'PRE')
   	
  -- --FILTRAMOS LAS PISCINAS A REGULARIZAR
		--SELECT cp.Key_Piscina, cp.Ciclo, CP.Fecha_IniSec, CP.Fecha_Siembra, ''''+cp.Key_Piscina+''',',
		--CP.Cantidad_Sembrada, CP.Cantidad_Sembrada

		--from CICLOS_PRODUCCION cp
		--left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
		--WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
		--AND REPLACE(cp.Sector,' ','') = @SECTORFILTER --and ej.ciclo is null
		--ORDER BY CP.Fecha_IniSec, CP.Fecha_Siembra

		
	select ''''+keyPiscina+''',' AS keyComm, 
	cp.Cod_Ciclo, Key_Piscina, cp.Ciclo as CicloExcel, Fecha_IniSec,
	cast(Fecha_Siembra as date) Fecha_Siembra, 
	CASE WHEN Fecha_Pesca IS NULL THEN '' ELSE CONVERT(VARCHAR(10),Fecha_Pesca,23) END Fecha_Pesca
	, 
	DATEDIFF(day, Fecha_IniSec, ej.fechaInicio) InicioDiff, 
	DATEDIFF(day, Fecha_Siembra, ej.fechaSiembra) SiembraDiff,
	DATEDIFF(day, COALESCE(Fecha_Pesca,GETDATE()), COALESCE(ej.fechaCierre,GETDATE())) CierreDiff,
	(Cantidad_Sembrada - ej.cantidadEntrada) CantidadDiff,

	Cantidad_Sembrada, Camaronera, Sector, ej.keyPiscina AS Key_Piscina_Insigne,
	ej.Cod_Ciclo Cod_Ciclo_Insigne, 
	Tipo,
	ej.fechaInicio, ej.fechaSiembra,
	CASE WHEN ej.fechaCierre IS NULL THEN '' ELSE CONVERT(VARCHAR(10),ej.fechaCierre,23) END fechaCierre, 
	ej.cantidadEntrada, ej.ciclo, 
	idPiscina, idPiscinaEjecucion
	INTO #TEMPTEMP
	from CICLOS_PRODUCCION cp
	left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
	WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
	AND (DATEDIFF(day, COALESCE(Fecha_Pesca,GETDATE()), COALESCE(ej.fechaCierre,GETDATE())) NOT BETWEEN -5 AND 5
	OR (Cantidad_Sembrada - ej.cantidadEntrada) NOT BETWEEN -100 AND 100 )
	--AND DATEDIFF(day, COALESCE(cp.Fecha_Pesca ,GETDATE()), GETDATE()) > 4
	--AND CP.Sector = @SECTORFILTER
	--AND EJ.nombreZona = 'ASIA'
	--AND EJ.nombreZona = 'AFRICA'
	AND EJ.nombreZona = 'CHURUTE'
	--AND EJ.nombreZona = 'DAULAR'
	--AND EJ.nombreZona = 'BAJENI'
	--AND EJ.nombreZona = 'CHANDUY-PAÑAMAO'
	--SELECT * FROM parZona
	--SELECT * FROM CICLOS_PRODUCCION
	--WHERE ZONA = 'ASIA'

	SELECT distinct keyComm FROM #TEMPTEMP
	SELECT * FROM #TEMPTEMP

	/*
	select E.cod_ciclo, T.cantidadDeclarada, T.cantidadTransferida, T.* from proTransferenciaEspecieDetalle T
	INNER JOIN EjecucionesPiscinaView E ON E.idPiscinaEjecucion = T.idPiscinaEjecucion
	where idTransferencia = 3471
	select Cantidad_Transf, * from TRANSFERENCIAS_PRODUCCION
	WHERE Cod_Ciclo_Origen = 'SANTAMONICAPC13.27'
	--*/	
	
	--	select * from maePiscina
	--	where idPiscina = 304
	--select * from audit_proPiscinaEjecucion
	--where idPiscina = 304 order by idPiscinaEjecucion, auditId
	/*
	select * from maePiscinaCiclo
	where idPiscina = 307
	select * from proPiscinaEjecucion
	where idPiscina = 304
	*/
	/*
		exec viewProcessCiclos 'TAURAIX110', 1;
		
		exec viewProcessCiclos 'SANTAMONICAPC17', 1;

	*/

	
	--updwate maePiscinaCiclo
	--set ciclo = 54
	--where idOrigen = 7678
	--updawte proPiscinaEjecucion
	--set ciclo = 54
	--where idPiscinaEjecucion = 7678
