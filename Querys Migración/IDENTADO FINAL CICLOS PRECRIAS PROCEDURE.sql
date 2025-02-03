USE IPSPCamaroneraTesting
GO
	----VARIABLE DE PRUEBA ENTRADA
	CREATE OR ALTER PROC USP_SCRIPTMOVIMIENTORECEPCIONES( @SECTORFILTER VARCHAR(100),
	@PISCINATEMP VARCHAR(100), @usarTrans bit = 0)
		AS BEGIN
		--DECLARE @usarTrans BIT = 1
		--DECLARE @SECTORFILTER VARCHAR(100) = 'LOSANGELES'
		--DECLARE @PISCINATEMP VARCHAR(100) = 'LOSANGELESPC3'
		--select * from CICLOS_PRODUCCION where Key_Piscina ='CAPULSAPC2'
		--DECLARE @PISCINALLAVE VARCHAR(100) = 'CAPULSAPC4.91'
 
		DROP TABLE IF EXISTS #EJECUCIONESTEMP			
		DROP TABLE IF EXISTS #FILTERPISCINAKEYTEMP		
		DROP TABLE IF EXISTS #RecepcionesTemp			
		DROP TABLE IF EXISTS #TranferenciaTempPrev		
		DROP TABLE IF EXISTS #TranferenciaTemp			

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

		--select cp.Cod_Ciclo, Key_Piscina, cp.Ciclo as CicloExcel, Fecha_IniSec, Fecha_Siembra, Fecha_Pesca, Cantidad_Sembrada, Zona, Camaronera, Sector, Piscina, Tipo,Tipo_Siembra, Densidad,
		--ej.fechaInicio, ej.fechaSiembra, ej.fechaCierre, ej.cantidadEntrada, ej.ciclo, DATEDIFF(day, Fecha_IniSec, ej.fechaInicio) InicioDiff, DATEDIFF(day, Fecha_Siembra, ej.fechaSiembra) SiembraDiff,DATEDIFF(day, Fecha_Pesca, ej.fechaCierre) CierreDiff,
		--(Cantidad_Sembrada - ej.cantidadEntrada) CantidadDiff, idPiscina, idPiscinaEjecucion
		----into #FILTERPISCINAKEYTEMP
		--from CICLOS_PRODUCCION cp
		--left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
		--WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) AND Sector =@SECTORFILTER order by 1 --and ej.ciclo is null

	   --FILTRAMOS LAS PISCINAS A REGULARIZAR
			SELECT cp.Key_Piscina, cp.Ciclo, cp.Cantidad_Sembrada
			into #FILTERPISCINAKEYTEMP
			from CICLOS_PRODUCCION cp
			left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
			WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
			AND cp.Key_Piscina = @PISCINATEMP and ej.ciclo is null

	   --STEP 2: Query para creación de tabla de transferencia con homologaciones de piscinas con códigos de Insigne
		SELECT  DISTINCT
				'01' AS empresa,			'01' AS division,	  pu.codigoZona AS zona,		 pu.codigoCamaronera AS camaronera,			pu.codigoSector AS sector, 
				 pu.idPiscina,				 pu.codigoPiscina,  

				 CASE WHEN t.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN t.tipo = 'PISCINA' THEN 'ENG01' ELSE '' END AS ROL,  
				 Sector_Origen	 +   CONVERT(VARCHAR(200),Piscina_Origen)    AS keyOrigen, 

				 Cod_Ciclo_Origen,					   fecha_Transf,		pu.codigoZona AS Zona_Origen,   pu.codigoCamaronera as Camaronera_Origen,   pu.nombreSector,			 pu.codigoSector as Sector_Origen, 
				 Piscina_Origen,					   Ciclo_Origen,		Tipo,							Sub_Tipo,									Estatus_Origen, 
				 Hectarea_Origen,					   Fecha_Siembra,		Cantidad_Sembrada,				Densidad,									Peso_Siembra, 
				 Estatus_Transf,					   Cons_Balanc,		    Guia_Transf,					Forma_Transf,   

				 CASE WHEN t.linea = 'TANQUERO'         THEN '001' 	  WHEN t.linea = 'TUBERÍA' THEN '002' 
					  WHEN t.linea = 'TUBERÍA-TANQUERO' THEN '003'    WHEN t.linea = 'A PIE'   THEN '004' 
					  WHEN t.linea = 'DESCUELGUE'       THEN '006'    ELSE '001'			   END	 AS tipoTransferencia,

				Sector_Destino + CONVERT(VARCHAR(200),Piscina_Destino) AS keyDestino,	
				Cod_Ciclo_Destino,			          puD.codigoZona   AS Zona_Destino,			puD.codigoCamaronera AS  Camaronera_Destino,		puD.codigoSector AS  Sector_DestinoCOD,		puD.idPiscina AS idPiscinaDestino,
				Piscina_Destino,					  Ciclo_Destino,							Estatus_Destino,									Hectarea_Destino,							Cantidad_Transf, 
				Peso_Transf,						  Peso_Real,								Libras_Transf,										Conv,										Procedencia_Laboratorio, 
				Linea,								  Maduracion,								Superv,												Balanc,										Lib_Transf_C, 
				Anio,								  Estatus_Transf   AS TipoTransfTOTAL,		'APR' AS estado,									'AdminPsCam'     AS usuarioResponsable,
			   'adminPsCam' AS usuarioCreacion,		 '::2' AS estacionCreacion,      GETDATE() AS fechaHoraCreacion, 
			   'adminPsCam' AS usuarioModificacion,  '::2' AS estacionModificacion,  GETDATE() AS fechaHoraModificacion
		 INTO #TranferenciaTempPrev
		FROM TRANSFERENCIAS_PRODUCCION t   
			left join #EJECUCIONESTEMP pu  ON pu.keyPiscina  = t.keyPiscinaOrigen   
			INNER join #EJECUCIONESTEMP puD ON puD.keyPiscina = t.keyPiscinaDestino
		WHERE T.keyPiscinaOrigen IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) 
			AND t.Ciclo_Origen >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = t.keyPiscinaOrigen)
		ORDER BY 1

		SELECT 	ROW_NUMBER ( ) OVER ( order by t.fecha_Transf,  t.keyOrigen,  t.keyDestino)  as rowKeySecuencia#,
				ROW_NUMBER ( ) OVER ( PARTITION BY keyOrigen order by  t.fecha_Transf, keyDestino ,Piscina_Origen, t.Cod_Ciclo_Origen)  as rowKey#, 
				ROW_NUMBER ( ) OVER ( PARTITION BY t.Cod_Ciclo_Origen order by  t.fecha_Transf, keyOrigen , t.Cod_Ciclo_Origen)  as rowCiclo#, *
				INTO #TranferenciaTemp
				FROM #TranferenciaTempPrev t 
	
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
		WHERE R.KeyPiscina IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) 
		and R.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = R.KeyPiscina)
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
	 
		
		select * from #RecepcionesTemp rp
		select * from #TranferenciaTemp rp
		
		BEGIN TRY
			if @usarTrans = 1 BEGIN BEGIN TRAN END

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

					--select 'antes propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = @PISCINATEMP and estado in ('INI','EJE', 'PRE') ORDER BY 4
					--ANTES DE INICIAR SE PUEDE REGULARIZAR LAS RECEPCIONES Y TRANSFERENCIAS UBICANDOS SUS IDS CORRECTOS


					--/***************FIN VARIABLES INICIALES****************/--
					IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion) >0
						BEGIN --yo se que aun falta el cilco 0 y cuando vienen en estado iniciado
						select 1 AS CONDICION, @cicloRecepcion AS CICLO
							select @secuencialPiscinaEjecucion = idPiscinaEjecucion, @secuencialPiscinaEjecucionSiguiente = idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion
							select @secuencialMaeCiclo = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion
							set @EjecucionExistente = 1
						END
					ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E 
					ON E.keyPiscina = CP.Key_Piscina
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
				
					-------STEP 6 GENERAMOS LA TRANSFERENCIA (TEMPORAL, CABECERA Y DETALLE)
				
					if not exists ( select 1 from proTransferenciaEspecie t inner join EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = t.idPiscinaEjecucion 
									where ej.cod_ciclo = @cicloRecepcion)
						BEGIN
								--/*INICIO SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
									
									SELECT TOP 1 @secuencialTransferencia = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecie' 

									SELECT TOP 1 @secuencialTransferenciaDetalle = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecieDetalle' 

								--/*FIN SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
						
							SELECT
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferencia		  AS idTransferencia,
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferenciaDetalle AS idTransferenciaDetalle,
								empresa,			                    fecha_Transf  AS fechaRegistro,		     fecha_Transf                AS fechaTransferencia,      ROL,
								tipoTransferencia,				        idPiscina,								 1                            AS idEspecie,              0   AS guiaTransferencia,		
								Cantidad_Transf AS cantidadTransferida, Peso_Transf  AS pesoTransferidoGramos,   @secuencialPiscinaEjecucion  AS idPiscinaEjecucion,     0	AS esTotal,    
								Sector_DestinoCOD,                      null         AS cantidadRemanente,       densidad,												 0 as balanceado, 
								''             AS descripcion,          usuarioResponsable,						 estado,												 usuarioCreacion,
								estacionCreacion,						fechaHoraCreacion,                       usuarioModificacion,                                    estacionModificacion ,
								Peso_Siembra,							Peso_Transf,							 Peso_Real,												 Lib_Transf_C, 
								Libras_Transf  AS librasDeclaradas,		Ciclo_Destino,						     fechaHoraModificacion, null as reprocesoContable,       Cod_Ciclo_Destino, 
								idPiscinaDestino,						TipoTransfTOTAL,						 procesado = 0
							INTO #InsertTransfTemp
							FROM #TranferenciaTemp
							WHERE Cod_Ciclo_Origen = @cicloRecepcion;
				 
							SELECT * FROM #InsertTransfTemp

							SELECT top 1 @cantidadTransferencia = SUM(cantidadTransferida) FROM #InsertTransfTemp
							SELECT top 1 @FechaCierre			= MAX(fechaTransferencia)  FROM #InsertTransfTemp
						
							IF exists (select 1 from #InsertTransfTemp)
								BEGIN
							
							select 'trans'
								
									INSERT INTO [dbo].[proTransferenciaEspecie] (
										idTransferencia,				empresa,						secuencia,				fechaRegistro,		    fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				guiaTransferencia,     
										cantidadTransferida,            pesoTransferidoGramos,			idPiscinaEjecucion,		esTotal,				
										cantidadRemanente,				densidad,						balanceado,				descripcion,
										usuarioResponsable,				estado,							usuarioCreacion,
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion)--, reprocesoContable)
									SELECT
										idTransferencia,				empresa,						idTransferencia,		fechaRegistro,			fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				RIGHT('0000000000' + CAST(idTransferencia AS VARCHAR(9)),9)   AS guiaTransferencia, 
										cantidadTransferida,			pesoTransferidoGramos,			idPiscinaEjecucion,		CASE WHEN (ROW_NUMBER() OVER (PARTITION BY fechaTransferencia ORDER BY idTransferencia)) = 1 THEN 1 ELSE 0 END AS esTotal, 
										cantidadRemanente,				densidad,						balanceado,				descripcion, 
										usuarioResponsable,				estado,							usuarioCreacion, 
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion--, reprocesoContable
									FROM #InsertTransfTemp;


									select @estadoTransferencia = TipoTransfTOTAL  from #InsertTransfTemp where TipoTransfTOTAL = 'TOTAL'

									if @estadoTransferencia = 'TOTAL'
										BEGIN
											/*ACTUALIZAMOS PISCINA EJECUCIÓN DE LA PISCINA DE ORIGEN*/--

											IF @EXISTE_CICLO_INICIADO = 1
												BEGIN
											
													--UPDATE proSecuencial 
													--SET    ultimaSecuencia = ultimaSecuencia + 1
													--WHERE  tabla		   = 'piscinaEjecucion' 
												
													--SELECT TOP 1 @secuencialPiscinaEjecucionSiguiente = ultimaSecuencia +1
													--FROM	proSecuencial 
													--WHERE	tabla = 'piscinaEjecucion'
												
												
													SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
													FROM	maeSecuencial 
													WHERE	tabla = 'PiscinaCiclo' 

												END

											--/*ACTUALIZAMOS PISCINA EJECUCIÓN*/--
											INSERT INTO proPiscinaEjecucion (
													idPiscinaEjecucion,					 idPiscina,				      ciclo,			rolPiscina,			numEtapa,			lote,				fechaInicio, 
													fechaSiembra,						 fechaCierre,			      tipoCierre,		idEspecie,			cantidadEntrada,	cantidadAdicional,  cantidadSalida,				
													cantidadPerdida,					 idPiscinaEjecucionSiguiente, estado,			tieneRaleo,			tieneRepanio,		tieneCosecha,		activo,
													usuarioCreacion,					 estacionCreacion,			  fechaHoraCreacion, 
													usuarioModificacion,				 estacionModificacion,		  fechaHoraModificacion) 
											SELECT @secuencialPiscinaEjecucionSiguiente, idPiscina,						0,					'',					0,				sector,				DATEADD(DAY, 1, min(@FechaCierre)), 
													NULL,								 NULL,							'',					0,					0,				0,					0, 
													0,									 NULL,						    'INI',				0,					0,				0,					1,
													@usuarioAudit,						'::2',							@fechaProceso,
													@usuarioAudit,						'::2',							@fechaProceso
											FROM #RecepcionesTemp 
											WHERE Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
											GROUP BY idPiscina, Ciclo, rol, sector
				 
											INSERT INTO [dbo].[maePiscinaCiclo] (
												idPiscinaCiclo,						idPiscina,			    ciclo,		
												fecha,								origen,				    idOrigen, 
												idOrigenEquivalente,				rolCiclo,			    activo, 
												usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
												usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
											SELECT 
												@secuencialMaeCiclo,			idPiscina,				0, 
												DATEADD(DAY, 1, min(@FechaCierre)), 'PRE',					@secuencialPiscinaEjecucionSiguiente, 
												null as idOrigenEquivalente,		ROL,					1, 
												@usuarioAudit,						'::2',					@fechaProceso, 
												@usuarioAudit,						'::2',					@fechaProceso
											FROM #RecepcionesTemp 
											WHERE	Cod_Ciclo = @cicloRecepcion 
											GROUP BY idPiscina, Ciclo, 
													 rol,       sector;
											
											--ACTUALIZAMOS LA EJECUCIÓN PASADA
											UPDATE PE
												SET 
													tipoCierre					= 'TRA',
													cantidadSalida				= @cantidadTransferencia,
													cantidadPerdida				= (cantidadEntrada + cantidadAdicional) - @cantidadTransferencia,
													fechaCierre					= @FechaCierre,
													estado						= 'PRE',
													idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucionSiguiente
												FROM #InsertTransfTemp   PTE
												JOIN proPiscinaEjecucion PE ON PTE.idPiscinaEjecucion = PE.idPiscinaEjecucion;
								
											--OBTENEMOS LOS ID DE EJECUCIÓN DESTINO Y CICLOS DE DESTINO **OJO ASUMIENDO QUE NO EXISTE
											UPDATE proSecuencial 
											SET    ultimaSecuencia = @secuencialPiscinaEjecucionSiguiente  
											WHERE  tabla           = 'piscinaEjecucion' 
		
											UPDATE maeSecuencial 
											SET    ultimaSecuencia = @secuencialMaeCiclo + 1
											WHERE  tabla           = 'PiscinaCiclo' 
											--declare @CicloSiguiente int, @KeyPiscinaCicloSiguiente varchar(50);
											--select  @CicloSiguiente = @secuencialMaeCiclo + 1
											--select  @KeyPiscinaCicloSiguiente = @keyPiscina + '.' + @CicloSiguiente
											--   EXEC InsertLogEjecucionesCiclosProduccion 
											--			@idPiscina,						 @secuencialPiscinaEjecucionSiguiente, 
											--			@CicloSiguiente,				 @keyPiscina, 
											--			@KeyPiscinaCicloSiguiente,	    'proTransferencia',
											--			'INI',							'proRecepcion - proTransferencia'

										END
										--UPDATE PICINA EJECUCION
								
									--/*TRANSFERENCIAS DESTINO*/--
								
									SET @EjecucionExistente = 0
									SET @EXISTE_CICLO_INICIADO = 0
									WHILE EXISTS (SELECT * FROM #InsertTransfTemp WHERE procesado = 0)
									BEGIN
											select top 1 @secuencialRowKeyTransferencia = idTransferenciaDetalle, @cicloTransferencia = Cod_Ciclo_Destino from #InsertTransfTemp;

											--VERIFICAR SI EXISTE CICLO DE DESTINO
											IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloTransferencia) >0
												BEGIN
													select @secuencialPiscinaEjecucionDESTINO = idPiscinaEjecucion, @secuencialPiscinaEjecucionSiguienteDESTINO = idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloTransferencia
													SET @EjecucionExistenteDESTINO = 1
													select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
												END
											ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
													AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
													AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
												   WHERE CP.Cod_Ciclo = @cicloTransferencia)
												BEGIN
													SELECT TOP 1  @secuencialPiscinaEjecucionDESTINO = E.idPiscinaEjecucion
														FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
																AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
																AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
															   WHERE CP.Cod_Ciclo = @cicloTransferencia

														select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
													
														SELECT TOP 1 @secuencialPiscinaEjecucionSiguienteDESTINO = ultimaSecuencia + 1
														FROM	proSecuencial 
														WHERE	tabla = 'piscinaEjecucion' 
														SET @EjecucionExistente = 1
														SET @EXISTE_CICLO_INICIADO = 1
												END
											ELSE 
												BEGIN
										
													SELECT TOP 1 @secuencialPiscinaEjecucionDESTINO = ultimaSecuencia + 1
													FROM	proSecuencial 
													WHERE	tabla = 'piscinaEjecucion' 

													SELECT TOP 1 @secuencialMaeCicloDESTINO = ultimaSecuencia + 1
													FROM	maeSecuencial 
													WHERE	tabla = 'PiscinaCiclo' 
													SET @EjecucionExistenteDESTINO = 0
												
													SET @secuencialPiscinaEjecucionSiguienteDESTINO = @secuencialPiscinaEjecucionDESTINO + 1;

													--***OJO CONSULTAR EXISTENTE***--
													INSERT INTO proPiscinaEjecucion (
														idPiscinaEjecucion,				idPiscina,					 ciclo,							rolPiscina,			 numEtapa,					lote,					fechaInicio, 
														fechaSiembra,					fechaCierre,				 tipoCierre,					idEspecie,			 cantidadEntrada,			cantidadAdicional,		cantidadSalida, 
														cantidadPerdida,				idPiscinaEjecucionSiguiente, estado,						tieneRaleo,			 tieneRepanio,				tieneCosecha,			activo, 
														usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,				usuarioModificacion, estacionModificacion,		fechaHoraModificacion)
													SELECT 
														@secuencialPiscinaEjecucionDESTINO,		idPiscinaDestino,			 Ciclo_Destino,					ROL,				 1,							Sector_DestinoCOD,		DATEADD(DAY, -1, MIN(fechaTransferencia)), 
														MIN(fechaTransferencia),		NULL,						 '',							1,					 SUM(cantidadTransferida),	 0,						0, 
														0,								NULL,						'EJE',							0,					 0,							 0,						1,
														@usuarioAudit,					'::2',						 @fechaProceso,					@usuarioAudit,		'::2',						 @fechaProceso
														FROM #InsertTransfTemp 
														GROUP BY idPiscinaDestino, Ciclo_Destino, rol, Sector_DestinoCOD
			
													INSERT INTO [dbo].[maePiscinaCiclo] (
														idPiscinaCiclo,								idPiscina,			    ciclo,		
														fecha,										origen,				    idOrigen, 
														idOrigenEquivalente,						rolCiclo,			    activo, 
														usuarioCreacion,							estacionCreacion,		fechaHoraCreacion, 
														usuarioModificacion,						estacionModificacion,   fechaHoraModificacion)
													SELECT 
														@secuencialMaeCicloDESTINO ,						idPiscinaDestino,		Ciclo_Destino, 
														DATEADD(DAY, -1, min(fechaTransferencia)), 'EJE',					@secuencialPiscinaEjecucionDESTINO, 
														null as idOrigenEquivalente,				ROL,					1, 
														@usuarioAudit,								'::2',					@fechaProceso, 
														@usuarioAudit,								'::2',					@fechaProceso
													FROM	 #InsertTransfTemp 
													GROUP BY idPiscinaDestino, Ciclo_Destino, 
															rol,			   Sector_DestinoCOD

												END
									
									
												INSERT INTO [dbo].[proTransferenciaEspecieDetalle] (
															idTransferenciaDetalle,			idTransferencia,			 orden,									idPiscina,				rolPiscina,				cantidadTransferida,
															pesoPromedioTransferencia,		biomasa,					 
															idPiscinaEjecucion,				tipoTransferencia,			 horaInicioTransferencia,				horaFinTransferencia, 
															observacion,					observacionParametro,		 observacionCaracteristica,				usuarioResponsable,		activo, 
															usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
															librasDeclaradas,				cantidadDeclarada,			 pesoDeclaradoTransferido,				numeroViajes)
												SELECT
															idTransferenciaDetalle,			idTransferencia,			 1,										idPiscinaDestino,		ROL as rolPiscina,		cantidadTransferida,
															pesoTransferidoGramos,			(cantidadTransferida * pesoTransferidoGramos) * 0.00220462 as biomasa, 
															@secuencialPiscinaEjecucionDESTINO,	tipoTransferencia,			'06:00:00' as horaInicioTransferencia, '06:00:00' as horaFinTransferencia, 
															'' as observacion,				null,						null,									usuarioResponsable,		1, 
															usuarioCreacion,				estacionCreacion,			fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
															librasDeclaradas,				cantidadTransferida,		pesoTransferidoGramos,					null
												FROM		#InsertTransfTemp
												where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferencia;

								
												declare @sumaTransDetalle int = 0;
												select @sumaTransDetalle FROM #InsertTransfTemp
												where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferencia;

												--ACTUALIZAMOS EL CICLO INICIADO DEL DESTINO
												declare @cicloMax int,@fechaSiembraMin date;
												select 
														@fechaSiembraMin				= min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding)
												FROM   proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')
													
												select 
													@cicloMax = irt.Ciclo_Destino
												FROM   #InsertTransfTemp irt 
												WHERE  irt.Cod_Ciclo_Destino = @cicloTransferencia

												UPDATE pe
													SET 
														ciclo						= @cicloMax , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														rolPiscina					= 'ENG01',
														numEtapa					= 1,
														fechaSiembra				= @fechaSiembraMin, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
														tipoCierre					= '',
														idEspecie					= 1,
														--cantidadEntrada				= sum(c.cantidadTransferida),
														cantidadEntrada				= cantidadEntrada + @sumaTransDetalle,
														cantidadAdicional			=  0,
														cantidadSalida				= 0,
														cantidadPerdida				= CASE WHEN cantidadSalida > 0 THEN (cantidadEntrada + cantidadAdicional) - cantidadSalida ELSE 0 END,
														estado						= 'EJE',
														usuarioModificacion			= @usuarioAudit,
														fechaHoraModificacion		= @fechaProceso
												--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
												--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
												--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
												FROM   proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

												--MAEPISCINA CICLO
												UPDATE pc
													SET 
														ciclo						= @cicloMax,--(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														origen						= 'EJE',
														rolCiclo					= 'ENG01',
														usuarioModificacion			= @usuarioAudit,
														fechaHoraModificacion		= @fechaProceso
												--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
												--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
												--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
												FROM  proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia 
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate()) 
														INNER JOIN maePiscinaCiclo pc on pe.idPiscinaEjecucion = pc.idOrigen
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

											UPDATE #InsertTransfTemp 
											SET   procesado = 1 
											WHERE Cod_Ciclo_Destino = @cicloTransferencia and idTransferenciaDetalle = @secuencialRowKeyTransferencia --and fechaRecepcion = @fechaRecep
									END
								
									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferencia) FROM #InsertTransfTemp)  
									WHERE  tabla		   = 'transferenciaEspecie' 

									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferenciaDetalle) FROM #InsertTransfTemp) 
									WHERE  tabla		   = 'transferenciaEspecieDetalle' 

							END
						END

						print 'secuencia ' + cast( @cicloRecepcion as varchar(50)) + ' ' + cast( @fechaRecep as varchar(10))
					
					--select 'despues propiscinaejecucion',* from EjecucionesPiscinaView where nombreSector = @PISCINATEMP and estado in ('INI','EJE', 'PRE') ORDER BY 4
					
					--exec viewProcessCiclos  @PISCINATEMP, 1
					UPDATE #RecepcionesTemp 
					SET   procesado = 1 
					WHERE Cod_Ciclo = @cicloRecepcion and rowKeySecuencia# = @rowKeySecuencia --and fechaRecepcion = @fechaRecep

				END

			-----CONFIRMACION DE LA TRANSACCION
			--SELECT * FROM proRecepcionEspecie WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proRecepcionEspecieDetalle WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proTransferenciaEspecieDetalle where  idPiscinaEjecucion = @secuencialPiscinaEjecucion
			--select * from  proPiscinaEjecucion where idPiscina = 2002
		
			--select 'FINAL propiscinaejecucion',* from EjecucionesPiscinaView where nombreSector = @SECTORFILTER and estado  in ('INI','EJE', 'PRE')  ORDER BY 4
			
			if @usarTrans = 1 BEGIN ROLLBACK TRAN END
		END TRY
		BEGIN CATCH
			-----REVERSA DE LA TRANSACCION
			if @usarTrans = 1 BEGIN ROLLBACK TRAN END
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
	END


	