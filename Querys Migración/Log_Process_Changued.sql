CREATE TABLE LOG_EJECUCIONES_CICLOS_PRODUCCION
(
 Id int identity(1,1),
 IdPiscina int,
 IdPiscinaEjecucion int,
 Ciclo int,
 KeyPiscina varchar(30),
 KeyPiscinaCiclo varchar(30),
 Proceso Varchar(30),
 Estado varchar(10),
 FechaLog DateTime,
 Observacion Varchar(30)
)
go

CREATE PROCEDURE InsertLogEjecucionesCiclosProduccion
    @IdPiscina INT,
    @IdPiscinaEjecucion INT,
    @Ciclo INT,
    @KeyPiscina VARCHAR(30),
    @KeyPiscinaCiclo VARCHAR(30),
    @Proceso VARCHAR(30),
    @Estado VARCHAR(10),
    @FechaLog DATETIME,
    @Observacion VARCHAR(30)
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
        @Estado,
        @FechaLog,
        @Observacion
    );
END;
