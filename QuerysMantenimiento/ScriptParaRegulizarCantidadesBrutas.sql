/*SELECT * FROM proTransferenciaEspecieDetalle WHERE cantidadDeclarada < cantidadTransferida order by fechaHoraCreacion desc

SELECT * FROM proTransferenciaEspecie WHERE idTransferencia = 4044
SELECT * FROM PiscinaUbicacion WHERE nombreSector like '%santarosa%'
*/


SELECT * 
 into #tmp_respaldo_TransferenciaEspecieDetalle_db
FROM proTransferenciaEspecieDetalle WHERE cantidadDeclarada < cantidadTransferida 
--and  idTransferencia = 4044
order by fechaHoraCreacion desc
 

begin tran
 select 'ANTES'        AS PROCESO, cantidadTransferida , cantidadDeclarada, *   FROM #tmp_respaldo_TransferenciaEspecieDetalle_db WHERE cantidadDeclarada < cantidadTransferida 
	update  proTransferenciaEspecieDetalle set cantidadDeclarada = cantidadTransferida  WHERE cantidadDeclarada < cantidadTransferida  
 SELECT 'DESPUES'      AS PROCESO, cantidadTransferida , cantidadDeclarada, *   FROM proTransferenciaEspecieDetalle  WHERE cantidadDeclarada < cantidadTransferida  
 SELECT 'REGULARIZADO' AS PROCESO, cantidadTransferida , cantidadDeclarada, *   FROM proTransferenciaEspecieDetalle  WHERE idTransferenciaDetalle in (select idTransferenciaDetalle from #tmp_respaldo_TransferenciaEspecieDetalle_db)
ROLLBACK tran
