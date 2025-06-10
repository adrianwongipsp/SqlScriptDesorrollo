DECLARE @zona VARCHAR(2) = '29'

SELECT DISTINCT
	pu.nombreSector AS Sector,
	pu.nombrePiscina AS Unidad,
	h.fechaMuestreo AS FechaMuestreo,
	CASE h.origenHistograma
		WHEN 'PES' THEN 'Pesca'
		ELSE 'Raleo'
	END AS OrigenHistograma,
	CAST(ROUND(peso.pesoPonderado,2) AS DECIMAL(18,2)) AS PesoPromedio,
	CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM maeTablaTallaCentralPeso t 
            WHERE peso.pesoPonderado >= t.limiteInferior 
            AND peso.pesoPonderado <= t.limiteSuperior
        ) THEN 1 
        ELSE 0 
    END as estaEnRango,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM maeTablaTallaCentralPeso t 
            WHERE peso.pesoPonderado >= t.limiteInferior 
            AND peso.pesoPonderado <= t.limiteSuperior
        ) THEN 'SI' 
        ELSE 'NO' 
    END as TallaCentral,
	ISNULL(h.numeroPicadoLeve,0) AS Picado_Leve,
	ISNULL(h.numeroPicadoFuerte,0) AS Picado_Fuerte,
	ISNULL(h.numeroPicadoSano,0) AS Picado_Sin_Picar,
	ISNULL(h.numeroTexturaDuro,0) AS Textura_Duro,
	ISNULL(h.numeroTexturaFlacido,0) AS Textura_Flacido,
	ISNULL(h.numeroTexturaMudado,0) AS Textura_Mudado,
	ISNULL(h.numeroA1,0) AS Color_A1,
	ISNULL(h.numeroA2,0) AS Color_A2,
	ISNULL(h.numeroA3,0) AS Color_A3,
	ISNULL(h.numeroA4,0) AS Color_A4,
	ISNULL(h.numeroPresenciaPataRojas,0) AS Patas_Rojas_Presencia,
	ISNULL(h.numeroAusenciaPataRojas,0) AS Patas_Rojas_Ausencia,
	ISNULL(h.numeroBranquiasVerdes,0) AS Branquias_Verdes,
	ISNULL(h.numeroBranquiasAmarillas,0) AS Branqueas_Amarillas,
	ISNULL(h.numeroBranquiasNegras,0) AS Branquias_Negras,
	ISNULL(h.numeroBranquiasLimpias,0) AS Branquias_Limpias
FROM proHistograma h
INNER JOIN proHistogramaDetalle hd ON h.idHistograma = hd.idHistograma AND hd.activo = 1
INNER JOIN PiscinaUbicacion pu ON pu.idPiscina = h.idPiscina
INNER JOIN (
	SELECT 
		hd.idHistograma,
		SUM((CAST(hd.cantidadMuestra AS DECIMAL(18,6)) / NULLIF(total.totalMuestra, 0)) * hd.pesoUnitario) AS pesoPonderado
	FROM proHistogramaDetalle hd
	INNER JOIN (
		SELECT idHistograma, SUM(cantidadMuestra) AS totalMuestra
		FROM proHistogramaDetalle
		WHERE activo = 1
		GROUP BY idHistograma
	) total ON total.idHistograma = hd.idHistograma
	WHERE hd.activo = 1
	GROUP BY hd.idHistograma
) AS peso ON peso.idHistograma = h.idHistograma
WHERE pu.codigoZona = @zona AND h.estado = 'APR'
ORDER BY pu.nombreSector, pu.nombrePiscina