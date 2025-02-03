SELECT ejv.idPiscina, 
		ejv.idPiscinaEjecucion, ejv.Piscina, ejv.Ciclo, ejv.FechaInicio, ejv.FechaSiembra, ejv.FechaCierre, ejv.CantidadEntrada, t.idTransferencia, td.idTransferenciaDetalle,
		t.fechaTransferencia, t.cantidadTransferida
FROM EjecucionesPiscinaView ejv inner join proTransferenciaEspecieDetalle td on td.idPiscina = ejv.idPiscina and td.idPiscinaEjecucion = ejv.idPiscinaEjecucion
										 inner join proTransferenciaEspecie t on t.idTransferencia = td.idTransferencia
												and t.fechaTransferencia not between  ejv.FechaSiembra and isnull(ejv.FechaCierre,getdate())
WHERE t.estado IN('APR') AND td.activo = 1 
 order by  ejv.Piscina,  ejv.Ciclo desc, FechaSiembra, fechaTransferencia;

 

select * from EjecucionesPiscinaView ejv where  
  NOT EXISTS (
 SELECT TOP 1 1 FROM proTransferenciaEspecieDetalle TD WHERE TD.idPiscinaEjecucion=ejv.idPiscinaEjecucion) and ejv.estado not in ('INI','ANU')
 AND rolPiscina IN ('ENG01') AND ejv.Ciclo > 0 AND tipoCierre NOT IN ('TRA')
 AND ejv.Ciclo NOT IN (
    SELECT MIN(ejv2.Ciclo) 
    FROM EjecucionesPiscinaView ejv2
    WHERE ejv2.IDPISCINA = ejv.IDPISCINA  AND ejv2.Ciclo > 0
    GROUP BY ejv2.IDPISCINA 
)	
AND NOT EXISTS (SELECT TOP 1 1 FROM proRecepcionEspecieDetalle rd where rd.idPiscinaEjecucion = ejv.idPiscinaEjecucion and rd.activo = 1)
ORDER BY Piscina ;  