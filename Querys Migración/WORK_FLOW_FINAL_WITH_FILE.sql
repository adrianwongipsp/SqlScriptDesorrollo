USE IPSPCamaroneraProduccion
GO

/*

SELECT REPLACE(nombreSector,' ','') FROM PiscinaUbicacion WHERE nombreZona = 'ASIA' GROUP BY nombreSector

exec usp_FiltrarPiscinaMontadasPorSector 'CHINA' ;
exec usp_FiltrarPiscinaMontadasPorSector 'HONGKONG' ;
exec usp_FiltrarPiscinaMontadasPorSector 'JAPON' ;
exec usp_FiltrarPiscinaMontadasPorSector 'VIETNAM' ;

exec usp_FiltrarPiscinaMontadasPorSector 'PSECTORV' ;
exec usp_FiltrarPiscinaMontadasPorSector 'PSECTORIV' ;

exec usp_FiltrarPiscinaMontadasPorSector 'PSECTORIII' ;
exec usp_FiltrarPiscinaMontadasPorSector 'PSECTORII' ;
exec usp_FiltrarPiscinaMontadasPorSector 'PSECTORI' ;
exec usp_FiltrarPiscinaMontadasPorSector 'ORGANICOP' ;

exec usp_FiltrarPiscinaMontadasPorSector 'ORGANICOCH' ;
exec usp_FiltrarPiscinaMontadasPorSector 'DPESCA' ;
exec usp_FiltrarPiscinaMontadasPorSector 'CHANDUY' ;
exec usp_FiltrarPiscinaMontadasPorSector 'CAMARPASA' ; 

exec usp_FiltrarPiscinaMontadasPorSector 'APENDICE'  ;

exec viewProcessCiclos 'CHANDUY57B', 1 
exec viewProcessCiclos 'PSECTORVII107', 1;
exec viewProcessCiclos 'COSTARICAII1', 1 
exec viewProcessCiclos 'EMIRATOSPC12B', 1
--*/

DECLARE @ISRECEPCION BIT = 0
DECLARE @ISROLLBACK BIT = 1
IF OBJECT_ID('tempdb..#tmp_filter_pescas') IS NOT NULL 
     DROP TABLE #tmp_filter_pescas; 
 select * , 0 as procesado 
 into #tmp_filter_pescas 
 from PiscinaUbicacion where keyPiscina in (
'EMIRATOS15'
)

