
--select cp.Cantidad_Sembrada, ej.* from EjecucionesPiscinaView ej 
--inner join CICLOS_PRODUCCION cp on ej.cod_ciclo = cp.Cod_Ciclo
--where cp.Cantidad_Sembrada != ej.CantidadEntrada and estado = 'PRE' 

begin tran
	DECLARE @SECTOR VARCHAR(50) = 'ASIA'

	DROP TABLE if exists #IDSPISCINASEJECUCION

	select pu.KeyPiscina, cp.Cantidad_Sembrada, ej.* 
	into #IDSPISCINASEJECUCION
	from proPiscinaEjecucion ej
	inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
	inner join CICLOS_PRODUCCION cp on pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
	where ej.activo = 1 and cp.Cantidad_Sembrada != ej.CantidadEntrada and pu.nombreZona = @SECTOR

	SELECT * FROM #IDSPISCINASEJECUCION

	PRINT('STAR UPDATE')

	update ej
	set ej.cantidadEntrada = cp.Cantidad_Sembrada
	from proPiscinaEjecucion ej
	inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
	inner join CICLOS_PRODUCCION cp on pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
	where ej.activo = 1 and cp.Cantidad_Sembrada != ej.CantidadEntrada and pu.nombreZona = @SECTOR and ej.estado = 'EJE'
	
	update ej
	set ej.cantidadEntrada = cp.Cantidad_Sembrada,
		ej.cantidadPerdida = cp.Cantidad_Sembrada + ej.cantidadAdicional - ej.cantidadSalida 
	from proPiscinaEjecucion ej
	inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
	inner join CICLOS_PRODUCCION cp on pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
	where ej.activo = 1 and cp.Cantidad_Sembrada != ej.CantidadEntrada and pu.nombreZona = @SECTOR and ej.estado in ('PRE','CER')
	PRINT('FINISH UPDATE')

	select * from proPiscinaEjecucion where idPiscinaEjecucion in (select idPiscinaEjecucion from #IDSPISCINASEJECUCION)

	select pu.KeyPiscina, cp.Cantidad_Sembrada, ej.* 
	from proPiscinaEjecucion ej
	inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
	inner join CICLOS_PRODUCCION cp on pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) = cp.Cod_Ciclo
	where ej.activo = 1 and cp.Cantidad_Sembrada != ej.CantidadEntrada and pu.nombreZona = @SECTOR 

ROLLBACK
--COMMIT


--SELECT * FROM EjecucionesKey
--WHERE idPiscinaEjecucion IN (5767,5780,5782,5783,5793,5990,6560,6590,6642,6832,
--7306,7765,7766,8023,8095)


