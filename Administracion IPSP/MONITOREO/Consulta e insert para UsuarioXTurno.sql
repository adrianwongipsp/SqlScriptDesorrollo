CREATE   PROCEDURE [dbo].[usp_genActualizarUsuarioXturno](
@Detalle xml,
@IdUsuario int,
@Usuario varchar(100),
@Resultado bit output
)
as
begin
begin try
BEGIN TRAN

--DECLARE @IdUsuario INT = 1
declare @permisos table(idUsuario int,idturno int, activo bit)
insert into @permisos(idUsuario,idturno,activo)
select idUsuario = Node.Data.value('(IdUsuario)[1]','int'),
				 idturno = Node.Data.value('(Idturno)[1]','int'),
				activo = Node.Data.value('(Activo)[1]','bit')
			FROM @Detalle.nodes('/DETALLE/PERMISO') Node(Data)

if(not exists(select IdUsuario from UsuarioXTurno where IdUsuario=@IdUsuario))
begin
INSERT INTO UsuarioXTurno(IdUsuario,IdTurno,IdDescanso,Activo,UsuarioCreacion,FechaCreacion)
select @IdUsuario,x.IdTurno,x.IdDescanso,ISNULL(p.activo,0)Activo ,@Usuario,GETDATE()
from DescansoXTurno x 
left join @permisos p on p.idturno = x.IdTurno
where not exists(select *from UsuarioXTurno u where u.IdTurno=p.idturno and u.IdDescanso = x.IdDescanso and u.IdUsuario = @IdUsuario)
end
else
begin
--inactiva si existen y  no vienen en la lista
update UsuarioXTurno 
set Activo = 0
,FechaModificacion = GETDATE()
where IdUsuario = @IdUsuario and Activo = 1 
and exists(select *from @permisos u where u.IdTurno= Idturno and u.IdUsuario = @IdUsuario and u.activo=0)

 --activa si existen y vienen en la lista
 UPDATE x
			SET x.Activo = 1,
				--x.UsuarioModificacion=@Usuario,
				x.FechaModificacion=GETDATE()
		    FROM UsuarioXTurno x
		    join @permisos y on  x.IdUsuario =y.idUsuario and x.IdTurno = y.idturno and y.activo=1
		    WHERE x.Activo=0 and x.IdUsuario =y.idUsuario and x.IdTurno = y.idturno and y.activo=1

--select *from UsuarioXTurno where IdUsuario =@IdUsuario;
end

COMMIT
	set @Resultado = 1

end try
begin catch
	ROLLBACK
	set @Resultado = 0
end catch
end
