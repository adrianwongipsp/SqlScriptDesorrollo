create procedure usp_proObtenerTipoPropiedadTransporte(@Todos varchar(1))
as 
begin
select IdTipoPropiedadTransporte,
Nombre,
Descripcion,
Activo
from proTipoPropiedadTransporte
where Activo = coalesce(@Todos,Activo)
end