SELECT distinct TOP 100   
        c.fechaControl,  el.descripcion as horaRegistro, 
        cm.nombre		as camaronera, cm.codigo AS codigoCamaronera,
		s.nombre		as sector, s.codigo AS codigoSector,
		c.zona, c.secuencia, c.fechaControl, c.fechaRegistro, c.usuarioResponsable, c.fechaHoraCreacion
		--, PU.nombrePiscina, d.idPiscinaEjecucion
FROM proControlParametro c 
INNER JOIN proControlParametroDetalle d ON c.idControlParametro = d.idControlParametro
INNER JOIN  proControlParametroValorDetalle dv ON d.idControlParametroDetalle = dv.idControlParametroDetalle
INNER JOIN PiscinaUbicacion PU ON d.idPiscina = PU.idPiscina
INNER JOIN parElementoCatalogo el		ON el.codigo = c.horaControl AND  idCatalogo		= 9
INNER JOIN parCamaronera cm				ON cm.codigo = c.camaronera   AND cm.idZona			= c.zona
INNER JOIN parSector s					ON s.codigo  = c.sector      AND s.idCamaronera		= cm.idCamaronera 
WHERE  cm.idZona			= 2   and s.nombre = 'SANDIEGO'
and dv.idParametroControl in (1,2,3)
ORDER BY c.fechaControl  DESC

SELECT * FROM proControlParametro WHERE idControlParametro=101607
 select * from parzona
 SELECT * FROM EjecucionesPiscinaView WHERE idPiscinaEjecucion= 9032
SELECT TOP 25 
		fechaMuestreo, 
		fechaHoraCreacion, 
		origenHistograma,
		nombreCamaronera, 
		nombreSector ,
		nombrePiscina,
		ph.*
FROM    proHistograma ph INNER JOIN PiscinaUbicacion pu ON pu.idPiscina =  ph.idPiscina 
WHERE   pu.codigoZona='03'	--and  idHistograma = 11395
ORDER BY 1 DESC

select   desc fechaMuestreo, empresa, division,  zona,  camaronera, sector, p.idMuestreo as Id, '' as adicional
		 from proMuestreoPoblacion p 
		 inner join proMuestreoPoblacionDetalleLance pd on p.idMuestreo = pd.idMuestreo
		 INNER JOIN PiscinaUbicacion pu ON pu.idPiscina =  pd.idPiscina 
			where p.zona='03' and estado = 'APR'
			ORDER BY 1 DESC
--select * from IPSPLightweightCore_Produccion.dbo.secUser where userLogin='2400050106' 
--select * from audit_secUserRoleAssignment where userId=421 order by updateDateTime desc

select * from PiscinaUbicacion where nombreSector ='PAKISTAN'