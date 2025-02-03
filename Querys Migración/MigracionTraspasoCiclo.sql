exec viewProcessCiclos 'ruandaPC11', 1
exec viewProcessCiclos 'EGIPTOPC11', 1
select * from maePiscinaCiclo where idPiscina = 887
select * from proPiscinaEjecucion where  idPiscina = 887
select * from proControlParametroDetalle where idPiscinaEjecucion in (9167) and idControlParametroDetalle=1425188
select * from maePiscinaCiclo     where idPiscina = 2612
select * from proPiscinaEjecucion where idPiscina = 2612


SELECT	peaPos.rolPiscina,			peaAnt.rolPiscina ,			peaPos.numEtapa,		peaAnt.numEtapa ,		peaPos.cantidadEntrada, peaAnt.cantidadEntrada ,
			peaPos.cantidadAdicional,	peaAnt.cantidadAdicional ,  peaPos.cantidadSalida, peaAnt.cantidadSalida ,	peaPos.cantidadPerdida, peaAnt.cantidadPerdida ,
			peaPos.estado,				peaAnt.estado , 
			peaPos.usuarioCreacion,		'adminPsCam' as usuarioCreacion, 	 peaPos.estacionCreacion,	 @estacionModificacion	as estacionCreacion,		peaPos.fechaHoraCreacion,	  GETDATE() as fechaHoraCreacion,
			peaPos.usuarioModificacion, 'adminPsCam' as usuarioModificacion, peaPos.estacionModificacion,@estacionModificacion  as estacionModificacion, 	peaPos.fechaHoraModificacion, GETDATE() as fechaHoraModificacion
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='INI'
	and peaAnt.estado IN('PRE','EJE')  

select * from maePiscinaCiclo     where IDorigen= 9002
select * from proPiscinaEjecucion where estado ='ANU'
--** --- UPDATE maePiscinaCiclo SET ciclo=35    where idPiscina = 2596 AND ciclo=36

 
--EGIPTO41.37
--2593
--9135

--RUANDA41.37
--911
--8664
 
