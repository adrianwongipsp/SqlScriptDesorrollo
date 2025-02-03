create procedure usp_proObtenerFormaTransporte(@Todos varchar(1))
as 
begin
select IdFormaTransporte,
Nombre,
Descripcion,
Activo
from proFormaTransporte
where Activo = coalesce(@Todos,Activo)
end