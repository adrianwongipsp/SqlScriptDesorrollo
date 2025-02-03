 
CREATE TABLE LOG_EJECUCIONES_CICLOS_PRODUCCION
(
 Id int identity(1,1),
 IdPiscina int,
 IdPiscinaEjecucion int,
 Ciclo int,
 KeyPiscina varchar(30),
 KeyPiscinaCiclo varchar(30),
 Proceso Varchar(60),
 IdProceso  Int,
 Estado varchar(10),
 FechaLog DateTime,
 Observacion Varchar(100)
)

GO

CREATE or ALTER PROCEDURE InsertLogEjecucionesCiclosProduccion
    @IdPiscina INT,
    @IdPiscinaEjecucion INT,
    @Ciclo INT,
    @KeyPiscina VARCHAR(30),
    @KeyPiscinaCiclo VARCHAR(30),
    @Proceso VARCHAR(30),
	@IdProceso INT,
    @Estado VARCHAR(10),
    @FechaLog DATETIME,
    @Observacion VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOG_EJECUCIONES_CICLOS_PRODUCCION
    (
        IdPiscina,
        IdPiscinaEjecucion,
        Ciclo,
        KeyPiscina,
        KeyPiscinaCiclo,
        Proceso,
		IdProceso,
        Estado,
        FechaLog,
        Observacion
    )
    VALUES
    (
        @IdPiscina,
        @IdPiscinaEjecucion,
        @Ciclo,
        @KeyPiscina,
        @KeyPiscinaCiclo,
        @Proceso,
		@IdProceso,
        @Estado,
        @FechaLog,
        @Observacion
    );
END;
