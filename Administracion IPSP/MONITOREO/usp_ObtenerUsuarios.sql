alter procedure usp_ObtenerUsuarios(@todos varchar(1)=null)
as
begin
--declare @todos varchar(1)=null
Select distinct us.ID
,us.IdUsuario
,us.Apellidos
,us.Nombres
,us.Badgenumber
,us.Activo
,us.Apellidos+' '+us.Nombres NombreCompleto
,dep.IdDepartamento
,dep.Nombre Departamento
from Usuario us
inner join UsuarioXMarcacion uxm on uxm.IdUsuario=us.IdUsuario
inner join Departamento dep on dep.IdDepartamento = uxm.IdDepartamento
where us.Activo =coalesce(@todos,us.Activo)
and dep.IdDepartamento = 66
 
end