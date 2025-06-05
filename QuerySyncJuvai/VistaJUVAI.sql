use IPSP_JUVAI
go

alter view Vw_BasePesoMuestra
as 
	select 
	im.nbIdImagen,
	im.nbSampleWeight,		im.nbIdTipoMuestra, im.nbIdCicloPiscina,     im.nbIdUsuario, 
	im.txtUsuarioRegistro,  im.dtFechaRegistro, im.dtFechaRegistroEnvio ,im.txtNombreMuestra,
	ar.nbAverageWeight,		ar.nbAverageLength, ar.nbDias, 				ar.nbNumeroAnimales,
	tm.txtNombreTipo as nombreTipoMuestra, 
	tm.nbIdFase,
	cp.txtIdPiscina, 
	cp.txtRolPiscina, 
	cp.txtEstadoCiclo, 
	cp.nbIdPiscinaEjecucion , 
	cp.nbNumeroCiclo,
	cp.txtClavePiscina, 
	cp.txtCodigoCiclo 
	from [tbImagenMuestra] im 
			inner join [tbCicloPiscina] cp on im.nbIdCicloPiscina = cp.nbIdCicloPiscina
			inner join [tbTipoMuestra]  tm on tm.nbIdTipoMuestra = im.nbIdTipoMuestra
			inner join [tbAnalisisRecibido] ar on ar.nbImageId = im.nbIdImagen and ar.nbIdCicloPiscina = cp.nbIdCicloPiscina
	where im.nbActivo = 1  
 