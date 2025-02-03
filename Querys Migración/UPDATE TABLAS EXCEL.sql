

	UPDATE CICLOS_PRODUCCION
SET Cod_Ciclo = REPLACE(Cod_Ciclo,' ',''),
	Key_Piscina = REPLACE(Key_Piscina,' ',''),
	Sector = REPLACE(Sector,' ','')
	
	UPDATE RECEPCIONES_PRODUCCION
SET Cod_Ciclo = REPLACE(Cod_Ciclo,' ',''),
	KeyPiscina = REPLACE(KeyPiscina,' ',''),
	Sector = REPLACE(Sector,' ','')
	
	UPDATE TRANSFERENCIAS_PRODUCCION
SET Cod_Ciclo_Origen = REPLACE(Cod_Ciclo_Origen,' ',''),
	Sector_Origen = REPLACE(Sector_Origen,' ',''),
	Piscina_Origen = REPLACE(Piscina_Origen,' ',''),
	Cod_Ciclo_Destino = REPLACE(Cod_Ciclo_Destino,' ',''),
	Sector_Destino = REPLACE(Sector_Destino,' ',''),
	Piscina_Destino = REPLACE(Piscina_Destino,' ',''),
	keyPiscinaDestino = REPLACE(Sector_Destino+Piscina_Destino,' ',''),
	keyPiscinaOrigen = REPLACE(Sector_Origen + Piscina_Origen,' ','')
	
	UPDATE PESCA_PRODUCCION
	SET Cod_Ciclo = REPLACE(Sector+Piscina+'.'+cast(ciclo as varchar(20)),' ',''),
	KeyPiscina = REPLACE(Sector+Piscina,' ',''),
	Sector = REPLACE(Sector,' ','')
	
	;WITH CTE AS (
    SELECT 
        Cod_ciclo,
        ROW_NUMBER() OVER(ORDER BY Zona) AS RowNum
    FROM 
        PESCA_PRODUCCION )
UPDATE p
SET p.Num = c.RowNum
FROM PESCA_PRODUCCION p
JOIN CTE c ON p.Cod_ciclo = c.Cod_ciclo;