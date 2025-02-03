USE IPSPCamaroneraTesting
GO
select * from PESCA_PRODUCCION
 DECLARE @idPiscina int;
 DECLARE @keyDestino varchar(50) = 'GUATEMALA4';
 SET @idPiscina = (SELECT IdPiscina from PiscinaUbicacion where keyPiscina = @keyDestino);

 --//CUALES SON LAS TRANSFERENCIAS QUE NO EXISTEN EN EL EXCEL
with CTE as (
			select r.fechaRecepcion, ej.keyPiscina, ej.cod_ciclo, rd.* from proRecepcionEspecieDetalle rd
			INNER JOIN proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
			INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = rd.idPiscinaEjecucion
			where  r.estado = 'APR')
SELECT 
    ts.fechaRecepcion,
    ts.keyPiscina,
    ts.cod_ciclo,
    ts.cantidadRecibida,
	ts.idRecepcion, 
	ts.idRecepcionDetalle
FROM 
    CTE ts
LEFT JOIN 
    RECEPCIONES_PRODUCCION ta
ON 
    ts.fechaRecepcion = ta.Fecha_Siembra AND 
    ts.keyPiscina = ta.KeyPiscina AND 
    ts.cod_ciclo = ta.Cod_Ciclo --AND 
    --ts.cantidadRecibida = ta.Cantidad_Sembrada
WHERE 
    ta.Fecha_Siembra IS NULL
    AND ta.KeyPiscina IS NULL
    AND ta.Cod_Ciclo IS NULL
    AND ta.Cantidad_Sembrada IS NULL
	and ts.idPiscina = @idPiscina;

--//CUALES SON LAS TRANSFERENCIAS QUE SOBRAN EN TRANSFERENCIA DE ESPECIES

with CTE2 as (
			select r.fechaRecepcion, ej.ciclo, ej.FechaInicio, ej.FechaSiembra, ej.FechaCierre, ej.keyPiscina, ej.cod_Ciclo, 
			ej.codigoZona , ej.codigoCamaronera, ej.codigoSector, rd.* 
			from proRecepcionEspecieDetalle rd
			INNER JOIN proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
			INNER JOIN EjecucionesPiscinaViewEstructura ej on ej.idPiscinaEjecucion = rd.idPiscinaEjecucion
			where  r.estado = 'APR')

SELECT 
	0 as idRecepcion,							'01' as empresa,							'01' as division,				pu.codigoZona,	
	pu.codigoCamaronera,						pu.codigoSector, 							pu.idPiscina,					
	ta.Ciclo,									
	CASE WHEN ta.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN ta.tipo = 'PISCINA' THEN 'ENG01' ELSE '' END rolPiscina,								
	0 as secuencia,					'PLA' as origen,							
	null idOrdenCompra,					 		null idDespacho,							null idPlanificacionSiembra,
	COALESCE(LP.idLaboratorio,0) idLaboratorio,	COALESCE(LP.idLaboratorioLarva,0) idLaboratorioLarva,	COALESCE(LM.idLaboratorioLarva,0) idLaboratorioMaduracion,	
	Peso_Siembra,								PlGr_Guia as plGramoLab,			        COALESCE(PlGr_Llegada,PlGr_Guia) as plGramoCam,		ta.Fecha_Siembra as fechaRegistro,		
	DATEADD(DAY, -1, ta.Fecha_Siembra) as fechaDespacho, 	ta.Fecha_Siembra as fechaRecepcion,		'06:00:00' as horaDespacho,	 '07:00:00' as horaRecepcion,
	0 as idResponsableSiembra,					1 as idEspecie,										'00001' AS tipoLarva,		  ta.Cantidad_Sembrada as cantidad, 
	1 as cantidadPlus,							(ta.Cantidad_Sembrada * 0.15) as porcentajePlus,
	'UNIDAD' as unidadMedida,					ta.Cantidad_Sembrada as cantidadRecibida,	ta.Guia_Remision as guiasRemision,	  0 as tieneFactura, 
	'Regularizada' as descripcion,				'' as responsableEntrega,					'APR' AS estado,					  'AdminPsCam' as usuarioResponsable,
	'adminPsCam'   as usuarioCreacion,			'::RECEP' AS estacionCreacion,				GETDATE() AS fechaHoraCreacion,		
	'adminPsCam'   as usuarioModificacion,		'::RECEP' AS estacionModificacion,			GETDATE() AS fechaHoraModificacion,		null AS reprocesoContable,
	0 procesado,								ta.Fecha_Siembra,							ta.KeyPiscina,						  ta.Cod_Ciclo,
    ta.Cantidad_Sembrada			
FROM 
    RECEPCIONES_PRODUCCION ta
LEFT JOIN 
    CTE2 ts
ON 
    ta.Fecha_Siembra = ts.fechaRecepcion AND 
    ta.KeyPiscina = ts.keyPiscina AND 
    ta.Cod_Ciclo = ts.cod_ciclo --AND 
INNER JOIN PiscinaUbicacion pu on ta.KeyPiscina = pu.keyPiscina
LEFT JOIN LABORATORIO_PROCEDENCIA_PRODUCCION LP ON LP.Procedencia_Laboratorio = ta.Procedencia_Laboratorio
LEFT JOIN LABORATORIO_MADURACION_PRODUCCION  LM ON LM.Maduracion = ta.Maduracion
WHERE 
    ts.fechaRecepcion IS NULL
    AND ts.keyPiscina IS NULL
    AND ts.cod_ciclo IS NULL
    AND ts.cantidadRecibida IS NULL
	AND ta.KeyPiscina = @keyDestino
	AND ta.ciclo >= (select min(ciclo) from EjecucionesPiscinaView p where p.keyPiscina = ta.KeyPiscina and p.estado IN ('PRE','EJE'));

	--select ej.cod_Ciclo, rd.* from proRecepcionEspecieDetalle rd
	--inner join EjecucionesPiscinaView ej on rd.idPiscinaEjecucion = ej.idPiscinaEjecucion
	----left join RECE
	--where rd.idPiscina = @idPiscina


