	USE IPSPCamaroneraTesting
	GO
	--VARIABLE DE PRUEBA ENTRADA

	--select * from CICLOS_PRODUCCION where Key_Piscina ='CAPULSAPC2'
	DECLARE @PISCINALLAVE VARCHAR(100) = 'CAPULSAPC3.93'
	DECLARE @SECTORFILTER VARCHAR(100) = 'CAPULSA'
 
	DROP TABLE IF EXISTS #EJECUCIONESTEMP
	DROP TABLE IF EXISTS #RecepcionesTemp


	/*Nomenclatura Preparacion = "PRE"; Manual = "MAN"; EjecucionPiscina = "EJE"; MantenimientoPiscina = "MNT";*/
	--STEP 1: Query para poblar temporal de ejecuciones moldeado a keys de excel
		SELECT	pu.codigoZona,	       pu.nombreZona,       pu.codigoCamaronera, pu.nombreCamaronera, 
				pu.codigoSector,       pu.nombreSector,     pu.codigoPiscina,    pu.nombrePiscina, 
				ce.codigoElemento,     ce.nombreElemento,   pe.idPiscina,        
				pu.nombreSector + pu.nombrePiscina + '.' + CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, 
				pu.nombreSector + pu.nombrePiscina AS keyPiscina, 
				pe.idPiscinaEjecucion, pe.ciclo,            pe.fechaInicio,      pe.fechaSiembra, 
				pe.fechaCierre,			pe.cantidadEntrada
		INTO #EJECUCIONESTEMP 
		FROM proPiscinaEjecucion pe 
			INNER JOIN PiscinaUbicacion  pu ON  pe.idPiscina	 = pu.idPiscina 
			INNER JOIN CATALOGO_ELEMENTS ce ON ce.codigoElemento = pe.rolPiscina AND ce.codigoCatalogo = 'maeRolPiscina' 
		WHERE estado in ('EJE', 'PRE')
   

	 --STEP 3: Query para creación de tabla de recepciones con homologaciones de piscinas con códigos de Insigne
	SELECT 
		ROW_NUMBER ( ) OVER ( order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowKeySecuencia#,
		ROW_NUMBER ( ) OVER ( PARTITION BY r.KeyPiscina order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowKey#,   
		ROW_NUMBER ( ) OVER ( PARTITION BY r.Cod_Ciclo order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)   as rowCiclo#, r.Cod_Ciclo,r.KeyPiscina as KeyPiscina,
		0 as idRecepcion,					'01' as empresa,							'01' as division,				pu.nombreZona as NombreZoma,	
		pu.codigoZona as zona,				 pu.nombreCamaronera as nombreCamaronera, 
		pu.codigoCamaronera as camaronera,	 r.Sector as nombreSector,					pu.codigoSector as sector, 
		r.Piscina,							 pu.codigoPiscina,						    pu.idPiscina,					r.Ciclo, 
		case when r.tipo = 'PRECRIADERO' then 'PRE01' when r.tipo = 'PISCINA' then 'ENG01' else '' end AS ROL, 
		0 as secuencia,				 		 'PLA' as origen,							null idOrdenCompra, 
		null idDespacho,				     null idPlanificacionSiembra,
		COALESCE(LP.idLaboratorio,0) as idLaboratorio, COALESCE(LP.idLaboratorioLarva,0) as idLaboratorioLarva,	COALESCE(LM.idLaboratorioLarva,0)  as idLaboratorioMaduracion,	Peso_Siembra, 
		PlGr_Guia as plGramoLab,			           PlGr_Llegada as plGramoCam,								r.Fecha_Siembra as fechaRegistro,								DATEADD(DAY, -1, r.Fecha_Siembra) as fechaDespacho, 
		r.Fecha_Siembra as fechaRecepcion,             '06:00:00' as horaDespacho,								'07:00:00' as horaRecepcion,
		0 as idResponsableSiembra,				       1 as idEspecie,											'00001' AS tipoLarva,											r.Cantidad_Sembrada as cantidad, 
		1 as cantidadPlus,						       (r.Cantidad_Sembrada * 0.15) as porcentajePlus, 
		'UNIDAD' as unidadMedida,				       r.Cantidad_Sembrada as cantidadRecibida,					r.Guia_Remision as guiasRemision,								0 as tieneFactura, 
		'Regularizada' as descripcion,			       '' as responsableEntrega,									'APR' AS estado,											'AdminPsCam' as usuarioResponsable,
		'adminPsCam'   as usuarioCreacion,		       '::2' AS estacionCreacion,									GETDATE() AS fechaHoraCreacion,		
		'adminPsCam'   as usuarioModificacion,         '::2' AS estacionModificacion,							     GETDATE() AS fechaHoraModificacion,						null AS reprocesoContable,
		0 procesado
	INTO #RecepcionesTemp
	FROM RECEPCIONES_PRODUCCION r 
	left join #EJECUCIONESTEMP pu ON pu.Cod_Ciclo = r.Cod_Ciclo 
	LEFT JOIN LABORATORIO_PROCEDENCIA_PRODUCCION LP ON LP.Procedencia_Laboratorio = r.Procedencia_Laboratorio
	LEFT JOIN LABORATORIO_MADURACION_PRODUCCION  LM ON LM.Maduracion = r.Maduracion
	WHERE R.KeyPiscina = @PISCINALLAVE --r.Sector = @SECTORFILTER
	ORDER BY 1;

	with  cte as(
		select  idPiscina, nombreSector+nombrePiscina  KeyPiscina, codigoPiscina, codigoSector sector, nombreSector, nombreCamaronera, codigoCamaronera, codigoZona, nombreZona
			from PiscinaUbicacion   rb -- where   idPiscina is not null
	)
	update ru
	set ru.idPiscina = rb.idPiscina,
		ru.codigoPiscina = rb.codigoPiscina, 
		ru.sector = rb.sector,
		ru.camaronera = rb.codigoCamaronera,
		ru.nombreCamaronera = rb.nombreCamaronera,
		ru.zona  = rb.codigoZona,
		ru.NombreZoma = rb.nombreZona
	from 
	#RecepcionesTemp ru inner join cte rb on ru.KeyPiscina = rb.KeyPiscina   and ru.idPiscina is null;
	 

	BEGIN TRY
		BEGIN TRAN

		declare @EjecucionExistente bit = 1
		declare @EjecucionExistenteDESTINO bit = 1
		declare @estadoTransferencia varchar(10)
		declare @EXISTE_CICLO_INICIADO bit = 0
		
		declare @secuencialRecepcion int = 0
		declare @secuencialRecepcionDetalle int = 0

		declare @secuencialRowKeyTransferencia int = 0
		declare @secuencialTransferencia int = 0
		declare @secuencialTransferenciaDetalle int = 0
		declare @maxSecuencialRecepcion int = 0

		declare @cantidadTransferencia int = 0 
		declare @FechaCierre date 
	
		declare @secuencialMaeCiclo int = 0
		declare @secuencialPiscinaEjecucion int = 0
		declare @secuencialPiscinaEjecucionSiguiente int = null

		declare @secuencialMaeCicloDESTINO int = 0
		declare @secuencialPiscinaEjecucionDESTINO int = 0
		declare @secuencialPiscinaEjecucionSiguienteDESTINO int = null

		declare @secuencia int = 0
		declare @cicloRecepcion varchar(100)
		declare @rowKeySecuencia int = 0
		declare @cicloTransferencia varchar(100)
		declare @fechaRecep dateTime
		declare @fechaProceso dateTime = getdate()
		declare @usuarioAudit varchar(50) = 'AdminPsCam'

		declare @idPiscina int
		declare @keyPiscina varchar(50)
		--Bloqueamos las tablas de secuenciales
		SELECT top 1 1 FROM proSecuencial WITH (TABLOCKX)
		SELECT top 1 1 FROM maeSecuencial WITH (TABLOCKX)
			
			WHILE exists (select procesado from #RecepcionesTemp where procesado = 0 )
			BEGIN
				--/***************INCIO VARIABLES INICIALES*********	*******/--
				SELECT TOP 1 @secuencia  = rowKeySecuencia# FROM #RecepcionesTemp  WHERE procesado = 0 ORDER BY rowKeySecuencia#;
				select top 1 @cicloRecepcion = Cod_Ciclo, @fechaRecep = fechaRecepcion, @rowKeySecuencia = rowKey# from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
				--SET @cicloRecepcion = @PISCINALLAVE --select top 1 @cicloRecepcion = @PISCINALLAVE from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
				
				SELECT TOP 1 @idPiscina  = idPiscina, 
							 @keyPiscina = keyPiscina  
					   FROM  #EJECUCIONESTEMP 
					   WHERE Cod_Ciclo = @cicloRecepcion

				DROP TABLE IF EXISTS #InsertRecepTemp  

				select 'antes propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = 'CAPULSAPC2' and estado in ('INI','EJE', 'PRE') ORDER BY 4
				--ANTES DE INICIAR SE PUEDE REGULARIZAR LAS RECEPCIONES Y TRANSFERENCIAS UBICANDOS SUS IDS CORRECTOS


				--/***************FIN VARIABLES INICIALES****************/--
				IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion) >0
					BEGIN --yo se que aun falta el cilco 0 y cuando vienen en estado iniciado
					select 1 AS CONDICION, @cicloRecepcion AS CICLO
						select @secuencialPiscinaEjecucion = idPiscinaEjecucion, @secuencialPiscinaEjecucionSiguiente = idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion
						select @secuencialMaeCiclo = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion
						set @EjecucionExistente = 1
					END
				ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
						AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
						AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
					   WHERE CP.Cod_Ciclo = @cicloRecepcion)
					BEGIN
					select 2 AS CONDICION, @cicloRecepcion AS CICLO
						SELECT TOP 1  @secuencialPiscinaEjecucion = E.idPiscinaEjecucion
							FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
									AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
									AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
								   WHERE CP.Cod_Ciclo = @cicloRecepcion

								   
							SELECT TOP 1 @secuencialPiscinaEjecucionSiguiente = ultimaSecuencia + 1
							FROM	proSecuencial 
							WHERE	tabla = 'piscinaEjecucion' 

							select @secuencialMaeCiclo = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion

							 SET @EjecucionExistente = 1
							 SET @EXISTE_CICLO_INICIADO = 1
							 
							select @secuencialPiscinaEjecucion AS ID, @secuencialPiscinaEjecucionSiguiente AS IDSGT
					END
				ELSE
					BEGIN 
					select 3 AS CONDICION, @cicloRecepcion AS CICLO
						set @EjecucionExistente = 0
						--/*INICIO SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--
						UPDATE proSecuencial 
						SET    ultimaSecuencia = ultimaSecuencia + 1  
						WHERE  tabla		   = 'piscinaEjecucion' 

						SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia 
						FROM	proSecuencial 
						WHERE	tabla = 'piscinaEjecucion' 

						UPDATE maeSecuencial 
								SET ultimaSecuencia = ultimaSecuencia + 1 
						WHERE tabla = 'PiscinaCiclo' 

						SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia 
						FROM	maeSecuencial 
						WHERE	tabla = 'PiscinaCiclo' 
						--/*FIN SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--

						--select @secuencialPiscinaEjecucion, @cicloRecepcion
						SET @secuencialPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucion + 1;

						-------STEP 4 GENERAMOS LA EJECUCIÓN Y CICLO DE LA PISCINA A SEMBRAR (RECEPCIONAR)
	 					SELECT @secuencialPiscinaEjecucion, idPiscina,					 Ciclo,				ROL,			1,				sector,					DATEADD(DAY, -1, min(fechaRecepcion)), 
									min(fechaRecepcion),		null,						  '',				 1,				SUM(cantidad),	SUM( porcentajePlus),	0, 
									0,							null,						 'EJE',				 0,				0,				0,						1,
									@usuarioAudit,				'::2',						 @fechaProceso,		
									@usuarioAudit,				'::2',						 @fechaProceso
							FROM   #RecepcionesTemp 
							WHERE  Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
							GROUP BY idPiscina, Ciclo, rol, sector

							-------EJECUCION PISCINA
							INSERT INTO proPiscinaEjecucion (
									idPiscinaEjecucion,			idPiscina,					 ciclo,				rolPiscina,		numEtapa,		 lote,					fechaInicio, 
									fechaSiembra,				fechaCierre,				 tipoCierre,		idEspecie,		cantidadEntrada, cantidadAdicional,		cantidadSalida, 
									cantidadPerdida,			idPiscinaEjecucionSiguiente, estado,			tieneRaleo,		tieneRepanio,	 tieneCosecha,			activo, 
									usuarioCreacion,			estacionCreacion,			 fechaHoraCreacion, 
									usuarioModificacion,		estacionModificacion,		 fechaHoraModificacion) 
							SELECT @secuencialPiscinaEjecucion, idPiscina,					 Ciclo,				ROL,			1,				sector,					DATEADD(DAY, -1, min(fechaRecepcion)), 
									min(fechaRecepcion),		null,						  '',				 1,				SUM(cantidad),	SUM( porcentajePlus),	0, 
									0,							null,						 'EJE',				 0,				0,				0,						1,
									@usuarioAudit,				'::2',						 @fechaProceso,		
									@usuarioAudit,				'::2',						 @fechaProceso
							FROM   #RecepcionesTemp 
							WHERE  Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
							GROUP BY idPiscina, Ciclo, rol, sector
				
							-------CICLO PISCINA
							INSERT INTO [dbo].[maePiscinaCiclo] (
								idPiscinaCiclo,						idPiscina,			    ciclo,		
								fecha,								origen,				    idOrigen, 
								idOrigenEquivalente,				rolCiclo,			    activo, 
								usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
								usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
							SELECT 
								@secuencialMaeCiclo,					idPiscina,			ciclo, 
								DATEADD(DAY, -1, MIN(fechaRecepcion)), 'EJE',				@secuencialPiscinaEjecucion, 
								null as idOrigenEquivalente,            ROL,				1, 
								@usuarioAudit,						   '::2',				@fechaProceso,
								@usuarioAudit,						   '::2',				@fechaProceso
							FROM #RecepcionesTemp 
							WHERE	Cod_Ciclo  = @cicloRecepcion 
							GROUP BY idPiscina,  Ciclo, 
									 rol,        sector;
						--/*FIN SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--

						-----------auditamos 
						--EXEC InsertLogEjecucionesCiclosProduccion 
						--			@idPiscina,		    @secuencialPiscinaEjecucion, 
						--			@secuencialMaeCiclo,@keyPiscina, 
						--			@cicloRecepcion,	'proRecepcion',
						--			'EJE',		        'proRecepcion'

					END


				if not exists ( select top 1 1 from proRecepcionEspecieDetalle re 
								inner join EjecucionesPiscinaView ej on re.idPiscinaEjecucion = ej.idPiscinaEjecucion
								where ej.Cod_Ciclo = @cicloRecepcion )
					BEGIN
						select 'recepcion'
						--/*INICIO SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
						UPDATE proSecuencial 
						SET    ultimaSecuencia = ultimaSecuencia  
						WHERE  tabla		   = 'recepcionEspecie' 

						SELECT TOP 1 @secuencialRecepcion = ultimaSecuencia 
						FROM	proSecuencial 
						WHERE	tabla = 'recepcionEspecie' 

						UPDATE proSecuencial 
						SET    ultimaSecuencia = ultimaSecuencia
						WHERE  tabla		   = 'recepcionEspecieDetalle' 

						SELECT TOP 1 @secuencialRecepcionDetalle = ultimaSecuencia 
						FROM  proSecuencial 
						WHERE tabla = 'recepcionEspecieDetalle' 

						--/*FIN SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
						
						-------STEP 5 GENERAMOS LA RECEPCION (TEMPORAL, CABECERA Y DETALLE)
						SELECT
							ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcion		AS idRecepcion,
							ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcionDetalle AS idRecepcionDetalle,
							empresa,				 division,			   zona,					camaronera,				 sector,				 0 as secuencia,	origen, 
							idOrdenCompra,			 idDespacho,	       idPiscina,				ROL,					 idPlanificacionSiembra, idLaboratorio,		idLaboratorioLarva,		
							idLaboratorioMaduracion, fechaRegistro,        fechaDespacho,		    fechaRecepcion,          horaDespacho,           horaRecepcion,     idResponsableSiembra, 
							idEspecie,				 tipoLarva,            cantidad,               cantidadPlus,			 porcentajePlus,         unidadMedida,      cantidadRecibida, 
							guiasRemision,           plGramoCam,           plGramoLab,				tieneFactura,			 descripcion,			responsableEntrega, estado,
							usuarioResponsable,      usuarioCreacion,      estacionCreacion,       fechaHoraCreacion,
							usuarioModificacion,     estacionModificacion, fechaHoraModificacion,  Cod_Ciclo,				 Ciclo--, reprocesoContable 
							into #InsertRecepTemp 
						FROM #RecepcionesTemp 
						where Cod_Ciclo = @cicloRecepcion and fechaRecepcion = @fechaRecep and procesado = 0 ; 
				
								SELECT * FROM #InsertRecepTemp
						-------CABECERA RECEPCION
						INSERT INTO [dbo].[proRecepcionEspecie] (
							idRecepcion,         empresa,              division,            zona,                   camaronera,            sector,             secuencia, 
							origen,              idOrdenCompra,        idDespacho,          idPlanificacionSiembra, idLaboratorio,         idLaboratorioLarva, fechaRegistro,
							fechaDespacho,       fechaRecepcion,       horaDespacho,        horaRecepcion,          idResponsableSiembra,  idEspecie,          tipoLarva, 
							cantidad,            cantidadPlus,         porcentajePlus,      unidadMedida,           cantidadRecibida,
							guiasRemision,       tieneFactura,         descripcion,         responsableEntrega,     estado,                usuarioResponsable, 
							usuarioCreacion,     estacionCreacion,     fechaHoraCreacion, 
							usuarioModificacion, estacionModificacion, fechaHoraModificacion)--, reprocesoContable)
						SELECT
							idRecepcion,		 empresa,				division,			zona,						camaronera,				sector,				idRecepcion, 
							origen,				 idOrdenCompra,			idDespacho,			idPlanificacionSiembra,		idLaboratorio,			idLaboratorioLarva, fechaRegistro, 
							fechaDespacho,		 fechaRecepcion,		horaDespacho,		horaRecepcion,				idResponsableSiembra,	idEspecie,			tipoLarva, 
							cantidad,			 cantidadPlus,			porcentajePlus,		unidadMedida,				cantidadRecibida,		
							guiasRemision,		 tieneFactura,		    descripcion,	    responsableEntrega,         estado,				    usuarioResponsable,		
							usuarioCreacion,	 estacionCreacion,		fechaHoraCreacion,
							usuarioModificacion, estacionModificacion,  fechaHoraModificacion--, reprocesoContable
						FROM #InsertRecepTemp

						-------DETALLE RECEPCION (**PENDIENTE LA PLANIFICACION DE ORIGEN)
						INSERT INTO [dbo].[proRecepcionEspecieDetalle] (
							  idRecepcionDetalle,			idRecepcion,						idPiscinaPlanificacion,		orden,					idPiscina,			      rolPiscina,			
							  cantidad,					    unidadMedida,						cantidadRecibida,			cantidadAdicional,		idPiscinaEjecucion,		  idCodigoGenetico,	
							  idLaboratorioMaduracion,		codigoLarva,						biomasa,				    oxigeno,                salinidad,                temperatura,   
							  costoLarva,					costoServiciosPrestados,			costoFlete,					amonio,					ph,						  alcalinidad,			
							  conteoAlgas,			        descripcion,						numeroCajas,				numeroTinas,            tanqueOrigen,             plGramoLab, 
							  plGramoCam,				    numeroArtemia,						calidadAgua,			    tanqueCalidadAguaBuena, tanqueCalidadAguaRegular, tanqueCalidadAguaMala,
							  observacionParametro,         observacionCaracteristica,			activo,						idMotivoAuditoria,
							  usuarioCreacion,              estacionCreacion,					fechaHoraCreacion,			usuarioModificacion,
							 estacionModificacion,			fechaHoraModificacion)--, origenPlGramo)
						SELECT
							 idRecepcionDetalle,			idRecepcion,						0 as idPiscinaPlanificacion,	1,							idPiscina,						ROL as rolPiscina, 
							 cantidad,						unidadMedida,						cantidadRecibida,				porcentajePlus,				@secuencialPiscinaEjecucion,    null as idCodigoGenetico, 
							 idLaboratorioMaduracion,		null as codigoLarva,				null as biomasa,				null as oxigeno,			null as salinidad,			    null as temperatura, 
							 null as costoLarva,			null as costoServiciosPrestados,	null as costoFlete,				null as amonio,			    null as ph,					    null as alcalinidad, 
							 null as conteoAlgas,			'' as descripcion,					null as numeroCajas,			3 as numeroTinas,			null as tanqueOrigen,			plGramoLab, 
							 plGramoCam,					null as numeroArtemia,				null as calidadAgua,		    1 as tanqueCalidadAguaBuena, 1 as tanqueCalidadAguaRegular, 1 as tanqueCalidadAguaMala,
							 null as observacionParametro,  null as observacionCaracteristica,  1 as activo,                    null as idMotivoAuditoria,
							 usuarioCreacion,               estacionCreacion,                  fechaHoraCreacion,			    usuarioModificacion,
							 estacionModificacion,          fechaHoraModificacion--, 'CAM' as origenPlGramo
						FROM #InsertRecepTemp;

						if @EjecucionExistente = 1 and @EXISTE_CICLO_INICIADO = 1
							BEGIN
							 SELECT 'HOLISS'
								--/*ACTUALIZAMOS EL IDEJECUCIÓN EN PARA DEJAR LISTO LA ULTIMA SECUENCIA **OJO*/--
				
								--UPDATE	proSecuencial 
								--SET		ultimaSecuencia = @secuencialPiscinaEjecucion
								--WHERE	tabla			= 'piscinaEjecucion' 
								
								--ACTUALIZAMOS EL CICLO INICIADO DEL DESTINO
								
								declare @sumaRecepDetalle int = 0;
								select @sumaRecepDetalle = cantidadRecibida FROM #InsertRecepTemp where Cod_Ciclo = @cicloRecepcion;
								SELECT  @cicloRecepcion;
								SELECT * FROM #InsertRecepTemp -- where Cod_Ciclo = @cicloRecepcion;
								declare @cicloMaxRECEP int, @fechaSiembraMinRECEP date;

								select 
										@fechaSiembraMinRECEP				= min(fechaRecepcion) over (order by c.idPiscina rows unbounded preceding)
								FROM   proRecepcionEspecieDetalle c  
								INNER JOIN proRecepcionEspecie t	  on c.idRecepcion = t.idRecepcion
								INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaRecepcion BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
								WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucion
								AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')
								
								select 
									@cicloMaxRECEP = irt.Ciclo
								FROM   #InsertRecepTemp irt 
								WHERE  irt.Cod_Ciclo = @cicloRecepcion

								UPDATE pe
									SET 
										ciclo						= @cicloMaxRECEP , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
										rolPiscina					= 'ENG01',
										numEtapa					= 1,
										fechaSiembra				= @fechaSiembraMinRECEP, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
										tipoCierre					= '',
										idEspecie					= 1,
										--cantidadEntrada				= sum(c.cantidadTransferida),
										cantidadEntrada				= cantidadEntrada + @sumaRecepDetalle,
										cantidadAdicional			=  0,
										cantidadSalida				= 0,
										cantidadPerdida				= CASE WHEN cantidadSalida > 0 THEN (cantidadEntrada + pe.cantidadAdicional) - cantidadSalida ELSE 0 END,
										estado						= 'EJE',
										usuarioModificacion			= @usuarioAudit,
										fechaHoraModificacion		= @fechaProceso
								--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
								--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
								--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
								FROM   proRecepcionEspecieDetalle c  
										INNER JOIN proRecepcionEspecie t	  on c.idRecepcion = t.idRecepcion
										INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaRecepcion BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
										WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucion
										AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

								--MAEPISCINA CICLO
								UPDATE pc
									SET 
										ciclo						= @cicloMaxRECEP,--(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
										origen						= 'EJE',
										rolCiclo					= 'PRE01',
										usuarioModificacion			= @usuarioAudit,
										fechaHoraModificacion		= @fechaProceso
								--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
								--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
								--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
								FROM  proTransferenciaEspecieDetalle c  
										INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia 
										INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = t.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate()) 
										INNER JOIN maePiscinaCiclo pc on pe.idPiscinaEjecucion = pc.idOrigen
										WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucion
										AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

								--FALTA MAECILO PONERLE EL ROL
							END
					END
				
				

					print 'secuencia ' + cast( @cicloRecepcion as varchar(50)) + ' ' + cast( @fechaRecep as varchar(10))
					
				select 'despues propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = 'CAPULSAPC2' and estado in ('INI','EJE', 'PRE') ORDER BY 4
				UPDATE #RecepcionesTemp 
				SET   procesado = 1 
				WHERE Cod_Ciclo = @cicloRecepcion and rowKeySecuencia# = @rowKeySecuencia --and fechaRecepcion = @fechaRecep

			END
		-----CONFIRMACION DE LA TRANSACCION
		--SELECT * FROM proRecepcionEspecie WHERE idRecepcion = @secuencialRecepcion
		--SELECT * FROM proRecepcionEspecieDetalle WHERE idRecepcion = @secuencialRecepcion
		--SELECT * FROM proTransferenciaEspecieDetalle where  idPiscinaEjecucion = @secuencialPiscinaEjecucion
		--select * from  proPiscinaEjecucion where idPiscina = 2002
		
		select 'FINAL propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = 'CAPULSAPC2' and estado  in ('INI','EJE', 'PRE')  ORDER BY 4
		ROLLBACK TRAN 
	END TRY
	BEGIN CATCH
		-----REVERSA DE LA TRANSACCION
		rollback tran 
		SELECT  
			 ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  

			DECLARE @ErrorMessage  NVARCHAR(4000), 
			        @ErrorSeverity INT, 
					@ErrorState INT;

			SELECT  @ErrorMessage  = ERROR_MESSAGE(), 
			        @ErrorSeverity = ERROR_SEVERITY(), 
					@ErrorState    = ERROR_STATE();
			
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH

