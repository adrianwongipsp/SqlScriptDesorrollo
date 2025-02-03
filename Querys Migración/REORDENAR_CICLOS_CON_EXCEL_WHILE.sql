/*	GARITA		HOLANDA			LALUZ			NURACORP		PORTILLO
	TAURAI		TAURAII			TAURAIII		TAURAIV			TAURAIX
	TAURAV		TAURAVI			TAURAVII		TAURAVIII

	LOSANGELES	SANDIEGO		SANFRANCISCO	SANTABARBARA
	SANTAMONICA	SANTAROSA
	
	exec viewProcessCiclos 'RUANDA34', 1

	exec viewProcessCiclos 'CHANDUY57A', 1
	
*/  

--UPDATE proPiscinaEjecucion 
--SET estado = 'ANU', activo = 0, estacionModificacion = '::inactivado manualmente' WHERE idPiscinaEjecucion = 4302

--	SELECT 1299637 + 289362
--UPDATE proPiscinaEjecucion
--SET cantidadEntrada = 439854, 
--cantidadPerdida = (439854 + cantidadAdicional - cantidadPerdida) WHERE idPiscinaEjecucion = 2659

--update proPiscinaEjecucion
--set estado = 'ANU', activo = 0 WHERE idPiscinaEjecucion = 1891
--update proTransferenciaEspecie
--set cantidadTransferida = 3000000 where idTransferencia =2744
--update proTransferenciaEspecieDetalle
--set cantidadTransferida = 3000000 where idTransferenciaDetalle = 3833


DECLARE @SECTORFILTER VARCHAR(30) = 'CHANDUY'
DECLARE @ISROLLBACK BIT = 1

	DROP TABLE IF EXISTS #PISCINASTEMPDESF
	DROP TABLE IF EXISTS #EJECUCIONESTEMP
	BEGIN TRAN
	
		SELECT	pu.codigoZona, pu.nombreZona,  pu.codigoCamaronera, pu.nombreCamaronera, 
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
		WHERE estado in ('EJE', 'PRE') AND PU.nombreSector = @SECTORFILTER
   	
		--select *
		select keyPiscina, 0 AS PROCESADO
			INTO #PISCINASTEMPDESF
			from CICLOS_PRODUCCION cp
			left JOIN #EJECUCIONESTEMP ej on cp.Key_Piscina = ej.keyPiscina 
			WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
			AND DATEDIFF(day, cp.Fecha_Siembra, ej.fechaSiembra) BETWEEN -5 AND 5
			AND DATEDIFF(day, COALESCE(cp.Fecha_Pesca,GETDATE()), COALESCE(ej.fechaCierre,GETDATE())) BETWEEN -100 AND 100
			AND CP.Ciclo != EJ.ciclo
			group by keyPiscina;
			SELECT * FROM #PISCINASTEMPDESF
		WHILE EXISTS (select top 1 1 FROM #PISCINASTEMPDESF where PROCESADO = 0)
			begin
					select top 1 keyPiscina FROM #PISCINASTEMPDESF where PROCESADO = 0
					DECLARE @keyPiscina VARCHAR(50) = (select top 1 keyPiscina FROM #PISCINASTEMPDESF where PROCESADO = 0);
					DECLARE @idPiscina INT = 0;
					DECLARE @secuencialMaeCiclo INT = 0;
					DECLARE @fechaProceso dateTime = getdate();
					DECLARE @usuarioAudit varchar(50) = 'AdminPsCam';
			
					EXEC USP_CORREGIR_FECHA_INICIO_POR_PISCINA @keyPiscina

					drop table if exists #TEMPCICLOSMONT;

					SELECT DISTINCT C.* INTO #TEMPCICLOSMONT FROM
					(	select cp.Ciclo AS cicloExcel, ej.Ciclo AS cicloSistema, EJ.idPiscina, EJ.idPiscinaEjecucion
						from CICLOS_PRODUCCION cp 
						inner  join EjecucionesPiscinaView ej on cp.Key_Piscina = ej.keyPiscina 
											AND DATEDIFF(day, ej.FechaInicio, cp.Fecha_IniSec) BETWEEN -5 AND 5
											AND DATEDIFF(day, ej.FechaSiembra, cp.Fecha_Siembra) BETWEEN -5 AND 5
											--AND DATEDIFF(day, COALESCE(ej.FechaCierre, GETDATE()), COALESCE(cp.Fecha_Pesca, GETDATE())) BETWEEN -3 AND 3
											where keyPiscina = @keyPiscina and ej.Ciclo != 0 AND EJ.estado NOT IN ('ANU','INI')           
					) AS C 
					WHERE cicloSistema IS NOT NULL
					
					set @idPiscina = (select idPiscina from PiscinaUbicacion where KeyPiscina = @keyPiscina)

					update ej
					SET ej.ciclo = cicloExcel
					from #TEMPCICLOSMONT cp
					inner  join EjecucionesPiscinaView ej on cp.idPiscinaEjecucion = ej.idPiscinaEjecucion 

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
								set ciclo = P.ciclo - 1,
									activo = CASE WHEN P.ciclo - 1 = 1 THEN 0 ELSE 1 END 
								FROM proPiscinaEjecucion P
								INNER JOIN maePiscinaCiclo PC ON P.idPiscinaEjecucion = PC.idOrigen
									WHERE P.idPiscina = @idPiscina AND origen = 'MAN'
									AND P.ciclo = (SELECT MIN(ciclo) FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina AND ciclo != 0 AND estado IN ('EJE','PRE')
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
							
						SELECT * FROM EjecucionesPiscinaView
						WHERE idPiscina = @idPiscina
						SELECT * FROM maePiscinaCiclo
						WHERE idPiscina = @idPiscina

						UPDATE #PISCINASTEMPDESF SET PROCESADO = 1 WHERE keyPiscina = @keyPiscina
			end
			
exec usp_FiltrarPiscinaMontadasPorSector @SECTORFILTER ;
IF @ISROLLBACK = 1 BEGIN ROLLBACK END
   ELSE BEGIN COMMIT END
