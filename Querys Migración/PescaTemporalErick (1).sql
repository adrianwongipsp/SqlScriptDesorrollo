---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
/*            
    Stored Procedure: PROCESS_CREATE_PESCA_CIERRE            
    Author: Adrian Wong Macías            
    Created Date: 2024-05-23            
    Description: Proceso de creación de pesca.            
              
    Revision History:            
        Date        Author           Description            
     2024-05-23  Adrian Wong      Inicio            
*/                           
             
CREATE OR ALTER PROCEDURE PROCESS_CREATE_PESCA_CIERRE_HISTORIAL    
	@keyPiscina Varchar(30),
	@Cod_Piscina Varchar(100),
    @idPiscinaEjecucion INT,            
    @idPiscina INT,     --no es necesario 
	@fechaCierre DATE,    
    @fechaProceso DATETIME,            
    @usuario VARCHAR(10),            
	@ciclo  INT,            
    @displayContent BIT            
AS            
BEGIN             
-- Drop the temporary table if it exists            
IF OBJECT_ID('tempdb..#PescaTemporal') IS NOT NULL            
     DROP TABLE #PescaTemporal;   

SELECT	  t.Num,			t.Zona,              t.Camaronera,    t.Sector,			t.Piscina,             
		  t.Tipo,			t.Estatus,           t.Hectarea,      t.Ciclo,			t.Fecha_IniSec,             
		  t.Fecha_Siembra,	t.Cantidad_Sembrada, t.Densidad,      t.EstatusPesca,	t.InicioPesca,             
		  t.FinPesca,		t.Fecha_DS,          t.Bines,         t.Libras,			t.Peso,             
		  t.Animales,		t.Fecha_Cierre,		 t.Observaciones, pu.idPiscina            
 INTO #PescaTemporal             
FROM  [PESCA_PRODUCCION] t  INNER JOIN PiscinaUbicacion pu ON pu.KeyPiscina = t.keyPiscina          
WHERE  pu.KeyPiscina = @keyPiscina             
		and CICLO = @ciclo   

