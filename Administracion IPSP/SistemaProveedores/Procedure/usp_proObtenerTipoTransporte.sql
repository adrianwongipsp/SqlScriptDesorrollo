alter procedure usp_proObtenerTipoTransporte(@Todos varchar(1),@IdMedioTransporte int=null)
as 
begin
select IdTipoTransporte,
IdMedioTransporte,
Nombre,
Descripcion,
Activo
from proTipoTransporte
where Activo = coalesce(@Todos,Activo)
and IdMedioTransporte = coalesce(@IdMedioTransporte,IdMedioTransporte)
end