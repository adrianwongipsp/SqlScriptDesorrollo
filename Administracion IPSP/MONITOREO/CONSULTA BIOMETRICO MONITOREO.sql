--insert into UsuarioXMarcacion(IdUsuario,IdDepartamento,IdBiometrico,IdLugar,IdEvento,Fecha,Hora)
select 
u.USERID,
--u.lastname,
--u.name,
u.DEFAULTDEPTID,
--dep.DEPTNAME,
ma.ID_Machine
--,ma.MachineAlias
,d.id_Door
,r.id_Reader
,m.time FechaMarcacion
,format(m.time,'HH:mm:ss') Hora
--,m.event_point_name
--,m.event_point_type
--,d.door_name
--,r.reader_name
--,r.reader_state

--,ma.IP,
--ma.Port,
--ma.Baudrate,ma.device_name
from USERINFO u
inner join DEPARTMENTS dep on dep.DEPTID = u.DEFAULTDEPTID
inner join acc_monitor_log m on m.pin = u.Badgenumber
inner join acc_door d on d.device_id = m.device_id  AND d.door_no = m.event_point_id 
LEFT JOIN acc_reader r on r.door_id = d.id_Door and  r.reader_state = m.state
inner join Machines ma on ma.ID_Machine = d.device_id
where CAST(m.time as date ) between '2024-04-01' and '2024-04-30'
--and CAST(m.time as time) between '12:00' and '14:00'
--and dep.DEPTNAME ='MONITOREO'
order by m.time asc

/*select 
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
--order by ma.ID_Machine
*/