use IPSPProduccion
DECLARE @PISCINALLAVE VARCHAR(100) = 'CAPULSAPC2.89'
--alter table RECEPCIONES_PRODUCCION
--add procesado bit
	drop table if exists #EJECUCIONESTEMP			
	drop table if exists #RecepcionesTemp
	drop table if exists #TranferenciaTempPrev
	drop table if exists #TranferenciaTemp
				PRINT 'HOLA';

	/*Preparacion = "PRE"; Manual = "MAN"; EjecucionPiscina = "EJE"; MantenimientoPiscina = "MNT";*/
	--Query para poblar temporal de ejecuciones moldeado a keys de excel
	select pu.nombreSector + pu.nombrePiscina + '.' + CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, pu.nombreSector + pu.nombrePiscina as keyPiscina, 
	pe.idPiscinaEjecucion, pe.ciclo, pe.fechaInicio, pe.fechaSiembra, pe.fechaCierre,
		pu.codigoZona, pu.nombreZona, pu.codigoCamaronera, pu.nombreCamaronera, pu.codigoSector, pu.nombreSector, pu.codigoPiscina, pu.nombrePiscina, ce.codigoElemento, ce.nombreElemento, pe.idPiscina
	into #EJECUCIONESTEMP 
	from proPiscinaEjecucion pe 
		inner join PiscinaUbicacion pu on  pe.idPiscina = pu.idPiscina 
		inner join CATALOGO_ELEMENTS ce on ce.codigoElemento = pe.rolPiscina and ce.codigoCatalogo = 'maeRolPiscina' 
	where estado = 'EJE' OR estado = 'PRE' 

	select * from #EJECUCIONESTEMP
	where keyPiscina = 'CAPULSAPC2'

	select Cod_Ciclo, Key_Piscina, Fecha_IniSec, Fecha_Siembra, Fecha_Pesca from CICLOS_PRODUCCION
	where Key_Piscina = 'CAPULSAPC2' AND Fecha_IniSec >= '2020-01-19'


	select  distinct
		--ROW_NUMBER ( ) OVER ( order by t.fecha_Transf,  t.keyPiscinaOrigen,  t.keyPiscinaDestino)  as rowKeySecuencia#,
		--ROW_NUMBER ( ) OVER ( PARTITION BY Sector_Origen + CONVERT(VARCHAR(200),Piscina_Origen) order by  t.fecha_Transf,Sector_Origen + CONVERT(VARCHAR(200),Piscina_Origen), t.Cod_Ciclo_Origen)  as rowKey#, 
		--ROW_NUMBER ( ) OVER ( PARTITION BY t.Cod_Ciclo_Origen order by  t.fecha_Transf, Sector_Origen + CONVERT(VARCHAR(200),Piscina_Origen), t.Cod_Ciclo_Origen)  as rowCiclo#,
		'01' as empresa, '01' as division,
		pu.codigoZona as zona, pu.codigoCamaronera as camaronera,  pu.codigoSector as sector, pu.idPiscina, pu.codigoPiscina, case when t.tipo = 'PRECRIADERO' then 'PRE01' when t.tipo = 'PISCINA' then 'ENG01' else '' end AS ROL, 
		Sector_Origen + CONVERT(VARCHAR(200),Piscina_Origen) as keyOrigen, Cod_Ciclo_Origen, fecha_Transf, pu.codigoZona as Zona_Origen, pu.codigoCamaronera as Camaronera_Origen, pu.codigoSector as Sector_Origen, Piscina_Origen, Ciclo_Origen, Tipo,	
		Sub_Tipo, Estatus_Origen, Hectarea_Origen, Fecha_Siembra, Cantidad_Sembrada, Densidad, Peso_Siembra, Estatus_Transf, 
		Cons_Balanc, Guia_Transf, Forma_Transf,   
		case when t.linea = 'TANQUERO' then '001' 				 when t.linea = 'TUBERÍA' then '002' 
			 when t.linea = 'TUBERÍA-TANQUERO' then '003'        when t.linea = 'A PIE' then '004' 
			 when t.linea = 'DESCUELGUE' then '006'				 else '001' end as tipoTransferencia,
		Sector_Destino + CONVERT(VARCHAR(200),Piscina_Destino) as keyDestino, Cod_Ciclo_Destino, puD.codigoZona as Zona_Destino, puD.codigoCamaronera as  Camaronera_Destino, puD.codigoSector as  Sector_DestinoCOD, puD.idPiscina as idPiscinaDestino,
		Piscina_Destino, Ciclo_Destino, Estatus_Destino, Hectarea_Destino, Cantidad_Transf, Peso_Transf, Peso_Real,
		Libras_Transf, Conv, Procedencia_Laboratorio, Linea, Maduracion, Superv, Balanc, Lib_Transf_C, Anio, 'APR' AS estado, 'AdminPsCam' as usuarioResponsable,
		'adminPsCam' AS usuarioCreacion, '::2' AS estacionCreacion, GETDATE() AS fechaHoraCreacion, 'adminPsCam' AS usuarioModificacion, '::2' AS estacionModificacion, GETDATE() AS fechaHoraModificacion
	 into #TranferenciaTempPrev
	from TRANSFERENCIAS_PRODUCCION t  --3223
		INNER join #EJECUCIONESTEMP pu on pu.keyPiscina = t.keyPiscinaOrigen   
		INNER join #EJECUCIONESTEMP puD on puD.keyPiscina = t.keyPiscinaDestino
		--where keyPiscinaDestino = 'GARITA56A'
	order by 1


	select 	ROW_NUMBER ( ) OVER ( order by t.fecha_Transf,  t.keyOrigen,  t.keyDestino)  as rowKeySecuencia#,
		    ROW_NUMBER ( ) OVER ( PARTITION BY keyOrigen order by  t.fecha_Transf, keyDestino ,Piscina_Origen, t.Cod_Ciclo_Origen)  as rowKey#, 
		    ROW_NUMBER ( ) OVER ( PARTITION BY t.Cod_Ciclo_Origen order by  t.fecha_Transf, keyOrigen , t.Cod_Ciclo_Origen)  as rowCiclo#, *
			into #TranferenciaTemp
			from #TranferenciaTempPrev t
	
	select 
		ROW_NUMBER ( ) OVER ( order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowKeySecuencia#,
		ROW_NUMBER ( ) OVER ( PARTITION BY r.KeyPiscina order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowKey#, r.KeyPiscina as KeyPiscina,
		ROW_NUMBER ( ) OVER ( PARTITION BY r.Cod_Ciclo order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowCiclo#, r.Cod_Ciclo,
		0 as idRecepcion,  '01' as empresa, '01' as division, pu.codigoZona as NombreZoma, pu.codigoZona as zona, pu.codigoCamaronera as nombreCamaronera, pu.codigoCamaronera as camaronera, r.Sector as nombreSector, pu.codigoSector as sector, 
		r.Piscina, pu.codigoPiscina, pu.idPiscina, r.Ciclo, case when r.tipo = 'PRECRIADERO' then 'PRE01' when r.tipo = 'PISCINA' then 'ENG01' else '' end AS ROL, 0 as secuencia, 
		'PLA' as origen, null idOrdenCompra, null idDespacho, null idPlanificacionSiembra,
		0 as idLaboratorio, 0 as idLaboratorioLarva,  0 as idLaboratorioMaduracion, Peso_Siembra, PlGr_Guia as plGramoLab, PlGr_Llegada as plGramoCam,
		r.Fecha_Siembra as fechaRegistro,  DATEADD(DAY, -1, r.Fecha_Siembra) as fechaDespacho, r.Fecha_Siembra as fechaRecepcion, '06:00:00' as horaDespacho,'07:00:00' as horaRecepcion,
		0 as idResponsableSiembra, 1 as idEspecie, '00001' AS tipoLarva, r.Cantidad_Sembrada as cantidad, 1 as cantidadPlus, (r.Cantidad_Sembrada * 0.15) as porcentajePlus, 
		'UNIDAD' as unidadMedida, r.Cantidad_Sembrada as cantidadRecibida,
		r.Guia_Remision as guiasRemision, 0 as tieneFactura, 'Regularizada' as descripcion, '' as responsableEntrega, 'APR' AS estado, 'AdminPsCam' as usuarioResponsable,
		'adminPsCam' AS usuarioCreacion, '::2' AS estacionCreacion, GETDATE() AS fechaHoraCreacion, 'adminPsCam' AS usuarioModificacion, '::2' AS estacionModificacion, GETDATE() AS fechaHoraModificacion, null AS reprocesoContable,
		r.procesado
	into #RecepcionesTemp
	from RECEPCIONES_PRODUCCION r INNER join #EJECUCIONESTEMP pu on pu.Cod_Ciclo = r.Cod_Ciclo order by 1


	BEGIN TRY
		begin tran

		
	declare @secuencialRecepcion int = 0
	declare @secuencialRecepcionDetalle int = 0
	declare @secuencialTransferencia int = 0
	declare @secuencialTransferenciaDetalle int = 0
	declare @maxSecuencialRecepcion int = 0

	declare @cantidadTransferencia int = 0
	declare @FechaCierre date 
	
	declare @secuencialMaeCiclo int = 0
	declare @secuencialPiscinaEjecucion int = 0
	declare @secuencialPiscinaEjecucionSiguiente int = null

	declare @secuencia int = 0
	declare @cicloRecepcion varchar(100)
	declare @cicloTransferencia varchar(100)
	declare @fechaRecep dateTime
	declare @fechaProceso dateTime = getdate()
	declare @usuarioAudit varchar(50) = 'AdminPsCam'

			--WHILE exists (select procesado from #RecepcionesTemp where procesado = 0 )
			--BEGIN
			
							select top 4 'antes proPiscinaEjecucion', * from proPiscinaEjecucion order by 2 desc
							select top 4 'antes maePiscinaCiclo', * from maePiscinaCiclo order by 2 desc
				--/*INCIO VARIABLES INICIALES*/--
				select top 1 @secuencia = rowKeySecuencia# from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
				SET @cicloRecepcion = @PISCINALLAVE 
				--select top 1 @cicloRecepcion = @PISCINALLAVE from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
				select top 1 @fechaRecep = fechaRecepcion from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
				drop table if exists #InsertRecepTemp

				--select * from #RecepcionesTemp where Cod_Ciclo = @cicloRecepcion and fechaRecepcion = @fechaRecep 
				--/*FIN VARIABLES INICIALES*/--
		
				--/*INICIO SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
				UPDATE proSecuencial 
						SET ultimaSecuencia = ultimaSecuencia  
						WHERE tabla = 'recepcionEspecie' 

						SELECT TOP 1 @secuencialRecepcion = ultimaSecuencia 
						FROM proSecuencial 
						WHERE tabla = 'recepcionEspecie' 

				UPDATE proSecuencial 
						SET ultimaSecuencia = ultimaSecuencia
						WHERE tabla = 'recepcionEspecieDetalle' 

						SELECT TOP 1 @secuencialRecepcionDetalle = ultimaSecuencia 
						FROM proSecuencial 
						WHERE tabla = 'recepcionEspecieDetalle' 

				--/*FIN SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
				--/*INICIO SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--

				UPDATE proSecuencial 
						SET ultimaSecuencia = ultimaSecuencia + 1  
				WHERE tabla = 'piscinaEjecucion' 

				SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia 
						FROM proSecuencial 
				WHERE tabla = 'piscinaEjecucion' 

				UPDATE maeSecuencial 
						SET ultimaSecuencia = ultimaSecuencia + 1
				WHERE tabla = 'PiscinaCiclo' 

				SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia
						FROM maeSecuencial 
				WHERE tabla = 'PiscinaCiclo' 

				SET @secuencialPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucion + 1;
				--/*FIN SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--
				-------
				INSERT INTO proPiscinaEjecucion (
						idPiscinaEjecucion, idPiscina, ciclo, rolPiscina, numEtapa, lote, fechaInicio, 
						fechaSiembra, fechaCierre, tipoCierre, idEspecie, cantidadEntrada, cantidadAdicional, 
						cantidadSalida, cantidadPerdida, idPiscinaEjecucionSiguiente, estado, tieneRaleo, 
						tieneRepanio, tieneCosecha, activo, usuarioCreacion, estacionCreacion, fechaHoraCreacion, 
						usuarioModificacion, estacionModificacion, fechaHoraModificacion) 
				select @secuencialPiscinaEjecucion, idPiscina, Ciclo, ROL, 1, sector, DATEADD(DAY, -1, min(fechaRecepcion)), min(fechaRecepcion), null, '', 1, 
						SUM(cantidad),SUM( porcentajePlus), 0, 0, null, 'EJE', 0,0,0,1,
						@usuarioAudit, '::2', @fechaProceso,@usuarioAudit, '::2', @fechaProceso
				from #RecepcionesTemp where Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
				group by idPiscina, Ciclo, rol, sector

				INSERT INTO [dbo].[maePiscinaCiclo] (
					idPiscinaCiclo, idPiscina, ciclo, fecha, origen, idOrigen, 
					idOrigenEquivalente, rolCiclo, activo, usuarioCreacion, 
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, 
					estacionModificacion, fechaHoraModificacion)
				SELECT 
					@secuencialMaeCiclo, idPiscina, ciclo, DATEADD(DAY, -1, min(fechaRecepcion)), 'EJE', @secuencialPiscinaEjecucion, 
					null as idOrigenEquivalente, ROL, 1, @usuarioAudit, '::2', @fechaProceso, @usuarioAudit, '::2', @fechaProceso
				FROM #RecepcionesTemp where Cod_Ciclo = @cicloRecepcion 
				group by idPiscina, Ciclo, rol, sector;
				-------

				-------
				SELECT
					ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcion AS idRecepcion,
					ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcionDetalle AS idRecepcionDetalle,
					empresa, division, zona, camaronera, sector, 0 as secuencia, origen, idOrdenCompra, idDespacho, idPiscina,ROL,
					idPlanificacionSiembra, idLaboratorio, idLaboratorioLarva, idLaboratorioMaduracion, fechaRegistro, fechaDespacho, fechaRecepcion, horaDespacho, horaRecepcion,
					idResponsableSiembra, idEspecie, tipoLarva, cantidad, cantidadPlus,
					porcentajePlus, unidadMedida, cantidadRecibida, guiasRemision, plGramoCam, plGramoLab,
					tieneFactura, descripcion, responsableEntrega, estado,
					usuarioResponsable, usuarioCreacion, estacionCreacion, fechaHoraCreacion,
					usuarioModificacion, estacionModificacion, fechaHoraModificacion--, reprocesoContable 
					into #InsertRecepTemp 
				FROM #RecepcionesTemp 
				where Cod_Ciclo = @cicloRecepcion and fechaRecepcion = @fechaRecep; 
				-------

				INSERT INTO [dbo].[proRecepcionEspecie] (
					idRecepcion, empresa, division, zona, camaronera, sector, secuencia, origen, idOrdenCompra, idDespacho, idPlanificacionSiembra, idLaboratorio, idLaboratorioLarva, fechaRegistro,
					fechaDespacho, fechaRecepcion, horaDespacho, horaRecepcion, idResponsableSiembra, idEspecie, tipoLarva, cantidad, cantidadPlus, porcentajePlus, unidadMedida, cantidadRecibida,
					guiasRemision, tieneFactura, descripcion, responsableEntrega, estado, usuarioResponsable, usuarioCreacion, estacionCreacion, fechaHoraCreacion, usuarioModificacion,
					estacionModificacion, fechaHoraModificacion)--, reprocesoContable)
				SELECT
					idRecepcion, empresa, division, zona, camaronera, sector, idRecepcion, origen, idOrdenCompra, idDespacho,
					idPlanificacionSiembra, idLaboratorio, idLaboratorioLarva, fechaRegistro, fechaDespacho, fechaRecepcion, horaDespacho, horaRecepcion,
					idResponsableSiembra, idEspecie, tipoLarva, cantidad, cantidadPlus,
					porcentajePlus, unidadMedida, cantidadRecibida, guiasRemision,
					tieneFactura, descripcion, responsableEntrega, estado,
					usuarioResponsable, usuarioCreacion, estacionCreacion, fechaHoraCreacion,
					usuarioModificacion, estacionModificacion, fechaHoraModificacion--, reprocesoContable
				FROM #InsertRecepTemp

					--QUEDA PENDIENTE LA PLANIFICACIÓN DE ORIGEN PARA RECEPCIÓN
					INSERT INTO [dbo].[proRecepcionEspecieDetalle] (
						idRecepcionDetalle, idRecepcion, idPiscinaPlanificacion, orden, idPiscina,
						rolPiscina, cantidad, unidadMedida, cantidadRecibida, cantidadAdicional,
						idPiscinaEjecucion, idCodigoGenetico, idLaboratorioMaduracion, codigoLarva,
						biomasa, oxigeno, salinidad, temperatura, costoLarva, costoServiciosPrestados,
						costoFlete, amonio, ph, alcalinidad, conteoAlgas, descripcion, numeroCajas,
						numeroTinas, tanqueOrigen, plGramoLab, plGramoCam, numeroArtemia, calidadAgua,
						tanqueCalidadAguaBuena, tanqueCalidadAguaRegular, tanqueCalidadAguaMala,
						observacionParametro, observacionCaracteristica, activo, idMotivoAuditoria,
						usuarioCreacion, estacionCreacion, fechaHoraCreacion, usuarioModificacion,
						estacionModificacion, fechaHoraModificacion)--, origenPlGramo)
					SELECT
						idRecepcionDetalle, idRecepcion, 0 as idPiscinaPlanificacion, 1, idPiscina,
						ROL as rolPiscina, cantidad, unidadMedida, cantidadRecibida, porcentajePlus,
						@secuencialPiscinaEjecucion, null as idCodigoGenetico, idLaboratorioMaduracion, null as codigoLarva,
						null as biomasa, null as oxigeno, null as salinidad, null as temperatura, null as costoLarva, null as costoServiciosPrestados,
						null as costoFlete, null as amonio, null as ph, null as alcalinidad, null as conteoAlgas,'' as descripcion, null as numeroCajas,
						3 as numeroTinas, null as tanqueOrigen, plGramoLab, plGramoCam, null as numeroArtemia, null as calidadAgua,
						1 as tanqueCalidadAguaBuena, 1 as tanqueCalidadAguaRegular, 1 as tanqueCalidadAguaMala,
							null as observacionParametro, null as observacionCaracteristica,1 as activo, null as idMotivoAuditoria,
						usuarioCreacion, estacionCreacion, fechaHoraCreacion, usuarioModificacion,
						estacionModificacion, fechaHoraModificacion--, 'CAM' as origenPlGramo
					FROM #InsertRecepTemp;

				
				--/*ACTUALIZAMOS EL IDEJECUCIÓN EN DETALLE DE RECEPCION*/--
					UPDATE RD
					SET 
						RD.idPiscinaEjecucion = @secuencialPiscinaEjecucion
					FROM #InsertRecepTemp PTE
							JOIN proRecepcionEspecieDetalle RD ON PTE.idRecepcionDetalle = RD.idRecepcionDetalle;
				
					UPDATE proSecuencial 
							SET ultimaSecuencia = @secuencialPiscinaEjecucionSiguiente
					WHERE tabla = 'piscinaEjecucion' 

				--/*SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
		
				--/*INICIO SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
					UPDATE proSecuencial 
							SET ultimaSecuencia = ultimaSecuencia  
							WHERE tabla = 'transferenciaEspecie' 

							SELECT TOP 1 @secuencialTransferencia = ultimaSecuencia 
							FROM proSecuencial 
							WHERE tabla = 'transferenciaEspecie' 

					UPDATE proSecuencial 
							SET ultimaSecuencia = ultimaSecuencia
							WHERE tabla = 'transferenciaEspecieDetalle' 

							SELECT TOP 1 @secuencialTransferenciaDetalle = ultimaSecuencia 
							FROM proSecuencial 
							WHERE tabla = 'transferenciaEspecieDetalle' 

				--/*FIN SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
				
							select top 4 'DURANTE proPiscinaEjecucion', * from proPiscinaEjecucion order by 2 desc
							select top 4 'DURANTE maePiscinaCiclo', * from maePiscinaCiclo order by 2 desc
				SELECT
					ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferencia AS idTransferencia,
					ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferenciaDetalle AS idTransferenciaDetalle,
					empresa, fecha_Transf AS fechaRegistro, fecha_Transf as fechaTransferencia, ROL,
					tipoTransferencia, idPiscina, 1 as idEspecie, 0 as guiaTransferencia, Cantidad_Transf as cantidadTransferida,
					Peso_Transf as pesoTransferidoGramos, @secuencialPiscinaEjecucion as idPiscinaEjecucion, 0 AS esTotal,  Sector_DestinoCOD,
					null as cantidadRemanente, densidad, 0 as balanceado, '' as descripcion, usuarioResponsable, estado, usuarioCreacion,
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion,
					Peso_Siembra, Peso_Transf, Peso_Real, Lib_Transf_C, Libras_Transf as librasDeclaradas, Ciclo_Destino, 
					fechaHoraModificacion, null as reprocesoContable, Cod_Ciclo_Destino, idPiscinaDestino
					into #InsertTransfTemp
				FROM #TranferenciaTemp
				where Cod_Ciclo_Origen = @cicloRecepcion;

				--select * from #InsertTransfTemp
				INSERT INTO [dbo].[proTransferenciaEspecie] (
					idTransferencia, empresa, secuencia, fechaRegistro, fechaTransferencia,
					tipoTransferencia, idPiscina, idEspecie, guiaTransferencia, cantidadTransferida,
					pesoTransferidoGramos, idPiscinaEjecucion, esTotal, cantidadRemanente, densidad,
					balanceado, descripcion, usuarioResponsable, estado, usuarioCreacion,
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion,
					fechaHoraModificacion)--, reprocesoContable)
				SELECT
					idTransferencia, empresa, idTransferencia, fechaRegistro, fechaTransferencia,
					tipoTransferencia, idPiscina, idEspecie, RIGHT('0000000000' + cast(idTransferencia as varchar(9)),9) as guiaTransferencia, cantidadTransferida,
					pesoTransferidoGramos, idPiscinaEjecucion, 
					CASE WHEN (ROW_NUMBER() OVER (PARTITION BY fechaTransferencia ORDER BY idTransferencia  )) = 1 THEN 1 ELSE 0 END AS esTotal, 
					cantidadRemanente, densidad, balanceado, descripcion, usuarioResponsable, estado, usuarioCreacion, 
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion, 
					fechaHoraModificacion--, reprocesoContable
				FROM #InsertTransfTemp;

				SELECT top 1 @cantidadTransferencia = SUM(cantidadTransferida) FROM #InsertTransfTemp
				SELECT top 1 @FechaCierre = max(fechaTransferencia) FROM #InsertTransfTemp

					/*ACTUALIZAMOS PISCINA EJECUCIÓN*/--
				
					--INSERTAMOS UNA EJECUCIÓN EN ESTADO INICIADO
				INSERT INTO proPiscinaEjecucion (
						idPiscinaEjecucion, idPiscina, ciclo, rolPiscina, numEtapa, lote, fechaInicio, 
						fechaSiembra, fechaCierre, tipoCierre, idEspecie, cantidadEntrada, cantidadAdicional, 
						cantidadSalida, cantidadPerdida, idPiscinaEjecucionSiguiente, estado, tieneRaleo, 
						tieneRepanio, tieneCosecha, activo, usuarioCreacion, estacionCreacion, fechaHoraCreacion, 
						usuarioModificacion, estacionModificacion, fechaHoraModificacion) 
				select @secuencialPiscinaEjecucionSiguiente, idPiscina, 0, '', 0, sector, DATEADD(DAY, 1, min(@FechaCierre)), NULL, 
						NULL, '', 0, 0, 0, 0, 0, null, 'INI', 0, 0, 0, 1,
						@usuarioAudit, '::2', @fechaProceso,@usuarioAudit, '::2', @fechaProceso
				from #RecepcionesTemp where Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
				group by idPiscina, Ciclo, rol, sector

				INSERT INTO [dbo].[maePiscinaCiclo] (
					idPiscinaCiclo, idPiscina, ciclo, fecha, origen, idOrigen, 
					idOrigenEquivalente, rolCiclo, activo, usuarioCreacion, 
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, 
					estacionModificacion, fechaHoraModificacion)
				SELECT 
					@secuencialMaeCiclo + 1, idPiscina, 0, DATEADD(DAY, 1, min(@FechaCierre)), 'PRE', @secuencialPiscinaEjecucionSiguiente, 
					null as idOrigenEquivalente, ROL, 1, @usuarioAudit, '::2', @fechaProceso, @usuarioAudit, '::2', @fechaProceso
				FROM #RecepcionesTemp where Cod_Ciclo = @cicloRecepcion 
				group by idPiscina, Ciclo, rol, sector;

				--ACTUALIZAMOS LA EJECUCIÓN PASADA
					UPDATE PE
					SET 
						tipoCierre = 'TRA',
						cantidadSalida = @cantidadTransferencia,
						cantidadPerdida = (cantidadEntrada + cantidadAdicional) - @cantidadTransferencia,
						fechaCierre = @FechaCierre,
						estado = 'PRE',
						idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucionSiguiente
					FROM #InsertTransfTemp PTE
					JOIN proPiscinaEjecucion PE ON PTE.idPiscinaEjecucion = PE.idPiscinaEjecucion;

						UPDATE proSecuencial 
								SET ultimaSecuencia = @secuencialPiscinaEjecucionSiguiente  
						WHERE tabla = 'piscinaEjecucion' 
		
						UPDATE maeSecuencial 
								SET ultimaSecuencia = @secuencialMaeCiclo + 1
						WHERE tabla = 'PiscinaCiclo' 


					--/*ACTUALIZAMOS PISCINA EJECUCIÓN*/--
			
					--/*TRANSFERENCIAS*/--
				SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia + 1
						FROM proSecuencial 
				WHERE tabla = 'piscinaEjecucion' 

				SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
						FROM maeSecuencial 
				WHERE tabla = 'PiscinaCiclo' 
		
				--SET @secuencialPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucion + 1;

				INSERT INTO [dbo].[proTransferenciaEspecieDetalle] (
					idTransferenciaDetalle, idTransferencia, orden, idPiscina, rolPiscina, cantidadTransferida,
					pesoPromedioTransferencia, biomasa, idPiscinaEjecucion, tipoTransferencia, 
					horaInicioTransferencia, horaFinTransferencia, observacion, observacionParametro, 
					observacionCaracteristica, usuarioResponsable, activo, usuarioCreacion, 
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion, 
					fechaHoraModificacion, librasDeclaradas, cantidadDeclarada, pesoDeclaradoTransferido, 
					numeroViajes)
				SELECT
					idTransferenciaDetalle, idTransferencia, 1, idPiscinaDestino, ROL as rolPiscina, cantidadTransferida,
					pesoTransferidoGramos, (cantidadTransferida * pesoTransferidoGramos) * 0.00220462 as biomasa, idPiscinaEjecucion, tipoTransferencia, 
					'06:00:00' as horaInicioTransferencia, '06:00:00' as horaFinTransferencia, '' as observacion, null, 
					null, usuarioResponsable, 1, usuarioCreacion, 
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion, 
					fechaHoraModificacion, librasDeclaradas, cantidadTransferida, pesoTransferidoGramos, null
				FROM #InsertTransfTemp;

				--select * from #InsertTransfTemp

					INSERT INTO proPiscinaEjecucion (
							idPiscinaEjecucion, idPiscina, ciclo, rolPiscina, numEtapa, lote, fechaInicio, 
							fechaSiembra, fechaCierre, tipoCierre, idEspecie, cantidadEntrada, cantidadAdicional, 
							cantidadSalida, cantidadPerdida, idPiscinaEjecucionSiguiente, estado, tieneRaleo, 
							tieneRepanio, tieneCosecha, activo, usuarioCreacion, estacionCreacion, fechaHoraCreacion, 
							usuarioModificacion, estacionModificacion, fechaHoraModificacion)
					select @secuencialPiscinaEjecucion, idPiscinaDestino, Ciclo_Destino, ROL, 1, Sector_DestinoCOD, DATEADD(DAY, -1, min(fechaTransferencia)), min(fechaTransferencia), null, '', 1, 
							SUM(cantidadTransferida), 0, 0, 0, NULL, 'EJE', 0, 0, 0, 1,
							@usuarioAudit, '::2', @fechaProceso,@usuarioAudit, '::2', @fechaProceso
					from #InsertTransfTemp 
					group by idPiscinaDestino, Ciclo_Destino, rol, Sector_DestinoCOD
			
				INSERT INTO [dbo].[maePiscinaCiclo] (
					idPiscinaCiclo, idPiscina, ciclo, fecha, origen, idOrigen, 
					idOrigenEquivalente, rolCiclo, activo, usuarioCreacion, 
					estacionCreacion, fechaHoraCreacion, usuarioModificacion, 
					estacionModificacion, fechaHoraModificacion)
				SELECT 
					@secuencialMaeCiclo , idPiscinaDestino, Ciclo_Destino, DATEADD(DAY, -1, min(fechaTransferencia)), 'EJE', @secuencialPiscinaEjecucion, 
					null as idOrigenEquivalente, ROL, 1, @usuarioAudit, '::2', @fechaProceso, @usuarioAudit, '::2', @fechaProceso
				FROM #InsertTransfTemp 
				group by idPiscinaDestino, Ciclo_Destino, rol, Sector_DestinoCOD


					UPDATE proSecuencial 
							SET ultimaSecuencia = (select max(idTransferencia) from #InsertTransfTemp)  
							WHERE tabla = 'transferenciaEspecie' 

					UPDATE proSecuencial 
							SET ultimaSecuencia = (select max(idTransferenciaDetalle) from #InsertTransfTemp) 
							WHERE tabla = 'transferenciaEspecieDetalle' 
							
							select top 4 'despues proPiscinaEjecucion', * from proPiscinaEjecucion order by 2 desc
							select top 4 'despues maePiscinaCiclo', * from maePiscinaCiclo order by 2 desc

				print 'secuencia ' + cast( @cicloRecepcion as varchar(50)) + ' ' + cast( @fechaRecep as varchar(10))
				--uppdate proSecuencial set ultimaSecuencia = ultimaSecuencia + 1 where tabla = 'recepcionEspecie'

				--delete from TRANSFERENCIAS where Camaronera_Origen = 'QWE'
				update #RecepcionesTemp set procesado = 1 where Cod_Ciclo = @cicloRecepcion --and fechaRecepcion = @fechaRecep
			--END
		rollback tran 
	END TRY
	BEGIN CATCH
		rollback tran 
		SELECT  
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  

				DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH

