DECLARE @PISCINA VARCHAR(40);
SET @PISCINA='COSTARICAII5'
declare @isRollBack INT
set     @isRollBack = 1---!!!! 1 ACTIVADO ROLLBACK   TRATA DE ESTE EN UNO PARA NO HACER LA CASITA
--exec viewProcessCiclos @PISCINA,1
begin tran
  
--drop table #temporalCicloInicial

	SELECT top 1  T1.FechaInicio, T2.Fecha_IniSec, T1.Ciclo AS CicloInsigne, T2.Ciclo as CicloArchivoSiembra, T1.idPiscina, T1.idPiscinaEjecucion, T1.idPiscinaEjecucionSiguiente, T1.keyPiscina
	into #temporalCicloInicial
	FROM EjecucionesPiscinaView T1
	INNER JOIN CICLOS_PRODUCCION T2
	  ON T1.FechaInicio = T2.Fecha_IniSec
	  AND T1.keyPiscina=T2.key_Piscina
	WHERE T1.keyPiscina= @PISCINA
	and
	T1.Ciclo != T2.Ciclo 
	order by T2.Ciclo  asc 
	
	select 'temporal', * from #temporalCicloInicial
	if not exists (	select 1 from #temporalCicloInicial)
	begin
	  select 'verificar datos de fecha Inicio'
	  return;
	end

	declare @idPiscina int, @idPiscinaEjecucion int, @fechaInicio Date;
	select top 1 @idPiscina = t1.idPiscina, @idPiscinaEjecucion =t1.idPiscinaEjecucion , @fechaInicio = t1.FechaInicio  from #temporalCicloInicial t1 

	SELECT 'CICLO ANTERIOR',* FROM maePiscinaCiclo WHERE idPiscina = @idPiscina
  
	update e set e.Ciclo = tc.CicloArchivoSiembra
			from EjecucionesPiscinaView  e inner join #temporalCicloInicial tc on tc.idPiscina = e.idPiscina and tc.idPiscinaEjecucion = e.idPiscinaEjecucion

	update e set e.Ciclo = tc.CicloArchivoSiembra
			from maePiscinaCiclo  e inner join #temporalCicloInicial tc on tc.idPiscina = e.idPiscina and tc.idPiscinaEjecucion = e.idOrigen

	 declare @cicloArranqueNuevo int; 
	 select @cicloArranqueNuevo=  e.Ciclo  
			from EjecucionesPiscinaView e with(nolock) inner join #temporalCicloInicial tc on tc.idPiscina = e.idPiscina and tc.idPiscinaEjecucion = e.idPiscinaEjecucion
    
    select @cicloArranqueNuevo as cicloArranqueNuevo
			 
	update e set  Ciclo = Ciclo + 1 
		FROM EjecucionesPiscinaView  e
		WHERE keyPiscina=@PISCINA   and e.idPiscinaEjecucion != @idPiscinaEjecucion
		and Ciclo > 0 

	update e set  Ciclo = Ciclo + 1 
	FROM maePiscinaCiclo  e
	WHERE e.idPiscina = @idPiscina 
	and e.idOrigen != @idPiscinaEjecucion
	and Ciclo > 0  and origen != 'MAN' and idOrigen != 999
	
	IF(@cicloArranqueNuevo> 1)
	BEGIN
		UPDATE maeSecuencial SET ultimaSecuencia = ultimaSecuencia +1 WHERE tabla='PiscinaCiclo'
		DECLARE @ultimaSecuencia INT
		SELECT @ultimaSecuencia =  ultimaSecuencia  FROM maeSecuencial WITH(NOLOCK) WHERE tabla='PiscinaCiclo' 

		INSERT INTO maePiscinaCiclo VALUES (@ultimaSecuencia,@idPiscina, @cicloArranqueNuevo -1, @fechaInicio,'MAN', 999, NULL, NULL, 1,
									'adminPsCam',':::1', GETDATE(),'adminPsCam',':::1', GETDATE())
	END 

	SELECT 'CICLO POSTERIOR', * FROM maePiscinaCiclo WHERE idPiscina in (select tc.idPiscina from #temporalCicloInicial tc)
	select 'Despues'
	exec viewProcessCiclos @PISCINA,1
	if(@isRollBack = 1)
	begin 
		ROLLBACK TRAN 
	end
	else
	begin
		COMMIT TRAN 
	end