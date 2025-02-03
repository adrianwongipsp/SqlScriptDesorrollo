USE IPSPCamaroneraTesting
GO
DECLARE @idPiscina int;
 DECLARE @keyDestino varchar(50) = 'PORTILLO4B';
 
 SET @idPiscina = (SELECT IdPiscina from PiscinaUbicacion where keyPiscina = @keyDestino);
 --//CUALES SON LAS TRANSFERENCIAS QUE NO EXISTEN EN EL EXCEL
with CTE as (
	select TE.fechaTransferencia, ej.keyPiscina, ej.cod_ciclo, ted.* from proTransferenciaEspecieDetalle ted
			INNER JOIN proTransferenciaEspecie te on te.idTransferencia = ted.idTransferencia
			INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = ted.idPiscinaEjecucion
			where  te.estado = 'APR')
SELECT 
    ts.fechaTransferencia,
    ts.keyPiscina,
    ts.cod_ciclo,
    ts.cantidadTransferida,
	ts.idTransferencia, 
	ts.idTransferenciaDetalle
FROM 
    CTE ts
LEFT JOIN 
    TRANSFERENCIAS_PRODUCCION ta
ON 
    ts.fechaTransferencia = ta.Fecha_Transf AND 
    ts.keyPiscina = ta.KeyPiscinaDestino AND 
    ts.cod_ciclo = ta.Cod_Ciclo_Destino AND 
    ts.cantidadTransferida = ta.Cantidad_Transf
WHERE 
    ta.Fecha_Transf IS NULL
    AND ta.KeyPiscinaDestino IS NULL
    AND ta.Cod_Ciclo_Destino IS NULL
    AND ta.Cantidad_Transf IS NULL
	and ts.idPiscina = @idPiscina;

--//CUALES SON LAS TRANSFERENCIAS QUE SOBRAN EN TRANSFERENCIA DE ESPECIES
	with CTE2 as (
		select TE.fechaTransferencia, ej.keyPiscina, ej.cod_ciclo, ted.* from proTransferenciaEspecieDetalle ted
				INNER JOIN proTransferenciaEspecie te on te.idTransferencia = ted.idTransferencia
				INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = ted.idPiscinaEjecucion
				where  te.estado = 'APR')


	SELECT	'01' AS empresa,			'01' AS division,	  pu.codigoZona AS zona,		 pu.codigoCamaronera AS camaronera,			pu.codigoSector AS sector, 
			pu.idPiscina,				 pu.codigoPiscina,  

			CASE WHEN ta.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN ta.tipo = 'PISCINA' THEN 'ENG01' WHEN ta.tipo = 'REPRODUCTOR' THEN 'REP01' ELSE '' END AS ROL,  
			REPLACE(Sector_Origen ,' ','')	 +   CONVERT(VARCHAR(200),Piscina_Origen)    AS keyOrigen, 

			Cod_Ciclo_Origen,					fecha_Transf,		pu.codigoZona AS Zona_Origen,   pu.codigoCamaronera as Camaronera_Origen,   pu.nombreSector,			 pu.codigoSector as Sector_Origen, 
			Piscina_Origen,					   Ciclo_Origen,		ta.Tipo,							Sub_Tipo,									Estatus_Origen, 
			Hectarea_Origen,					ta.Fecha_Siembra,	ta.Cantidad_Sembrada,			ta.Densidad,									Peso_Siembra, 
			Estatus_Transf,					   Cons_Balanc,		    Guia_Transf,					Forma_Transf,   

			CASE WHEN ta.linea = 'TANQUERO'         THEN '001' 	  WHEN ta.linea = 'TUBERÍA' THEN '002' 
			WHEN ta.linea = 'TUBERÍA-TANQUERO' THEN '003'    WHEN ta.linea = 'A PIE'   THEN '004' 
			WHEN ta.linea = 'DESCUELGUE'       THEN '006'    ELSE '001'			   END	 AS tipoTransferencia,

			REPLACE(Sector_Destino ,' ','') + CONVERT(VARCHAR(200),Piscina_Destino) AS keyDestino,	
			Cod_Ciclo_Destino,			          puD.codigoZona   AS Zona_Destino,			puD.codigoCamaronera AS  Camaronera_Destino,		puD.codigoSector AS  Sector_DestinoCOD,		puD.idPiscina AS idPiscinaDestino,
			Piscina_Destino,					  Ciclo_Destino,							Estatus_Destino,									Hectarea_Destino,							Cantidad_Transf, 
			Peso_Transf,						  Peso_Real,								Libras_Transf,										Conv,										Procedencia_Laboratorio, 
			Linea,								  Maduracion,								Superv,												Balanc,										Lib_Transf_C, 
			Anio,								  Estatus_Transf   AS TipoTransfTOTAL,		'APR' AS estado,									'AdminPsCam'     AS usuarioResponsable,
			'adminPsCam' AS usuarioCreacion,	  ':TRANSINSERT' AS estacionCreacion,      GETDATE() AS fechaHoraCreacion, 
			'adminPsCam' AS usuarioModificacion,  ':TRANSINSERT' AS estacionModificacion,  GETDATE() AS fechaHoraModificacion,					0 procesado,
			(SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = puD.idPiscina AND pp.ciclo = ta.Ciclo_Destino) idPiscinaEjecucionDestino,
			(SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = pu.idPiscina AND pp.ciclo = ta.Ciclo_Origen) idPiscinaEjecucionOrigen
	FROM 
		TRANSFERENCIAS_PRODUCCION ta
	LEFT JOIN 
		CTE2 ts
	ON 
		ta.Fecha_Transf = ts.fechaTransferencia AND 
		ta.KeyPiscinaDestino = ts.keyPiscina AND 
		ta.Cod_Ciclo_Destino = ts.cod_ciclo --AND 
		--ta.Cantidad_Transf = ts.cantidadTransferida
	INNER JOIN PiscinaUbicacion pu on ta.keyPiscinaOrigen = pu.keyPiscina
	INNER JOIN PiscinaUbicacion puD on ta.keyPiscinaDestino = puD.keyPiscina
	WHERE 
		ts.fechaTransferencia IS NULL
		AND ts.keyPiscina IS NULL
		AND ts.cod_ciclo IS NULL
		AND ts.cantidadTransferida IS NULL
		AND ta.keyPiscinaDestino = @keyDestino
		AND ta.Ciclo_Destino >= (select min(ciclo) from EjecucionesPiscinaView p where p.keyPiscina = ta.keyPiscinaDestino and p.estado IN ('PRE','EJE'))
		AND (SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = puD.idPiscina AND pp.ciclo = ta.Ciclo_Destino) is not null
		AND	(SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = pu.idPiscina AND pp.ciclo = ta.Ciclo_Origen) is not null
		 
			