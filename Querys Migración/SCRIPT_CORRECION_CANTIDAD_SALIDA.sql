

select cp.Cantidad_Sembrada, ej.* from EjecucionesPiscinaView ej 
inner join CICLOS_PRODUCCION cp on ej.cod_ciclo = cp.Cod_Ciclo
where CantidadSalida = 0 and estado = 'PRE' 

select cp.Animales, ej.* from EjecucionesPiscinaView ej 
inner join PESCA_PRODUCCION cp on ej.cod_ciclo = cp.Cod_Ciclo
where cantidadSalida = 0 and estado = 'PRE'  and cp.Animales is not null

select cp.Animales, ej.* 
from proPiscinaEjecucion ej
inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
inner join PESCA_PRODUCCION cp on pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
where cantidadSalida = 0 and estado = 'PRE'  and cp.Animales is not null

--ESTE SCRIPT CORRIGE LAS CANTIDAD DE SALIDA QUE CONTIENEN 0
begin tran

		DROP TABLE if exists #IDSPISCINASEJECUCION


select ej.idPiscinaEjecucion 
INTO #IDSPISCINASEJECUCION
from proPiscinaEjecucion ej
inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
inner join PESCA_PRODUCCION cp on pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
where ej.activo = 1 and cantidadSalida = 0 and estado = 'PRE'  and cp.Animales is not null 
select * from #IDSPISCINASEJECUCION
select * from proPiscinaEjecucion where idPiscinaEjecucion in (select idPiscinaEjecucion from #IDSPISCINASEJECUCION)

			update ej
			set ej.cantidadSalida = cp.Animales,
				ej.cantidadPerdida = ej.cantidadEntrada + ej.cantidadAdicional - cp.Animales 
			from proPiscinaEjecucion ej
			inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
			inner join PESCA_PRODUCCION cp on pu.KeyPiscina + '.' + cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
			where  ej.activo = 1 and cantidadSalida = 0 and estado = 'PRE' and cp.Animales is not null

select * from proPiscinaEjecucion where idPiscinaEjecucion in (select idPiscinaEjecucion from #IDSPISCINASEJECUCION)

rollback
