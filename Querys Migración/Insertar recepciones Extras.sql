BEGIN TRAN

SELECT 
	r.idRecepcion,
	null idCodigoGenetico,
	null idLaboratorioMaduracion,
	'00001' codigoLarva,
	null plGramo,
	null tanque,
	null salinidad,
	null temperatura,
	0.0 pesoInicial,
	null edadMinima,
	null oxigeno,
	null fechaSiembraNauplio,
	NULL estadioLarva,
	NULL diasLaboratorio,
	NULL larvasAzules,
	NULL larvasVacias,
	NULL larvasMuertas,
	NULL disparidadTallas,
	NULL plGramoLaboratorio,
	NULL tipoTransporte,
	'AdminPsCam' transportista,
	'XXXXXX' placa,
	'123' guiasEmbarque,
	'AdminPsCam' AS usuarioCreacion,
	'::RECEP' AS estacionCreacion,
	GETDATE() AS fechaHoraCreacion,
	'AdminPsCam' AS usuarioModificacion,
	'::RECEP' AS estacionModificacion,
	GETDATE() AS fechaHoraModificacion
FROM proRecepcionEspecie R LEFT JOIN proRecepcionEspecieExtra RE ON R.idRecepcion = RE.idRecepcion
WHERE    RE.idRecepcion IS NULL
AND
R.estacionCreacion IN ('::RECEP','::2')

INSERT INTO proRecepcionEspecieExtra (idRecepcion, 
idCodigoGenetico,    idLaboratorioMaduracion,	codigoLarva, plGramo,
tanque,              salinidad,					temperatura,
pesoInicial,		 edadMinima,				oxigeno,
fechaSiembraNauplio, estadioLarva,				diasLaboratorio,
larvasAzules,        larvasVacias,				larvasMuertas,
disparidadTallas,    plGramoLaboratorio,		tipoTransporte,
transportista,       placa,						guiasEmbarque,
usuarioCreacion,     estacionCreacion,			fechaHoraCreacion,
usuarioModificacion, estacionModificacion,		fechaHoraModificacion)
SELECT 
	r.idRecepcion,
	null idCodigoGenetico,
	null idLaboratorioMaduracion,
	'00001' codigoLarva,
	null plGramo,
	null tanque,
	null salinidad,
	null temperatura,
	0.0 pesoInicial,
	null edadMinima,
	null oxigeno,
	null fechaSiembraNauplio,
	NULL estadioLarva,
	NULL diasLaboratorio,
	NULL larvasAzules,
	NULL larvasVacias,
	NULL larvasMuertas,
	NULL disparidadTallas,
	NULL plGramoLaboratorio,
	NULL tipoTransporte,
	'AdminPsCam' transportista,
	'XXXXXX' placa,
	'123' guiasEmbarque,
	'AdminPsCam' AS usuarioCreacion,
	'::RECEP' AS estacionCreacion,
	GETDATE() AS fechaHoraCreacion,
	'AdminPsCam' AS usuarioModificacion,
	'::RECEP' AS estacionModificacion,
	GETDATE() AS fechaHoraModificacion
FROM proRecepcionEspecie R LEFT JOIN proRecepcionEspecieExtra RE ON R.idRecepcion = RE.idRecepcion
WHERE    RE.idRecepcion IS NULL
AND
R.estacionCreacion IN ('::RECEP','::2')

ROLLBACK 
--COMMIT