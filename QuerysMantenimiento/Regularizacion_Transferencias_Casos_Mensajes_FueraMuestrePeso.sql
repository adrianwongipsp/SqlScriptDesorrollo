 DECLARE @idTransferencia INT
 DECLARE @idMuestreoPeso INT

 SET @idTransferencia  = 3026
 SET @idMuestreoPeso  = 5687

 IF OBJECT_ID('tempdb..#TMP_MUESTREO_PESO') IS NOT NULL          
     DROP TABLE #TMP_MUESTREO_PESO;      

SELECT TMP_MUESTREO_PESO.* 
INTO #TMP_MUESTREO_PESO
FROM 
(SELECT 'DESTINO' as Tipo,EJ.estado,ej.idPiscina, ej.idPiscinaEjecucion, PU.nombreSector, PU.nombrePiscina, ej.FechaInicio, ej.FechaSiembra, ISNULL(ej.FechaCierre,GETDATE()) as FechaCierre,
CD.idPiscinaEjecucion as idPiscinaEjecucionControl, c.idMuestreo, c.fechaMuestreo, CD.activo as activoMuestro,
PED.idPiscinaEjecucion as idPiscinaEjecucionTransferencia,PED.idTransferencia, t.fechaTransferencia
FROM proMuestreoPesoDetalle CD 
	inner join proMuestreoPeso c on c.idMuestreo = CD.idMuestreo
	inner join PiscinaUbicacion pu on pu.idPiscina = CD.idPiscina
	INNER JOIN proTransferenciaEspecieDetalle PED ON PED.idPiscina = pu.idPiscina
	INNER JOIN proTransferenciaEspecie t on t.idTransferencia = PED.idTransferencia
	INNER JOIN EjecucionesPiscinaView ej on ej.idPiscina = PED.idPiscina and ej.idPiscinaEjecucion = PED.idPiscinaEjecucion
WHERE CD.idMuestreo = @idMuestreoPeso AND PED.idTransferencia= @idTransferencia
union 
SELECT 'ORIGEN' as Tipo,EJ.estado, ej.idPiscina, ej.idPiscinaEjecucion, PU.nombreSector, PU.nombrePiscina, ej.FechaInicio, ej.FechaSiembra, ISNULL(ej.FechaCierre,GETDATE()) as FechaCierre,
cd.idPiscinaEjecucion as idPiscinaEjecucionControl, c.idMuestreo, c.fechaMuestreo, CD.activo as activoMuestro,
t.idPiscinaEjecucion as idPiscinaEjecucionTransferencia,t.idTransferencia, t.fechaTransferencia
FROM proTransferenciaEspecie t
	INNER JOIN PiscinaUbicacion pu on pu.idPiscina = t.idPiscina
	 INNER JOIN proMuestreoPesoDetalle CD on CD.idPiscina = t.idPiscina and CD.idPiscinaEjecucion = t.idPiscinaEjecucion
  	INNER JOIN proMuestreoPeso c on c.idMuestreo = CD.idMuestreo
   INNER JOIN EjecucionesPiscinaView ej on ej.idPiscina = t.idPiscina and ej.idPiscinaEjecucion = t.idPiscinaEjecucion
WHERE t.idTransferencia = @idTransferencia AND
 c.idMuestreo   = @idMuestreoPeso  )AS TMP_MUESTREO_PESO

 SELECT
		CASE 
			WHEN idPiscinaEjecucion = idPiscinaEjecucionControl 
				 AND idPiscinaEjecucion = idPiscinaEjecucionTransferencia
				 AND (fechaMuestreo < FechaInicio OR fechaMuestreo > FechaCierre)
			THEN 1
			ELSE 0
		END AS AplicarRegularizacion,
		Tipo,
		estado,
		idPiscina, 
		idPiscinaEjecucion,
		nombreSector,
		nombrePiscina,
		FechaInicio,
		FechaSiembra,
		FechaCierre,
		idPiscinaEjecucionControl,
		idMuestreo,
		fechaMuestreo,
		activoMuestro,
		idPiscinaEjecucionTransferencia,
		idTransferencia,
		fechaTransferencia 
 FROM 
 #TMP_MUESTREO_PESO
 