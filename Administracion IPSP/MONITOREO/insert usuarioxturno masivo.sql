BEGIN TRAN
declare @fechaini date ='2024-04-01'
,@fechafin date = '2024-04-30'
,@idturno int = 3
,@horaini varchar(50)
,@horafin varchar(50);
--cALCUALR HORAINICIO MIN Y HORAFIN MAX
set @horaini = (select horainicio from Turno where IdTurno =@idturno);
set @horafin = (select horafin from Turno where IdTurno =@idturno);
if(@horafin < @horaini)
	select @horaini,@horafin

select 
--us.Apellidos+' '+us.Nombres NombreCompleto
--,dep.Nombre Departamento
--,b.Alias Biometrico
--,lg.Nombre LugarFisico,
us.IdUsuario
--,uxm.IdDepartamento
--,uxm.IdBiometrico
--,uxm.IdLugar
--,uxm.IdEvento
--,ev.Nombre Evento
,CAST(uxm.Fecha as date)FechaMarcacion
,CONVERT(varchar, uxm.Hora, 108) Hora
into #consulta
from UsuarioXMarcacion uxm
inner join Usuario us on us.IdUsuario = uxm.IdUsuario
inner join Departamento dep on dep.IdDepartamento = uxm.IdDepartamento
inner join Biometrico b on b.IdBiometrico = uxm.IdBiometrico
inner join LugarFisico lg on lg.IdLugar = uxm.IdLugar
inner join Evento ev on ev.IdEvento = uxm.IdEvento
where 
--CAST(uxm.Fecha as date) between '2024-04-01' and '2024-06-05'
------and dep.Nombre = 'MONITOREO'
--and uxm.Hora between '15:00' and '22:59'
--and lg.IdLugar = 33
(
        -- Para la hora entre 23:00 y 23:59 de cada día en el rango de fechas
        CAST(uxm.Fecha AS DATE) BETWEEN '2024-04-01' AND '2024-06-04'
        AND uxm.Hora BETWEEN '23:00:00' AND '23:59:59'
    )
    OR
    (
        -- Para la hora entre 00:00 y 06:59 del día siguiente para cada día en el rango de fechas
        CAST(uxm.Fecha AS DATE) BETWEEN '2024-04-02' AND '2024-06-05'
        AND uxm.Hora BETWEEN '00:00:00' AND '06:59:59'
    )
and b.IdBiometrico=9
--and us.IdUsuario=21
group by us.IdUsuario
,uxm.Fecha,uxm.Hora

select distinct IdUsuario
from #consulta
declare @Id int=0;
while exists(select distinct IdUsuario from #consulta )
begin
select top(1) @Id = IdUsuario from #consulta

insert into UsuarioXTurno(IdUsuario,IdTurno,IdDescanso,Activo)
select @Id,x.IdTurno,x.IdDescanso,1 from DescansoXTurno x where IdTurno = 3
and not exists(select y.IdUsuario,y.IdTurno,y.IdTurno from UsuarioXTurno y where y.IdUsuario =@Id and y.IdTurno=3 and y.IdDescanso = x.IdDescanso)
delete from #consulta where IdUsuario = @Id;
end


drop table #consulta
select *from UsuarioXTurno
ROLLBACK

