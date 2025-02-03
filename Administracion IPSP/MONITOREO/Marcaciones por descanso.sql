select u.Apellidos,u.Nombres,us.*,ev.Nombre Evento from UsuarioXMarcacion us
inner join evento ev on ev.idevento = us.idevento 
inner join Usuario u on u.IdUsuario = us.IdUsuario
where CAST(Fecha as date) ='2024-04-27'
and Hora between '07:00' and '09:00'
--and us.IdUsuario = 481
and IdDepartamento = 66
and u.Apellidos like'%Heredia%'
order by IdUsuario, Hora asc