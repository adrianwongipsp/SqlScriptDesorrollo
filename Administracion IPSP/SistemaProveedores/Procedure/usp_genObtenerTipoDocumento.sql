create procedure usp_genObtenerTipoDocumento(@todos varchar(1)=null)
as
begin
select IdTipoDocumento,
Nombre,
Descripcion,
Activo
from genTipoDocumento
where Activo = coalesce(@todos,Activo)
end