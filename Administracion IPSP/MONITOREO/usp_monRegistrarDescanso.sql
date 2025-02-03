alter procedure usp_monRegistrarDescanso(
@IdDescanso int,
@Descripcion varchar(200),
@HoraInicio varchar(10),
@HoraFin varchar(10),
@ValorMinutos int,
@IdTurno int,
@IdTipoDescanso int,
@IdRestriccion int,
@Usuario varchar(50),
@Resultado int output,
@Error varchar(max) output
)
as
begin
BEGIN TRY
BEGIN TRAN tri
--declare @IdDescanso int=0;
if(@IdRestriccion=0)
begin
set @IdRestriccion = null;
end

--SET @IdDescanso = (SELECT IdDescanso FROM Descanso WHERE Descripcion = @Descripcion AND HoraInicio = @HoraInicio AND HoraFin = @HoraFin)

IF (@IdDescanso = 0)
BEGIN
    -- Inserción de un nuevo descanso
    SET @IdDescanso = (SELECT COALESCE(MAX(IdDescanso), 0) + 1 FROM Descanso)

    INSERT INTO Descanso(IdDescanso, Descripcion, HoraInicio, HoraFin, ValorMinutos, IdTipoDescanso, IdRestriccion, Activo, UsuarioCreacion, FechaCreacion)
    VALUES(@IdDescanso, @Descripcion, @HoraInicio, @HoraFin, @ValorMinutos, @IdTipoDescanso, @IdRestriccion, 1, @Usuario, GETDATE())

    IF @IdTurno = 0
    BEGIN
        INSERT INTO DescansoXTurno(IdTurno, IdDescanso, Activo, UsuarioCreacion, FechaCreacion)
        SELECT IdTurno, @IdDescanso, 1, @Usuario, GETDATE() FROM Turno WHERE Activo = 1
    END
    ELSE
    BEGIN
        INSERT INTO DescansoXTurno(IdTurno, IdDescanso, Activo, UsuarioCreacion, FechaCreacion)
        VALUES(@IdTurno, @IdDescanso, 1, @Usuario, GETDATE())
    END
END
ELSE
BEGIN
    -- Actualización de un descanso existente
    UPDATE Descanso
    SET Descripcion = @Descripcion,
        HoraInicio = @HoraInicio,
        HoraFin = @HoraFin,
        ValorMinutos = @ValorMinutos,
        IdTipoDescanso = @IdTipoDescanso,
        IdRestriccion = @IdRestriccion,
        Activo = 1,
        UsuarioModificacion = @Usuario,
        FechaModificacion = GETDATE()
    WHERE IdDescanso = @IdDescanso

    -- Eliminar registros existentes en DescansoXTurno
    DELETE FROM DescansoXTurno WHERE IdDescanso = @IdDescanso

    -- Reinsertar registros en DescansoXTurno
    IF @IdTurno = 0
    BEGIN
        INSERT INTO DescansoXTurno(IdTurno, IdDescanso, Activo, UsuarioCreacion, FechaCreacion)
        SELECT IdTurno, @IdDescanso, 1, @Usuario, GETDATE() FROM Turno WHERE Activo = 1
    END
    ELSE
    BEGIN
        INSERT INTO DescansoXTurno(IdTurno, IdDescanso, Activo, UsuarioCreacion, FechaCreacion)
        VALUES(@IdTurno, @IdDescanso, 1, @Usuario, GETDATE())
    END
END

SET @Resultado = 1;
COMMIT;
--ROLLBACK
END TRY
BEGIN CATCH
		ROLLBACK TRAN tri
		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
		SET @Resultado = 0;
		set @Error = ERROR_MESSAGE();
 END CATCH

end