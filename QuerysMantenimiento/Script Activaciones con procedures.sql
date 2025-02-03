declare @idPiscinaEjecucion int = 5147, @idPiscina int , @FechaInicio DATE = '2024-05-28' , @FechaFin DATE = '2024-07-12'  

BEGIN TRAN

set @idPiscina = (SELECT top 1 idPiscina FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (@idPiscinaEjecucion))

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (@idPiscina)

SELECT c.fechaControl,d.* FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaControl  between @FechaInicio and @FechaFin and activo = 0

SELECT c.fechaMuestreo,d.* FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE c.estado != 'ANU' and  idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 0;

		EXEC PROCESS_UPDATE_EJECUCIONES_CONTROL_ACTIVACIONES	@idPiscina, 0;
		EXEC PROCESS_UPDATE_EJECUCIONES_POBLACION				@idPiscina, 0;
		EXEC PROCESS_UPDATE_EJECUCIONES_PESO_ACTIVACIONES		@idPiscina, 0;
		
SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (@idPiscina)

SELECT c.fechaControl,d.* FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaControl  between @FechaInicio and @FechaFin and activo = 0

SELECT c.fechaMuestreo,d.* FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE c.estado != 'ANU' and  idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 0;

rollback tran

 --COMMIT 

-- SELECT c.fechaControl,d.* FROM proControlParametro c 
--inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and idPiscina = 2375 -- and idPiscinaEjecucion = @idPiscinaEjecucion 
--and c.idControlParametro =67276