DECLARE @zona VARCHAR(10) = '20';

-- Normaliza valor de entrada
IF (COALESCE(@zona, '') = '')
BEGIN
    SET @zona = NULL;
END

;WITH zonas AS (
  SELECT zo.codigo CodigoZona, zo.nombre Zona, ca.codigo CodigoCamaronera, ca.nombre Camaronera, 
         se.codigo CodigoSector, se.nombre Sector, me.nombre AS NombreMegaZona
  FROM parZona zo
  INNER JOIN parCamaronera ca ON zo.idZona = ca.idZona
  INNER JOIN parSector se ON ca.idCamaronera = se.idCamaronera
  INNER JOIN parMegaZona me ON zo.idMegaZona = me.idMegaZona
  WHERE zo.codigo = COALESCE(@zona, zo.codigo)
),
piscinas AS (
  SELECT 
	z.NombreMegaZona,
	z.Zona as NombreZona,
	z.Sector,
	pis.idPiscina,
    pis.nombre,
    pis.superficieValor,
    pis.profundidadValor,
    pis.zona,
    pis.camaronera
   -- pis.sector
  FROM maePiscina pis
  INNER JOIN zonas z ON z.CodigoZona = pis.zona AND z.CodigoCamaronera = pis.camaronera AND z.CodigoSector = pis.sector
)
SELECT 
	pis.NombreMegaZona AS Megazona,
	pis.NombreZona AS Zona,
	pis.Sector,
	pis.nombre AS Unidad,
	pis.superficieValor AS Hectarea,
	pe.ciclo AS Ciclo,
	pe.rolPiscina AS Rol,
	pe.fechaInicio AS FechaInicio,
	pe.fechaSiembra AS FechaSiembra,
	pe.fechaCierre AS FechaCierre
FROM proPiscinaEjecucion pe 
INNER JOIN piscinas pis ON pis.idPiscina = pe.idPiscina 
WHERE pe.activo = 1
ORDER BY pe.idPiscina, pe.fechaInicio