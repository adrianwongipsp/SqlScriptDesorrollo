 --select ej.FechaCierre, c.Fecha_Pesca from CICLOS_PRODUCCION c inner join EjecucionesPiscinaView ej on ej.cod_ciclo = c.Cod_Ciclo
 --where ej.cod_ciclo='EMIRATOS13.24'
  -- exec	viewProcessCiclos 'EMIRATOS17', 1 
  ---OJO EJECUTAR UNA SOLA VEZ -- FALTA VALIDAR CICLOS FALTANTES
 DECLARE @COD_CICLO_CERRAR VARCHAR(30) 
 DECLARE @Key_Piscina VARCHAR(30) 
 DECLARE @idTransferencia INT
 DECLARE @usarTrans BIT
 SET  @Key_Piscina = 'EMIRATOSPC12B'
 SET  @COD_CICLO_CERRAR = 'EMIRATOSPC12B.34'
 SET  @idTransferencia = 5913
 SET @usarTrans = 1  --OJO 1 ACTIVA EL ROLLBACK; SIEMPRE PROBAR EN 1  Y LUEGO DESACTIVAR¡¡¡¡
 exec	viewProcessCiclos @Key_Piscina, 1 

if @usarTrans = 1 BEGIN BEGIN TRAN END 

 declare @idPiscinaEjecucion int
 declare @idPiscinaCiclo int
 update proSecuencial set ultimaSecuencia = ultimaSecuencia + 1 where tabla = 'PiscinaEjecucion'
 update maeSecuencial set ultimaSecuencia = ultimaSecuencia + 1 where tabla = 'PiscinaCiclo'

  select top 1 @idPiscinaEjecucion = ultimaSecuencia  from proSecuencial   where tabla = 'PiscinaEjecucion'
  select top 1 @idPiscinaCiclo = ultimaSecuencia  from maeSecuencial   where tabla = 'PiscinaCiclo'

  -- select top 1 @idPiscinaEjecucion = ultimaSecuencia + 1  from proSecuencial   where tabla = 'PiscinaEjecucion'
  --select top 1 @idPiscinaCiclo = ultimaSecuencia +1  from maeSecuencial   where tabla = 'PiscinaCiclo'

 INSERT INTO proPiscinaEjecucion (
idPiscinaEjecucion,			  idPiscina,         ciclo,
rolPiscina,					  numEtapa,			 lote,				fechaInicio,		 fechaSiembra,			fechaCierre,
tipoCierre,					  idEspecie,         cantidadEntrada,   cantidadAdicional,   cantidadSalida,		cantidadPerdida,     
idPiscinaEjecucionSiguiente,  estado,			 tieneRaleo,		tieneRepanio,		 tieneCosecha,			activo,
usuarioCreacion,			  estacionCreacion,  fechaHoraCreacion, usuarioModificacion, estacionModificacion,  fechaHoraModificacion)
select 
	@idPiscinaEjecucion as idPiscinaEjecucion ,
	pe.idPiscina as idPiscina,
	0 as ciclo,
	'' as rolPiscina,
	0 as numEtapa,
	1 as lote,
	DATEADD(DAY, 1, c.Fecha_Pesca) as fechaInicio,
	NULL as fechaSiembra,
	NULL as fechaCierre,
	''    as tipoCierre,
	0 as idEspecie,
	0 as cantidadEntrada,
	0 as cantidadAdicional,
	0 as cantidadSalida,
	0 as cantidadPerdida,
	NULL as idPiscinaEjecucionSiguiente,
	'INI' as estado,
	0 as tieneRaleo,
	0 as tieneRepanio,
	0 as tieneCosecha,
	1 as activo,
	'adminPsCam' as usuarioCreacion,
	':::1' as estacionCreacion,
	GETDATE() as fechaHoraCreacion,
	'adminPsCam' as usuarioModificacion,
	':::1' as estacionModificacion,
	GETDATE() as fechaHoraModificacion
