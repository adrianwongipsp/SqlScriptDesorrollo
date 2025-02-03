alter procedure usp_monObtenerDescanso(@todos varchar(1)=null)
as
begin
SELECT 
	d.IdDescanso,
    d.Descripcion AS Descanso,
    d.HoraInicio AS HoraInicio,
    d.HoraFin AS HoraFin,
    CAST(d.HoraInicio AS NVARCHAR(5)) + ' - ' + CAST(d.HoraFin AS NVARCHAR(5)) AS Horario,
    d.Activo AS Activo,
    d.IdTipoDescanso AS IdTipoDescanso,
    d.IdRestriccion AS IdRestriccion,
    t.Descripcion AS TipoDescanso,
    r.Descripcion AS Restriccion,
    r.Cantidad AS Cantidad,
    d.ValorMinutos AS ValorMinutos,
    CASE 
        WHEN COUNT(tu.IdTurno) > 1 THEN 'TODOS'
        ELSE MAX(tu.Descripcion)
    END AS Turno,
    CASE 
        WHEN COUNT(tu.IdTurno) > 1 THEN 0
        ELSE MAX(tu.IdTurno)
    END AS IdTurno
FROM Descanso d
INNER JOIN TipoDescanso t ON t.IdTipoDescanso = d.IdTipoDescanso
INNER JOIN Restriccion r ON r.IdRestriccion = d.IdRestriccion
INNER JOIN DescansoXTurno dx ON dx.IdDescanso = d.IdDescanso
INNER JOIN Turno tu ON tu.IdTurno = dx.IdTurno
where d.Activo=coalesce(@todos,d.Activo)
GROUP BY 
	d.IdDescanso,
    d.Descripcion,
    d.HoraInicio,
    d.HoraFin,
    d.Activo,
    d.IdTipoDescanso,
    d.IdRestriccion,
    t.Descripcion,
    r.Descripcion,
    r.Cantidad,
    d.ValorMinutos;
end