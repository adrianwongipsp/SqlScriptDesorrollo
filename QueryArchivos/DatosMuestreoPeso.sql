DECLARE @zona VARCHAR(2) = '29'
DECLARE @rol VARCHAR(10) = 'ENG01'

DROP TABLE IF EXISTS #usuarios_pesos

SELECT userId, userLogin, description AS nombreLogin
INTO #usuarios_pesos
FROM IPSPLightweightCore_Produccion.dbo.secUser
WHERE active = 1

SELECT 
	pu.nombreSector AS Sector,
	pu.nombrePiscina AS Unidad,
	mp.fechaMuestreo AS FechaMuestreo,
	CASE mp.tipoMuestreo
		WHEN 'PES' THEN 'Peso'
		ELSE 'Prepeso'
	END AS TipoMuestro,
	--CASE pe.rolPiscina
	--	WHEN 'ENG01' THEN 'Engorde'
	--	ELSE 'Precria'
	--END AS Rol,
	ISNULL(mpd.pesoPromedioReportado,0) AS PesoPromedio,
	(mpd.pesoGramosTotal / mpd.cantidadTotal) AS PesoPromedio,
	mpd.cantidadTotal AS CantidadMuestra,
	COALESCE(upr.nombreLogin, mp.responsable, '') AS Responsable
FROM proMuestreoPeso mp
INNER JOIN proMuestreoPesoDetalle mpd ON mp.idMuestreo = mpd.idMuestreo AND mpd.activo = 1
INNER JOIN PiscinaUbicacion pu ON pu.idPiscina = mpd.idPiscina
LEFT JOIN proPiscinaEjecucion pe ON mpd.idPiscina = pe.idPiscinaEjecucion AND pe.activo = 1
LEFT JOIN #usuarios_pesos upr ON upr.userLogin = mp.responsable
WHERE mp.zona = @zona AND pe.rolPiscina = @rol
	AND mp.estado = 'APR'
ORDER BY mp.fechaMuestreo, pu.nombreSector, pu.nombrePiscina

DROP TABLE IF EXISTS #usuarios_poblacional
