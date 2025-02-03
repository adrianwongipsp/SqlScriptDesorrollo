  declare @cod_cicloAnterior varchar(30)
  set @cod_cicloAnterior ='MARRUECOSPC17.67'

  declare @ultimaSecuenciaPiscinaCiclo int
  set @ultimaSecuenciaPiscinaCiclo = 0
 
  declare @estacionModificacion VARCHAR(15)
  set @estacionModificacion ='::TRANSCICLO'
 -- SELECT * FROM proPiscinaEjecucion WHERE estado='ANU'

 IF OBJECT_ID('tempdb..#idsPiscinaPlanificacion') IS NOT NULL
    DROP TABLE #idsPiscinaPlanificacion;

IF OBJECT_ID('tempdb..#temp_proPlanificacionSiembraPiscinaPorReceptar') IS NOT NULL
    DROP TABLE #temp_proPlanificacionSiembraPiscinaPorReceptar;

IF OBJECT_ID('tempdb..#temp_proPlanificacionSiembraDetallePiscinaPorReceptar') IS NOT NULL
    DROP TABLE #temp_proPlanificacionSiembraDetallePiscinaPorReceptar;	
	
BEGIN TRAN
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


	declare @rolPiscina varchar(6) 
    declare @esPrecerrado varchar(6) 
	DECLARE @idPiscinaEjecucionSiguiente INT
	declare @idPiscinaPosterior int
	declare @idPiscinaAnterior int 
	SELECT	@rolPiscina    =	peaAnt.rolPiscina, 
	     	@esPrecerrado =	peaAnt.estado ,
			@idPiscinaEjecucionSiguiente=	peaAnt.idPiscinaEjecucionSiguiente  ,
			@idPiscinaPosterior =	peaPos.idPiscina ,
			@idPiscinaAnterior  =   peaAnt.idPiscina
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='INI'
	and peaAnt.estado IN('PRE','EJE') 
	SELECT	@rolPiscina AS rolPiscina, 	@esPrecerrado AS esPrecerrado , @idPiscinaEjecucionSiguiente as idPiscinaEjecucionSiguiente, @idPiscinaPosterior as idPiscinaPosterior
	UPDATE peaPos set
			peaPos.rolPiscina         =	 peaAnt.rolPiscina ,			peaPos.numEtapa       =		peaAnt.numEtapa ,		peaPos.cantidadEntrada = peaAnt.cantidadEntrada ,
			peaPos.cantidadAdicional  =	 peaAnt.cantidadAdicional ,     peaPos.cantidadSalida =     peaAnt.cantidadSalida,	peaPos.cantidadPerdida = peaAnt.cantidadPerdida ,
			peaPos.estado			  =  peaAnt.estado ,				peaPos.fechaSiembra   =     peaAnt.fechaSiembra ,   peaPos.idEspecie   =     peaAnt.idEspecie ,
			peaPos.ciclo              =  peaAnt.ciclo,
			peaPos.usuarioCreacion=		'adminPsCam' ,					peaPos.estacionCreacion		   =	@estacionModificacion,				peaPos.fechaHoraCreacion=	  GETDATE(),
			peaPos.usuarioModificacion= 'adminPsCam' ,					peaPos.estacionModificacion	   =    @estacionModificacion,				peaPos.fechaHoraModificacion= GETDATE(),
			peaPos.fechaCierre		  =  peaAnt.fechaCierre,            peaPos.tipoCierre              =    peaAnt.tipoCierre    ,              
			peaPos.idPiscinaEjecucionSiguiente = peaAnt.idPiscinaEjecucionSiguiente,
			peaPos.tieneRaleo = peaAnt.tieneRaleo,
		    peaPos.tieneRepanio = peaAnt.tieneRepanio,
			peaPos.tieneCosecha = peaAnt.tieneCosecha,
			peaPos.fechaInicio  =  peaAnt.fechaInicio
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='INI'
	and peaAnt.estado  IN('PRE','EJE') 

	
	--update maeSecuencial set  ultimaSecuencia = ultimaSecuencia + 1 where tabla='PiscinaCiclo'
	--select @ultimaSecuenciaPiscinaCiclo = ultimaSecuencia from maeSecuencial   where tabla='PiscinaCiclo'

	--select '', @ultimaSecuenciaPiscinaCiclo, peaPos.idPiscina,	 peaPos.ciclo,			peaPos.fechaInicio,    'EJE',			peaPos.idPiscinaEjecucion,	null,  
	--									  peaPos.rolPiscina,	1,      'adminPsCam' ,			@estacionModificacion,              GETDATE(),	         'adminPsCam' ,			@estacionModificacion,	    GETDATE()
	--								FROM  
	--proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
	--							 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	--where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado ='EJE'
	--and peaAnt.estado ='EJE' 

	--	SELECT '' AS HOLA, pc.ciclo , peaPos.ciclo,  pc.rolCiclo , peaPos.rolPiscina, pc.origen , 'EJE', pc.fechaHoraModificacion , GETDATE(),
	--	pc.usuarioModificacion ,  'adminPsCam' ,	pc.estacionModificacion , @estacionModificacion 
	--from
	--proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
	--							 inner join  maePiscinaCiclo pc on pc.idPiscina = me.idPiscinaPosterior and pc.idOrigen = me.idPiscinaEjecucionPosterior
	--where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado IN('PRE','EJE')
	
    UPDATE pc
		set pc.ciclo = peaPos.ciclo,  pc.rolCiclo = peaPos.rolPiscina, pc.origen = 'EJE', pc.fechaHoraModificacion = GETDATE(),
		pc.usuarioModificacion =  'adminPsCam' ,	pc.estacionModificacion = @estacionModificacion 
	from
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  maePiscinaCiclo pc on pc.idPiscina = me.idPiscinaPosterior and pc.idOrigen = me.idPiscinaEjecucionPosterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado IN('PRE','EJE')

  --REASIGNACION DE PROCESOS DE SIEMBRA Y COSECHA
  --SELECT 'transferencia destino', * 
  UPDATE td SET td.idPiscina = me.idPiscinaPosterior , td.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
				td.fechaHoraModificacion = GETDATE(),  td.usuarioModificacion =  'adminPsCam' ,	td.estacionModificacion = @estacionModificacion 
	  FROM proTransferenciaEspecieDetalle td inner join  MigracionEjecucion me on td.idPiscina = me.idPiscinaAnterior and td.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 
	   
  --SELECT 'transferencia origen', * 
  UPDATE tor SET tor.idPiscina = me.idPiscinaPosterior , tor.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
				 tor.fechaHoraModificacion = GETDATE(),  tor.usuarioModificacion =  'adminPsCam' ,	tor.estacionModificacion = @estacionModificacion 
	  FROM proTransferenciaEspecie tor inner join  MigracionEjecucion me on tor.idPiscina = me.idPiscinaAnterior and tor.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 
	   
	  if(@esPrecerrado ='PRE')
	  BEGIN
			--ACTUALIZO LAS SIGUIENTES EJECUCIONES
			EXEC PROCESS_REASIGNACIONPISCINA @idPiscinaPosterior, @idPiscinaEjecucionSiguiente, @estacionModificacion, @idPiscinaAnterior; 
			--ACTUALIZO LAS SIGUIENTES EJECUCIONES 
	  END
	    ---recepcion y planificiacion
	  if(@rolPiscina ='PRE01')
	  begin
			 PRINT 'PLANIFICACION DE SIEMBRA'
			  select rd.idPiscinaPlanificacion 
				into #idsPiscinaPlanificacion
					from proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
					inner join  MigracionEjecucion me on rd.idPiscina = me.idPiscinaAnterior and rd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
						where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
             
			 --SELECT rd.* FROM   proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
				--	inner join  MigracionEjecucion me on rd.idPiscina = me.idPiscinaAnterior and rd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
				--		where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1
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
							 prc.fechaHoraModificacion = GETDATE(),		   prc.usuarioModificacion =  'adminPsCam' , prc.estacionModificacion = @estacionModificacion 
			  from proPlanificacionSiembraDetallePiscinaPorReceptar prc 
				inner join #temp_proPlanificacionSiembraDetallePiscinaPorReceptar tpr on 
						 prc.idPlanificacionSiembraDetallePiscina   =  tpr.idPlanificacionSiembraDetallePiscina  and 
						 prc.idDetallePiscinaPorReceptar			=  tpr.idDetallePiscinaPorReceptar           and 
						 prc.idPlanificacionSiembra				    =  tpr.idPlanificacionSiembra			     and 
						 prc.idPiscinaOrigen						=  tpr.idPiscinaOrigen
				inner join  MigracionEjecucion me on prc.idPiscinaOrigen = me.idPiscinaAnterior  
				  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

			  update ppp set  ppp.idPiscina = me.idPiscinaPosterior ,
							 ppp.fechaHoraModificacion = GETDATE(),		   ppp.usuarioModificacion =  'adminPsCam' , ppp.estacionModificacion = @estacionModificacion 
			  from proPlanificacionSiembraDetallePiscina ppp 
			  inner join #temp_proPlanificacionSiembraDetallePiscinaPorReceptar tpr on
								ppp.idPlanificacionSiembraDetallePiscina = tpr.idPlanificacionSiembraDetallePiscina and 
								ppp.idPiscina							 = tpr.idPiscinaOrigen
			 inner join  MigracionEjecucion me on ppp.idPiscina = me.idPiscinaAnterior  
				  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

		  --SELECT 'proPlanificacionSiembraPiscinaPorReceptar', * 
			update pspr set  pspr.idPiscinaOrigen = me.idPiscinaPosterior ,
							 pspr.fechaHoraModificacion = GETDATE(),		   pspr.usuarioModificacion =  'adminPsCam' , pspr.estacionModificacion = @estacionModificacion 
			  from proPlanificacionSiembraPiscinaPorReceptar pspr inner join  MigracionEjecucion me on pspr.idPiscinaOrigen = me.idPiscinaAnterior   
			 where idPiscinaPorReceptar in (select * from #idsPiscinaPlanificacion)
			  
			 PRINT 'PLANIFICACION DE SIEMBRA'
		end
  --SELECT 'recepcion', * 
     UPDATE red SET red.idPiscina = me.idPiscinaPosterior , red.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
		 red.fechaHoraModificacion = GETDATE(),  red.usuarioModificacion =  'adminPsCam' ,	red.estacionModificacion = @estacionModificacion 
	  FROM proRecepcionEspecieDetalle red inner join  MigracionEjecucion me on red.idPiscina = me.idPiscinaAnterior and red.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 
	   
	SELECT rd.* FROM   proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
					inner join  MigracionEjecucion me on rd.idPiscina = me.idPiscinaPosterior and rd.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior 
						where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1
  --SELECT 'Cosecha', * 
      UPDATE co SET co.idPiscina = me.idPiscinaPosterior ,		   co.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior,
				co.idPiscinaAnterior = me.idPiscinaPosterior , co.idPiscinaEjecucionAnterior = me.idPiscinaEjecucionPosterior,
				co.fechaHoraModificacion = GETDATE(),		   co.usuarioModificacion =  'adminPsCam' ,							co.estacionModificacion = @estacionModificacion 
	  FROM proPiscinaCosecha co inner join  MigracionEjecucion me on co.idPiscina = me.idPiscinaAnterior and co.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  


	     --SELECT 'ControlParametro', * 
   --   SELECT 'ControlParametro',    pcd.idPiscina , me.idPiscinaPosterior ,       pcd.idPiscinaEjecucion  , me.idPiscinaEjecucionPosterior, 
			--	   pcd.fechaHoraModificacion , GETDATE(),		   pcd.usuarioModificacion ,  'adminPsCam' ,                   pcd.estacionModificacion , @estacionModificacion 
	  --FROM proControlParametroDetalle pcd inner join  MigracionEjecucion me on pcd.idPiscina = me.idPiscinaAnterior and pcd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  --where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
	   
   --SELECT 'ControlParametro', * 
      UPDATE pcd SET pcd.idPiscina = me.idPiscinaPosterior ,       pcd.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				   pcd.fechaHoraModificacion = GETDATE(),		   pcd.usuarioModificacion =  'adminPsCam' ,                   pcd.estacionModificacion = @estacionModificacion 
	  FROM proControlParametroDetalle pcd inner join  MigracionEjecucion me on pcd.idPiscina = me.idPiscinaAnterior and pcd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
    
	   --SELECT 'MuestreoPoblacion', * 
      UPDATE ppd SET ppd.idPiscina = me.idPiscinaPosterior ,       ppd.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				     ppd.fechaHoraModificacion = GETDATE(),		   ppd.usuarioModificacion =  'adminPsCam' ,                   ppd.estacionModificacion = @estacionModificacion 
	  FROM proMuestreoPoblacionDetalleLance ppd inner join  MigracionEjecucion me on ppd.idPiscina = me.idPiscinaAnterior and ppd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

	  	   --SELECT 'MuestreoPeso', * 
      UPDATE pps SET pps.idPiscina = me.idPiscinaPosterior ,       pps.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				     pps.fechaHoraModificacion = GETDATE(),		   pps.usuarioModificacion =  'adminPsCam' ,                   pps.estacionModificacion = @estacionModificacion 
	  FROM proMuestreoPesoDetalle pps inner join  MigracionEjecucion me on pps.idPiscina = me.idPiscinaAnterior and pps.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  

	  UPDATE ppsc SET    ppsc.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
							   ppsc.fechaHoraModificacion = GETDATE(),		       ppsc.usuarioModificacion =  'adminPsCam' ,                   ppsc.estacionModificacion = @estacionModificacion 
	  FROM proPiscinaControlPeso ppsc inner join  MigracionEjecucion me on   ppsc.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
	  
	  UPDATE ppsc SET    ppsc.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
							   ppsc.fechaHoraModificacion = GETDATE(),		       ppsc.usuarioModificacion =  'adminPsCam' ,                   ppsc.estacionModificacion = @estacionModificacion 
	  FROM proPiscinaControlPoblacion ppsc inner join  MigracionEjecucion me on   ppsc.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1   

  --ANULACION DE CICLOS  
	UPDATE peaAnt set
		    peaAnt.activo			  = 0,							    fechaInicio ='1980-01-01',
			peaAnt.rolPiscina         =	'',								peaAnt.numEtapa       =		0,		peaAnt.cantidadEntrada = 0 ,
			peaAnt.cantidadAdicional  =	 0 ,							peaAnt.cantidadSalida =     0,		peaAnt.cantidadPerdida = 0,
			peaAnt.estado			  =  'ANU' ,						peaAnt.ciclo          =     0,
			peaAnt.lote				  = '',							    peaAnt.fechaSiembra   = NULL,       peaAnt.idEspecie = 0,
			peaAnt.idPiscinaEjecucionSiguiente = null,					peaAnt.fechaCierre	  = NULL,		peaAnt.tipoCierre = '' ,
			peaAnt.usuarioCreacion     = 'adminPsCam' ,					peaAnt.estacionCreacion		    = @estacionModificacion, peaAnt.fechaHoraCreacion     = GETDATE(),
			peaAnt.usuarioModificacion = 'adminPsCam' ,					peaAnt.estacionModificacion		= @estacionModificacion, peaAnt.fechaHoraModificacion = GETDATE()  
	 FROM  
	proPiscinaEjecucion  peaPos  inner join  MigracionEjecucion me on peaPos.idPiscina = me.idPiscinaPosterior and peaPos.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
								 inner join  proPiscinaEjecucion peaAnt on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaPos.estado  IN('PRE','EJE') 
	and peaAnt.estado  IN('PRE','EJE')  
	 
	update c set activo = 0, ciclo = 0, origen = 'PRE', rolCiclo='' ,
	   C.fechaHoraModificacion = GETDATE(),		       C.usuarioModificacion =  'adminPsCam' ,                   C.estacionModificacion = @estacionModificacion 
	from maePiscinaCiclo c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior and c.idOrigen = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior  and me.activo = 1

	--update p set p.activo = 0 
	--from maePiscina p inner join  MigracionEjecucion me on p.idPiscina = me.idPiscinaAnterior 
	--where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1
  
    if exists (select top 1 1 from MigracionEjecucion   where cod_cicloAnterior = @cod_cicloAnterior
			and FechaSiembraAnterior is null and FechaSiembraPosterior is null and idPiscinaEjecucionAnterior is not null and idPiscinaEjecucionPosterior is not null  ) 
			begin
			  print 'caso ambas piscinas inciadas'
					UPDATE C SET  C.activo = 0,  C.fechaHoraModificacion = GETDATE(),	C.usuarioModificacion =  'adminPsCam',	C.estacionModificacion = '::TRANSCICLO' 
					FROM  maePiscinaCiclo C inner join  
								MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior and c.idOrigen = me.idPiscinaEjecucionAnterior
					WHERE me.cod_cicloAnterior=@cod_cicloAnterior  and me.activo = 1   

					UPDATE peaAnt SET  peaAnt.estado = 'ANU' , peaAnt.activo = 0 , ciclo  = 0,	rolPiscina ='',	numEtapa=0, lote='',	fechaInicio='1980-01-01',
							fechaSiembra=NULL,	fechaCierre=NULL,	tipoCierre='',	idEspecie=0,	cantidadEntrada=0,	cantidadAdicional=0,	cantidadSalida=0,	cantidadPerdida=0
							 ,idPiscinaEjecucionSiguiente	=NULL, 	tieneRaleo=0,	tieneRepanio=0, tieneCosecha=0 
							  , peaAnt.fechaHoraModificacion = GETDATE(),		   peaAnt.usuarioModificacion =  'adminPsCam' , peaAnt.estacionModificacion = '::TRANSCICLO' 
					FROM proPiscinaEjecucion peaAnt  inner join  MigracionEjecucion me on peaAnt.idPiscina = me.idPiscinaAnterior and peaAnt.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
								
									where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1 and peaAnt.estado = 'INI'
 
		      UPDATE pcd SET pcd.idPiscina = me.idPiscinaPosterior ,       pcd.idPiscinaEjecucion  = me.idPiscinaEjecucionPosterior, 
				   pcd.fechaHoraModificacion = GETDATE(),		   pcd.usuarioModificacion =  'adminPsCam' ,                   pcd.estacionModificacion = @estacionModificacion 
			  FROM proControlParametroDetalle pcd inner join  MigracionEjecucion me on pcd.idPiscina = me.idPiscinaAnterior and pcd.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
			  where me.cod_cicloAnterior=@cod_cicloAnterior and me.activo = 1  
			  print 'caso ambas piscinas inciadas'
			end
	update MigracionEjecucion set activo = 0  where cod_cicloAnterior = @cod_cicloAnterior 
	
	select c.* from proPiscinaEjecucion c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior-- and c.idPiscinaEjecucion = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 

	select c.*  from proPiscinaEjecucion c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaPosterior-- and c.idPiscinaEjecucion = me.idPiscinaEjecucionPosterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 
 
	select c.*  from maePiscinaCiclo c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaAnterior --and c.idOrigen = me.idPiscinaEjecucionAnterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 

	select c.*  from maePiscinaCiclo c inner join  MigracionEjecucion me on c.idPiscina = me.idPiscinaPosterior --and c.idOrigen = me.idPiscinaEjecucionPosterior
	where me.cod_cicloAnterior=@cod_cicloAnterior 


	--select * from proTransferenciaEspecie where idPiscinaEjecucion in (8688,9150,9179)
	--select * from proRecepcionEspecieDetalle where idPiscinaEjecucion in  (8688,9150,9179)
rollback TRAN
 
