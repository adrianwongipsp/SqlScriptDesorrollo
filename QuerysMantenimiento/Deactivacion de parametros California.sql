 ---------------California  SantaBarbara PISCINA 7 CICLO 9 IDEJE: 1629 NUEVO id   '2024-03-23'()-------------------------------------------------------------------------------------------
SELECT * FROM proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro
WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 and fechaControl >='2024-03-23'  and activo=1

SELECT * FROM PiscinaUbicacion    WHERE nombreCamaronera='Santa Barbara' and nombrePiscina = '7' AND idPiscina = 633
SELECT * FROM proPiscinaEjecucion WHERE idPiscina = 633 --2715 -- 

--128 registros --CONTROL DE PARAMETROS (INACTIVAR)
   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
   --and fechaControl >='2024-03-23'  and activo=1 
--128 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 --  and fechaControl >='2024-03-23'  and activo=0
 

SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 and fechaMuestreo >='2024-03-23'  and activo=1

--5 REGISTROS --CONTROL DE PESO (INACTIVAR)
 --UPDATE d set d.activo = 0 from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 --and fechaMuestreo >='2024-03-23'  and activo=1

--4 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 --and fechaMuestreo >='2024-03-23'  and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE idPiscinaEjecucion= 1629 
 and fechaMuestreo >='2024-03-23'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion= 1629 
 and fechaMuestreo >='2024-03-23'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************

 ---------------California  SantaBarbara PISCINA 7 CICLO 9 IDEJE: 1629 NUEVO id   '2024-03-23'()-------------------------------------------------------------------------------------------
SELECT * FROM proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro
WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 and fechaControl >='2024-03-23'  and activo=1

SELECT * FROM PiscinaUbicacion    WHERE nombreCamaronera='Santa Barbara' and nombrePiscina = '7' AND idPiscina = 633
SELECT * FROM proPiscinaEjecucion WHERE idPiscina = 633 --2715 -- 

--128 registros --CONTROL DE PARAMETROS (INACTIVAR)
   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
   --and fechaControl >='2024-03-23'  and activo=1 
--128 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 --  and fechaControl >='2024-03-23'  and activo=0
 

SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 and fechaMuestreo >='2024-03-23'  and activo=1

--5 REGISTROS --CONTROL DE PESO (INACTIVAR)
 --UPDATE d set d.activo = 0 from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 --and fechaMuestreo >='2024-03-23'  and activo=1

--4 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 
 --and fechaMuestreo >='2024-03-23'  and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE idPiscinaEjecucion= 1629 
 and fechaMuestreo >='2024-03-23'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion= 1629 
 and fechaMuestreo >='2024-03-23'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************

GO

 ---------------CALIFORNIA SANTA MONICA SANTA MONICA PC5 PISCINA 694 CICLO 23 IDEJE: 4899 NUEVO id '2024-04-02'()-------------------------------------------------------------------------------------------

SELECT * FROM proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro
WHERE idPiscina= 633 and idPiscinaEjecucion= 1629 and fechaControl >='2024-03-23'  and activo=1
SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (4899)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (694)

SELECT * FROM proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 694 and idPiscinaEjecucion = 4899 
and fechaControl >='2024-04-02'  and activo=1

-- 71 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 694 and idPiscinaEjecucion = 4899 
   --and fechaControl >='2024-04-02'  and activo=1

-- 71 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 694 and idPiscinaEjecucion = 4899 
--and fechaControl >='2024-04-02'  and activo=0
 

SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 694 and idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1

--5 REGISTROS --CONTROL DE PESO (INACTIVAR)
-- UPDATE d set d.activo = 0 
-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 694 and idPiscinaEjecucion = 4899 
--and fechaMuestreo >='2024-04-02'  and activo=1

--5 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 694 and idPiscinaEjecucion = 4899 
--and fechaControl >='2024-04-02' and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------

