

--select idPiscina, nombreZona, nombreCamaronera, nombreZona, nombrePiscina from PiscinaUbicacion
--where idPiscina = 1711

declare @idPiscina int = 689
Select * from EjecucionesPiscinaView
where idPiscina = @idPiscina

--Recepcion (ingreso de transferencias)
select 'Recepciones' as Tipo, pu.Piscina, rd.idPiscina, rd.idPiscinaEjecucion, pu.Ciclo, r.idRecepcion, r.fechaRecepcion, r.fechaDespacho, rd.cantidadRecibida, rd.cantidadAdicional from proRecepcionEspecieDetalle rd
inner join proRecepcionEspecie r on rd.idRecepcion = r.idRecepcion
inner join EjecucionesPiscinaView pu on pu.idPiscina = rd.idPiscina
where rd.idPiscina = @idPiscina and r.estado in ('ING','APR') 

--Tranferencia de destinos por ingreso de transferencias
select 'Transferencias ingresos' as Tipo, pu.Piscina, td.idPiscina, td.idPiscinaEjecucion, pu.Ciclo, t.idTransferencia, t.fechaTransferencia, TD.cantidadTransferida, TD.cantidadDeclarada, td.pesoPromedioTransferencia, td.pesoDeclaradoTransferido, td.librasDeclaradas 
from proTransferenciaEspecie t
inner join proTransferenciaEspecieDetalle td on td.idTransferencia = t.idTransferencia
inner join EjecucionesPiscinaView pu on pu.idPiscina = td.idPiscina
where td.idPiscina = @idPiscina and t.estado in ('ING','APR')

--Tranferencia en caso tuvo salida por transferencia
select 'Transferencias salidas' as Tipo, pu.Piscina, t.idPiscina, t.idPiscinaEjecucion, pu.Ciclo, t.idTransferencia, t.fechaTransferencia, TD.cantidadTransferida, TD.cantidadDeclarada, td.pesoPromedioTransferencia, td.pesoDeclaradoTransferido, td.librasDeclaradas
from proTransferenciaEspecieDetalle td
inner join proTransferenciaEspecie t on td.idTransferencia = t.idTransferencia
inner join EjecucionesPiscinaView pu on pu.idPiscina = t.idPiscina
where t.idPiscina = @idPiscina and t.estado in ('ING','APR')

select 'Control parámetros' as Tipo, p.idControlParametro, p.fechaControl, pu.Piscina, cp.idPiscina, cp.idPiscinaEjecucion, pu.Ciclo
from proControlParametroDetalle cp
inner join proControlParametro p on cp.idControlParametro = p.idControlParametro
inner join EjecucionesPiscinaView pu on pu.idPiscina = cp.idPiscina
where cp.idPiscina = @idPiscina and p.estado in ('ING','APR') and p.fechaControl between pu.FechaIncio and coalesce(pu.FechaCierre,GETDATE())

select 'Muestreos Peso' as Tipo, p.idMuestreo, p.fechaMuestreo, pu.Piscina, cp.idPiscina, cp.idPiscinaEjecucion, pu.Ciclo, p.tipoMuestreoDetalle, p.tipoMuestreo, p.estado
from proMuestreoPesoDetalle cp
inner join proMuestreoPeso p on cp.idMuestreo = p.idMuestreo
inner join EjecucionesPiscinaView pu on pu.idPiscina = cp.idPiscina
where cp.idPiscina = @idPiscina and p.estado in ('ING','APR') and p.fechaMuestreo between pu.FechaIncio and coalesce(pu.FechaCierre,GETDATE())

select 'Contro Peso' as Tipo,pu.Piscina, idPiscina, cp.idPiscinaEjecucion, pesoGramosTotal, pesoLongitudPromedio
from proPiscinaControlPeso cp
inner join EjecucionesPiscinaView pu on pu.idPiscinaEjecucion = cp.idPiscinaEjecucion
where pu.idPiscina = @idPiscina  and CP.fechaMuestreo between pu.FechaIncio and coalesce(pu.FechaCierre,GETDATE())

select 'Muestreos Población' as Tipo, p.idMuestreo, p.fechaMuestreo, pu.Piscina, cp.idPiscina, cp.idPiscinaEjecucion, pu.Ciclo, cp.poblacionEstimada, cp.promedioNivelAgua, p.estado
from proMuestreoPoblacionDetalleLance cp
inner join proMuestreoPoblacion p on cp.idMuestreo = p.idMuestreo
inner join EjecucionesPiscinaView pu on pu.idPiscina = cp.idPiscina
where cp.idPiscina = @idPiscina and p.estado in ('ING','APR') and p.fechaMuestreo between pu.FechaIncio and coalesce(pu.FechaCierre,GETDATE())

select 'Control población' as Tipo,pu.Piscina, idPiscina, cp.idPiscinaEjecucion, cantidadTotal, poblacionEstimada
from proPiscinaControlPoblacion cp
inner join EjecucionesPiscinaView pu on pu.idPiscinaEjecucion = cp.idPiscinaEjecucion
where pu.idPiscina = @idPiscina

select 'Histogramas' as Tipo, pu.Piscina, pu.idPiscina, pu.idPiscinaEjecucion, origenHistograma, fechaMuestreo, cantidadMuestreo
from proHistograma h
inner join EjecucionesPiscinaView pu on h.idPiscina = pu.idPiscina
where h.idPiscina = @idPiscina and h.fechaMuestreo between pu.FechaIncio and coalesce(pu.FechaCierre,GETDATE())

--select * 

--select 'Cosechas' as Tipo, pu.Piscina, pu.idPiscina, pu.idPiscinaEjecucion, pu.Ciclo, pc.fechaInicio,pc.fechaFin, pc.fechaLiquidacion, pc.numeroBins
--from proPiscinaCosecha pc
--inner join EjecucionesPiscinaView pu on pc.idPiscina = pu.idPiscina
--where pc.idPiscina = @idPiscina --and pc.fechaLiquidacion between pu.FechaIncio and coalesce(pu.FechaCierre,GETDATE())

