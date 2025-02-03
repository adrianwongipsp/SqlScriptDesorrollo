
--SCRIPT PARA VER CANTIDADES DESIGUALES EN TRANSFERENCIA DE PISCINAS ORIGENES
DROP TABLE IF EXISTS #TRANSINSIGNEORIGTEMP
DROP TABLE IF EXISTS #TRANSEXCELORIGTEMP
DECLARE @SECTORORIGNE VARCHAR(50) = 'CHURUTE'
select ej.idPiscina, ej.idPiscinaEjecucion, pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) cod_ciclo, keyPiscina, sum(t.cantidadTransferida) cantidadTransferida
INTO #TRANSINSIGNEORIGTEMP
from proTransferenciaEspecie t 
inner join proPiscinaEjecucion ej on t.idPiscinaEjecucion = ej.idPiscinaEjecucion
inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
where nombreZona = @SECTORORIGNE AND T.estado = 'APR'
group by ej.idPiscina, ej.idPiscinaEjecucion,pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)), keyPiscina 
ORDER BY KeyPiscina 

select Cod_Ciclo_Origen, keyPiscinaOrigen, sum(CAST(Cantidad_Transf AS INT )) as cantidadTransferida 
INTO #TRANSEXCELORIGTEMP
from TRANSFERENCIAS_PRODUCCION TP
where Zona_Origen = @SECTORORIGNE AND TP.Ciclo_Origen >= (select min(ciclo) from EjecucionesPiscinaView p where p.keyPiscina = tp.keyPiscinaOrigen) 
group by Cod_Ciclo_Origen, keyPiscinaOrigen
ORDER BY keyPiscinaOrigen 

SELECT *, TI.cantidadTransferida - TE.cantidadTransferida FROM #TRANSINSIGNEORIGTEMP TI
INNER JOIN #TRANSEXCELORIGTEMP TE ON TI.cod_ciclo = TE.Cod_Ciclo_Origen
WHERE TI.cantidadTransferida != TE.cantidadTransferida

--SCRIPT PARA VER CANTIDADES DESIGUALES EN TRANSFERENCIA DE PISCINAS ORIGENES
DROP TABLE IF EXISTS #TRANSINSIGNEDESTTEMP
DROP TABLE IF EXISTS #TRANSEXCELDESTTEMP
DECLARE @SECTORDESTI VARCHAR(50) = 'CHURUTE'

select ej.idPiscina, ej.idPiscinaEjecucion, pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)) cod_ciclo, keyPiscina, sum(td.cantidadTransferida) cantidadTransferida
INTO #TRANSINSIGNEDESTTEMP
from proTransferenciaEspecieDetalle td
inner join proTransferenciaEspecie t on td.idTransferencia = t.idTransferencia
inner join proPiscinaEjecucion ej on td.idPiscinaEjecucion = ej.idPiscinaEjecucion
inner join PiscinaUbicacion pu on ej.idPiscina = pu.idPiscina
where nombreZona = @SECTORDESTI and t.estado = 'APR'
group by ej.idPiscina, ej.idPiscinaEjecucion,pu.KeyPiscina +'.'+ cast(ej.ciclo as varchar(4)), keyPiscina 
ORDER BY KeyPiscina

select Cod_Ciclo_Destino, keyPiscinaDestino, sum(CAST(Cantidad_Transf AS INT )) cantidadTransferida
INTO #TRANSEXCELDESTTEMP
from TRANSFERENCIAS_PRODUCCION TP
where Zona_Destino = @SECTORDESTI AND TP.Ciclo_Destino >= (select min(ciclo) from EjecucionesPiscinaView p where p.keyPiscina = tp.keyPiscinaDestino) 
group by Cod_Ciclo_Destino, keyPiscinaDestino
ORDER BY keyPiscinaDestino

SELECT *, TI.cantidadTransferida - TE.cantidadTransferida FROM #TRANSINSIGNEDESTTEMP TI
INNER JOIN #TRANSEXCELDESTTEMP TE ON TI.cod_ciclo = TE.Cod_Ciclo_Destino
WHERE TI.cantidadTransferida != TE.cantidadTransferida



