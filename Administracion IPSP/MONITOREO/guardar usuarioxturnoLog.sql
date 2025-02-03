begin tran
declare @permisos table(idusuario int,idturno int,activo bit,fechaAsigando date)
insert into @permisos(idusuario,idturno,activo,fechaAsigando)
values(464,1,1,'2024-04-01'),(464,2,1,'2024-04-01'),(464,3,0,null)
select *from @permisos;

--RECORRER LA TABLA DE @PERMISOS Y AL FINAL ELIMINAR EL REGISTRO CONSULTADO

insert into UsuarioXTurnoLog(IdUsuario,IdTurno,FechaTurnoAsignadoAnterior,Activo,UsuarioCreacion,FechaCreacion)
select distinct u.IdUsuario,u.IdTurno,u.FechaTurnoAsignado,1,'edgar.barrera',GETDATE()
from UsuarioXTurno u
inner join @permisos p on p.idusuario = u.IdUsuario and p.idturno = u.IdTurno
where u.IdUsuario =464
and p.Activo = 1

select *from UsuarioXTurnoLog;
rollback


