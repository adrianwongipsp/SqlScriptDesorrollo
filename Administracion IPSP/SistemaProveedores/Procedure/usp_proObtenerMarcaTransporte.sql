create procedure usp_proObtenerMarcaTransporte(@Todos varchar(1))
as 
begin
select IdMarcaTransporte,
Nombre,
Descripcion,
Activo
from proMarcaTransporte
where Activo = coalesce(@Todos,Activo)
end