
DECLARE @fechaProceso dateTime = getdate()
DECLARE @usuarioAudit varchar(50) = 'AdminPsCam'
DECLARE @secuencialPiscinaEjecucion INT
DECLARE @secuencialMaeCiclo INT
DECLARE @secuencialPiscinaEjecucionSiguiente INT = 3703
DECLARE @idPiscina INT
DECLARE @ciclo INT = 63
DECLARE @rol varchar(10)
DECLARE @keyPiscina varchar(10) 
DECLARE @cod_Ciclo varchar(20) ='CAPULSAPC5.81'
DECLARE @lote varchar(10) 
DECLARE @fechaInicio date 
DECLARE @fechaSiembra date 
DECLARE @FechaCierre date 
DECLARE @CantidadSiembra INT 

	SELECT @FechaCierre = Fecha_Pesca, @fechaInicio = Fecha_IniSec, @fechaSiembra = Fecha_Siembra, @CantidadSiembra = Cantidad_Sembrada, 
	@rol = CASE WHEN tipo = 'PRECRIADERO' THEN 'PRE01' WHEN tipo = 'PISCINA' THEN 'ENG01' ELSE '' END, @ciclo = Ciclo, @keyPiscina = Key_Piscina
	FROM CICLOS_PRODUCCION
	WHERE Cod_Ciclo = @cod_Ciclo

	SELECT @idPiscina = idPiscina, @lote = codigoSector FROM PiscinaUbicacion where keyPiscina = @keyPiscina
	select * from EjecucionesPiscinaView where keyPiscina = @keyPiscina  order by 1 desc

BEGIN TRAN
	
	SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia + 1
	FROM	proSecuencial 
	WHERE	tabla = 'piscinaEjecucion' 

	SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
	FROM	maeSecuencial 
	WHERE	tabla = 'PiscinaCiclo' 

	-------EJECUCION PISCINA

		INSERT INTO proPiscinaEjecucion (
			idPiscinaEjecucion,				idPiscina,					 ciclo,					rolPiscina,		numEtapa,			lote,					fechaInicio, 
			fechaSiembra,					fechaCierre,				 tipoCierre,			idEspecie,		cantidadEntrada,	cantidadAdicional,		cantidadSalida, 
			cantidadPerdida,				idPiscinaEjecucionSiguiente, estado,				tieneRaleo,		tieneRepanio,		tieneCosecha,			activo, 
			usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion, 
			usuarioModificacion,			estacionModificacion,		 fechaHoraModificacion) 
			VALUES (
			@secuencialPiscinaEjecucion,	@idPiscina,					 @ciclo,					@rol,		1,					@lote,					@fechaInicio, 
			@fechaSiembra,					@FechaCierre,				 'TRA',					 1,				@CantidadSiembra,	@CantidadSiembra + (@CantidadSiembra * .15),	0, 
			0,								@secuencialPiscinaEjecucionSiguiente,				 'PRE',			0,				0,					0,		1,
			@usuarioAudit,					'::MANUAL',						 @fechaProceso,		
			@usuarioAudit,					'::MANUAL',						 @fechaProceso)
		
		-------CICLO PISCINA
		INSERT INTO [dbo].[maePiscinaCiclo] (
			idPiscinaCiclo,						idPiscina,			    ciclo,		
			fecha,								origen,				    idOrigen, 
			idOrigenEquivalente,				rolCiclo,			    activo, 
			usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
			usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
		VALUES(
			@secuencialMaeCiclo,				@idPiscina,			@ciclo, 
			@fechaInicio,						'EJE',				@secuencialPiscinaEjecucion, 
			null,								@rol,			1, 
			@usuarioAudit,					    '::MANUAL',				@fechaProceso,
			@usuarioAudit,					    '::MANUAL',				@fechaProceso)
			
	UPDATE proSecuencial 
	SET    ultimaSecuencia = @secuencialPiscinaEjecucion   
	WHERE  tabla		   = 'piscinaEjecucion' 

	UPDATE maeSecuencial 
	SET ultimaSecuencia = @secuencialMaeCiclo
	WHERE tabla = 'PiscinaCiclo' 

	update [maePiscinaCiclo]
	set ciclo = ciclo -1
	where idPiscina = @idPiscina and origen = 'MAN'

	select * from [maePiscinaCiclo] where idPiscina = @idPiscina
	select * from EjecucionesPiscinaView where keyPiscina = @keyPiscina order by 1 desc

ROLLBACK TRAN
--COMMIT TRAN