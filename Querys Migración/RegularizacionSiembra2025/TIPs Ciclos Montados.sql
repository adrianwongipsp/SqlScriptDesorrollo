EXEC viewProcessCiclos 'TAURAIVPC3', 1 

SELECT * FROM proPiscinaEjecucion WHERE idPiscina = 370 AND Ciclo >= 54
SELECT * FROM maePiscinaCiclo WHERE idPiscina = 370 AND Ciclo >= 54
 

SELECT * FROM proPiscinaEjecucion WHERE idPiscinaEjecucion = 14751

select * from RECEPCIONES_PRODUCCION where KeyPiscina='TAURAIVPC3' and Ciclo > 51 
select * from transferencias_PRODUCCION where keyPiscinaOrigen='TAURAIVPC3' and Ciclo_Origen > 49
select * from CICLOS_PRODUCCION where Key_Piscina='TAURAIVPC3' and Ciclo > 52

--exec USP_SCRIPTINSERTRECEPCIONES 'TAURAIVPC3', 0,'2024-09-13'

--exec USP_SCRIPTINSERTTRANSFERENCIASDESTINO @keyPiscina, null;

begin tran
-- USP_SCRIPTINSERTTRANSFERENCIASORIGEN 'TAURAIVPC3', '2024-10-03','TAURAV3.14'
 rollback tran
 
 
 select ej.idPiscina, ej.idPiscinaEjecucion,   ej.cantidadSalida , t.cantidadTransferida from proPiscinaEjecucion ej inner join
 proTransferenciaEspecie t on t.idPiscina = ej.idPiscina and t.idPiscinaEjecucion = ej.idPiscinaEjecucion
 where ej.estado ='pre' and  ej.idPiscina = 370 AND Ciclo >= 52

 
 --   ej set ej.cantidadSalida = t.cantidadTransferida from proPiscinaEjecucion ej inner join
 --proTransferenciaEspecie t on t.idPiscina = ej.idPiscina and t.idPiscinaEjecucion = ej.idPiscinaEjecucion
 -- where ej.estado ='pre' and  ej.idPiscina = 370 AND Ciclo >= 52

   select  ej.cantidadPerdida  , ej.cantidadEntrada - ej.cantidadSalida from proPiscinaEjecucion ej  
 where ej.estado ='pre' and  ej.idPiscina = 370 AND Ciclo >= 52

----    ej set   ej.cantidadPerdida  = ej.cantidadEntrada - ej.cantidadSalida from proPiscinaEjecucion ej  
-- where ej.estado ='pre' and  ej.idPiscina = 370 AND Ciclo >= 52