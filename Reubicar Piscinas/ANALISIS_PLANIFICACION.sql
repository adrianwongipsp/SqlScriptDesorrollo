	

	
	select top 10 * from proPlanificacionSiembra        --no tiene sector
	select top 10 * from proPlanificacionSiembraDetalle --no tiene sector
	select top 10 * from proPlanificacionSiembraDetallePiscina --no tiene sector
	select top 10 * from proPlanificacionSiembraDetallePiscinaPorReceptar --no tiene sector
	select top 10 * from proPlanificacionSiembraExtra --no tiene datos ni sector
	select top 10 * from proPlanificacionSiembraPiscinaPorReceptar --no tiene sector
 --caso 1 (piscina origen precria)
 	select * from tempMigracionPiscina where idPISCINA = 307
	select top 10 * from proPlanificacionSiembra WHERE idPlanificacionSiembra = 6
 	select   * from proPlanificacionSiembraDetalle sd inner join tempMigracionPiscina t on t.idPiscina = sd.idPiscinaPrecria  where idPISCINA = 307 
--ORIGINAL: (D) TAURAIIPC38
--update maePiscina SET zona ='31', camaronera = '00064' , sector ='00005',lote='00005'   WHERE idPiscina = 307

--DESTINO: (B) TAURAIVPC38
--update maePiscina SET zona ='29', camaronera = '00002' , sector ='00009',lote='00003'   WHERE idPiscina = 307 

-----caso 2(piscina destino)--------------------------
	select * from tempMigracionPiscina where idPISCINA in( 300,303)
	select  * from proPlanificacionSiembraDetallePiscina sd inner join tempMigracionPiscina t on t.idPiscina = sd.idPiscina  where t.idPISCINA in( 300,303) and idPlanificacionSiembraDetalle = 7871
	select top 10 * from proPlanificacionSiembraDetalle WHERE idPlanificacionSiembraDetalle = 7871
	select top 10 * from proPlanificacionSiembra WHERE idPlanificacionSiembra =   1031
--ORIGINAL: (D) TAURAIIPC31 y PC34
--update maePiscina SET zona ='31', camaronera = '00064' , sector ='00005',lote='00005'   WHERE idPiscina = 300
--update maePiscina SET zona ='31', camaronera = '00064' , sector ='00005',lote='00005'   WHERE idPiscina = 303
--DESTINO: (B) TAURAIIPC31 y PC34
--update maePiscina SET zona ='29', camaronera = '00002' , sector ='00009',lote='00003'   WHERE idPiscina = 300 
--update maePiscina SET zona ='29', camaronera = '00002' , sector ='00009',lote='00003'   WHERE idPiscina = 303 