create procedure usp_genObtenerDocumento(@IdTipoDocumento int =null,@todos varchar(1)=null)
as
begin
--declare @IdTipoDocumento int =null;
--set @IdTipoDocumento = 5;
	select d.IdDocumento,
	d.IdTipoDocumento,
	d.Nombre,
	d.Activo,
	t.Nombre TipoDocumento
	from genDocumento d
	inner join genTipoDocumento t on t.IdTipoDocumento = d.IdTipoDocumento
	where d.IdTipoDocumento =coalesce(@IdTipoDocumento,d.IdTipoDocumento)
	and d.Activo = coalesce(@todos,d.Activo);
end