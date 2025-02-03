create procedure usp_proObtenerModeloTransporte(@Todos varchar(1))
as 
begin
select IdModeloTransporte,
Nombre,
Descripcion,
Activo
from proModeloTransporte
where Activo = coalesce(@Todos,Activo)
end