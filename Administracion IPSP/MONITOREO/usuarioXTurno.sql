ALTER PROCEDURE usp_ObtenerUsuarioXTurnoMonitoreo(@IdUsuario INT)
as 
begin
--DECLARE @IdUsuario INT = 464
SELECT 
Distinct
    @IdUsuario AS IdUsuario,
    --u.Nombres AS NombreUsuario,
    ISNULL(ut.IdTurno, t.IdTurno) AS IdTurno,
    t.Descripcion AS Turno,
    --ISNULL(dxt.IdDescanso, 0) AS IdDescanso,
    ISNULL(ut.Activo, 0) AS Activo
FROM Turno t
CROSS JOIN Usuario u
LEFT JOIN UsuarioXTurno ut ON ut.IdUsuario = @IdUsuario AND ut.IdTurno = t.IdTurno AND ut.Activo = 1
LEFT JOIN DescansoXTurno dxt ON dxt.IdTurno = t.IdTurno AND dxt.IdDescanso = ut.IdDescanso AND dxt.Activo = 1
WHERE u.IdUsuario = @IdUsuario
AND t.Activo = 1
end
