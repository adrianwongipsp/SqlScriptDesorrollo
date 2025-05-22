-- //**************** Caso de valores a encerar ***********************//
SELECT * 
FROM EjecucionesPiscinaView 
WHERE keyPiscina ='TAURAI71'

SELECT * 
FROM proPiscinaEjecucion 
WHERE idPiscinaEjecucion = 8216 
	AND estado ='PRE' 
	AND activo = 1 
	AND cantidadPerdida = 0
-- proPiscinaEjecucion set cantidadPerdida =  cantidadEntrada - cantidadSalida WHERE idPiscinaEjecucion = 8216 AND  idPiscina = 171 AND estado ='PRE' AND activo = 1 AND cantidadPerdida = 0 AND  cantidadSalida > 0



-- //********************** CASO DE CAMBIAR ROLES ENG01(PISCINA O ENGORDE) Y PRE01 (PRECRIAS) //********************
EXEC viewProcessCiclos 'COSTARICAI20',1

SELECT * 
FROM CICLOS_PRODUCCION 
WHERE Key_Piscina='COSTARICAI20' ORDER BY Ciclo

---REVISAR EL MAESTRO PISCINA QUE ROLES TIENE DISPONIBLE
SELECT * 
FROM maePiscina 
WHERE idPiscina= 2051

SELECT * 
FROM maePiscinaRol 
WHERE idPiscina= 2051

--TABLAS A AFECTAR (SON proPiscinaEjecucion, maePiscinaCiclo, proRecepcionEspecieDetalle Y/O Tranferencia
SELECT  * 
FROM proPiscinaEjecucion 
WHERE idPiscina=2051 
	AND idPiscinaEjecucion 
	IN (5062,5639,8545,9443,10264,11747,13053,13987,14802)	--CAMPO A MODIFICAR rolPiscina = 'PRE01'
--proPiscinaEjecucion set rolPiscina = 'PRE01' WHERE idPiscina=2051 AND idPiscinaEjecucion IN (5062,5639,8545,9443,10264,11747,13053,13987,14802) --UPDATE

SELECT  *
FROM maePiscinaCiclo 
WHERE idPiscina=2051 
	AND idOrigen 
	IN (5062,5639,8545,9443,10264,11747,13053,13987,14802)			--CAMPO A MODIFICAR rolCiclo = 'PRE01'
--update maePiscinaCiclo set rolCiclo = 'PRE01' WHERE idPiscina=2051 AND idOrigen IN (5062,5639,8545,9443,10264,11747,13053,13987,14802)

--PIDEN PRE01 -- GENERALMENTE ES proRecepcionEspecieDetalle
SELECT * 
FROM proRecepcionEspecieDetalle 
WHERE idPiscina=2051 
	AND idRecepcion 
	IN (10409,10579,9564,8211,7711,6142,4656,4657,4658,3050)			--CAMPO A MODIFICAR rolPiscina = 'PRE01'
--update proRecepcionEspecieDetalle set rolPiscina = 'PRE01' WHERE idPiscina=2051 AND idRecepcion IN (10409,10579,9564,8211,7711,6142,4656,4657,4658,3050)

--PIDEN ENG01 -- GENERALMENTE ES proTransferenciaEspecieDetalle
SELECT * 
FROM proTransferenciaEspecieDetalle 
WHERE idPiscina=2051 
  AND idTransferencia 
  IN (0,0,0)					--CAMPO A MODIFICAR rolPiscina = 'PRE01'


-- //*********************** casos de transferencias faltantes (caso normal) ************************//
--reviso datos de origen
EXEC viewProcessCiclos 'SANTAMONICAPC4', 1

SELECT * 
FROM CICLOS_PRODUCCION 
WHERE Key_Piscina='SANTAMONICAPC4'

SELECT * 
FROM TRANSFERENCIAS_PRODUCCION 
WHERE keyPiscinaOrigen='SANTAMONICAPC4'
--SANTAMONICA24.11
 
--reviso datos de destino de transferencia indicado (ejemplo SANTAMONICA24, ciclo 11, con fecha 2025-03-01)
EXEC viewProcessCiclos 'SANTAMONICA24', 1

SELECT * 
FROM CICLOS_PRODUCCION 
WHERE Key_Piscina='SANTAMONICA24'

--ejecuto el proceso de insercion de transferencia
BEGIN TRAN
--exec  USP_SCRIPTINSERTTRANSFERENCIASDESTINO 'SANTAMONICA24', '2025-03-01';
ROLLBACK TRAN

--luego verificar las cantidades de salidas de pisicina de origen (SANTAMONICAPC4) y luego la cantidad de entrada de piscina destino (SANTAMONICA24)
--como es precria
SELECT SUM(cantidadTransferida) CantidadSalida_PRE01  
FROM proTransferenciaEspecie 
WHERE idPiscina = 594 
	AND idPiscinaEjecucion = 14120 
	AND estado='APR'
-- proPiscinaEjecucion set  cantidadSalida =4298048  WHERE idPiscina = 594 AND idPiscinaEjecucion = 14120 AND estado ='PRE' AND activo = 1  
-- proPiscinaEjecucion set cantidadPerdida =  cantidadEntrada - cantidadSalida WHERE idPiscina = 594 AND idPiscinaEjecucion = 14120 AND estado ='PRE' AND activo = 1   AND  cantidadSalida > 0

SELECT SUM(D.cantidadTransferida) CantidadEntrada_ENG01  
FROM proTransferenciaEspecieDetalle D 
INNER JOIN proTransferenciaEspecie C ON C.idTransferencia = D.idTransferencia
WHERE D.idPiscina = 650 
	AND  D.idPiscinaEjecucion = 14755 
	AND activo=1

-- proPiscinaEjecucion set  cantidadEntrada =5391688  WHERE idPiscina = 650 AND idPiscinaEjecucion = 14755 AND estado ='EJE' AND activo = 1  
-- proPiscinaEjecucion set cantidadPerdida =  cantidadEntrada - cantidadSalida WHERE idPiscina = 650 AND idPiscinaEjecucion = 14755 AND estado ='EJE' AND activo = 1   

--verifcar las fechas de   cierre Y inicio ejecuntando DE PISCINA ORIGEN (SANTAMONICAPC4)  nuevamente (EJECUTAR EL SCRIPT DE SUMAR DIAS FECHA CIERRE)
EXEC viewProcessCiclos 'SANTAMONICAPC4', 1
--verifcar las fechas de siembra ejecuntando DE PISCINA destino (SANTAMONICA24 ciclo 11)  nuevamente (EJECUTAR EL SCRIPT DE SUMAR DIAS FECHA CIERRE)
EXEC viewProcessCiclos 'SANTAMONICA24', 1