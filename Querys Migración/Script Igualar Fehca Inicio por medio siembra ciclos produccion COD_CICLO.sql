 

--IGUALAR PISCINAS
BEGIN TRAN
DECLARE @ISROLLBACK BIT = 1
	DECLARE @KEYPISCINA VARCHAR(50) = 'LOSANGELES10';
	declare @DIASDIFERENCIA int =  1
--CREATE OR ALTER PROCEDURE USP_CORREGIR_FECHA_INICIO_POR_PISCINA
--(@KEYPISCINA VARCHAR(50))
--AS BEGIN

	SELECT pe.FechaInicio, c.Fecha_IniSec,pe.FechaSiembra , c.Fecha_Siembra, *
	FROM EjecucionesPiscinaView pe inner join CICLOS_PRODUCCION c on 
	DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra ) BETWEEN -@DIASDIFERENCIA AND @DIASDIFERENCIA
	--pe.FechaSiembra = c.Fecha_Siembra 
	AND c.Cod_Ciclo = pe.cod_ciclo
	AND  DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra )!= 0
	AND c.Key_Piscina = pe.keyPiscina
	where c.Key_Piscina IN (@KEYPISCINA)
	ORDER BY c.Fecha_IniSec

	UPDATE pe  SET PE.FechaInicio = c.Fecha_IniSec
	FROM EjecucionesPiscinaView pe inner join CICLOS_PRODUCCION c on 
	DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra ) BETWEEN -@DIASDIFERENCIA AND @DIASDIFERENCIA
	--pe.FechaSiembra = c.Fecha_Siembra 
	AND c.Cod_Ciclo = pe.cod_ciclo
	AND  DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra )!= 0
	AND c.Key_Piscina = pe.keyPiscina
	where c.Key_Piscina IN (@KEYPISCINA)

	UPDATE pc  SET pc.fecha = c.Fecha_IniSec
	FROM EjecucionesPiscinaView pe inner join CICLOS_PRODUCCION c on 
	DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra ) BETWEEN -@DIASDIFERENCIA AND @DIASDIFERENCIA
	--pe.FechaSiembra = c.Fecha_Siembra 
	AND c.Cod_Ciclo = pe.cod_ciclo
	AND  DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra )!= 0
	AND c.Key_Piscina = pe.keyPiscina
	inner join maePiscinaCiclo pc on pc.idOrigen = pe.idPiscinaEjecucion
	where c.Key_Piscina IN (@KEYPISCINA)

	SELECT pe.FechaInicio, c.Fecha_IniSec,pe.FechaSiembra , c.Fecha_Siembra, *
	FROM EjecucionesPiscinaView pe inner join CICLOS_PRODUCCION c on 
	DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra ) BETWEEN -@DIASDIFERENCIA AND @DIASDIFERENCIA
	--pe.FechaSiembra = c.Fecha_Siembra 
	AND c.Cod_Ciclo = pe.cod_ciclo
	AND  DATEDIFF(day, pe.FechaSiembra, c.Fecha_Siembra )!= 0
	AND c.Key_Piscina = pe.keyPiscina
	inner join maePiscinaCiclo pc on pc.idOrigen = pe.idPiscinaEjecucion
	where c.Key_Piscina IN (@KEYPISCINA)
	ORDER BY c.Fecha_IniSec

--END
 
IF @ISROLLBACK = 1 BEGIN rollback END
   ELSE BEGIN COMMIT END