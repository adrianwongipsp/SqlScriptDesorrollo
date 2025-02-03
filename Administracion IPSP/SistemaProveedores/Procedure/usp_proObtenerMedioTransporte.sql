create procedure usp_proObtenerMedioTransporte(@Todos varchar(1))
as 
begin
select IdMedioTransporte,
Nombre,
Descripcion,
Activo
from proMedioTransporte
where Activo = coalesce(@Todos,Activo)
end