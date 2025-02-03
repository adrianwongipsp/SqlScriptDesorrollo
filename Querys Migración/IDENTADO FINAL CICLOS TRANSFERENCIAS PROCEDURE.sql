	USE IPSPCamaroneraTesting
GO
	--VARIABLE DE PRUEBA ENTRADA
	CREATE OR ALTER PROC USP_SCRIPTMOVIMIENTOTRANSFERENCIAS
	(@PiscinaTemp VARCHAR(100), @SECTORFILTER VARCHAR(100))
	AS BEGIN

		--DECLARE @SECTORFILTER VARCHAR(100) = 'CAPULSA' --'COSTARICAI';
		--DECLARE @PiscinaTemp VARCHAR(100) ;
		--select @PiscinaTemp = 'CAPULSA5';
		--DECLARE @ISROOLBACK bit = 1
		DROP TABLE IF EXISTS #EJECUCIONESTEMP 
		DROP TABLE IF EXISTS #FILTERPISCINAKEYTEMP 
		DROP TABLE IF EXISTS #TranferenciaTempPrev 
		DROP TABLE IF EXISTS #TranferenciaTemp 

		/*Nomenclatura Preparacion = "PRE"; Manual = "MAN"; EjecucionPiscina = "EJE"; MantenimientoPiscina = "MNT";*/
		--STEP 1: Query para poblar temporal de ejecuciones moldeado a keys de excel
			SELECT	pu.codigoZona,	       pu.nombreZona,       pu.codigoCamaronera, pu.nombreCamaronera, 
					pu.codigoSector,       pu.nombreSector,     pu.codigoPiscina,    pu.nombrePiscina, 
					ce.codigoElemento,     ce.nombreElemento,   pe.idPiscina,        
					pu.nombreSector + pu.nombrePiscina + '.' +	CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, 
					pu.nombreSector + pu.nombrePiscina AS keyPiscina, 
					pe.idPiscinaEjecucion, pe.ciclo,            pe.fechaInicio,      pe.fechaSiembra, 
					pe.fechaCierre,		   pe.cantidadEntrada	
			INTO #EJECUCIONESTEMP 
			FROM proPiscinaEjecucion pe 
				INNER JOIN PiscinaUbicacion  pu ON  pe.idPiscina	 = pu.idPiscina 
				INNER JOIN CATALOGO_ELEMENTS ce ON ce.codigoElemento = pe.rolPiscina AND ce.codigoCatalogo = 'maeRolPiscina' 
			WHERE estado in ('EJE', 'PRE')
   

		/*
		select cp.Cod_Ciclo, Key_Piscina, cp.Ciclo as CicloExcel, Fecha_IniSec, Fecha_Siembra, Fecha_Pesca, Cantidad_Sembrada, Zona, Camaronera, Sector, Piscina, Tipo,Tipo_Siembra, Densidad,
		ej.fechaInicio, ej.fechaSiembra, ej.fechaCierre, ej.cantidadEntrada, ej.ciclo, DATEDIFF(day, Fecha_IniSec, ej.fechaInicio) InicioDiff, DATEDIFF(day, Fecha_Siembra, ej.fechaSiembra) SiembraDiff,DATEDIFF(day, Fecha_Pesca, ej.fechaCierre) CierreDiff,
		(Cantidad_Sembrada - ej.cantidadEntrada) CantidadDiff, idPiscina, idPiscinaEjecucion
		--into #FILTERPISCINAKEYTEMP
		from CICLOS_PRODUCCION cp
		left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
		WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) AND Sector = 'ARGENTINA' order by 1 -- @SECTORFILTER --and ej.ciclo is null
		*/

	   --FILTRAMOS LAS PISCINAS A REGULARIZAR
			SELECT cp.Key_Piscina, cp.Ciclo, cp.Cantidad_Sembrada
			into #FILTERPISCINAKEYTEMP
			from CICLOS_PRODUCCION cp
			left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
			WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
			AND REPLACE(Sector,' ','') = @SECTORFILTER and ej.ciclo is null AND cp.Key_Piscina = @PiscinaTemp

			SELECT 'FILTRO PISCIAN' FILTRO, * FROM #FILTERPISCINAKEYTEMP
	   --STEP 2: Query para creación de tabla de transferencia con homologaciones de piscinas con códigos de Insigne
		SELECT  DISTINCT
				'01' AS empresa,			'01' AS division,	  pu.codigoZona AS zona,		 pu.codigoCamaronera AS camaronera,			pu.codigoSector AS sector, 
				 pu.idPiscina,				 pu.codigoPiscina,  

				 CASE WHEN t.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN t.tipo = 'PISCINA' THEN 'ENG01' WHEN t.tipo = 'REPRODUCTOR' THEN 'REP01' ELSE '' END AS ROL,  
				 REPLACE(Sector_Origen ,' ','')	 +   CONVERT(VARCHAR(200),Piscina_Origen)    AS keyOrigen, 

				 Cod_Ciclo_Origen,					   fecha_Transf,		pu.codigoZona AS Zona_Origen,   pu.codigoCamaronera as Camaronera_Origen,   pu.nombreSector,			 pu.codigoSector as Sector_Origen, 
				 Piscina_Origen,					   Ciclo_Origen,		t.Tipo,							Sub_Tipo,									Estatus_Origen, 
				 Hectarea_Origen,					   t.Fecha_Siembra,		t.Cantidad_Sembrada,			t.Densidad,									Peso_Siembra, 
				 Estatus_Transf,					   Cons_Balanc,		    Guia_Transf,					Forma_Transf,   

				 CASE WHEN t.linea = 'TANQUERO'         THEN '001' 	  WHEN t.linea = 'TUBERÍA' THEN '002' 
					  WHEN t.linea = 'TUBERÍA-TANQUERO' THEN '003'    WHEN t.linea = 'A PIE'   THEN '004' 
					  WHEN t.linea = 'DESCUELGUE'       THEN '006'    ELSE '001'			   END	 AS tipoTransferencia,

				REPLACE(Sector_Destino ,' ','') + CONVERT(VARCHAR(200),Piscina_Destino) AS keyDestino,	
				Cod_Ciclo_Destino,			          puD.codigoZona   AS Zona_Destino,			puD.codigoCamaronera AS  Camaronera_Destino,		puD.codigoSector AS  Sector_DestinoCOD,		puD.idPiscina AS idPiscinaDestino,
				Piscina_Destino,					  Ciclo_Destino,							Estatus_Destino,									Hectarea_Destino,							Cantidad_Transf, 
				Peso_Transf,						  Peso_Real,								Libras_Transf,										Conv,										Procedencia_Laboratorio, 
				Linea,								  Maduracion,								Superv,												Balanc,										Lib_Transf_C, 
				Anio,								  Estatus_Transf   AS TipoTransfTOTAL,		'APR' AS estado,									'AdminPsCam'     AS usuarioResponsable,
			   'adminPsCam' AS usuarioCreacion,		 '::2' AS estacionCreacion,      GETDATE() AS fechaHoraCreacion, 
			   'adminPsCam' AS usuarioModificacion,  '::2' AS estacionModificacion,  GETDATE() AS fechaHoraModificacion,							0 procesado,								pp.Fecha_DS
		INTO #TranferenciaTempPrev
		FROM TRANSFERENCIAS_PRODUCCION t   
			left join #EJECUCIONESTEMP pu  ON REPLACE(pu.keyPiscina ,' ','')  = REPLACE(t.keyPiscinaOrigen ,' ','')   
			LEFT join #EJECUCIONESTEMP puD ON REPLACE(puD.keyPiscina ,' ','') = REPLACE(t.keyPiscinaDestino ,' ','')
			left join PESCA_PRODUCCION pp ON REPLACE(pp.Cod_ciclo ,' ','') = REPLACE(t.Cod_Ciclo_Destino ,' ','')
		WHERE /*T.keyPiscinaOrigen IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) 
		AND  */T.keyPiscinaDestino IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) --Sector_Origen = @SECTORFILTER
		ORDER BY 1
		
		--select 'REGULARIZAR' AS REGULARIZAR2, * from #TranferenciaTempPrev
		SELECT 	ROW_NUMBER ( ) OVER ( order by t.fecha_Transf, t.keyOrigen, t.keyDestino)  as rowKeySecuencia#,
				ROW_NUMBER ( ) OVER ( PARTITION BY keyOrigen order by  t.fecha_Transf, keyDestino ,Piscina_Origen, t.Cod_Ciclo_Origen)  as rowKey#, 
				ROW_NUMBER ( ) OVER ( PARTITION BY t.Cod_Ciclo_Origen order by  t.fecha_Transf, keyOrigen , t.Cod_Ciclo_Origen)  as rowCiclo#,
				case when t.Fecha_Transf =  
					(select max(Fecha_Transf) from #TranferenciaTempPrev  tp where tp.Cod_Ciclo_Destino = t.Cod_Ciclo_Destino and t.Fecha_DS is not null)
					then CAST(1 as bit)
					else CAST(0 as bit) end as Pesca,
				*
				INTO #TranferenciaTemp
				FROM #TranferenciaTempPrev t
				where t.keyDestino = @PiscinaTemp
				order by 1;


		with  cte as(
			select  idPiscina,				REPLACE(nombreSector,' ','') + nombrePiscina  KeyPiscina,		codigoPiscina,		nombreCamaronera, nombreZona,
					codigoSector sector,	nombreSector,												codigoCamaronera,	codigoZona
				from PiscinaUbicacion   rb )

		update ru
		set ru.idPiscina = rb.idPiscina,			ru.codigoPiscina = rb.codigoPiscina,			ru.sector = rb.sector,
			ru.camaronera = rb.codigoCamaronera,	ru.Camaronera_Origen = rb.codigoCamaronera,		ru.zona  = rb.codigoZona,
			ru.Zona_Origen = rb.codigoZona,			ru.Sector_Origen = rb.sector,					ru.nombreSector = rb.nombreSector
		from 
		#TranferenciaTemp ru 
		inner join cte rb on ru.keyOrigen = rb.KeyPiscina   and ru.idPiscina is null;

		with  cte2 as(
			select  idPiscina,				REPLACE(nombreSector,' ','')+nombrePiscina  KeyPiscina,		codigoPiscina,		nombreCamaronera, nombreZona,
					codigoSector sector,	nombreSector,												codigoCamaronera,	codigoZona
				from PiscinaUbicacion   rb -- where   idPiscina is not null
		)
		update ru
		set 
			ru.Zona_Destino = rbD.codigoZona,		ru.Camaronera_Destino = rbD.codigoCamaronera,	ru.Sector_DestinoCOD = rbD.sector,
			ru.idPiscinaDestino = rbD.idPiscina
		from 
		#TranferenciaTemp ru 
		inner join cte2 rbD on ru.keyDestino = rbD.KeyPiscina   and ru.idPiscinaDestino is null;
		
		select 'REGULARIZAR' AS REGULARIZAR, * from #TranferenciaTemp
		BEGIN TRY

			declare @EjecucionExistente bit = 1
			declare @EjecucionExistenteDESTINO bit = 1
			declare @estadoTransferencia varchar(10)
			declare @EXISTE_CICLO_INICIADO bit = 0
		
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
			declare @rowKeySecuencia int = 0
			declare @cicloTransferencia varchar(100)
			declare @cicloTransferenciaDestino varchar(100)
			declare @cicloTransferenciaDestinoVALIDACION varchar(100)
			declare @fechaRecep dateTime
			declare @fechaProceso dateTime = getdate()
			declare @usuarioAudit varchar(50) = 'AdminPsCam'
			DECLARE @MESAJEERROR VARCHAR(100)

			declare @idPiscina int
			declare @keyPiscina varchar(50)
			--Bloqueamos las tablas de secuenciales
			SELECT top 1 1 FROM proSecuencial WITH (TABLOCKX)
			SELECT top 1 1 FROM maeSecuencial WITH (TABLOCKX)
				declare @cpount int = 0
				WHILE exists (select procesado from #TranferenciaTemp where procesado = 0 )
				BEGIN
				select @cpount = @cpount+1
					--/***************INCIO VARIABLES INICIALES****************/--
					select top 1  @secuencia  = rowKeySecuencia#,	@cicloTransferencia = Cod_Ciclo_Origen, 
								  @fechaRecep = Fecha_Transf,		@rowKeySecuencia = rowKey#,				@cicloTransferenciaDestinoVALIDACION = Cod_Ciclo_Destino
						   from #TranferenciaTemp  where procesado = 0 order by rowKeySecuencia#;
					select @cpount as contadorDeVueltas

					set @idPiscina = 0
					set @keyPiscina = ''
					set @secuencialPiscinaEjecucion = 0

					set @idPiscina	= (SELECT TOP 1 idPiscina	 FROM  #EJECUCIONESTEMP	WHERE Cod_Ciclo = @cicloTransferencia)
					set @keyPiscina = (SELECT TOP 1  keyPiscina  FROM  #EJECUCIONESTEMP WHERE Cod_Ciclo = @cicloTransferencia)


					SELECT TOP 1 @idPiscina  = idPiscina, 
								 @keyPiscina = keyPiscina  
						   FROM  #EJECUCIONESTEMP 
						   WHERE Cod_Ciclo = @cicloTransferencia

					--SELECT TOP 1 * 
					--	   FROM  #EJECUCIONESTEMP 
					--	   WHERE Cod_Ciclo = @cicloTransferencia

					DROP TABLE IF EXISTS #InsertTransfTemp  

					--/*BUSCAMOS EL IDPISCINAEJECUCIÓN DE LA PISCINA DE ORIGEN*/--
					set @secuencialPiscinaEjecucion = (SELECT  idPiscinaEjecucion FROM EjecucionesPiscinaView WHERE cod_ciclo = @cicloTransferencia)

					--select @cicloTransferencia as cicloOrigen, @cicloTransferenciaDestinoVALIDACION as cicloDestino
					
					--select @secuencialPiscinaEjecucion as aaaaaa, @idPiscina as ccccc

					if @secuencialPiscinaEjecucion is null OR @secuencialPiscinaEjecucion = 0
						BEGIN
							set @MESAJEERROR = 'NO SE ENCONTRÓ EL SECUENCIAL PISCINA EJECUCIÓN DE LA PISCINA ' + @cicloTransferencia
							RAISERROR(@MESAJEERROR, 16,1)
						END
					ELSE
						BEGIN
							IF not exists (SELECT top 1 1 FROM proPiscinaEjecucion WHERE idPiscinaEjecucion = @secuencialPiscinaEjecucion and idPiscina = @idPiscina)
							begin 
								set @MESAJEERROR = 'La ejecución de la piscina N° ' + @secuencialPiscinaEjecucion + ' no pertenece a la piscina ' + @cicloTransferencia
								RAISERROR(@MESAJEERROR, 16,1)
							end
						END


					--select * FROM EjecucionesPiscinaView WHERE cod_ciclo = @cicloTransferencia
					--select * from EjecucionesPiscinaView WHERE keyPiscina = 'CAPULSAPC4' --.63'
					--select * from EjecucionesPiscinaView WHERE keyPiscina = 'CAPULSA23' --.63'
					--select * from CICLOS_PRODUCCION where Key_Piscina = 'CAPULSA23'
					--select * from proRecepcionEspecieDetalle where idPiscinaEjecucion = 3735
					--select keyOrigen, Fecha_Transf, idPiscina, idPiscinaDestino, keyDestino, Ciclo_Destino, Cantidad_Transf ROL from #TranferenciaTemp where keyDestino =  'CAPULSA23'
					--select T.idPiscina, T.idPiscinaEjecucion, T.fechaTransferencia, TD.idPiscina, TD.idPiscinaEjecucion, td.cantidadTransferida, TD.rolPiscina from proTransferenciaEspecieDetalle td
					--inner join proTransferenciaEspecie t on td.idTransferencia = t.idTransferencia  where td.idPiscinaEjecucion = 3735 and t.estado = 'APR'

				--select 'VALIDACION ANTIGUA EJEMPLO DE TRANS VALID' AS VALID,  ej.cod_ciclo, t.fechaTransferencia, te.cantidadTransferida  , T.*
				--from proTransferenciaEspecieDetalle  TE
				--		INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
				--		inner join EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = tE.idPiscinaEjecucion 
				--				where ej.cod_ciclo = @cicloTransferenciaDestinoVALIDACION AND T.estado = 'APR'
								
				--select 'EJEMPLO DE TRANS VALID' AS VALIDEW ,ej.cod_ciclo, t.fechaTransferencia, td.cantidadTransferida , 
				--tt.Cod_Ciclo_Destino,  tt.Cantidad_Transf, tt.Fecha_Transf ,
				--T.* 
				--from proTransferenciaEspecieDetalle  td
				--		INNER JOIN proTransferenciaEspecie t ON td.idTransferencia = t.idTransferencia 
				--		INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = td.idPiscinaEjecucion 

				--		INNER JOIN #TranferenciaTemp tt on t.fechaTransferencia = tt.Fecha_Transf 
				--								and ej.cod_ciclo = tt.Cod_Ciclo_Destino 
				--								and td.cantidadTransferida = tt.Cantidad_Transf
				--		where ej.cod_ciclo = @cicloTransferenciaDestinoVALIDACION AND T.estado = 'APR'
				--		and rowKeySecuencia# = @secuencia;

				if not exists ( select 1 from proTransferenciaEspecieDetalle  td
						INNER JOIN proTransferenciaEspecie t ON td.idTransferencia = t.idTransferencia 
						INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = td.idPiscinaEjecucion 
						INNER JOIN #TranferenciaTemp tt on  
						--DATEDIFF(day, t.fechaTransferencia, tt.Fecha_Transf) BETWEEN -2 AND 2 
						t.fechaTransferencia = tt.Fecha_Transf --VALIDACION ANTIGUA 
												and ej.cod_ciclo = tt.Cod_Ciclo_Destino 
												and td.cantidadTransferida = tt.Cantidad_Transf
						where ej.cod_ciclo = @cicloTransferenciaDestinoVALIDACION AND T.estado = 'APR'
						and rowKeySecuencia# = @secuencia)
						BEGIN
								--/*INICIO SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
									
									SELECT TOP 1 @secuencialTransferencia = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecie' 

									SELECT TOP 1 @secuencialTransferenciaDetalle = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecieDetalle' 

								--/*FIN SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
						
							SELECT top 1
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferencia		  AS idTransferencia,
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferenciaDetalle AS idTransferenciaDetalle,
								empresa,			                    fecha_Transf  AS fechaRegistro,		     fecha_Transf                AS fechaTransferencia,      ROL,
								Sector_Origen,							Cod_Ciclo_Origen,						 Ciclo_Origen,
								tipoTransferencia,				        idPiscina,								 1                            AS idEspecie,              0   AS guiaTransferencia,		
								Cantidad_Transf AS cantidadTransferida, Peso_Transf  AS pesoTransferidoGramos,   @secuencialPiscinaEjecucion  AS idPiscinaEjecucion,     0	AS esTotal,    
								Sector_DestinoCOD,                      null         AS cantidadRemanente,       densidad,												 0 as balanceado, 
								''             AS descripcion,          usuarioResponsable,						 estado,												 usuarioCreacion,
								estacionCreacion,						fechaHoraCreacion,                       usuarioModificacion,                                    estacionModificacion,
								Peso_Siembra,							Peso_Transf,							 Peso_Real,												 Lib_Transf_C, 
								Libras_Transf  AS librasDeclaradas,		Ciclo_Destino,						     fechaHoraModificacion, null as reprocesoContable,       Cod_Ciclo_Destino, 
								idPiscinaDestino,						TipoTransfTOTAL,						 procesado = 0,											 Fecha_DS,					
								keyDestino,								Pesca
							INTO #InsertTransfTemp
							FROM #TranferenciaTemp WHERE Cod_Ciclo_Origen = @cicloTransferencia and rowKeySecuencia# = @secuencia ;

							select Cod_Ciclo_Destino AS 'ESTO ES #InsertTransfTemp', * FROM #InsertTransfTemp WHERE Cod_Ciclo_Origen = @cicloTransferencia 
				 
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
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, reprocesoContable)
									SELECT
										idTransferencia,				empresa,						idTransferencia,		fechaRegistro,			fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				RIGHT('0000000000' + CAST(idTransferencia AS VARCHAR(9)),9)   AS guiaTransferencia, 
										cantidadTransferida,			pesoTransferidoGramos,			idPiscinaEjecucion,		CASE WHEN (ROW_NUMBER() OVER (PARTITION BY fechaTransferencia ORDER BY idTransferencia)) = 1 THEN 1 ELSE 0 END AS esTotal, 
										cantidadRemanente,				densidad,						balanceado,				descripcion, 
										usuarioResponsable,				estado,							usuarioCreacion, 
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, reprocesoContable
									FROM #InsertTransfTemp;

									select @estadoTransferencia = TipoTransfTOTAL  from #InsertTransfTemp where TipoTransfTOTAL = 'TOTAL'

									if @estadoTransferencia = 'TOTAL'
										BEGIN
										
											SELECT TOP 1 @secuencialPiscinaEjecucionSiguiente = ultimaSecuencia + 1
											FROM	proSecuencial 
											WHERE	tabla = 'piscinaEjecucion' 
										
											SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
											FROM	maeSecuencial 
											WHERE	tabla = 'PiscinaCiclo' 
										
select max(idPiscinaEjecucion), @cpount CONTADORVUELTA from proPiscinaEjecucion
select * from proSecuencial
where tabla  = 'piscinaEjecucion'
											--/*ACTUALIZAMOS PISCINA EJECUCIÓN*/--
											INSERT INTO proPiscinaEjecucion (
													idPiscinaEjecucion,					 idPiscina,				      ciclo,			rolPiscina,			numEtapa,			lote,				fechaInicio, 
													fechaSiembra,						 fechaCierre,			      tipoCierre,		idEspecie,			cantidadEntrada,	cantidadAdicional,  cantidadSalida,				
													cantidadPerdida,					 idPiscinaEjecucionSiguiente, estado,			tieneRaleo,			tieneRepanio,		tieneCosecha,		activo,
													usuarioCreacion,					 estacionCreacion,			  fechaHoraCreacion, 
													usuarioModificacion,				 estacionModificacion,		  fechaHoraModificacion) 
											SELECT @secuencialPiscinaEjecucionSiguiente, idPiscina,						0,					'',					0,				Sector_Origen,		DATEADD(DAY, 1, min(@FechaCierre)), 
													NULL,								 NULL,							'',					0,					0,				0,					0, 
													0,									 NULL,						    'INI',				0,					0,				0,					1,
													@usuarioAudit,						'::2',							@fechaProceso,
													@usuarioAudit,						'::2',							@fechaProceso
											FROM #InsertTransfTemp 
											WHERE Cod_Ciclo_Origen = @cicloTransferencia -- and fechaRecepcion = @fechaRecep
											GROUP BY idPiscina, Ciclo_Origen, rol, Sector_Origen
				 
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
											FROM #InsertTransfTemp 
											WHERE	Cod_Ciclo_Origen = @cicloTransferencia 
											GROUP BY idPiscina, Ciclo_Origen, rol, Sector_Origen
											
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
											SET    ultimaSecuencia = @secuencialMaeCiclo
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
											select top 1 @secuencialRowKeyTransferencia = idTransferenciaDetalle, @cicloTransferenciaDestino = Cod_Ciclo_Destino from #InsertTransfTemp;

											--VERIFICAR SI EXISTE CICLO DE DESTINO
											IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloTransferenciaDestino) >0
												BEGIN
													select @secuencialPiscinaEjecucionDESTINO = idPiscinaEjecucion, @secuencialPiscinaEjecucionSiguienteDESTINO = idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloTransferenciaDestino
													SET @EjecucionExistenteDESTINO = 1
													select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
												END
											ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
													AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
													AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
												   WHERE CP.Cod_Ciclo = @cicloTransferenciaDestino)
												BEGIN
													SELECT TOP 1  @secuencialPiscinaEjecucionDESTINO = E.idPiscinaEjecucion
														FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
																AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
																AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
															   WHERE CP.Cod_Ciclo = @cicloTransferenciaDestino

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
													
select max(idPiscinaEjecucion), @cpount CONTADORVUELTAS from proPiscinaEjecucion
select * from proSecuencial
where tabla  = 'piscinaEjecucion'
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
												where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferenciaDestino;

								
												declare @sumaTransDetalle int = 0;

												--select @sumaTransDetalle = SUM(cantidadTransferida) FROM #InsertTransfTemp
												--where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferenciaDestino;
											
												select @sumaTransDetalle = SUM(TE.cantidadTransferida) FROM proTransferenciaEspecieDetalle TE
												INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
												WHERE TE.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO AND T.estado = 'APR'

												--select 'QUERY TRANS',* FROM proTransferenciaEspecieDetalle TE
												--INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
												--WHERE TE.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO AND T.estado = 'APR'

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
												WHERE  irt.Cod_Ciclo_Destino = @cicloTransferenciaDestino

												--SELECT 'OJO TRANSFERENCINA', * FROM proTransferenciaEspecieDetalle c  
												--		INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
												--		INNER JOIN proPiscinaEjecucion pe on pe.idPiscinaEjecucion = c.idPiscinaEjecucion and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
												--		WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
												--		AND t.estado NOT IN ('ANU','ING') AND pe.estado IN ('EJE', 'INI', 'PRE')

												UPDATE pe
													SET 
														ciclo						= @cicloMax , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														rolPiscina					= 'ENG01',
														numEtapa					= 1,
														fechaSiembra				= @fechaSiembraMin, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
														tipoCierre					= '',
														idEspecie					= 1,
														--cantidadEntrada				= sum(c.cantidadTransferida),
														cantidadEntrada				= @sumaTransDetalle,
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
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscinaEjecucion = c.idPiscinaEjecucion and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU','ING') AND pe.estado IN ('EJE', 'INI', 'PRE')
														
												--MAEPISCINA CICLO
												UPDATE pc
													SET 
														ciclo						= @cicloMax, --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
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
											WHERE Cod_Ciclo_Destino = @cicloTransferenciaDestino and idTransferenciaDetalle = @secuencialRowKeyTransferencia --and fechaRecepcion = @fechaRecep
											
											SELECT 'HOLAAA', * FROM #InsertTransfTemp WHERE Pesca = 1 and Cod_Ciclo_Destino = @cicloTransferenciaDestino
										
											--/*INICIO ACTUALIZAMOS PISCINA EJECUCIÓN*/--
											IF exists (SELECT 1 FROM #InsertTransfTemp WHERE Pesca = 1 and Cod_Ciclo_Destino = @cicloTransferenciaDestino)
											BEGIN
												declare @keyPiscinaDestino varchar(50)
												declare @idPiscinaDestino int
												declare @fechaPesca date
												declare @cicloDestino int

												select top 1 @keyPiscinaDestino = keyDestino,				@idPiscinaDestino = idPiscinaDestino, 
															 @fechaPesca = Fecha_DS,						@cicloDestino = Ciclo_Destino 
															 from #InsertTransfTemp				where Cod_Ciclo_Destino = @cicloTransferenciaDestino
												SELECT 'COMSUNME PESCA' SANCOCHO, @keyPiscinaDestino, @secuencialPiscinaEjecucionDESTINO EJECUCION, @idPiscinaDestino PISCINA, @cicloTransferenciaDestino CICLO
												
												SELECT 'RESULTADO PESCA', * from  proPiscinaCosecha PC WHERE PC.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
													AND PC.idPiscina= @idPiscinaDestino AND tipoPesca = 'PES' AND liquidado = 1 

												IF NOT EXISTS (SELECT 1 from  proPiscinaCosecha PC WHERE PC.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
													AND PC.idPiscina= @idPiscinaDestino AND tipoPesca = 'PES' AND liquidado = 1 )
													BEGIN
															SELECT 1 
															exec PROCESS_CREATE_PESCA_CIERRE_HISTORIAL  @keyPiscina = @keyPiscinaDestino,		@idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO,		@idPiscina = @idPiscinaDestino,
																										@Cod_Piscina = @cicloTransferenciaDestino,
																										@fechaCierre = @fechaPesca,				@fechaProceso = @fechaProceso,									@usuario = @usuarioAudit,            
																										@ciclo = @cicloDestino,					@displayContent = 0
															
													END
											END
										
											--/*FIN ACTUALIZAMOS PISCINA EJECUCIÓN*/--

									END
								
									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferencia) FROM #InsertTransfTemp)  
									WHERE  tabla		   = 'transferenciaEspecie' 

									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferenciaDetalle) FROM #InsertTransfTemp) 
									WHERE  tabla		   = 'transferenciaEspecieDetalle' 

								END
						END

						print 'secuencia ' + cast( @cicloTransferencia as varchar(50)) + ' ' + cast( @fechaRecep as varchar(10))
					
					select 'despues propiscinaejecucion', * from EjecucionesPiscinaView where keyPiscina = @PiscinaTemp and estado in ('INI','EJE', 'PRE') ORDER BY 4
					UPDATE #TranferenciaTemp 
					SET   procesado = 1 
					WHERE Cod_Ciclo_Origen = @cicloTransferencia and rowKeySecuencia# = @secuencia

				END
			-----CONFIRMACION DE LA TRANSACCION
			--SELECT * FROM proRecepcionEspecie WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proRecepcionEspecieDetalle WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proTransferenciaEspecieDetalle where  idPiscinaEjecucion = @secuencialPiscinaEjecucion
			--select * from  proPiscinaEjecucion where idPiscina = 2002
		
			select 'FINAL propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = @PiscinaTemp and estado  in ('INI','EJE', 'PRE')  ORDER BY 4
		
			
		END TRY
		BEGIN CATCH
			-----REVERSA DE LA TRANSACCION
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