create table MigracionEjecucion
(
	idMigracionEjecucion int identity(1,1),
	cod_cicloAnterior varchar(30),
	idPiscinaAnterior int,
	idPiscinaEjecucionAnterior int,
	FechaSiembraAnterior date,
	cod_cicloPosterior varchar(30),
	idPiscinaPosterior int,
	idPiscinaEjecucionPosterior int,
    FechaSiembraPosterior date,
	activo bit
)
insert into MigracionEjecucion (cod_cicloAnterior,  idPiscinaAnterior,           idPiscinaEjecucionAnterior, 
                                FechaSiembraAnterior, cod_cicloPosterior,
								idPiscinaPosterior, idPiscinaEjecucionPosterior, FechaSiembraPosterior, activo)
								values ('RUANDA41.37',911,8664,'2024-08-07','EGIPTO41.37', 2593, 9135,'2024-08-07',1)



 /*UPDATE peaAct
  SET peaAct.ESTADO = 'APR', peaAct.fechaSiembra = me.FechaSiembraAnterior, */
  declare @cod_cicloAnterior varchar(30)
  set @cod_cicloAnterior ='RUANDA41.37'
  declare @ultimaSecuenciaPiscinaCiclo int
  set @ultimaSecuenciaPiscinaCiclo = 0
    declare @esPrecria int
    set @esPrecria =1
  begin tran
	SELECT	peaPos.rolPiscina,			peaAnt.rolPiscina ,			peaPos.numEtapa,		peaAnt.numEtapa ,		peaPos.cantidadEntrada, peaAnt.cantidadEntrada ,
			peaPos.cantidadAdicional,	peaAnt.cantidadAdicional ,  peaPos.cantidadSalida, peaAnt.cantidadSalida ,	peaPos.cantidadPerdida, peaAnt.cantidadPerdida ,
			peaPos.estado,				peaAnt.estado , 
			peaPos.usuarioCreacion,		'adminPsCam' as usuarioCreacion, 	 peaPos.estacionCreacion,	 '::1'	as estacionCreacion,		peaPos.fechaHoraCreacion,	  GETDATE() as fechaHoraCreacion,
			peaPos.usuarioModificacion, 'adminPsCam' as usuarioModificacion, peaPos.estacionModificacion,'::1'  as estacionModificacion, 	peaPos.fechaHoraModificacion, GETDATE() as fechaHoraModificacion
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='INI'
	and peaAnt.estado ='EJE' 


	UPDATE peaPos set
			peaPos.rolPiscina         =	 peaAnt.rolPiscina ,			peaPos.numEtapa       =		peaAnt.numEtapa ,		peaPos.cantidadEntrada = peaAnt.cantidadEntrada ,
			peaPos.cantidadAdicional  =	 peaAnt.cantidadAdicional ,     peaPos.cantidadSalida =     peaAnt.cantidadSalida,	peaPos.cantidadPerdida = peaAnt.cantidadPerdida ,
			peaPos.estado			  =  peaAnt.estado ,				peaPos.fechaSiembra   =     peaAnt.fechaSiembra ,   peaPos.idEspecie   =     peaAnt.idEspecie ,
			peaPos.ciclo              =  peaAnt.ciclo,
			peaPos.usuarioCreacion=		'adminPsCam' ,					peaPos.estacionCreacion		=	 '::1',				peaPos.fechaHoraCreacion=	  GETDATE(),
			peaPos.usuarioModificacion= 'adminPsCam' ,					peaPos.estacionModificacion		='::1',				peaPos.fechaHoraModificacion= GETDATE()  
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='INI'
	and peaAnt.estado ='EJE' 

	
	--update maeSecuencial set  ultimaSecuencia = ultimaSecuencia + 1 where tabla='PiscinaCiclo'
	--select @ultimaSecuenciaPiscinaCiclo = ultimaSecuencia from maeSecuencial   where tabla='PiscinaCiclo'

	--select '', @ultimaSecuenciaPiscinaCiclo, peaPos.idPiscina,	 peaPos.ciclo,			peaPos.fechaInicio,    'EJE',			peaPos.idPiscinaEjecucion,	null,  
	--									  peaPos.rolPiscina,	1,      'adminPsCam' ,			'::1',              GETDATE(),	         'adminPsCam' ,			'::1',	    GETDATE()
	--								FROM  
	--proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
	--							 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	--where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='EJE'
	--and peaAnt.estado ='EJE' 

    UPDATE pc
		set pc.ciclo = peaPos.ciclo,  pc.rolCiclo = peaPos.rolPiscina, pc.origen = 'EJE', pc.fechaHoraModificacion = GETDATE(), pc.usuarioModificacion =  'adminPsCam' ,	pc.estacionModificacion = '::1' 
	from
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  maePiscinaCiclo pc on pc.idPiscina = me.idPiscinaPosterior and pc.idOrigen = me.idPiscinaEjecucionPosterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='EJE'

  --REASIGNACION DE PROCESOS DE SIEMBRA Y COSECHA
  --SELECT 'transferencia destino', * 
  UPDATE td SET td.idPiscina = me.idPiscinaPosterior , td.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
				td.fechaHoraModificacion = GETDATE(),  td.usuarioModificacion =  'adminPsCam' ,	td.estacionModificacion = '::1' 
	  FROM proTransferenciaEspecieDetalle td inner join  MigracionEjecucion me on td.idPiscina = me.idPiscinaAnterior and td.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 
	   
  --SELECT 'transferencia origen', * 
  UPDATE tor SET tor.idPiscina = me.idPiscinaPosterior , tor.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
				 tor.fechaHoraModificacion = GETDATE(),  tor.usuarioModificacion =  'adminPsCam' ,	tor.estacionModificacion = '::1' 
	  FROM proTransferenciaEspecie tor inner join  MigracionEjecucion me on tor.idPiscina = me.idPiscinaAnterior and tor.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 


	  ---recepcion y planificiacion
	  if(@esPrecria=1)
	  begin
			  select rd.idPiscinaPlanificacion 
				into #idsPiscinaPlanificacion
					from proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
					inner join  MigracionEjecucion me on rd.idPiscina = me.idPiscinaAnterior and rd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
						where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
   
			  select pspr.*
					into #temp_proPlanificacionSiembraPiscinaPorReceptar
			 from proPlanificacionSiembraPiscinaPorReceptar pspr inner join  MigracionEjecucion me on pspr.idPiscinaOrigen = me.idPiscinaAnterior   
			 where idPiscinaPorReceptar in (select * from #idsPiscinaPlanificacion)


			 select distinct prc.idPlanificacionSiembraDetallePiscina,prc.idDetallePiscinaPorReceptar,prc.idPlanificacionSiembra, prc.idPiscinaOrigen
				into #temp_proPlanificacionSiembraDetallePiscinaPorReceptar
				from proPlanificacionSiembraDetallePiscinaPorReceptar prc 
						 inner join  #temp_proPlanificacionSiembraPiscinaPorReceptar pr on pr.idPiscinaOrigen = prc.idPiscinaOrigen		and  pr.fechaInicio = prc.fechaInicio and pr.fechaFin = prc.fechaFin
						 inner join  proPlanificacionSiembraDetallePiscina ppp			on ppp.idPlanificacionSiembraDetallePiscina = prc.idPlanificacionSiembraDetallePiscina and ppp.idPiscina = prc.idPiscinaOrigen
						 inner join  proRecepcionEspecieDetalle red						on red.idPiscinaPlanificacion =  pr.idPiscinaPorReceptar and red.idPiscina = pr.idPiscinaOrigen
				  inner join  MigracionEjecucion me on red.idPiscina = me.idPiscinaAnterior and red.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
				  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

			  update prc set  prc.idPiscinaOrigen = me.idPiscinaPosterior ,
							 prc.fechaHoraModificacion = GETDATE(),		   prc.usuarioModificacion =  'adminPsCam' , prc.estacionModificacion = '::1' 
			  from proPlanificacionSiembraDetallePiscinaPorReceptar prc 
				inner join #temp_proPlanificacionSiembraDetallePiscinaPorReceptar tpr on 
						 prc.idPlanificacionSiembraDetallePiscina   =  tpr.idPlanificacionSiembraDetallePiscina  and 
						 prc.idDetallePiscinaPorReceptar			=  tpr.idDetallePiscinaPorReceptar           and 
						 prc.idPlanificacionSiembra				    =  tpr.idPlanificacionSiembra			     and 
						 prc.idPiscinaOrigen						=  tpr.idPiscinaOrigen
				inner join  MigracionEjecucion me on prc.idPiscinaOrigen = me.idPiscinaAnterior  
				  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

			  update ppp set  ppp.idPiscina = me.idPiscinaPosterior ,
							 ppp.fechaHoraModificacion = GETDATE(),		   ppp.usuarioModificacion =  'adminPsCam' , ppp.estacionModificacion = '::1' 
			  from proPlanificacionSiembraDetallePiscina ppp 
			  inner join #temp_proPlanificacionSiembraDetallePiscinaPorReceptar tpr on
								ppp.idPlanificacionSiembraDetallePiscina = tpr.idPlanificacionSiembraDetallePiscina and 
								ppp.idPiscina							 = tpr.idPiscinaOrigen
			 inner join  MigracionEjecucion me on ppp.idPiscina = me.idPiscinaAnterior  
				  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

		  --SELECT 'proPlanificacionSiembraPiscinaPorReceptar', * 
			update pspr set  pspr.idPiscinaOrigen = me.idPiscinaPosterior ,
							 pspr.fechaHoraModificacion = GETDATE(),		   pspr.usuarioModificacion =  'adminPsCam' , pspr.estacionModificacion = '::1' 
			  from proPlanificacionSiembraPiscinaPorReceptar pspr inner join  MigracionEjecucion me on pspr.idPiscinaOrigen = me.idPiscinaAnterior   
			 where idPiscinaPorReceptar in (select * from #idsPiscinaPlanificacion)
		end
  --SELECT 'recepcion', * 
     UPDATE red SET red.idPiscina = me.idPiscinaPosterior , red.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
		 red.fechaHoraModificacion = GETDATE(),  red.usuarioModificacion =  'adminPsCam' ,	red.estacionModificacion = '::1' 
	  FROM proRecepcionEspecieDetalle red inner join  MigracionEjecucion me on red.idPiscina = me.idPiscinaAnterior and red.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 
	   
  --SELECT 'Cosecha', * 
      UPDATE co SET co.idPiscina = me.idPiscinaPosterior ,		   co.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
				co.idPiscinaAnterior = me.idPiscinaPosterior , co.idPiscinaEjecucionAnterior = me.idPiscinaEjecucionPosterior,
				co.fechaHoraModificacion = GETDATE(),		   co.usuarioModificacion =  'adminPsCam' ,							co.estacionModificacion = '::1' 
	  FROM proPiscinaCosecha co inner join  MigracionEjecucion me on co.idPiscina = me.idPiscinaAnterior and co.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

   --SELECT 'ControlParametro', * 
      UPDATE pcd SET pcd.idPiscina = me.idPiscinaPosterior ,       pcd.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				   pcd.fechaHoraModificacion = GETDATE(),		   pcd.usuarioModificacion =  'adminPsCam' ,                   pcd.estacionModificacion = '::1' 
	  FROM proControlParametroDetalle pcd inner join  MigracionEjecucion me on pcd.idPiscina = me.idPiscinaAnterior and pcd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
    
	   --SELECT 'MuestreoPoblacion', * 
      UPDATE ppd SET ppd.idPiscina = me.idPiscinaPosterior ,       ppd.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				     ppd.fechaHoraModificacion = GETDATE(),		   ppd.usuarioModificacion =  'adminPsCam' ,                   ppd.estacionModificacion = '::1' 
	  FROM proMuestreoPoblacionDetalleLance ppd inner join  MigracionEjecucion me on ppd.idPiscina = me.idPiscinaAnterior and ppd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

	  	   --SELECT 'MuestreoPeso', * 
      UPDATE pps SET pps.idPiscina = me.idPiscinaPosterior ,       pps.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				     pps.fechaHoraModificacion = GETDATE(),		   pps.usuarioModificacion =  'adminPsCam' ,                   pps.estacionModificacion = '::1' 
	  FROM proMuestreoPesoDetalle pps inner join  MigracionEjecucion me on pps.idPiscina = me.idPiscinaAnterior and pps.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

	  UPDATE ppsc SET    ppsc.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
							   ppsc.fechaHoraModificacion = GETDATE(),		       ppsc.usuarioModificacion =  'adminPsCam' ,                   ppsc.estacionModificacion = '::1' 
	  FROM proPiscinaControlPeso ppsc inner join  MigracionEjecucion me on   ppsc.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
	  
	  UPDATE ppsc SET    ppsc.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
							   ppsc.fechaHoraModificacion = GETDATE(),		       ppsc.usuarioModificacion =  'adminPsCam' ,                   ppsc.estacionModificacion = '::1' 
	  FROM proPiscinaControlPoblacion ppsc inner join  MigracionEjecucion me on   ppsc.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1   

  --ANULACION DE CICLOS  
	UPDATE peaAnt set
		    peaAnt.activo			 = 0,							    fechaInicio ='1980-01-01',
			peaAnt.rolPiscina        =	'',								peaAnt.numEtapa       =		0,		peaAnt.cantidadEntrada = 0 ,
			peaAnt.cantidadAdicional =	 0 ,							peaAnt.cantidadSalida =     0,		peaAnt.cantidadPerdida = 0,
			peaAnt.estado			  =  'ANU' ,						peaAnt.ciclo          =     0,
			peaAnt.usuarioCreacion=		'adminPsCam' ,					peaAnt.estacionCreacion		=	 '::1',				peaAnt.fechaHoraCreacion=	  GETDATE(),
			peaAnt.usuarioModificacion= 'adminPsCam' ,					peaAnt.estacionModificacion		='::1',				peaAnt.fechaHoraModificacion= GETDATE()  
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='EJE'
	and peaAnt.estado ='EJE' 
	 
	update c set activo = 0, ciclo = 0, origen = 'PRE', rolCiclo='' 
	from maePiscinaCiclo c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior and c.idOrigen = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior  and me.activo = 1

	update p set p.activo = 0 
	from maePiscina p inner join  MigracionEjecucion me on p.idPiscina = me.idPiscinaAnterior 
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1
  
	update MigracionEjecucion set activo = 0  where cod_cicloAnterior = @cod_cicloAnterior

	select c.* from proPiscinaEjecucion c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior-- and c.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 
	select c.*  from proPiscinaEjecucion c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaPosterior-- and c.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 

	select c.*  from maePiscinaCiclo c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior --and c.idOrigen = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 
	select c.*  from maePiscinaCiclo c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaPosterior --and c.idOrigen = me.idPiscinaEjecucionPosterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 
rollback tran

--select * from maePiscinaCiclo where activo = 0 and origen='eje'
--SELECT * FROM proTransferenciaEspecieDetalle WHERE idPiscina = 911 AND idPiscinaEjecucion=8664
--SELECT * FROM proRecepcionEspecieDetalle WHERE idPiscina = 911 AND idPiscinaEjecucion=8664
--SELECT * FROM proPiscinaCosecha where  idPiscina = 911 AND idPiscinaEjecucion=8664

--SELECT * FROM proControlParametroDetalle where  idPiscina = 911 AND idPiscinaEjecucion=8664
--SELECT * FROM proMuestreoPoblacionDetalleLance where  idPiscina = 911 AND idPiscinaEjecucion=8664
--SELECT * FROM proMuestreoPesoDetalle where  idPiscina = 911 AND idPiscinaEjecucion=8664
--SELECT * FROM proPiscinaControlPeso WHERE  idPiscinaEjecucion=8664
--SELECT * FROM proPiscinaControlPoblacion WHERE  idPiscinaEjecucion=8664

SELECT * FROM proPiscinaEjecucion WHERE  idPiscinaEjecucion=8664
select * from maePiscinaCiclo where idPiscina = 911 AND idOrigen=8664
select SUM(cantidadTransferida) from proTransferenciaEspecieDetalle where idPiscina = 911 AND idPiscinaEjecucion=8664
select * from PiscinaUbicacion where idZona=10 
 