alter procedure usp_ObtenerDescansoXturno
as
begin
select 
t.IdTurno,
t.Descripcion Turno,
d.IdDescanso,
d.Descripcion Descanso,
d.HoraInicio + ' - '+d.HoraFin Horario
from DescansoXTurno dt
inner join Turno t on t.IdTurno = dt.IdTurno
inner join Descanso d on d.IdDescanso = dt.IdDescanso
end