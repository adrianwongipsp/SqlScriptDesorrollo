--DELETE Piscinas_Desactivaciones
--Desactivaciones de piscinas mediante tabla fisica
--Sacamos la cantidad de registros de controles y pesos con una tabla física de prueba de los ids llamada (Piscinas_Desactivaciones)

SELECT  pd.idPiscinaEjecucion, pd.fechaInicio, pd.fechaFin, 
(SELECT COUNT(d.idControlParametroDetalle) FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and  idPiscinaEjecucion = pd.idPiscinaEjecucion 
and  fechaControl  between pd.fechaInicio and pd.fechaFin  and activo = 0) as NControles,
(SELECT COUNT(d.idMuestreoDetalle)  FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE c.estado != 'ANU' and  idPiscinaEjecucion = pd.idPiscinaEjecucion 
and  fechaMuestreo  between pd.fechaInicio and pd.fechaFin  and activo = 0) as NPESOS 
FROM Piscinas_Desactivaciones pd

--where idPiscinaEjecucion = 3584


SELECT  d.idPiscinaEjecucion, activo, pd.fechaInicio, pd.fechaFin, COUNT(d.idControlParametroDetalle) as NControles FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro 
inner join Piscinas_Desactivaciones pd ON d.idPiscinaEjecucion = pd.idPiscinaEjecucion 
WHERE c.estado != 'ANU' and d.idPiscinaEjecucion = pd.idPiscinaEjecucion and  fechaControl between pd.fechaInicio and  pd.fechaFin and activo = 1 
group by  d.idPiscinaEjecucion, activo, pd.fechaInicio, pd.fechaFin 

SELECT  d.idPiscinaEjecucion, activo, pd.fechaInicio, pd.fechaFin, COUNT(d.idMuestreoDetalle) as NControles FROM proMuestreoPeso c 
inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo 
inner join Piscinas_Desactivaciones pd ON d.idPiscinaEjecucion = pd.idPiscinaEjecucion 
WHERE c.estado != 'ANU' and d.idPiscinaEjecucion = pd.idPiscinaEjecucion and  fechaMuestreo between pd.fechaInicio and  pd.fechaFin and activo = 1 
group by  d.idPiscinaEjecucion, activo, pd.fechaInicio, pd.fechaFin 



begin tran

--Se creó un respaldo temporal para validación de datos
--select * intwso TEMPControlDetalle
--from proControlParametroDetalle

--select * inswto TEMPMuestreosPeso
--from proMuestreoPesoDetalle

--Mandamos a actualizar los inactivos

--upddddddate d 
--set d.activo = 0
--FROM proControlParametro c 
--inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro 
--inner join Piscinas_Desactivaciones pd ON d.idPiscinaEjecucion = pd.idPiscinaEjecucion 
--WHERE c.estado != 'ANU' and d.idPiscinaEjecucion = pd.idPiscinaEjecucion and  fechaControl between pd.fechaInicio and  pd.fechaFin and activo = 1 

--updaedkfgkjhsdponfgpdwte d 
--set d.activo = 0
-- FROM proMuestreoPeso c 
--inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo 
--inner join Piscinas_Desactivaciones pd ON d.idPiscinaEjecucion = pd.idPiscinaEjecucion 
--WHERE c.estado != 'ANU' and d.idPiscinaEjecucion = pd.idPiscinaEjecucion and  fechaMuestreo between pd.fechaInicio and  pd.fechaFin and activo = 1 


--POR PISCINA
--updsssate d 
--set d.activo = 0
--FROM proControlParametro c 
--inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro 
--inner join Piscinas_Desactivaciones pd ON d.idPiscina = pd.idPiscina
--WHERE c.estado != 'ANU' and d.idPiscina = pd.idPiscina and  fechaControl between pd.fechaInicio and  pd.fechaFin and activo = 1 and pd.NuevaEjecucion = 1

--updsssate d 
--set d.activo = 0
-- FROM proMuestreoPeso c 
--inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo 
--inner join Piscinas_Desactivaciones pd ON d.idPiscina = pd.idPiscina
--WHERE c.estado != 'ANU' and d.idPiscina = pd.idPiscina and  fechaMuestreo between pd.fechaInicio and  pd.fechaFin and activo = 1 and pd.NuevaEjecucion = 1

select pd.idPiscina, pd.idPiscinaEjecucion, pd.fechaInicio, pd.fechaFin  FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro 
inner join Piscinas_Desactivaciones pd ON d.idPiscina = pd.idPiscina
WHERE c.estado != 'ANU' and d.idPiscina = pd.idPiscina and  fechaControl between pd.fechaInicio and  pd.fechaFin and activo = 1 and pd.NuevaEjecucion = 1

select pd.idPiscina, pd.idPiscinaEjecucion, pd.fechaInicio, pd.fechaFin FROM proMuestreoPeso c 
inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo 
inner join Piscinas_Desactivaciones pd ON d.idPiscina = pd.idPiscina
WHERE c.estado != 'ANU' and d.idPiscina = pd.idPiscina and  fechaMuestreo between pd.fechaInicio and  pd.fechaFin and activo = 1 and pd.NuevaEjecucion = 1

rollback


