declare @idPiscinaEjecucion int = 4945, @idPiscina int , @FechaInicio DATE = '2024-07-01' , @FechaFin DATE = '2024-07-25'


DECLARE @BORRAR BIT = 0
--SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (@idPiscinaEjecucion)
--select * from proPiscinaEjecucion where idPiscinaEjecucion = @idPiscinaEjecucion
 ---------------CORVINEROI HONDURASALTO HONDURASALTO 1	2087	3786	8   NUEVO id '2024-01-04'()-------------------------------------------------------------------------------------------
 
set @idPiscina = (SELECT top 1 idPiscina FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion IN (@idPiscinaEjecucion))
--select @idPiscina
SELECT * FROM EjecucionesPiscinaView WHERE idPiscina IN (@idPiscina) order by idPiscinaEjecucion desc, Ciclo desc

SELECT c.fechaControl, d.* FROM proControlParametro c 
inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and  fechaControl  between @FechaInicio and @FechaFin and activo = 1

SELECT c.fechaMuestreo, d.* FROM  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 1

-- 678 registros --CONTROL DE PARAMETROS (INACTIVAR)



	IF @BORRAR = 1
		BEGIN
			   UPDATE d set d.activo = 0 from  proControlParametro c 
			   inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
			   and fechaControl  between @FechaInicio and @FechaFin and activo = 1

			----24 REGISTROS --CONTROL DE PESO (INACTIVAR)
			   UPDATE d set d.activo = 0 
			   from  proMuestreoPeso c inner join proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo WHERE c.estado != 'ANU' and idPiscina = @idPiscina and idPiscinaEjecucion = @idPiscinaEjecucion 
			   and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 1

		END
--------------------------------------------------------------------------------------------------------------------------------------------------
--******************
-----***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
SELECT * FROM  proPiscinaControlPeso WHERE  idPiscinaEjecucion = @idPiscinaEjecucion 
and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 1
 
---------***NO AFECTA PAR VALIDACION PERO PARA CONTROL DE PISCINA CORRECTO***-----
--SELECT * FROM  proPiscinaControlPoblacion WHERE  idPiscinaEjecucion = @idPiscinaEjecucion 
--and fechaMuestreo between @FechaInicio and @FechaFin  and activo = 1
--------------------------------------------------------------------------------------------------------------------------------------------------
GO