from 
	CICLOS_PRODUCCION c inner join EjecucionesPiscinaView ej on ej.cod_ciclo = c.Cod_Ciclo
	INNER JOIN proPiscinaEjecucion   pe on pe.idPiscina = ej.idPiscina and pe.idPiscinaEjecucion = ej.idPiscinaEjecucion
 where ej.cod_ciclo=@COD_CICLO_CERRAR

 insert into maePiscinaCiclo (
	idPiscinaCiclo,      idPiscina,	    	   ciclo,
	fecha,				 origen,			   idOrigen,
	idOrigenEquivalente, rolCiclo,			   activo,
	usuarioCreacion,	 estacionCreacion,     fechaHoraCreacion,
	usuarioModificacion, estacionModificacion, fechaHoraModificacion)
 
 select 
	@idPiscinaCiclo as idPiscinaCiclo,
	ej.idPiscina as idPiscina,
	0 as ciclo,
	DATEADD(DAY, 1, c.Fecha_Pesca)  as fecha,
	'PRE' as origen,
	@idPiscinaEjecucion as idOrigen,
	NULL as idOrigenEquivalente,
	'' as rolCiclo,
	1 as activo,
	'adminPsCam' as usuarioCreacion,
	':::1' as estacionCreacion,
	GETDATE() as fechaHoraCreacion,
	'adminPsCam' as usuarioModificacion,
	':::1' as estacionModificacion,
	GETDATE() as fechaHoraModificacion
from 
	CICLOS_PRODUCCION c inner join EjecucionesPiscinaView ej on ej.cod_ciclo = c.Cod_Ciclo
	INNER JOIN proPiscinaEjecucion   pe on pe.idPiscina = ej.idPiscina and pe.idPiscinaEjecucion = ej.idPiscinaEjecucion
 where ej.cod_ciclo=@COD_CICLO_CERRAR

/*select  pe.fechaCierre , c.Fecha_Pesca,
			   pe.estado      , 'PRE',
			   PE.idPiscinaEjecucionSiguiente , @idPiscinaEjecucion,
			   PE.cantidadSalida , t.cantidadTransferida ,
			   PE.cantidadPerdida , pe.cantidadEntrada - t.cantidadTransferida ,
			   tipoCierre='TRA',
			   PE.usuarioModificacion , 	'adminPsCam'   ,
			   PE.estacionModificacion , ':::1'   ,
			   PE.fechaHoraModificacion , GETDATE()  */

 UPDATE pe set pe.fechaCierre = c.Fecha_Pesca,
			   pe.estado      = 'PRE',
			   PE.idPiscinaEjecucionSiguiente = @idPiscinaEjecucion,
	           PE.cantidadSalida = t.cantidadTransferida ,
			   PE.cantidadPerdida = pe.cantidadEntrada - t.cantidadTransferida ,
			   pe.tipoCierre='TRA',
			   PE.usuarioModificacion = 	'adminPsCam'   ,
			   PE.estacionModificacion = ':::1'   ,
			   PE.fechaHoraModificacion = GETDATE()    
 from 
	CICLOS_PRODUCCION c inner join EjecucionesPiscinaView ej on ej.cod_ciclo = c.Cod_Ciclo
	INNER JOIN proPiscinaEjecucion   pe on pe.idPiscina = ej.idPiscina and pe.idPiscinaEjecucion = ej.idPiscinaEjecucion
	INNER JOIN proTransferenciaEspecie t on t.idPiscina = pe.idPiscina and pe.idPiscinaEjecucion = t.idPiscinaEjecucion
 where ej.cod_ciclo = @COD_CICLO_CERRAR and idTransferencia = @idTransferencia and esTotal = 1

  
  exec	viewProcessCiclos @Key_Piscina, 1 

 if @usarTrans = 1 BEGIN ROLLBACK TRAN END  

 SELECT 'FIN' AS TERMINO_PROCESO