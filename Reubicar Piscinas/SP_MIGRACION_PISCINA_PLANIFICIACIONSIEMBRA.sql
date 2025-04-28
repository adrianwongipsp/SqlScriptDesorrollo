--EXEC SP_MIGRACION_PISCINA_SIEMBRA

 CREATE PROCEDURE SP_MIGRACION_PISCINA_PLANIFICACION
	@mostrarResultados bit  
 AS
 BEGIN
 --Planificacion 
  UPDATE B SET  B.lote = l.codigo,
				B.estacionModificacion = 'MIGRACION'
  FROM   tempMigracionPiscina MP INNER JOIN proPlanificacionSiembraDetalle B ON B.idPiscinaPrecria  = MP.IDPISCINA
								 INNER JOIN parLote l ON l.idLote = mp.idlote_new

  UPDATE B SET  B.lote = l.codigo,
				B.estacionModificacion = 'MIGRACION'
  FROM   tempMigracionPiscina MP INNER JOIN proPlanificacionSiembraDetallePiscina B ON B.idPiscina  = MP.IDPISCINA
								 INNER JOIN parLote l ON l.idLote = mp.idlote_new
 
   IF(@mostrarResultados = 1)
   BEGIN
		  SELECT COUNT (1) registrosAfectado, 'proPlanificacionSiembraDetalle'        as tabla 
		  FROM proPlanificacionSiembraDetalle		  WHERE estacionModificacion = 'MIGRACION'

		  SELECT COUNT (1) registrosAfectado, 'proPlanificacionSiembraDetallePiscina' as tabla 
		  FROM proPlanificacionSiembraDetallePiscina  WHERE estacionModificacion = 'MIGRACION'
   END
 END