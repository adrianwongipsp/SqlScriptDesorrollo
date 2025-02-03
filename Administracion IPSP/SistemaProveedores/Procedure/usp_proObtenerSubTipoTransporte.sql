create procedure usp_proObtenerSubTipoTransporte(@Todos varchar(1),@IdTipoTransporte int=null)
as 
begin
select IdSubTipoTransporte,
IdTipoTransporte,
Nombre,
Descripcion,
Activo
from proSubTipoTransporte
where Activo = coalesce(@Todos,Activo)
and IdTipoTransporte = coalesce(@IdTipoTransporte,IdTipoTransporte)
end