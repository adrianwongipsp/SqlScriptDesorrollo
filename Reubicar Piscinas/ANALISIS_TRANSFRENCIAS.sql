SELECT * FROM proTransferenciaEspecie WHERE idTransferencia = 7715
SELECT *
INTO #T_PiscinaUbicacion
FROM PiscinaUbicacion WHERE idPiscina = 278
 SELECT * 
 INTO #T_maePiscina
 FROM maePiscina WHERE idPiscina = 278

SELECT * FROM #T_PiscinaUbicacion
SELECT * FROM parZona WHERE idZona = 30
SELECT * FROM parCamaronera WHERE idZona = 30
SELECT * FROM parSector WHERE idCamaronera = 3 AND idSector = 14
SELECT * FROM parLote WHERE idSector = 14
SELECT * FROM maePiscina WHERE idPiscina = 278
--update maePiscina SET zona ='30', camaronera = '00003' , sector ='00014',lote='00004'   WHERE idPiscina = 278
--update maePiscina SET nombre ='PC11A'   WHERE idPiscina = 278

--update maePiscina SET zona ='28', camaronera = '00001' , sector ='00079',lote='00008'   WHERE idPiscina = 278
--update maePiscina SET nombre ='PC11'   WHERE idPiscina = 278


SELECT * FROM proTransferenciaEspecieDetalle WHERE idTransferencia = 7715
SELECT *
INTO #TA_PiscinaUbicacion
FROM PiscinaUbicacion WHERE idPiscina = 243
 SELECT * 
 INTO #TA_maePiscina
 FROM maePiscina WHERE idPiscina = 243

 SELECT * FROM #TA_PiscinaUbicacion
SELECT * FROM parZona WHERE idZona = 30
SELECT * FROM parCamaronera WHERE idZona = 30
SELECT * FROM parSector WHERE idCamaronera = 3 AND idSector = 14
SELECT * FROM parLote WHERE idSector = 14
SELECT * FROM maePiscina WHERE idPiscina = 243

--update maePiscina SET zona ='30', camaronera = '00003' , sector ='00014',lote='00004'   WHERE idPiscina = 243


--update maePiscina SET zona ='28', camaronera = '00001' , sector ='00079',lote='00008'   WHERE idPiscina = 243

/***
	Hubo que modificar el html (para el reporte, para migrar debes considerar procesos de permisos de backend	 
***/