USE IPSPCamaroneraProduccion
GO

begin tran
DECLARE @ISROLLBACK BIT = 1

DECLARE @keyPiscina varchar(50) = 'NURACORP67'
DECLARE @idPiscina int
DECLARE @secuencialMaeCiclo INT
DECLARE @fechaProceso dateTime = getdate()
DECLARE @usuarioAudit varchar(50) = 'AdminPsCam'

set @idPiscina = (select idPiscina from PiscinaUbicacion where KeyPiscina = @keyPiscina)

EXEC USP_CORREGIR_FECHA_INICIO_POR_PISCINA @keyPiscina

drop table if exists #TEMPCICLOSMONT;
	
	SELECT * FROM proPiscinaEjecucion
	WHERE idPiscina = @idPiscina
	SELECT * FROM maePiscinaCiclo
	WHERE idPiscina = @idPiscina
	
SELECT DISTINCT C.* INTO #TEMPCICLOSMONT FROM
(	select cp.Ciclo AS cicloExcel, ej.Ciclo AS cicloSistema, EJ.idPiscina, EJ.idPiscinaEjecucion
	from CICLOS_PRODUCCION cp 
	inner  join EjecucionesPiscinaView ej on cp.Key_Piscina = ej.keyPiscina 
						AND DATEDIFF(day, ej.FechaInicio, cp.Fecha_IniSec) BETWEEN -5 AND 5
						AND DATEDIFF(day, ej.FechaSiembra, cp.Fecha_Siembra) BETWEEN -3 AND 3
						--AND DATEDIFF(day, COALESCE(ej.FechaCierre, GETDATE()), COALESCE(cp.Fecha_Pesca, GETDATE())) BETWEEN -3 AND 3
						where keyPiscina = @keyPiscina and ej.Ciclo != 0 AND EJ.estado NOT IN ('ANU','INI')      
) AS C 
WHERE cicloSistema IS NOT NULL --AND idPiscina != 0
select * from #TEMPCICLOSMONT
						update ej
						SET ej.ciclo = cicloExcel
						from #TEMPCICLOSMONT cp
						inner  join EjecucionesPiscinaView ej on cp.idPiscinaEjecucion = ej.idPiscinaEjecucion 

						update mp
						set mp.ciclo = ej.cicloExcel 
						   --select mp.ciclo, ej.ciclo 
						   from maePiscinaCiclo mp
						   inner join #TEMPCICLOSMONT ej on mp.idOrigen = ej.idPiscinaEjecucion
						   
						   IF NOT EXISTS (select 1 from maePiscinaCiclo where  origen = 'MAN' AND idPiscina = @idPiscina )
							   BEGIN 
									SELECT 'CREAR'
									SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
									FROM	maeSecuencial 
									WHERE	tabla = 'PiscinaCiclo' 

									------- CICLO PISCINA
									INSERT INTO [dbo].[maePiscinaCiclo] (
										idPiscinaCiclo,						idPiscina,			    ciclo,		
										fecha,								origen,				    idOrigen, 
										idOrigenEquivalente,				rolCiclo,			    activo, 
										usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
										usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
									SELECT 
										@secuencialMaeCiclo,				@idPiscina,				ciclo - 1, 
										fechaInicio,						'MAN',					999, 
										null,								NULL,						1, 
										@usuarioAudit,					    '::MANUALCICLO',				@fechaProceso,
										@usuarioAudit,					    '::MANUALCICLO',				@fechaProceso
										FROM proPiscinaEjecucion
										WHERE idPiscina = @idPiscina 
										AND ciclo = (SELECT MIN(ciclo) FROM proPiscinaEjecucion WHERE idPiscina =@idPiscina AND ciclo != 0 AND estado IN ('EJE','PRE')
										GROUP BY idPiscina)

										UPDATE maeSecuencial 
										SET ultimaSecuencia = @secuencialMaeCiclo
										WHERE tabla = 'PiscinaCiclo' 
							   END
							ELSE
								BEGIN
								SELECT 'SDSD'

									update PC
									set ciclo = PC.ciclo - 1,
										activo = CASE WHEN PC.ciclo - 1 = 1 THEN 0 ELSE 1 END 
										--SELECT *
									FROM maePiscinaCiclo PC 
										WHERE PC.idPiscina = @idPiscina AND origen = 'MAN'
										AND PC.ciclo = (SELECT MIN(ciclo) FROM proPiscinaEjecucion PJT WHERE PJT.idPiscina = @idPiscina AND ciclo != 0 AND estado IN ('EJE','PRE')
										GROUP BY idPiscina) 
								END
								
							IF EXISTS (SELECT 1 FROM maePiscinaCiclo WHERE idPiscina = @idPiscina AND ORIGEN = 'MAN' AND activo = 1 AND ciclo = 0)
								BEGIN
									UPDATE maePiscinaCiclo SET activo = 0 WHERE idPiscina = @idPiscina AND ORIGEN = 'MAN' AND activo = 1 AND ciclo = 0
								END
							IF EXISTS (select 1 from maePiscinaCiclo where idPiscina = @idPiscina AND ciclo = 1
												group by idPiscina, ciclo having COUNT(ciclo) >1)
								BEGIN
									UPDATE maePiscinaCiclo SET activo = 0 WHERE idPiscina = @idPiscina AND ORIGEN = 'MAN' AND activo = 1
								END

	SELECT * FROM proPiscinaEjecucion
	WHERE idPiscina = @idPiscina
	SELECT * FROM maePiscinaCiclo
	WHERE idPiscina = @idPiscina
	
--exec usp_FiltrarPiscinaMontadasPorSector 'LALUZ' ;

IF @ISROLLBACK = 1 BEGIN rollback END
   ELSE BEGIN COMMIT END