IF EXISTS (SELECT * FROM #PescaTemporal)
	BEGIN 
		-- Variables locales            
		DECLARE @horaInicioHistograma TIME = '06:00';
		DECLARE @horaFinHistograma TIME = '07:00';        
		DECLARE @descripcion VARCHAR(250) = 'REGISTRO GENERADO POR PROCESO DE REGULARIZACION SOLICITADO POR USUARIO PARA LA PISCINA (' + CAST(@idPiscina AS VARCHAR(10)) + ')';    
		DECLARE @origenHistograma VARCHAR(10) ='PES'
		DECLARE @estadoProceso VARCHAR(10) ='APR'
		DECLARE @secuencialHistograma INT;
		DECLARE @secuencialHistogramaDetalle INT;
		DECLARE @secuencialPedidoBin INT;            
		DECLARE @secuencialPedidoBinDetalle INT;
		DECLARE @secuencialPiscinaCosecha INT;
		DECLARE @horaInicioPesca TIME = '09:00'; 
		DECLARE @horaFinPesca TIME = '10:00';
		-- Actualización de secuenciales            
		UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla IN ('histograma', 'HistogramaDetalle', 'pedidoBin', 'pedidoBinDetalle', 'piscinaCosecha');             
		-- Obtener nuevos secuenciales            
		SELECT TOP 1 @secuencialHistograma = ultimaSecuencia FROM proSecuencial WHERE tabla = 'histograma';            
		SELECT TOP 1 @secuencialHistogramaDetalle = ultimaSecuencia FROM proSecuencial WHERE tabla = 'HistogramaDetalle';            
		SELECT TOP 1 @secuencialPedidoBin = ultimaSecuencia FROM proSecuencial WHERE tabla = 'pedidoBin';            
		SELECT TOP 1 @secuencialPedidoBinDetalle = ultimaSecuencia FROM proSecuencial WHERE tabla = 'pedidoBinDetalle';            
		SELECT TOP 1 @secuencialPiscinaCosecha = ultimaSecuencia FROM proSecuencial WHERE tabla = 'piscinaCosecha';            
            
		-- Insertar en proHistograma            
		INSERT INTO proHistograma (
			idHistograma, empresa, secuencia, idPiscina, idPiscinaEjecucion, origenHistograma, fechaRegistro,            
			fechaMuestreo, UsuarioResponsable, horaInicio, horaFinal, cantidadMuestreo, descripcion,            
			numeroPicadoLeve, numeroPicadoFuerte, numeroPicadoSano, numeroTexturaDuro, numeroTexturaFlacido, numeroTexturaMudado,            
			estado, usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion, responsable, tipoHistograma            
		)            
		SELECT @secuencialHistograma, p.empresa, @secuencialHistograma, pesc.IdPiscina, @idPiscinaEjecucion, @origenHistograma, @fechaProceso,           
			   DATEADD(day, -1, pesc.Fecha_DS), @usuario, @horaInicioHistograma, @horaFinHistograma, 1, @descripcion,            
			0, 0, 1, 1, 0, 0, @estadoProceso,             
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso, @usuario   , 'PPROM'        
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina;            
            
		-- Insertar en proHistogramaDetalle            
		INSERT INTO proHistogramaDetalle (            
			idHistogramaDetalle, idHistograma, orden,            
			pesoUnitario, idTalla, idTallaCola, activo,            
			usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion ,        
	  longitud, medidaLongitud, cantidadMuestra        
		)            
		SELECT @secuencialHistogramaDetalle, @secuencialHistograma, 1, pesc.Peso, tiEntero.idTallaItem, tiCola.idTallaItem, 1,            
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso,        
		 null, null, 1        
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		INNER JOIN invTallaItem tiEntero ON pesc.Peso BETWEEN tiEntero.pesoMinimo AND tiEntero.pesoMaximo AND tiEntero.histograma = 1            
		INNER JOIN invTipoItemTalla tipEntero ON tipEntero.talla = tiEntero.codigo AND tipEntero.idTipoItem = 1            
		INNER JOIN invTallaItem tiCola ON pesc.Peso BETWEEN tiCola.pesoMinimo AND tiCola.pesoMaximo AND tiCola.histograma = 1            
		INNER JOIN invTipoItemTalla tipCola ON tipCola.talla = tiCola.codigo AND tipCola.idTipoItem = 2;            
            
		-- Insertar en proPedidoBin            
		INSERT INTO proPedidoBin (            
			idPedidoBin, empresa, division, zona,            
			fechaPedido, idEspecie, idTipoIngreso, descripcion,            
			fechaRegistro, usuarioResponsable, tipoPedido, idMotivoAuditoria,            
			estado, usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion            
		)            
		SELECT @secuencialPedidoBin, p.empresa, p.division, p.zona,            
			   DATEADD(day, -1, pesc.Fecha_DS), 1, 41, @descripcion,            
			   @fechaProceso, @usuario, '00002', NULL,            
			   @estadoProceso, @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso            
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina;            
            
		-- Insertar en proPedidoBinDetalle            
		INSERT INTO proPedidoBinDetalle (            
			idPedidoBinDetalle, idPedidoBin, idPiscina, idPiscinaEjecucion,            
			tipoPesca, cantidadPesca, tipoUnidadMedida,            
			unidadMedida, cantidadBinesRequerido, numeroCompuertas,            
			idHistograma, pesoHistograma, horaInicio,            
			observacion, motivoAuditoria, activo,            
			usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion, numeroTinas            
		)            
		SELECT @secuencialPedidoBinDetalle, @secuencialPedidoBin, @idPiscina, @idPiscinaEjecucion,            
			   @origenHistograma, pesc.Libras,'PES',            
			   'LIBRA', pesc.Bines, 1,            
		   @secuencialHistograma, pesc.Peso, @horaInicioPesca,            
			   '', '', 1,            
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso, 1            
		FROM #PescaTemporal pesc            
	  INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina;            
            
		-- Insertar en proPiscinaCosecha            
		INSERT INTO proPiscinaCosecha (            
			idPiscinaCosecha, empresa, secuencia, secuenciaPiscina, idPiscinaEjecucion,            
			idPiscina, idPiscinaEjecucionAnterior, idPiscinaAnterior,            
			fechaInicio, fechaFin, horaInicio, fechaLiquidacion, horaFinal, idEmpacadora,            
			fechaRegistro, horaRegistro, usuarioResponsable, numeroBins, numeroViajes, numeroPersonas,            
			cantidadCosechada, pesoCosechaLibras, pesoPromedioGramos, diasAyuno, origenCosecha, personal,            
			tipoPesca, liquidado, descripcion, motivoCambioPiscina, motivoCambioTipoPesca, estado,            
			idMotivoAuditoria, binesTotales, binesBaja, binesStock, idHistograma, pesoHistograma,            
			usuarioCreacion, estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion, fechaHoraModificacion,            
			estadoTrabajo, binesParciales            
		)            
		SELECT @secuencialPiscinaCosecha, p.empresa, @secuencialPiscinaCosecha, 1, @idPiscinaEjecucion,            
			   @idPiscina, @idPiscinaEjecucion, @idPiscina,            
			   pesc.Fecha_DS, pesc.Fecha_DS, @horaInicioPesca, pesc.Fecha_DS, @horaFinPesca, NULL,            
			   CAST(@fechaProceso AS DATE), CAST(@fechaProceso AS TIME), @usuario,            
			   pesc.Bines, 0, 0,            
			   pesc.Animales, pesc.Libras, pesc.Peso,            
			   NULL, 'HIST', 0,            
			   @origenHistograma, 1, '',            
			   '', '', @estadoProceso,            
			   NULL, pesc.Bines, 0,            
			   0, @secuencialHistograma, pesc.Peso,            
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso, 'FIN', 0            
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina;            
            
	 UPDATE pe set pe.cantidadSalida =  pesc.Animales   --pe.cantidadSalida + pesc.Animales  
	 FROM  #PescaTemporal pesc            
		INNER JOIN maePiscina p    ON pesc.IdPiscina       = p.idPiscina            
	 INNER JOIN proPiscinaEjecucion pe   ON pe.idPiscina         = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina and pe.idPiscinaEjecucion = @idPiscinaEjecucion;            
            
	  update pe set       
	  --pe.cantidadPerdida  =  (pe.cantidadEntrada  + pe.cantidadAdicional) - pe.cantidadSalida            
		pe.cantidadPerdida = CASE       
			WHEN pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida < 0 THEN 0       
			ELSE pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida       
		END       ,
		pe.estado = 'PRE',--CERRAR
		pe.fechaCierre =  @fechaCierre
	  FROM   proPiscinaEjecucion   pe             
	  WHERE  pe.idPiscinaEjecucion = @idPiscinaEjecucion;            
            

		IF NOT EXISTS(select top 1 1 from EjecucionesPiscinaView where cod_ciclo = @Cod_Piscina)
		BEGIN 
		
			DECLARE @secuencialPiscinaEjecucion  INT
			DECLARE @secuencialMaeCiclo          INT

			SELECT TOP 1 @secuencialPiscinaEjecucion  = ultimaSecuencia + 1
						FROM	proSecuencial 
						WHERE	tabla = 'piscinaEjecucion' 

			SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
						FROM	maeSecuencial 
						WHERE	tabla = 'PiscinaCiclo' 
						
			  INSERT INTO proPiscinaEjecucion (
								idPiscinaEjecucion,					 idPiscina,				      ciclo,			rolPiscina,			numEtapa,			lote,				fechaInicio, 
								fechaSiembra,						 fechaCierre,			      tipoCierre,		idEspecie,			cantidadEntrada,	cantidadAdicional,  cantidadSalida,				
								cantidadPerdida,					 idPiscinaEjecucionSiguiente, estado,			tieneRaleo,			tieneRepanio,		tieneCosecha,		activo,
								usuarioCreacion,					 estacionCreacion,			  fechaHoraCreacion, 
								usuarioModificacion,				 estacionModificacion,		  fechaHoraModificacion) 

				SELECT top 1	@secuencialPiscinaEjecucion,		 idPiscina,					  0,				'',					0,					codigoSector,		DATEADD(DAY, 1, @fechaCierre), 
								NULL,								 NULL,							'',					0,					0,				0,					0, 
								0,									 NULL,						    'INI',				0,					0,				0,					1,
								@usuario,							'::2',							@fechaProceso,
								@usuario,							'::2',							@fechaProceso
					FROM PiscinaUbicacion where KeyPiscina = @keyPiscina;

				INSERT INTO [dbo].[maePiscinaCiclo] (
							idPiscinaCiclo,						idPiscina,			    ciclo,		
							fecha,								origen,				    idOrigen, 
							idOrigenEquivalente,				rolCiclo,			    activo, 
							usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
							usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
				SELECT top 1
							@secuencialMaeCiclo,			idPiscina,				0, 
							DATEADD(DAY, 1, @FechaCierre),		'PRE',					@secuencialPiscinaEjecucion, 
							null as idOrigenEquivalente,		'',						1, 
							@usuario,							'::2',					@fechaProceso, 
							@usuario,							'::2',					@fechaProceso
					 from PiscinaUbicacion where KeyPiscina = @keyPiscina;

				 
			UPDATE pe set   pe.idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucion
			FROM   proPiscinaEjecucion   pe             
			WHERE  pe.idPiscinaEjecucion = @idPiscinaEjecucion; 
	  
		   --ABRO EL NUEVO CICLO
   			UPDATE proSecuencial 
						SET    ultimaSecuencia = @secuencialPiscinaEjecucion
						WHERE  tabla		   = 'piscinaEjecucion' 
					
			UPDATE maeSecuencial 
						SET   ultimaSecuencia = @secuencialMaeCiclo
						WHERE tabla = 'PiscinaCiclo' 
		END

	END

END 