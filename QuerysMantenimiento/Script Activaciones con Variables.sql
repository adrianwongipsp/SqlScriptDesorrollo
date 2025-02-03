declare @idPiscinaEjecucion int = 3482, @idPiscina int , @FechaInicio DATE = '2024-05-15' , @FechaFin DATE = '2024-06-07' 

declare @NUEVOIDEJECUCION   int = 3482
--6546

--SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (5067) select * from proPiscinaEjecucion where idPiscinaEjecucion = 5067
 ---------------CORVINEROI CAPULSA CAPULSA PC4	2004	3703	64 NUEVO id '2024-01-04'()-------------------------------------------------------------------------------------------

set @idPiscina = (SELECT top 1 idPiscina FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (@idPiscinaEjecucion))

SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (@idPiscina)

SELECT c.fechaControl,d.* FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaControl  between @FechaInicio and @FechaFin and activo = 0

SELECT c.fechaMuestreo,d.* FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE c.estado != 'ANU' and  idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 0

--  registros --CONTROL DE PARAMETROS (ACTIVAR)

 --UPDATE d set d.activo = 1, d.idPiscinaEjecucion = @NUEVOIDEJECUCION
 --FROM  proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro  WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion and 
 --fechaControl  between @FechaInicio and @FechaFin and activo = 0

------ REGISTROS --CONTROL DE PESO (ACTIVAR)
-- UPDATE d set d.activo = 1, d.idPiscinaEjecucion =  @NUEVOIDEJECUCION
-- from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo  WHERE c.estado != 'ANU' and  idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion and 
-- fechaMuestreo between @FechaInicio and @FechaFin  and activo = 0

 --UPDATE d set d.idPiscinaEjecucion =  @NUEVOIDEJECUCION
 --from proPiscinaControlPeso d WHERE  idPiscinaEjecucion = @idPiscinaEjecucion and 
 --fechaMuestreo between @FechaInicio and @FechaFin  and activo = 1

--------------------------------------------------------------------------------------------------------------------------------------------------
/********************************************************************************************************************************************************************************************************/
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 1

 
--SELECT * FROM  proPiscinaControlPoblacion WHERE idPiscinaEjecucion = @idPiscinaEjecucion  
--and fechaMuestreo between @FechaInicio and @FechaFin and activo=1
--------------------------------------------------------------------------------------------------------------------------------------------------
GO