GO

 ---------------CALIFORNIA SANTA BARBARA SANTA BARBARA PC25 PISCINA 690 CICLO 19 IDEJE: 4990 NUEVO id '2024-04-01'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (4990)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (690)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 690 and idPiscinaEjecucion = 4990 
and fechaControl >='2024-04-01' and activo=1 

-- 45 registros --CONTROL DE PARAMETROS (INACTIVAR)

--   UPDATE d set d.activo = 0 from  proControlParametro c 
--   inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 690 and idPiscinaEjecucion = 4990 
--and fechaControl >='2024-04-01' and activo=1

-- 45 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 690 and idPiscinaEjecucion = 4990 
--and fechaControl >='2024-04-01' and activo=0
 

SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 690 and idPiscinaEjecucion = 4990 
and fechaMuestreo >='2024-04-01' and activo=1

--2 REGISTROS --CONTROL DE PESO (INACTIVAR)
-- UPDATE d set d.activo = 0 
-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 690 and idPiscinaEjecucion = 4990 
--and fechaMuestreo >='2024-04-01' and activo=1

--2 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 690 and idPiscinaEjecucion = 4990 
--and fechaControl >='2024-04-01' and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------

GO

 ---------------CALIFORNIA SANTA ROSA SANTA ROSA 24 PISCINA 676 CICLO 4 IDEJE: 1000 NUEVO id '2024-01-04'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (1000)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (676)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
and fechaControl >='2024-01-04' and activo=1 

-- 678 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
   --and fechaControl >='2024-01-04' and activo=1

-- 678 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
--and fechaControl >='2024-01-04' and activo=0
 
SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
and fechaMuestreo >='2024-01-04' and activo=1

--24 REGISTROS --CONTROL DE PESO (INACTIVAR)
-- UPDATE d set d.activo = 0 
-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
--and fechaMuestreo >='2024-01-04' and activo=1

--24 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
--and fechaMuestreo >='2024-01-04' and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------

GO

 ---------------CALIFORNIA SAN FRANCISCO SAN FRANCISCO PC22 PISCINA 579 CICLO 19 IDEJE: 1000 NUEVO id '2024-01-15'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (2906,3946,4867)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (579)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 579 and idPiscinaEjecucion IN (2906,3946,4867)
and fechaControl >='2024-01-15' and activo=1 

-- 341 registros --CONTROL DE PARAMETROS (INACTIVAR)

 --  UPDATE d set d.activo = 0 from  proControlParametro c 
 --  inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 579 and idPiscinaEjecucion IN (2906,3946,4867)
	--and fechaControl >='2024-01-15' and activo=1

-- 341 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 579 and idPiscinaEjecucion IN (2906,3946,4867)
	--and fechaControl >='2024-01-15' and activo=0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 579 and idPiscinaEjecucion IN (2906,3946,4867)
	and fechaMuestreo >= '2024-01-15' and activo = 1

--15 REGISTROS --CONTROL DE PESO (INACTIVAR)
 --UPDATE d set d.activo = 0 
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 579 and idPiscinaEjecucion IN (2906,3946,4867)
	--and fechaMuestreo >= '2024-01-15' and activo=1

--15 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 676 and idPiscinaEjecucion = 1000 
--and fechaMuestreo >='2024-01-04' and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------

GO

 ---------------CALIFORNIA SANTA ROSA SANTA ROSA PC32 PISCINA 701 CICLO 19 IDEJE: 4853 NUEVO id '2024-03-28'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (4853)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (701)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 701 and idPiscinaEjecucion IN (4853)
and fechaControl >='2024-03-28' and activo=1 

-- 38 registros --CONTROL DE PARAMETROS (INACTIVAR)

--   UPDATE d set d.activo = 0 from  proControlParametro c 
--   inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 701 and idPiscinaEjecucion IN (4853)
--and fechaControl >='2024-03-28' and activo=1

-- 38 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 701 and idPiscinaEjecucion IN (4853)
--and fechaControl >='2024-03-28' and activo=0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 701 and idPiscinaEjecucion IN (4853)
	and fechaMuestreo >='2024-03-28' and activo = 1

