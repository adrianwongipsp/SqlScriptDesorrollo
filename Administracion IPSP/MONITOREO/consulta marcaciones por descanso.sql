select
us.IdUsuario
,us.Apellidos + ' '+us.Nombres NombreCompleto
,b.Alias Biometrico
,lf.Nombre LugarFisico
,ev.Nombre Evento
,CAST(uxm.Fecha as date) FechaMarcacion
,uxm.Hora HoraMarcacion
from UsuarioXMarcacion uxm
inner join Usuario us on us.IdUsuario = uxm.IdUsuario
inner join DepartamentoXBiometrico dxb on dxb.IdBiometrico = uxm.IdBiometrico and dxb.IdDepartamento = uxm.IdDepartamento
and dxb.IdLugar = uxm.IdLugar and dxb.IdEvento = uxm.IdEvento
inner join Biometrico b on b.IdBiometrico = dxb.IdBiometrico
inner join Departamento dep on dep.IdDepartamento = dxb.IdDepartamento
inner join LugarFisico lf on lf.IdLugar = dxb.IdLugar
inner join Evento ev on ev.IdEvento = dxb.IdEvento

where CAST(uxm.Fecha as date) between '2024-04-04' and '2024-04-04'
and uxm.Hora between '07:00' and '09:00'
and b.IdBiometrico =9
and dep.Nombre ='MONITOREO'
--and us.IdUsuario=517
order by us.Apellidos, uxm.Hora