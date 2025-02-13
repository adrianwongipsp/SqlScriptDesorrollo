  

/*************************************************************************************
  Atención: Los ciclos deben tener un fecha de inicio minima coincidente para partir
**************************************************************************************/

declare @isRollBack INT
set     @isRollBack = 1 ---!!!! 1 ACTIVADO ROLLBACK   TRATA DE ESTE EN UNO PARA NO HACER LA CASITA

DECLARE @PISCINA VARCHAR(40);
SET @PISCINA='SUECIAIIPC38'

--exec viewProcessCiclos @PISCINA,1
begin tran
   
     IF OBJECT_ID('tempdb..#temporalCicloInicial') IS NOT NULL
	BEGIN
		DROP TABLE #temporalCicloInicial;
	END

	SELECT top 1 T1.FechaInicio, T2.Fecha_IniSec, T1.Ciclo AS CicloInsigne, T2.Ciclo as CicloArchivoSiembra, T1.idPiscina, T1.idPiscinaEjecucion, T1.idPiscinaEjecucionSiguiente, T1.keyPiscina
	 into #temporalCicloInicial
	FROM EjecucionesPiscinaView T1
	INNER JOIN CICLOS_PRODUCCION T2
	  ON T1.FechaInicio = T2.Fecha_IniSec
	  AND T1.keyPiscina=T2.key_Piscina
	WHERE T1.keyPiscina= @PISCINA
	and
	T1.Ciclo != T2.Ciclo 
	order by T2.Fecha_IniSec  ASC
	
	--SELECT * FROM proPiscinaEjecucion WHERE idPiscina  IN (SELECT IDPISCINA FROM #temporalCicloInicial)
	select 'temporal', * from #temporalCicloInicial
	if not exists (	select 1 from #temporalCicloInicial)
	begin
	  select @PISCINA + ' - verificar datos de fecha Inicio'
	  return;
	end

	declare @idPiscina int, @idPiscinaEjecucion int, @fechaInicio Date;
	declare @CicloInsigne int ,  	@CicloArchivoSiembra int, @step int
 
	select top 1 @idPiscina   = t1.idPiscina, @idPiscinaEjecucion  = t1.idPiscinaEjecucion , @fechaInicio = t1.FechaInicio , 
				@CicloInsigne = CicloInsigne, @CicloArchivoSiembra = CicloArchivoSiembra
	from #temporalCicloInicial t1 

	set @step = 1;
	if(@CicloInsigne > @CicloArchivoSiembra )
	begin
		set @step = -(@CicloInsigne - @CicloArchivoSiembra);
	end
	if(@CicloInsigne < @CicloArchivoSiembra )
	begin
		set @step = +(@CicloArchivoSiembra  - @CicloInsigne );
	end

	SELECT 'CICLO ANTERIOR',* FROM maePiscinaCiclo WHERE idPiscina = @idPiscina ORDER BY fecha
  
	update e set e.Ciclo = tc.CicloArchivoSiembra
			from EjecucionesPiscinaView  e inner join #temporalCicloInicial tc on tc.idPiscina = e.idPiscina and tc.idPiscinaEjecucion = e.idPiscinaEjecucion

	update e set e.Ciclo = tc.CicloArchivoSiembra
			from maePiscinaCiclo  e inner join #temporalCicloInicial tc on tc.idPiscina = e.idPiscina and tc.idPiscinaEjecucion = e.idOrigen

	 declare @cicloArranqueNuevo int; 
	 select @cicloArranqueNuevo=  e.Ciclo  
			from EjecucionesPiscinaView e with(nolock) inner join #temporalCicloInicial tc on tc.idPiscina = e.idPiscina and tc.idPiscinaEjecucion = e.idPiscinaEjecucion
    
    select @cicloArranqueNuevo as cicloArranqueNuevo
			 
	update e set  Ciclo = Ciclo + @step 
		FROM EjecucionesPiscinaView  e
		WHERE keyPiscina=@PISCINA   and e.idPiscinaEjecucion != @idPiscinaEjecucion
		and Ciclo > 0 

	update e set  Ciclo = Ciclo  + @step 
	FROM maePiscinaCiclo  e
	WHERE e.idPiscina = @idPiscina 
	and e.idOrigen != @idPiscinaEjecucion
	and Ciclo > 0  and origen != 'MAN' and idOrigen != 999
	
	IF(@cicloArranqueNuevo> 1)
	BEGIN
		declare @cicloMan int 
		 select @cicloMan = MIN(ciclo) from maePiscinaCiclo where idPiscina=@idPiscina AND origen ='EJE' AND idOrigen!=999 and activo = 1 AND CICLO > 0

		IF NOT EXISTS(select * from maePiscinaCiclo where idPiscina=@idPiscina AND origen='MAN' AND idOrigen=999 and activo = 1 AND CICLO > 0)
		BEGIN
			UPDATE maeSecuencial SET ultimaSecuencia = ultimaSecuencia +1 WHERE tabla='PiscinaCiclo'
			DECLARE @ultimaSecuencia INT
			SELECT @ultimaSecuencia =  ultimaSecuencia  FROM maeSecuencial WITH(NOLOCK) WHERE tabla='PiscinaCiclo' 
			INSERT INTO maePiscinaCiclo VALUES (@ultimaSecuencia,@idPiscina, @cicloMan -1, @fechaInicio,'MAN', 999, NULL, NULL, 1,
										'adminPsCam',':::1', GETDATE(),'adminPsCam',':::1', GETDATE())
		END
		ELSE
		BEGIN
			UPDATE maePiscinaCiclo SET CICLO = @cicloMan -1, usuarioModificacion = 'adminPsCam',
								estacionModificacion=	':::1', fechaHoraModificacion = GETDATE() where idPiscina=@idPiscina AND origen='MAN' AND idOrigen=999 and activo = 1   
		END 
	END 

	SELECT 'CICLO POSTERIOR', * FROM maePiscinaCiclo WITH(NOLOCK) WHERE idPiscina in (select tc.idPiscina from #temporalCicloInicial tc) ORDER BY fecha
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