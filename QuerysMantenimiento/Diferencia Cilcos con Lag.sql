

--select Piscina, idPiscina, cod_ciclo, Ciclo 
----diferencia del ciclo anterior agupado por idPiscina, es decir si los ciclos son 1,2,3 para idPiscina 65 deberia ver en mi nueva columna la diferencia con el registro de la columna ciclo (int)
---- 2(registro actual) -1 (registro anterior) es igual a 1 ; y asi sucesivamente   3 (registro actual) - 2 (registro anterior) es igual 1
--from EjecucionesPiscinaView where keyPiscina in('LALUZ6',
--'LALUZ10',
--'LALUZPC19',
--'LALUZ2') order by  cod_ciclo, ciclo

 
SELECT 
    EJ.Piscina, 
    EJ.idPiscina, 
    EJ.cod_ciclo, 
    EJ.Ciclo,
     CASE WHEN LAG(EJ.Ciclo) OVER (PARTITION BY  EJ.idPiscina ORDER BY  EJ.ciclo) = 0  THEN 1 ELSE   
	 ISNULL( EJ.Ciclo - LAG(EJ.Ciclo) OVER (PARTITION BY EJ.idPiscina ORDER BY EJ.ciclo),0) END AS Diferencia
	INTO #VERCICLOS_TAURA_REPETIDOS
FROM 
    EjecucionesPiscinaView EJ INNER JOIN CICLOS_PRODUCCION  CP ON EJ.keyPiscina = CP.Key_Piscina AND EJ.cod_ciclo = CP.Cod_Ciclo
 
ORDER BY  
    EJ.idPiscina, EJ.ciclo;

	SELECT cod_ciclo, COUNT(CICLO) FROM #VERCICLOS_TAURA_REPETIDOS WHERE  Diferencia =0
	GROUP BY  cod_ciclo
	HAVING  COUNT(CICLO) > 1

--SELECT * FROM proPiscinaEjecucion WHERE idPiscina=246