BEGIN TRAN
DECLARE @keyPiscina varchar(50)
DECLARE @SectorPiscina varchar(50)
DECLARE @contador int = 0
DECLARE @rangoDiasSiembra int = 5
 BEGIN TRY

		
		WHILE EXISTS (SELECT TOP 1 1 FROM #tmp_filter_pescas WHERE procesado = 0)
		BEGIN
			
				set @contador = @contador + 1
				SELECT 'ITERACIÓN ' + cast(@contador as varchar (3)) AS ITERACION 
				SELECT TOP 1 @keyPiscina = keyPiscina, @SectorPiscina = REPLACE(nombreSector ,' ','') FROM #tmp_filter_pescas WHERE procesado=0

				---***************************************************************************************************----

				DECLARE      @idPiscina int ,
							 @usuario varchar(10) ,
							 @fechaProceso datetime ,
							 @displayContent bit , 
							 @idPicinaEjecucionCierre int 

				SELECT TOP 1 @idPiscina = idPiscina , @usuario = 'AdminPsCam', @fechaProceso = GETDATE() , @displayContent = 0
						FROM #tmp_filter_pescas WHERE keyPiscina= @keyPiscina

				insert into logTempPiscinaEjecucion
				select 'Antes de Regularizar' +  CAST(GETDATE() as varchar(50)) , * from proPiscinaEjecucion
				where idPiscina = @idPiscina

				-- Desactivamos la Piscina que tenga un ciclo en iniciado y que esté inactivado
				IF(SELECT count (1) FROM proPiscinaEjecucion WHERE activo = 0 AND ESTADO = 'INI' and idPiscina = @idPiscina) > 0 AND
				  (SELECT count (1) FROM proPiscinaEjecucion WHERE activo = 1 AND ESTADO = 'EJE' And idPiscina = @idPiscina) > 0
					BEGIN
					SELECT 'ELIMINÓ UN ID EJECUCION' AS MENSAJE  
						update proPiscinaEjecucion
						set estado = 'ANU'
						WHERE activo = 0 AND ESTADO = 'INI' AND idPiscina = @idPiscina
					END

				--IF EXISTS (select 1
				--		   from CICLOS_PRODUCCION cp  
				--		   inner  join EjecucionesPiscinaView ej on cp.Key_Piscina = ej.keyPiscina 
				--		   AND DATEDIFF(day, ej.FechaInicio, cp.Fecha_IniSec) BETWEEN -100 AND 100
				--		   AND DATEDIFF(day, ej.FechaSiembra, cp.Fecha_Siembra) BETWEEN -3 AND 3 
				--		   AND DATEDIFF(day, COALESCE(ej.FechaCierre, GETDATE()), COALESCE(cp.Fecha_Pesca, GETDATE())) BETWEEN -3 AND 3 
				--		   where keyPiscina = @keyPiscina and ej.Ciclo != 0 AND EJ.estado NOT IN ('ANU','INI') 
				--		   GROUP BY CP.Key_Piscina
				--		   HAVING sum(cp.Ciclo) != sum(ej.Ciclo) AND COUNT(cp.Ciclo) = COUNT(ej.Ciclo) )

					DECLARE @debeActualizar BIT
					EXEC usp_ActualizarSoloCiclos @idPiscina  = @idPiscina, @debeActualizar = @debeActualizar OUT  

					IF (@debeActualizar = 1)
					BEGIN
						SELECT 'HIZO BREAK' AS MENSAJE 

						update ej
						SET ej.ciclo = cp.Ciclo
						from CICLOS_PRODUCCION cp
						inner  join EjecucionesPiscinaView ej on cp.Key_Piscina = ej.keyPiscina 
						AND DATEDIFF(day, ej.FechaInicio, cp.Fecha_IniSec) BETWEEN -10 AND 10
						AND DATEDIFF(day, ej.FechaSiembra, cp.Fecha_Siembra) BETWEEN -3 AND 3 
						AND DATEDIFF(day, COALESCE(ej.FechaCierre, COALESCE(cp.Fecha_Pesca, GETDATE())) , 
										  COALESCE(cp.Fecha_Pesca, COALESCE(ej.FechaCierre, GETDATE()))) BETWEEN -3 AND 3 
						where keyPiscina = @keyPiscina and ej.Ciclo != 0 AND EJ.estado NOT IN ('ANU','INI') 

						update mp
						set mp.ciclo = ej.ciclo 
						   --select mp.ciclo, ej.ciclo 
						   from maePiscinaCiclo mp
						   inner join EjecucionesPiscinaView ej on mp.idOrigen = ej.idPiscinaEjecucion
						   where ej.keyPiscina = @keyPiscina

						   
			  -- select mp.ciclo, ej.ciclo from maePiscinaCiclo mp
			  --inner join EjecucionesPiscinaView ej on mp.idOrigen = ej.idPiscinaEjecucion
					--	   where ej.keyPiscina = @keyPiscina

					--	Select Cod_Ciclo, Key_Piscina,Ciclo,  Fecha_IniSec, CAST(Fecha_Siembra AS DATE) AS Fecha_Siembra,
					--		CAST(Fecha_Pesca AS DATE) AS Fecha_Pesca, Tipo, Cantidad_Sembrada, Zona, Camaronera, Piscina, 
					--		Sub_Tipo, Estatus, Hectarea, Tipo_Siembra, Fecha_Siemb_Fut, Fecha_Pesc_Fut, Densidad
					--		from CICLOS_PRODUCCION where Key_Piscina = @keyPiscina ORDER BY Ciclo DESC, Cod_Ciclo DESC

						update   #tmp_filter_pescas SET procesado  = 1 WHERE procesado = 0 and keyPiscina = @keyPiscina
						
						exec viewProcessCiclos  @keyPiscina, 1
						CONTINUE;
						--BREAK;
					END

				
				SELECT 'SIGUIEN EL WHILE' AS MENSAJE 

				EXEC PROCESS_CREATE_CYCLES_FINALLY @idPiscina			  = @idPiscina, 
												 @usuario				  = @usuario, 
												 @fechaProceso            = @fechaProceso , 
												 @displayContent          = 0,
												 @rangoDiasSiembra		  = @rangoDiasSiembra,
												 @idPicinaEjecucionCierre = @idPicinaEjecucionCierre out;
				

				update   #tmp_filter_pescas SET procesado  = 1 WHERE procesado=0 and keyPiscina =@keyPiscina
				---***************************************************************************************************----7
					
				IF (SELECT TOP 1  Tipo FROM  CICLOS_PRODUCCION  WHERE Key_Piscina = @keyPiscina) = 'PRECRIADERO'
					BEGIN
						SELECT 'ES PRECRIADERO'
						--EXEC USP_SCRIPTMOVIMIENTORECEPCIONES @SectorPiscina, @keyPiscina, 0
					END
				ELSE
					BEGIN
						SELECT 'ES ENGORDE'
						--EXEC USP_SCRIPTMOVIMIENTOTRANSFERENCIAS @keyPiscina, @SectorPiscina
					END

					SELECT * FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina

					UPDATE proPiscinaEjecucion
					SET estado = CASE WHEN  fechaSiembra is not null  AND  cantidadEntrada > 0  and fechaCierre is null   THEN 'EJE'
					WHEN  fechaSiembra is null  AND  cantidadEntrada <= 0   and fechaCierre is null   THEN 'INI'
					WHEN  fechaSiembra is not null  AND  cantidadEntrada > 0 and fechaCierre is not null   THEN 'PRE' END,
					tipoCierre = CASE 
						WHEN fechaCierre is not null and cantidadSalida > 0 and rolPiscina = 'PRE01' AND tipoCierre = '' THEN 'TRA'
						WHEN fechaCierre is not null and cantidadSalida > 0 and rolPiscina = 'ENG01' AND tipoCierre = '' THEN 'COS'
						ELSE tipoCierre END
						
					WHERE idPiscina = @idPiscina and ciclo > 0;

						IF EXISTS(select 1 from EjecucionesPiscinaView  EJ INNER JOIN  proPiscinaCosecha PC ON  PC.idPiscinaEjecucion = EJ.idPiscinaEjecucion
								 WHERE EJ.idPiscina = @idPiscina AND EJ.estado = 'PRE' AND PC.estado = 'ING' and tipoPesca = 'PES')
							begin
								SELECT 'ENTRO A ACTUALIZAR LA PESCA INICIADA'
								UPDATE pc
								set  pc.estado = 'APR',
									 pc.liquidado = 1,
									 PC.cantidadCosechada = PE.Animales,
									 PC.usuarioModificacion ='AdminPsCam',
									 pc.fechaHoraModificacion = GETDATE(),
									 pc.estacionModificacion = ':::2'
								--select * 
								FROM
										proPiscinaCosecha  pc inner join 
										EjecucionesPiscinaView EJ on ej.idPiscinaEjecucion = pc.idPiscinaEjecucion
										INNER JOIN  PESCA_PRODUCCION PE ON EJ.keyPiscina = PE.keyPiscina AND EJ.cod_ciclo = PE.Cod_ciclo
										where   EJ.estado = 'PRE' AND PC.estado = 'ING' and tipoPesca='PES' AND EJ.idPiscina = @idPiscina

							end
							
						IF EXISTS(select 1 FROM proPiscinaCosecha  pc 
							inner join EjecucionesPiscinaView EJ on ej.idPiscinaEjecucion = pc.idPiscinaEjecucion
										INNER JOIN  PESCA_PRODUCCION PE ON EJ.keyPiscina = PE.keyPiscina AND EJ.cod_ciclo = PE.Cod_ciclo
										where   EJ.estado = 'PRE' 
										AND PC.estado IN ('ING','APR') 
										AND tipoPesca='PES' AND EJ.idPiscina = @idPiscina AND liquidado = 0
										AND pe.Fecha_DS is not null
										AND DATEDIFF(day, PC.fechaFin, pe.Fecha_DS) BETWEEN -2 AND 2  )
							begin

								SELECT 'ENTRO A ACTUALIZAR LA PESCA NO LIQUIDADA'
								print 'ENTRO A ACTUALIZAR LA PESCA NO LIQUIDADA'
								UPDATE pc
								set  pc.estado = 'APR',
									 pc.liquidado = 1,
									 pc.fechaLiquidacion = pc.fechaFin,
									 PC.cantidadCosechada = PE.Animales,
									 PC.usuarioModificacion ='AdminPsCam',
									 pc.fechaHoraModificacion = GETDATE(),
									 pc.estacionModificacion = ':::2'
								--select * 
								FROM proPiscinaCosecha  pc 
								inner join EjecucionesPiscinaView EJ on ej.idPiscinaEjecucion = pc.idPiscinaEjecucion
										INNER JOIN  PESCA_PRODUCCION PE ON EJ.keyPiscina = PE.keyPiscina AND EJ.cod_ciclo = PE.Cod_ciclo
										where   EJ.estado = 'PRE' 
										AND PC.estado IN ('ING','APR') 
										AND tipoPesca='PES' AND EJ.idPiscina = @idPiscina AND liquidado = 0
										AND estadoTrabajo = 'FIN'
										AND pe.Fecha_DS is not null
										AND DATEDIFF(day, PC.fechaFin, pe.Fecha_DS) BETWEEN -2 AND 2  


							end
						

						IF EXISTS (select 1 FROM PESCA_PRODUCCION pe INNER JOIN EjecucionesPiscinaView ej on ej.cod_ciclo = pe.Cod_ciclo 
										LEFT JOIN proPiscinaCosecha pc ON ej.idPiscinaEjecucion = pc.idPiscinaEjecucion and pc.tipoPesca = 'PES' and liquidado = 1
										WHERE EJ.estado = 'PRE' AND EJ.idPiscina = @idPiscina and pc.idPiscinaCosecha is null
										AND pe.Fecha_DS is not null )
							 begin
								
								DROP TABLE IF EXISTS #PESCAPARTIALTEMP 

								SELECT 
									ROW_NUMBER ( ) OVER ( order by ej.idPiscina, ej.Ciclo)  as indice,
									ej.idPiscina, ej.idPiscinaEjecucion, ej.Ciclo, procesado = 0
								INTO #PESCAPARTIALTEMP
								FROM PESCA_PRODUCCION pe INNER JOIN EjecucionesPiscinaView ej on ej.cod_ciclo = pe.Cod_ciclo 
										LEFT JOIN proPiscinaCosecha pc ON ej.idPiscinaEjecucion = pc.idPiscinaEjecucion and pc.tipoPesca = 'PES' and liquidado = 1
										WHERE EJ.estado IN ('PRE','EJE') AND EJ.idPiscina = @idPiscina and pc.idPiscinaCosecha is null 
										AND pe.Fecha_DS is not null 

								DECLARE @ITERACIONPESCA INT = 0
								SELECT '#PESCAPARTIALTEMP' PESCAPARTIALTEMP, * FROM #PESCAPARTIALTEMP
								WHILE EXISTS (SELECT 1 FROM #PESCAPARTIALTEMP WHERE procesado = 0)
									BEGIN
									select * from #PESCAPARTIALTEMP
									SET @ITERACIONPESCA = @ITERACIONPESCA + 1;
										/*********************************************INICIO WHILE PESCA*********************************************/
										DECLARE @IDPISCINACERRAR INT, @IDPISCINAEJECUCIONCERRAR INT, @cicloCerrar INT;  
										
										set @IDPISCINACERRAR =			(select idPiscina FROM #PESCAPARTIALTEMP WHERE indice = @ITERACIONPESCA and procesado != 1)
										set @IDPISCINAEJECUCIONCERRAR = (select idPiscinaEjecucion FROM #PESCAPARTIALTEMP WHERE indice = @ITERACIONPESCA and procesado != 1)
										set @cicloCerrar =				(select Ciclo FROM #PESCAPARTIALTEMP WHERE indice = @ITERACIONPESCA and procesado != 1)

										SELECT @cicloCerrar cicloCerrar, @IDPISCINACERRAR IDPISCINACERRAR, @IDPISCINAEJECUCIONCERRAR IDPISCINAEJECUCIONCERRAR
										SELECT 'ENTRO A CERRAR PESCA POR WHILE'

										EXEC PROCESS_CREATE_PESCA_CIERRE_FINAL @idPiscinaEjecucion = @IDPISCINAEJECUCIONCERRAR, @idPiscina      = @IDPISCINACERRAR, 
																		 @fechaProceso		 = @fechaProceso,            @usuario        = @usuario, 
																		 @ciclo              = @cicloCerrar,		     @displayContent = 0--@displayContent

										update #PESCAPARTIALTEMP SET procesado = 1 WHERE indice = @ITERACIONPESCA

										/*********************************************FIN WHILE PESCA*********************************************/
									END
							 END

							IF EXISTS (  SELECT *
								FROM (
									SELECT
										idPiscina,
										SUM(CASE WHEN estado = 'PRE' THEN 1 ELSE 0 END) AS pre_count,
										SUM(CASE WHEN estado = 'EJE' THEN 1 ELSE 0 END) AS eje_count,
										SUM(CASE WHEN estado = 'INI' THEN 1 ELSE 0 END) AS ini_count
									FROM
										proPiscinaEjecucion
									where idPiscina = @idPiscina  and 
									activo = 1 and estado not in('ANU')
									GROUP BY
										idPiscina
								) AS counts
								WHERE pre_count > 0 AND eje_count = 0 AND ini_count = 0)
							BEGIN
								EXEC USP_INSERTEJECUCIONINITIAL @idPiscina
							END

							--RECALCULAMOS LA CANTIDAD DE SALIDA EN CASO DE QUE EXISTA ALGUNA PISCINA CON ROL DE PRECRIADERO
							if exists (select 1 from CICLOS_PRODUCCION WHERE Key_Piscina = @keyPiscina and Tipo = 'PRECRIADERO')
							begin 
								with cte as (select Ciclo_Origen, Cod_Ciclo_Origen, sum(Cantidad_Transf) as Cantidad_Transf
								from TRANSFERENCIAS_PRODUCCION t
								where keyPiscinaOrigen = @keyPiscina --'PSECTORVIII4A'
								group by Ciclo_Origen, Cod_Ciclo_Origen)

								update ej
								set CantidadSalida = t.Cantidad_Transf
								from cte t
								inner join EjecucionesPiscinaView ej on t.Cod_Ciclo_Origen = ej.cod_ciclo
								where keyPiscina = @keyPiscina
							end

							--RECALCULAMOS LA CANTIDAD PERDIDA 
							update proPiscinaEjecucion
							set cantidadPerdida = 
							CASE WHEN cantidadSalida <= 0 THEN 0 
								 WHEN estado = 'EJE' THEN 0
								 ELSE cantidadEntrada + cantidadAdicional - cantidadSalida END
							where idPiscina = @idPiscina --and estado = 'PRE'
				--SELECT TOP 1  * FROM  CICLOS_PRODUCCION  WHERE Key_Piscina = @keyPiscina AND Ciclo = 18
				IF (SELECT TOP 1  Tipo FROM  CICLOS_PRODUCCION  WHERE Key_Piscina = @keyPiscina) = 'PRECRIADERO'
					BEGIN
						SELECT 'ES PRECRIADERO'
							  exec USP_SCRIPTINSERTRECEPCIONES @keyPiscina, 0
					END
				ELSE
					BEGIN
						SELECT 'ES ENGORDE'
						--exec USP_SCRIPTINSERTTRANSFERENCIASDESTINO @keyPiscina, null;

					END

					/*ANULAMOS LAS TRANSFERENCIAS SOBRANTES */--COMENTADO EJV 
					--EXEC USP_ANULARTRANSFERENCIASSOBRANTES @IdPiscina
					
				---Actualizacion de ciclos
					EXEC PROCESS_UPDATE_EJECUCIONES_CONTROL			@idPiscina, 0
					EXEC PROCESS_UPDATE_EJECUCIONES_POBLACION		@idPiscina, 0
					EXEC PROCESS_UPDATE_EJECUCIONES_PESO			@idPiscina, 0
					EXEC PROCESS_UPDATE_EJECUCIONES_RECEPCION       @idPiscina, 0
					EXEC PROCESS_UPDATE_EJECUCIONES_TRANSFERENCIA	@idPiscina, 0
					exec PROCESS_UPDATE_EJECUCIONES_COSECHAS		@idPiscina, 0,0

					--SELECT P.fechaControl, PD.* FROM proControlParametroDetalle PD
					--INNER JOIN proControlParametro P ON PD.idControlParametro = P.idControlParametro
					--WHERE idPiscina = 1707 AND P.fechaControl > '2024-06-25'

				exec viewProcessCiclos  @keyPiscina, 1

				
				--SELECT * FROM proPiscinaEjecucion
				--WHERE cantidadPerdida < 0

		END
		
		IF @ISROLLBACK = 1
			BEGIN
			
				ROLLBACK TRAN
			END
		ELSE
			BEGIN
			select 'iscommit'
				COMMIT TRAN
			END
 END TRY
 BEGIN CATCH
			ROLLBACK TRAN
 -----REVERSA DE LA TRANSACCION
			SELECT  
				 ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  

				DECLARE @ErrorMessage  NVARCHAR(4000), 
						@ErrorSeverity INT, 
						@ErrorState INT;

				SELECT  @ErrorMessage  = ERROR_MESSAGE(), 
						@ErrorSeverity = ERROR_SEVERITY(), 
						@ErrorState    = ERROR_STATE();
			
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
 END CATCH
  
--SELECT * FROM EjecucionesPiscinaView WHERE keyPiscina = @keyPiscina and estado in ('INI','EJE', 'PRE') ORDER BY 1,4 DESC

--select 'EJEMPLO DE TRANS VALID' AS VALID, T.* 
--from proTransferenciaEspecieDetalle TE
--						INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
--						inner join EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = tE.idPiscinaEjecucion 
--								where ej.cod_ciclo = 'CAPULSA5.29' AND T.estado = 'APR'
--select 'EJEMPLO DE TRANS VALID' AS VALID, T.* from proTransferenciaEspecieDetalle TE
--						INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
--						inner join EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = tE.idPiscinaEjecucion 
--								where ej.cod_ciclo = 'CAPULSA5.30' AND T.estado = 'APR'
--select * from EjecucionesPiscinaView where keyPiscina = @keyPiscina order by Ciclo


	

--upd2ate proPiscinaEjecucion
--set tipoCierre = 'COS'
--WHERE idPiscinaEjecucion = 3738
--SELECT * FROM proPiscinaEjecucion where idPiscina = 2039 --idPiscinaEjecucion = 6592

--SELECT * FROM proTransferenciaEspecie WHERE idTransferencia = 2265 
--SELECT * FROM proTransferenciaEspecieDetalle WHERE idTransferencia = 2265 
