 DECLARE @idTransferencia INT
 DECLARE @idControlParametro INT

 SET @idTransferencia  = 3536
 SET @idControlParametro  = 72719
 
 IF OBJECT_ID('tempdb..#TMP_TRANS_CONTROL') IS NOT NULL          
     DROP TABLE #TMP_TRANS_CONTROL;      
 
SELECT TMP_TRANS_CONTROL.* 
INTO #TMP_TRANS_CONTROL
FROM 
(SELECT 'DESTINO' as Tipo,EJ.estado,ej.idPiscina, ej.idPiscinaEjecucion, PU.nombreSector, PU.nombrePiscina, ej.FechaInicio, ej.FechaSiembra, ISNULL(ej.FechaCierre,GETDATE()) as FechaCierre,
CD.idPiscinaEjecucion as idPiscinaEjecucionControl, c.idControlParametro, c.fechaControl, CD.activo as activoControl,
PED.idPiscinaEjecucion as idPiscinaEjecucionTransferencia,PED.idTransferencia, t.fechaTransferencia
FROM proControlParametroDetalle CD 
	inner join proControlParametro c on c.idControlParametro = CD.idControlParametro
	inner join PiscinaUbicacion pu on pu.idPiscina = CD.idPiscina
	INNER JOIN proTransferenciaEspecieDetalle PED ON PED.idPiscina = pu.idPiscina
	INNER JOIN proTransferenciaEspecie t on t.idTransferencia = PED.idTransferencia
	INNER JOIN EjecucionesPiscinaView ej on ej.idPiscina = PED.idPiscina and ej.idPiscinaEjecucion = PED.idPiscinaEjecucion
WHERE CD.idControlParametro = @idControlParametro AND PED.idTransferencia= @idTransferencia
union 
SELECT 'ORIGEN' as Tipo,EJ.estado, ej.idPiscina, ej.idPiscinaEjecucion, PU.nombreSector, PU.nombrePiscina, ej.FechaInicio, ej.FechaSiembra, ISNULL(ej.FechaCierre,GETDATE()) as FechaCierre,
cd.idPiscinaEjecucion as idPiscinaEjecucionControl, c.idControlParametro, c.fechaControl, CD.activo as activoControl,
t.idPiscinaEjecucion as idPiscinaEjecucionTransferencia,t.idTransferencia, t.fechaTransferencia
FROM proTransferenciaEspecie t
	INNER JOIN PiscinaUbicacion pu on pu.idPiscina = t.idPiscina
	 INNER JOIN proControlParametroDetalle CD on CD.idPiscina = t.idPiscina and CD.idPiscinaEjecucion = t.idPiscinaEjecucion
  	INNER JOIN proControlParametro c on c.idControlParametro = CD.idControlParametro
   INNER JOIN EjecucionesPiscinaView ej on ej.idPiscina = t.idPiscina and ej.idPiscinaEjecucion = t.idPiscinaEjecucion
WHERE t.idTransferencia = @idTransferencia AND
 c.idControlParametro   = @idControlParametro  )AS TMP_TRANS_CONTROL

 SELECT
		CASE 
			WHEN idPiscinaEjecucion = idPiscinaEjecucionControl 
				 AND idPiscinaEjecucion = idPiscinaEjecucionTransferencia
				 AND (fechaControl < FechaInicio OR fechaControl > FechaCierre)
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
		idControlParametro,
		fechaControl,
		activoControl,
		idPiscinaEjecucionTransferencia,
		idTransferencia,
		fechaTransferencia 
 FROM 
 #TMP_TRANS_CONTROL 

 