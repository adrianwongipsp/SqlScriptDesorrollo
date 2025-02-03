/*INSERT DE USUARIOS
insert into Usuario(IdUsuario,Badgenumber,Nombres,Apellidos,Activo,FechaCreacion,UsuarioCreacion)
select USERID,Badgenumber,Name,lastname,1,GETDATE(),'edgar.barrera' from USERINFO
*/

/*INSERT DE DEPARTAMENTOS
insert into Departamento(IdDepartamento,Nombre,Activo,FechaCreacion,UsuarioCreacion)
select DEPTID,DEPTNAME,1,GETDATE(),'edgar.barrera' from DEPARTMENTS
*/

/*INSERT BIOMETRICO
insert into Biometrico(IdBiometrico,IP,Puerto,Baudrate,UserCount,FingerCount,FirmWareVersion,SerialNumber,DeviceName,Alias,Activo,FechaCreacion,UsuarioCreacion)
select m.ID_Machine,m.id,m.Port,m.Baudrate,m.usercount,m.fingercount,m.FirmwareVersion,m.sn,m.device_name,m.MachineAlias,1,GETDATE(),'edgar.barrera' from Machines m
*/

/*INSERT DE LUGAR FISICO
insert into LugarFisico(IdLugar,NoLugar,Nombre,Activo,FechaCreacion,UsuarioCreacion)
select d.id_Door,d.door_no,d.door_name,1,GETDATE(),'edgar.barrera' from acc_door d
*/

/*INSERT EVENTO
insert into Evento(IdEvento,Nombre,Activo,FechaCreacion,UsuarioCreacion)
select d.id_Reader,d.reader_name,1,GETDATE(),'edgar.barrera' from acc_reader d
*/
/*INSERT LugarXEvento
insert into LugarXEvento(IdLugar,IdEvento,IdBiometrico)
select 
d.id_Door
--,d.door_name
--,r.door_id
,r.id_Reader
--,r.reader_name
--,ma.device_name
,ma.ID_Machine
from acc_door d
inner join acc_reader r on r.door_id = d.id_Door
inner join Machines ma on ma.ID_Machine = d.device_id
*/
/*INSERT DepartamentoXBiometrico
select
u.DEFAULTDEPTID
,ma.ID_Machine
into #consulta
from USERINFO u
inner join DEPARTMENTS dep on dep.DEPTID = u.DEFAULTDEPTID
inner join acc_monitor_log m on m.pin = u.Badgenumber
inner join acc_door d on d.device_id = m.device_id  AND d.door_no = m.event_point_id 
LEFT JOIN acc_reader r on r.door_id = d.id_Door and  r.reader_state = m.state
inner join Machines ma on ma.ID_Machine = d.device_id
--where CAST(m.time as date ) between '2024-03-01' and '2024-04-30'
--and CAST(m.time as time) between '12:00' and '14:00'
--and dep.DEPTNAME ='MONITOREO'
order by m.time asc

	insert into DepartamentoXBiometrico(IdDepartamento,IdBiometrico)
	select distinct 
	c.DEFAULTDEPTID,
	c.ID_Machine
	from #consulta c
	order by c.DEFAULTDEPTID

	DROP TABLE #consulta
*/

/*INSERT UsuarioXMarcacion
select u.USERID,
u.lastname,
u.name,
u.DEFAULTDEPTID,
dep.DEPTNAME
,m.time FechaMarcacion
,format(m.time,'HH:mm:ss') Hora
,m.event_point_name
,m.event_point_type
,d.door_name
,r.reader_name
,r.reader_state
,ma.ID_Machine
,ma.MachineAlias
into #consultaMarcaciones
from USERINFO u
inner join DEPARTMENTS dep on dep.DEPTID = u.DEFAULTDEPTID
inner join acc_monitor_log m on m.pin = u.Badgenumber
inner join acc_door d on d.device_id = m.device_id  AND d.door_no = m.event_point_id 
LEFT JOIN acc_reader r on r.door_id = d.id_Door and  r.reader_state = m.state
inner join Machines ma on ma.ID_Machine = d.device_id
where CAST(m.time as date ) between '2024-04-01' and '2024-06-04'
--and CAST(m.time as time) between '12:00' and '14:00'
--and dep.DEPTNAME ='MONITOREO'
order by m.time asc

insert into UsuarioXMarcacion(IdUsuario,IdDepartamento,IdBiometrico,Fecha,Hora)
select c.USERID,c.DEFAULTDEPTID,c.ID_Machine,c.FechaMarcacion,c.Hora
from #consultaMarcaciones c
order by FechaMarcacion

drop table #consultaMarcaciones



*/