--3 REGISTROS --CONTROL DE PESO (INACTIVAR)
	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 701 and idPiscinaEjecucion IN (4853)
	--and fechaMuestreo >='2024-03-28'  and activo=1

--3 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 701 and idPiscinaEjecucion IN (4853)
	--and fechaMuestreo >='2024-03-28' and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
 
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion = 4899 
and fechaMuestreo >='2024-04-02'  and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------

GO
------------------------******************** SEGUNDA TANDA ********************------------------------

 ---------------CALIFORNIA SANTA ROSA SANTA ROSA 29 PISCINA 681 CICLO 11 IDEJE: 5284 NUEVO id '2024-04-12'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (5284)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (681)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 681 and idPiscinaEjecucion IN (5284)
and fechaControl >='2024-04-12' and activo=1 

-- 32 registros --CONTROL DE PARAMETROS (INACTIVAR)

--   UPDATE d set d.activo = 0 from  proControlParametro c 
--   inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 681 and idPiscinaEjecucion IN (5284)
--	 and fechaControl >='2024-04-12' and activo=1

-- 32 registros --CONTROL DE PARAMETROS (ACTIVAR)

--UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 681 and idPiscinaEjecucion IN (5284)
--and fechaControl >='2024-04-12' and activo=0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 681 and idPiscinaEjecucion IN (5284)
	and fechaMuestreo >='2024-04-12' and activo = 1

--0 REGISTROS --CONTROL DE PESO (INACTIVAR)
	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 681 and idPiscinaEjecucion IN (5284)
	--and fechaMuestreo >='2024-04-12' and activo=1

--0 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 681 and idPiscinaEjecucion IN (5284)
	--and fechaMuestreo >='2024-04-12'and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 5284 
and fechaMuestreo >='2024-04-12'  and activo=1
 
--------------------------------------------------------------------------------------------------------------------------------------------------
GO


 ---------------CALIFORNIA SANTA ROSA SANTA ROSA 8 PISCINA 688 CICLO 6 IDEJE: 5283 NUEVO id '2024-04-05'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (5283)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (688)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
and fechaControl >='2024-04-05' and activo = 1 

-- 12 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
   --and fechaControl >='2024-04-05' and activo = 1

-- 12 registros --CONTROL DE PARAMETROS (ACTIVAR)

--	 UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--	 FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
--   and fechaControl >='2024-04-05' and activo = 0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
	and fechaMuestreo >='2024-04-05' and activo = 1

--1 REGISTROS --CONTROL DE PESO (INACTIVAR)

	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
	--and fechaMuestreo >='2024-04-05' and activo = 1

--1 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
	--and fechaMuestreo >='2024-04-05'and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 5283 
and fechaMuestreo >='2024-04-05'  and activo = 1
 
--------------------------------------------------------------------------------------------------------------------------------------------------
GO


 ---------------CALIFORNIA SANTA ROSA SANTA ROSA 21 PISCINA 673 CICLO 5 IDEJE: 1636 NUEVO id '2024-04-02'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (1636)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (673)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 673 and idPiscinaEjecucion IN (1636)
and fechaControl >='2024-04-02' and activo = 1 

-- 84 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 673 and idPiscinaEjecucion IN (1636)
   --and fechaControl >='2024-04-02' and activo = 1 

-- 84 registros --CONTROL DE PARAMETROS (ACTIVAR)

--	 UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--	 FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 673 and idPiscinaEjecucion IN (1636)
--   and fechaControl >='2024-04-02' and activo = 0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 673 and idPiscinaEjecucion IN (1636)
	and fechaMuestreo >='2024-04-02' and activo = 1

--3 REGISTROS --CONTROL DE PESO (INACTIVAR)

	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 673 and idPiscinaEjecucion IN (1636)
	--and fechaMuestreo >='2024-04-02' and activo = 1

--3 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 688 and idPiscinaEjecucion IN (5283)
	--and fechaMuestreo >='2024-04-02'and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 5283 
