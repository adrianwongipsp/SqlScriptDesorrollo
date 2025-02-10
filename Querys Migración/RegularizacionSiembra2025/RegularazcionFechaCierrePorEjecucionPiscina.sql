
--exec viewProcessCiclos 'CHURUTE30', 1


---INICIO DE PROCESO
--fechaCierre variacion 1 dias
declare @diferenciaDia INT
set		@diferenciaDia	= -2;
declare @keyPiscina VARCHAR(25)
set		@keyPiscina	 = 'LOSANGELESPC6'
declare @ciclo		VARCHAR(25)
set		@ciclo		= 7
declare @isRollBack INT
------------------------
set     @isRollBack = 1 ---!!!! 1 ACTIVADO ROLLBACK   TRATA DE ESTE EN UNO PARA NO HACER LA CASITA

BEGIN TRAN

select * from EjecucionesPiscinaView where KEYPiscina=@keyPiscina AND Ciclo >= @ciclo
--ACTUALIZO LA FECHA CON LA DIFERENCIA INDICADA
	DECLARE @FECHAFINCIERRE DATE
	DECLARE @IDPISCINA INT, @IDPISCINAEJECUCION INT, @IDPISCINAEJECUCIONSIGUIENTE INT;
	DECLARE @IDPISCINACOSECHA INT;
	DECLARE @IDTRANSAFERENCIA INT;

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
		    
     
	SELECT  TOP 1 @IDTRANSAFERENCIA = idTransferencia
			FROM proTransferenciaEspecie
			WHERE 
				idPiscina = @IDPISCINA
				AND idPiscinaEjecucion = @IDPISCINAEJECUCION
				AND esTotal = 1
				AND fechaTransferencia = (
					SELECT MAX(fechaTransferencia)
					FROM proTransferenciaEspecie
					WHERE 
						idPiscina = @IDPISCINA
						AND idPiscinaEjecucion = @IDPISCINAEJECUCION
						AND esTotal = 1
				);

	UPDATE EjecucionesPiscinaView SET FechaCierre = DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE)  WHERE KEYPiscina=@keyPiscina AND Ciclo =@ciclo
	select @IDPISCINACOSECHA as  IDPISCINACOSECHA
	print 'update cosecha'
	if(@IDPISCINACOSECHA is not  null)
	begin
		UPDATE proPiscinaCosecha    SET   fechaInicio       = DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE), 
										  fechaFin          = DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE),
										  fechaLiquidacion  = DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE)
									 WHERE idPiscinaCosecha = @IDPISCINACOSECHA  and estado ='APR'
	 end

 
	 SELECT @IDTRANSAFERENCIA AS  IDTRANSAFERENCIA
     print 'update cosecha'
	 if(@IDTRANSAFERENCIA is not null)
	 begin 
	   SELECT 'Transferencia Sin Afectar', fechaTransferencia,
					DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE)  , * FROM proTransferenciaEspecie WHERE idTransferencia = @IDTRANSAFERENCIA  and estado ='APR'
	  UPDATE proTransferenciaEspecie    SET   fechaTransferencia       = DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE)   
								 WHERE idTransferencia = @IDTRANSAFERENCIA AND 	idPiscina = @IDPISCINA
						         AND idPiscinaEjecucion = @IDPISCINAEJECUCION AND fechaTransferencia != DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE)  
								 and estado ='APR'
       SELECT 'Transferencia Afectada', fechaTransferencia,
					DATEADD(day, + @diferenciaDia, @FECHAFINCIERRE)  , * FROM proTransferenciaEspecie WHERE idTransferencia = @IDTRANSAFERENCIA  and estado ='APR'
	 END

	  print 'reset fecha cierre'
	  SELECT TOP 1 @FECHAFINCIERRE     = DATEADD(day,+ 1, FechaCierre)      
		    FROM EjecucionesPiscinaView  with(nolock)

	  WHERE keyPiscina = @keyPiscina AND Ciclo =@ciclo

	IF(@IDPISCINAEJECUCIONSIGUIENTE > 0)
	BEGIN  
		UPDATE proPiscinaEjecucion SET fechaInicio = @FECHAFINCIERRE   WHERE idPiscinaEjecucion = @IDPISCINAEJECUCIONSIGUIENTE
	    UPDATE maePiscinaCiclo     SET fecha       = @FECHAFINCIERRE   WHERE idOrigen           = @IDPISCINAEJECUCIONSIGUIENTE 
	END 

	SELECT * FROM EjecucionesPiscinaView WHERE KEYPiscina=@keyPiscina AND Ciclo >= @ciclo
	SELECT * FROM maePiscinaCiclo WHERE idOrigen           = @IDPISCINAEJECUCIONSIGUIENTE 
	IF(@isRollBack = 1)
	BEGIN 
		ROLLBACK TRAN 
	END
	ELSE
	BEGIN
		COMMIT TRAN 
	END
