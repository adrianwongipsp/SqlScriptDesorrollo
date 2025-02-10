
--exec viewProcessCiclos 'CHURUTE29', 1


---INICIO DE PROCESO
--fechaCierre variacion 1 dias
declare @diferenciaDia INT
set		@diferenciaDia	= 2;
declare @keyPiscina VARCHAR(25)
set		@keyPiscina	 = 'CHURUTE29'
declare @ciclo		VARCHAR(25)
set		@ciclo		= 27
declare @isRollBack INT
set     @isRollBack = 1---!!!! 1 ACTIVADO ROLLBACK   TRATA DE ESTE EN UNO PARA NO HACER LA CASITA

BEGIN TRAN

select * from EjecucionesPiscinaView where KEYPiscina=@keyPiscina AND Ciclo >= @ciclo
--ACTUALIZO LA FECHA CON LA DIFERENCIA INDICADA
	DECLARE @FECHAFINCIERRE DATE
	DECLARE @IDPISCINA INT, @IDPISCINAEJECUCION INT, @IDPISCINAEJECUCIONSIGUIENTE INT;
	DECLARE @IDPISCINACOSECHA INT;

	SELECT TOP 1 @FECHAFINCIERRE     = FechaCierre,   
				 @IDPISCINA          = idPiscina, 
				 @IDPISCINAEJECUCION = idPiscinaEjecucion,
				 @IDPISCINAEJECUCIONSIGUIENTE = ISNULL(idPiscinaEjecucionSiguiente,0)
		   FROM EjecucionesPiscinaView  
		   WHERE KEYPiscina=@keyPiscina AND Ciclo =@ciclo


	SELECT @IDPISCINACOSECHA = idPiscinaCosecha 
     FROM  proPiscinaCosecha 
	 WHERE idPiscina          =  @IDPISCINA          AND 
           idPiscinaEjecucion =  @IDPISCINAEJECUCION AND 
		   fechaLiquidacion   =  @FECHAFINCIERRE     AND 
		   liquidado	      =  1
		    
     
	UPDATE EjecucionesPiscinaView SET FechaCierre = DATEADD(day, - @diferenciaDia, @FECHAFINCIERRE)  WHERE KEYPiscina=@keyPiscina AND Ciclo =@ciclo

	UPDATE proPiscinaCosecha    SET   fechaInicio       = DATEADD(day,- @diferenciaDia, @FECHAFINCIERRE), 
									  fechaFin          = DATEADD(day, - @diferenciaDia, @FECHAFINCIERRE),
									  fechaLiquidacion  = DATEADD(day, - @diferenciaDia, @FECHAFINCIERRE)
								 WHERE idPiscinaCosecha = @IDPISCINACOSECHA
	IF(@diferenciaDia > 1)
	BEGIN
		SELECT TOP 1 @FECHAFINCIERRE     = DATEADD(day,+ 1, FechaCierre)      
		    FROM EjecucionesPiscinaView  
		   WHERE keyPiscina = @keyPiscina AND Ciclo =@ciclo
	END 
 
	IF(@IDPISCINAEJECUCIONSIGUIENTE > 0)
	BEGIN  
		UPDATE proPiscinaEjecucion SET fechaInicio = @FECHAFINCIERRE  WHERE idPiscinaEjecucion = @IDPISCINAEJECUCIONSIGUIENTE
	    UPDATE maePiscinaCiclo     SET fecha      = @FECHAFINCIERRE   WHERE idOrigen           = @IDPISCINAEJECUCIONSIGUIENTE 
	END 

	select * from EjecucionesPiscinaView where KEYPiscina=@keyPiscina AND Ciclo >= @ciclo
	SELECT * FROM maePiscinaCiclo WHERE idOrigen           = @IDPISCINAEJECUCIONSIGUIENTE 
	if(@isRollBack = 1)
	begin 
		ROLLBACK TRAN 
	end
	else
	begin
		COMMIT TRAN 
	end