and fechaMuestreo >='2024-04-02'  and activo = 1
 
--------------------------------------------------------------------------------------------------------------------------------------------------
GO

 ---------------CALIFORNIA SANTA ROSA SANTA ROSA PC34 PISCINA 599 CICLO 5 IDEJE: 4188 NUEVO id '2024-04-06'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (5145)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (599)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
and fechaControl >='2024-04-06' and activo = 1 

-- 14 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
   --and fechaControl >='2024-04-06' and activo = 1 

-- 84 registros --CONTROL DE PARAMETROS (ACTIVAR)

--	 UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--	 FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
--   and fechaControl >='2024-04-06' and activo = 0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
	and fechaMuestreo >='2024-04-06' and activo = 1

--3 REGISTROS --CONTROL DE PESO (INACTIVAR)

	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
	--and fechaMuestreo >='2024-04-06' and activo = 1

--3 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
	--and fechaMuestreo >='2024-04-06'and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 5145 
and fechaMuestreo >='2024-04-06'  and activo = 1
 
--------------------------------------------------------------------------------------------------------------------------------------------------
GO


 ---------------CALIFORNIA SANTA MONICA SANTA MONICA PC4 PISCINA 594 CICLO 22 IDEJE: 5056 NUEVO id '2024-04-05'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (5056)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (594)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 594 and idPiscinaEjecucion IN (5056)
and fechaControl >='2024-04-05' and activo = 1 

-- 36 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 594 and idPiscinaEjecucion IN (5056)
   --and fechaControl >='2024-04-05' and activo = 1 

-- 84 registros --CONTROL DE PARAMETROS (ACTIVAR)

--	 UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--	 FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
--   and fechaControl >='2024-04-06' and activo = 0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 594 and idPiscinaEjecucion IN (5056)
	and fechaMuestreo >='2024-04-05' and activo = 1

--3 REGISTROS --CONTROL DE PESO (INACTIVAR)

	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 594 and idPiscinaEjecucion IN (5056)
	--and fechaMuestreo >= '2024-04-05' and activo = 1

--3 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
	--and fechaMuestreo >='2024-04-06'and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 5145 
and fechaMuestreo >='2024-04-06'  and activo = 1
 
--------------------------------------------------------------------------------------------------------------------------------------------------
GO


 ---------------CALIFORNIA SANTA MONICA SANTA MONICA PC4 PISCINA 641 CICLO 22 IDEJE: 1603 NUEVO id '2024-03-29'()-------------------------------------------------------------------------------------------

SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (1603)

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (641)

SELECT * FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 641 and idPiscinaEjecucion IN (1603)
and fechaControl >='2024-03-29' and activo = 1 

-- 36 registros --CONTROL DE PARAMETROS (INACTIVAR)

   --UPDATE d set d.activo = 0 from  proControlParametro c 
   --inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 641 and idPiscinaEjecucion IN (1603)
   --and fechaControl >='2024-03-29' and activo = 1 

-- 84 registros --CONTROL DE PARAMETROS (ACTIVAR)

--	 UPDATE d set d.activo = 1, d.idPiscinaEjecucion = 5364  
--	 FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
--   and fechaControl >='2024-04-06' and activo = 0
 
	SELECT * FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE idPiscina = 641 and idPiscinaEjecucion IN (1603)
	and fechaMuestreo >='2024-03-29' and activo = 1

--3 REGISTROS --CONTROL DE PESO (INACTIVAR)

	-- UPDATE d set d.activo = 0 
	-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 641 and idPiscinaEjecucion IN (1603)
	--and fechaMuestreo >='2024-03-29' and activo = 1

--3 REGISTROS --CONTROL DE PESO (ACTIVAR)
 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  5364
 --from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE idPiscina = 599 and idPiscinaEjecucion IN (5145)
	--and fechaMuestreo >='2024-04-06'and activo=0
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = 5145 
and fechaMuestreo >='2024-04-06'  and activo = 1
 
--------------------------------------------------------------------------------------------------------------------------------------------------
GO