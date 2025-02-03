
DECLARE @secuencialPiscinaEjecucionSiguiente INT = 3703
DECLARE @idPiscina INT = 877
DECLARE @ciclo INT = 63
DECLARE @rol varchar(10)
DECLARE @keyPiscina varchar(10) 
DECLARE @cod_Ciclo varchar(20) ='CAPULSAPC5.81'
DECLARE @lote varchar(10) 
DECLARE @fechaInicio date 
DECLARE @fechaSiembra date 
DECLARE @CantidadSiembra INT;
GO
CREATE OR ALTER PROCEDURE USP_INSERTEJECUCIONINITIAL(
@idPiscina INT
)
AS BEGIN

	DECLARE @secuencialPiscinaEjecucion INT
	DECLARE @secuencialPiscinaEjecucionActualizar INT
	DECLARE @secuencialMaeCiclo INT
	DECLARE @fechaProceso dateTime = getdate()
	DECLARE @fechaInicio date 
	DECLARE @lote varchar(10) 
	DECLARE @usuarioAudit varchar(50) = 'AdminPsCam'

	SELECT @fechaInicio =  DATEADD(day, 1, MAX(fechaCierre))
	FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina

	SELECT @lote = codigoSector 
	FROM PiscinaUbicacion where idPiscina = @idPiscina

--BEGIN TRAN
	
	SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia + 1
	FROM	proSecuencial 
	WHERE	tabla = 'piscinaEjecucion' 

	SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
	FROM	maeSecuencial 
	WHERE	tabla = 'PiscinaCiclo' 

	------- EJECUCION PISCINA

		INSERT INTO proPiscinaEjecucion (
			idPiscinaEjecucion,				idPiscina,					 ciclo,					rolPiscina,		numEtapa,			lote,					fechaInicio, 
			fechaSiembra,					fechaCierre,				 tipoCierre,			idEspecie,		cantidadEntrada,	cantidadAdicional,		cantidadSalida, 
			cantidadPerdida,				idPiscinaEjecucionSiguiente, estado,				tieneRaleo,		tieneRepanio,		tieneCosecha,			activo, 
			usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion, 
			usuarioModificacion,			estacionModificacion,		 fechaHoraModificacion)
			VALUES (
			@secuencialPiscinaEjecucion,	@idPiscina,					 0,						'',				0,					@lote,					@fechaInicio, 
			NULL,							NULL,						'',						0,				0,					0,						0, 
			0,								NULL,						'INI',			0,					0,						0,						
			1,								@usuarioAudit,				'::MANUALCICLO',		@fechaProceso,		
			@usuarioAudit,					'::MANUALCICLO',			@fechaProceso)
		
		------- CICLO PISCINA
		INSERT INTO [dbo].[maePiscinaCiclo] (
			idPiscinaCiclo,						idPiscina,			    ciclo,		
			fecha,								origen,				    idOrigen, 
			idOrigenEquivalente,				rolCiclo,			    activo, 
			usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
			usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
		VALUES(
			@secuencialMaeCiclo,				@idPiscina,				0, 
			@fechaInicio,						'PRE',					@secuencialPiscinaEjecucion, 
			null,								'',						1, 
			@usuarioAudit,					    '::MANUALCICLO',				@fechaProceso,
			@usuarioAudit,					    '::MANUALCICLO',				@fechaProceso)
	
	select top 1 @secuencialPiscinaEjecucionActualizar = idPiscinaEjecucion 
	from proPiscinaEjecucion where idPiscina = @idPiscina order by ciclo desc

	UPDATE p 
	SET idPiscinaEjecucionSiguiente =  @secuencialPiscinaEjecucion
	from proPiscinaEjecucion p
	where idPiscinaEjecucion = @secuencialPiscinaEjecucionActualizar

	UPDATE proSecuencial 
	SET    ultimaSecuencia = @secuencialPiscinaEjecucion   
	WHERE  tabla		   = 'piscinaEjecucion' 

	UPDATE maeSecuencial 
	SET ultimaSecuencia = @secuencialMaeCiclo
	WHERE tabla = 'PiscinaCiclo' 
	END

--ROLLBACK TRAN
--COMMIT TRAN