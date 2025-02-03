BEGIN TRANSACTION;

WITH PiscinasNumeradas AS (
    SELECT
        idPiscina,
        nombre,
        activo,
        ROW_NUMBER() OVER (PARTITION BY nombre ORDER BY idPiscina) AS NumFila
    FROM
        maePiscina
    WHERE
        zona = '09'
        AND camaronera = '00002'
        AND sector = '00001'
)

/* PiscinasNumeradas
SET activo = 0
WHERE NumFila > 1;
 */
  SELECT idPiscina, nombre, activo FROM maePiscina WITH(NOLOCK) WHERE zona='09' and camaronera='00002' and sector='00001'

  --COMMIT
  --para confirmar los cambios
-- ROLLBACK para revertir los cambios en caso de problemas
-- Comenta o descomenta la línea según sea necesario



 --;

  SELECT idPiscina, nombre, activo FROM maePiscina WITH(NOLOCK) WHERE zona='09' and camaronera='00002' and sector='00001' AND activo=0
  SELECT idPiscina, nombre, activo FROM maePiscina WITH(NOLOCK) WHERE zona='07' and camaronera='00001' and sector='00001' AND activo=0

  SELECT * FROM proPiscinaEjecucion WHERE idPiscina IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='09' and camaronera='00002' and sector='00001' AND activo=0)
  SELECT * FROM proPiscinaEjecucion WHERE idPiscina IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='07' and camaronera='00001' and sector='00001' AND activo=0)

 -- proPiscinaEjecucion SET activo=0 WHERE idPiscina IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='09' and camaronera='00002' and sector='00001' AND activo=0)
 -- proPiscinaEjecucion SET activo=0 WHERE idPiscina IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='07' and camaronera='00001' and sector='00001' AND activo=0)

 SELECT * FROM maePiscinaCiclo WHERE idPiscina  IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='07' and camaronera='00001' and sector='00001' AND activo=0)
  SELECT * FROM maePiscinaCiclo WHERE idPiscina IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='09' and camaronera='00002' and sector='00001' AND activo=0)

-- maePiscinaCiclo  SET activo=0  WHERE idPiscina  IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='07' and camaronera='00001' and sector='00001' AND activo=0)
-- maePiscinaCiclo  SET activo=0  WHERE idPiscina  IN (  SELECT idPiscina FROM maePiscina WITH(NOLOCK) WHERE zona='09' and camaronera='00002' and sector='00001' AND activo=0)