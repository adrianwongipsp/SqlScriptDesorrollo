USE IPSPCamaroneraZonificacion
GO

SELECT  codigoZona, nombreZona, codigoCamaronera, nombreCamaronera,	codigoSector ,nombreSector, COUNT(idPiscina) AS cantidadPiscina
FROM PiscinaUbicacion 
WHERE  (nombreZona IN('GOLFOA', 'GOLFOB') OR nombreSector IN('ESPAÑA','KANSAS'))
GROUP BY  codigoZona, nombreZona, codigoCamaronera	, nombreCamaronera,	codigoSector ,nombreSector
ORDER BY  nombreSector;

IF NOT OBJECT_ID('tempdb..#TMP_AJUSTE_MASIVO') IS NULL  DROP TABLE #TMP_AJUSTE_MASIVO
GO 
CREATE TABLE #TMP_AJUSTE_MASIVO
(
    NUEVOZONA INT,
	ID_ZONA INT,
	COD_ZONA VARCHAR(10),
    ZONA VARCHAR(80),
	ID_ZONA_OLD INT NULL,
	COD_ZONA_OLD VARCHAR(10),
	NUEVOCAMARONERA INT,
    ID_CAMARONERA INT,
	COD_CAMARONERA VARCHAR(10),
	CAMARONERA VARCHAR(80),
	COD_CAMARONERA_OLD VARCHAR(10),
    ID_SECTOR INT,
	COD_SECTOR VARCHAR(10),
	SECTOR VARCHAR(80),
	CAMBIO INT,
	CODIGO_SECTOR_OLD  VARCHAR(10),
	NUEVOMZONA INT,
	ID_MZONA INT,
	COD_MZONA VARCHAR(10),
    MEGAZONA VARCHAR(80),
  );
SET NOCOUNT OFF; 

BEGIN TRY 
BEGIN TRAN

     select *
	 INTO tempMigracionPiscina20250731
	 from tempMigracionPiscina
     delete from tempMigracionPiscina

    INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,14,'14','BAJENA',0,51,'00051','BAJENA',26,'00026','ESPAÑA',1,0,3,'03','MEDIA','15','00052','00026');
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,14,'14','BAJENA',0,51,'00051','BAJENA',27,'00027','KANSAS',1,0,3,'03','MEDIA','15','00052','00027');

	-----MEGA ZONA GOLFO
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,11,'11','GOLFO',1,0,'00000','GOLFO',65,'00065','SUECIAI',1,0,2,'02','GOLFO','21','00058','00065');
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,11,'11','GOLFO',1,0,'00000','GOLFO',66,'00066','SUECIAII',1,0,2,'02','GOLFO','21','00058','00066');
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,11,'11','GOLFO',1,0,'00000','GOLFO',64,'00064','AUSTRALIA',1,0,2,'02','GOLFO','21','00058','00064');
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,11,'11','GOLFO',1,0,'00000','GOLFO',67,'00067','NUEVAZELANDA',1,0,2,'02','GOLFO','22','00059','00067');
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,11,'11','GOLFO',1,0,'00000','GOLFO',83,'00083','BORABORAI',1,0,2,'02','GOLFO','22','00059','00083');
	INSERT INTO #TMP_AJUSTE_MASIVO(NUEVOZONA, ID_ZONA, COD_ZONA, ZONA, NUEVOCAMARONERA, ID_CAMARONERA, COD_CAMARONERA, CAMARONERA, ID_SECTOR, COD_SECTOR, SECTOR, CAMBIO, NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, COD_ZONA_OLD, COD_CAMARONERA_OLD, CODIGO_SECTOR_OLD) VALUES (0,11,'11','GOLFO',1,0,'00000','GOLFO',87,'00087','BORABORAII',1,0,2,'02','GOLFO','22','00059','00087');


	DECLARE @idtP INT=40;
	INSERT INTO [dbo].[tempMigracionPiscina](   [idTempMigracionPiscina],[ZONA_OLD]             ,[IDZONA_OLD]   ,[CODIGOZONA_OLD]   ,[CAMARONERA_OLD]   ,[IDCAMARONERA_OLD]
												,[CODIGOCAMARONERA_OLD]  ,[SECTOR_OLD]           ,[IDSECTOR_OLD] ,[CODIGOSECTOR_OLD] ,[CODIGOPISCINA]    ,[IDPISCINA]
												,[NOMBREPISCINA]         ,[KEYPISCINA]           ,[ZONA_NEW]     ,[IDZONA_NEW]       ,[CODIGOZONA_NEW]   ,[CAMARONERA_NEW]
												,[IDCAMARONERA_NEW]      ,[CODIGOCAMARONERA_NEW] ,[SECTOR_NEW]   ,[IDSECTOR_NEW]     ,[CODIGOSECTOR_NEW] ,[IDLOTE_NEW]
												,[ACTIVO]                ,[TIPO]                 ,[PROCESADO]    ,[USUARIO_PROCESO]  ,[FECHA_PROCESO])
	SELECT 
	@idtP ++ ROW_NUMBER() OVER (ORDER BY b.idPiscina),
	x.nombreZona   ,x.idZona       ,x.codigoZona  ,x.nombreCamaronera  ,x.idCamaronera   ,x.codigoCamaronera       ,x.nombreSector
	,x.idSector    ,x.codigoSector ,b.codigo      ,b.idPiscina         ,b.nombre         ,x.nombreSector +b.nombre ,''
	,0             ,''             ,''            ,0                   ,''               ,''                       ,0   
	,''            ,0              ,1             ,'Piscina'     ,0              ,'adminPsCam'  ,GETDATE()
	FROM maePiscina b
	INNER JOIN SectorUbicacion x ON b.sector=x.codigoSector
	WHERE b.activo=1 
	AND (x.nombreMegaZona ='GOLFO' OR x.nombreSector IN('ESPAÑA','KANSAS'));			


		-----megazona
		IF(SELECT COUNT(*) FROM #TMP_AJUSTE_MASIVO WHERE NUEVOMZONA=1)>=1
		BEGIN
			 DECLARE @idMegaZona int 
			 DECLARE @idMaxMegaZona int 
			 SET @idMegaZona = 0
			 IF EXISTS(SELECT  TOP 1 1 FROM parSecuencial WITH(NOLOCK) WHERE tabla='megaZona')
			 BEGIN
				SELECT TOP 1 @idMegaZona = ultimaSecuencia
					FROM parSecuencial WITH(NOLOCK) WHERE tabla='megaZona'
			 END 
		  
			  INSERT INTO parMegaZona(idMegaZona, idDivision, codigo, nombre, descripcion, activo, fechaHoraCreacion, usuarioCreacion, estacionCreacion, fechaHoraModificacion, usuarioModificacion, estacionModificacion)
			  SELECT DISTINCT
			  @idMegaZona + ROW_NUMBER() OVER (ORDER BY MEGAZONA)
			  ,1
			  ,FORMAT(@idMegaZona + ROW_NUMBER() OVER (ORDER BY MEGAZONA), '00')
			  ,MEGAZONA
			  ,MEGAZONA
			  ,1
			  ,GETDATE()
			  ,'adminPsCam'
			  ,''
			  ,GETDATE()
			  ,'adminPsCam'
			  ,''
			  FROM #TMP_AJUSTE_MASIVO
			  WHERE NUEVOMZONA=1
			  AND NOT EXISTS (SELECT * FROM parMegaZona WITH(NOLOCK) WHERE nombre = MEGAZONA)
			  GROUP BY MEGAZONA

			  SELECT @idMaxMegaZona = MAX(idMegaZona) FROM parMegaZona WITH(NOLOCK)
			  IF(@idMegaZona =0)
			  BEGIN
				INSERT INTO parSecuencial VALUES ('megaZona',  @idMaxMegaZona)  
			  END 
			  ELSE
			  BEGIN
				 UPDATE parSecuencial SET ultimaSecuencia = @idMaxMegaZona WHERE tabla ='megaZona'
			  END
		END
		ELSE IF EXISTS(SELECT * FROM parMegaZona WITH(NOLOCK) WHERE nombre IN(SELECT MEGAZONA FROM #TMP_AJUSTE_MASIVO) AND activo=0)
		BEGIN
		   UPDATE parMegaZona 
		   SET activo = 1,
		       fechaHoraModificacion=GETDATE(),
			   usuarioModificacion='adminPsCam'
		   WHERE  nombre IN(SELECT MEGAZONA FROM #TMP_AJUSTE_MASIVO) AND activo=0;
		END

		UPDATE x 
		SET x.COD_MZONA= y.codigo,
			x.ID_MZONA=y.idMegaZona
		FROM #TMP_AJUSTE_MASIVO x
		INNER JOIN parMegaZona y WITH(NOLOCK) ON  x.MEGAZONA=y.nombre 
		WHERE   x.NUEVOMZONA=1 AND y.activo = 1;

		----zona
		IF(SELECT COUNT(*) FROM #TMP_AJUSTE_MASIVO WHERE NUEVOZONA=1)>=1
		BEGIN
			 DECLARE @idZona INT 
			 DECLARE @idMaxZona INT 
			 SET @idZona = 0
			 IF EXISTS(SELECT  TOP 1 1 FROM parSecuencial WITH(NOLOCK) WHERE tabla='Zona')
			 BEGIN
				SELECT TOP 1 @idZona = ultimaSecuencia
					FROM parSecuencial WITH(NOLOCK) WHERE tabla='Zona'
			 END 
		  
			  INSERT INTO parZona(idZona, idMegaZona, idDivision, codigo, codigoSri ,nombre, descripcion, direccion, telefono, correoElectronico, activo, fechaHoraCreacion, usuarioCreacion, estacionCreacion, fechaHoraModificacion, usuarioModificacion, estacionModificacion, numeroPedidoLarva, aplicaApiLarvia)
			  SELECT DISTINCT
			  @idZona + ROW_NUMBER() OVER (ORDER BY ZONA)
			  ,ID_MZONA
			  ,1
			  ,FORMAT(@idZona + ROW_NUMBER() OVER (ORDER BY ZONA), '00')
			  ,FORMAT(@idZona + ROW_NUMBER() OVER (ORDER BY ZONA), '000')
			  ,ZONA
			  ,ZONA
			  ,ZONA
			  ,''
			  ,''
			  ,1
			  ,GETDATE()
			  ,'adminPsCam'
			  ,''
			  ,GETDATE()
			  ,'adminPsCam'
			  ,''
			  ,1
			  ,0
			  FROM #TMP_AJUSTE_MASIVO
			  WHERE NUEVOZONA=1
			  AND NOT EXISTS (SELECT * FROM parZona WITH(NOLOCK) WHERE nombre = ZONA)
			  GROUP BY ZONA,ID_MZONA

			  SELECT @idMaxZona = MAX(idMegaZona) FROM parMegaZona WITH(NOLOCK)
			  IF(@idZona =0)
			  BEGIN
				INSERT INTO parSecuencial VALUES ('Zona',  @idMaxZona)  
			  END 
			  ELSE
			  BEGIN
				 UPDATE parSecuencial SET ultimaSecuencia = @idMaxZona WHERE tabla ='Zona'
			  END
		END
		ELSE IF EXISTS(SELECT * FROM parZona WITH(NOLOCK) WHERE nombre IN(SELECT ZONA FROM #TMP_AJUSTE_MASIVO) AND activo=0)
		BEGIN

			  UPDATE x  SET x.activo = 1,
			         x.idMegaZona = y.ID_MZONA,
			  		 x.fechaHoraModificacion=GETDATE(),
			         x.usuarioModificacion='adminPsCam'
			  FROM parZona x
			  INNER JOIN #TMP_AJUSTE_MASIVO y ON x.nombre= y.ZONA
			  WHERE   x.activo=0;

		END
		  


	      UPDATE x 
		  SET x.COD_ZONA = y.codigo,
		      x.ID_ZONA  = y.idZona
		  FROM #TMP_AJUSTE_MASIVO x
		  INNER JOIN parZona y WITH(NOLOCK) ON x.ZONA = y.nombre
		  WHERE  x.NUEVOZONA = 1 AND y.activo = 1 ;
		  

		  UPDATE x 
		  SET x.activo =  0,
		      x.fechaHoraModificacion = GETDATE(),
			  x.usuarioModificacion   = 'adminPsCam'
		  FROM  parZona x WITH(NOLOCK)  
		  INNER JOIN #TMP_AJUSTE_MASIVO tam
		  ON x.codigo  = tam.COD_ZONA_OLD 
		  WHERE x.codigo IN('21','22')  
		  AND   x.activo = 1;


		----camaronera 
		IF (SELECT COUNT(*) FROM #TMP_AJUSTE_MASIVO WHERE NUEVOCAMARONERA=1)>=1
		BEGIN

	     DECLARE @id INT 
		 DECLARE @idMax INT 
		 SET @id = 0
		 IF EXISTS(SELECT  TOP 1 1 FROM parSecuencial WITH(NOLOCK) WHERE tabla='Camaronera')
		 BEGIN
			  SELECT TOP 1 @id = ultimaSecuencia
			  FROM parSecuencial WITH(NOLOCK) 
			  WHERE tabla='Camaronera';
		 END 
		  

		  INSERT INTO parCamaronera(idCamaronera, idZona, codigo ,nombre, descripcion, activo, fechaHoraCreacion, usuarioCreacion, estacionCreacion, fechaHoraModificacion, usuarioModificacion, estacionModificacion)
		  SELECT DISTINCT
		   @id + ROW_NUMBER() OVER (ORDER BY CAMARONERA)
		  ,ID_ZONA
		  ,FORMAT(@id + ROW_NUMBER() OVER (ORDER BY CAMARONERA), '00000')
		  ,CAMARONERA
		  ,CAMARONERA
		  ,1
		  ,GETDATE()
		  ,'adminPsCam'
		  ,''
		  ,GETDATE()
		  ,'adminPsCam'
		  ,''
		  FROM #TMP_AJUSTE_MASIVO
		  WHERE NUEVOCAMARONERA=1
		  AND NOT EXISTS (SELECT  *FROM parCamaronera WITH(NOLOCK) WHERE nombre = CAMARONERA  ) --AND idZona=ID_ZONA)
		  GROUP BY CAMARONERA, ID_ZONA

		  SELECT @idMax = MAX(idCamaronera) FROM parCamaronera WITH(NOLOCK)
		  IF(@id =0)
		  BEGIN
		    INSERT INTO parSecuencial VALUES ('Camaronera',  @idMax)  
		  END 
		  ELSE
		  BEGIN
			 UPDATE parSecuencial SET ultimaSecuencia = @idMax WHERE tabla ='Camaronera'
		  END
		 END
		 ELSE IF EXISTS(SELECT * FROM parCamaronera WITH(NOLOCK) WHERE nombre IN(SELECT CAMARONERA FROM #TMP_AJUSTE_MASIVO) AND activo=0)
		 BEGIN
			  UPDATE parCamaronera 
			  SET activo = 1,
			  	  fechaHoraModificacion=GETDATE(),
			      usuarioModificacion='adminPsCam'
			  WHERE  nombre IN(SELECT CAMARONERA FROM #TMP_AJUSTE_MASIVO) AND activo=0;
		 END
 

	      UPDATE x 
		  SET x.COD_CAMARONERA = y.codigo,
		      x.ID_CAMARONERA  = y.idCamaronera
		  FROM #TMP_AJUSTE_MASIVO x
		  INNER JOIN parCamaronera y WITH(NOLOCK) 
		  ON x.CAMARONERA=y.nombre 
		  WHERE  y.activo = 1 AND x.NUEVOCAMARONERA = 1; 

		  UPDATE x 
		  SET x.activo =  0,
		      x.fechaHoraModificacion=GETDATE(),
			  x.usuarioModificacion='adminPsCam'
		  FROM  parCamaronera x WITH(NOLOCK)  
		  INNER JOIN #TMP_AJUSTE_MASIVO y WITH(NOLOCK) ON x.codigo=y.COD_CAMARONERA_OLD 
		  WHERE x.codigo IN('00058','00059') AND  x.activo = 1;
		  
	     --SELECT ' finally #TMP_AJUSTE_MASIVO' AS TABLA,* FROM #TMP_AJUSTE_MASIVO


			----sector
    IF (SELECT COUNT(*) FROM #TMP_AJUSTE_MASIVO WHERE CAMBIO=2)>=1
	BEGIN
	     DECLARE @ids INT 
		 DECLARE @idMaxs INT 
		 SET @ids = 0
		 IF EXISTS(SELECT  TOP 1 1 FROM parSecuencial WITH(NOLOCK) WHERE tabla='Sector')
		 BEGIN
			SELECT TOP 1 @ids = ultimaSecuencia
				FROM parSecuencial WITH(NOLOCK) WHERE tabla='Sector'
		 END 
		  
		  INSERT INTO parSector(idSector,idCamaronera, codigo ,nombre, descripcion, codigoINP, activo, fechaHoraCreacion, usuarioCreacion, estacionCreacion, fechaHoraModificacion, usuarioModificacion, estacionModificacion)
		  SELECT DISTINCT
		   @ids + ROW_NUMBER() OVER (ORDER BY SECTOR)
		  ,ID_CAMARONERA
		  ,FORMAT(@ids + ROW_NUMBER() OVER (ORDER BY SECTOR), '00000')
		  ,SECTOR
		  ,SECTOR
		  ,FORMAT(@ids + ROW_NUMBER() OVER (ORDER BY SECTOR), '00000')
		  ,1
		  ,GETDATE()
		  ,'adminPsCam'
		  ,''
		  ,GETDATE()
		  ,'adminPsCam'
		  ,''
		  FROM #TMP_AJUSTE_MASIVO
		  WHERE CAMBIO=2
		  AND NOT EXISTS (SELECT distinct nombre FROM parSector WITH(NOLOCK) WHERE nombre = SECTOR)-- AND idCamaronera=ID_CAMARONERA )
		  GROUP BY SECTOR, ID_CAMARONERA

		  SELECT @idMaxs = MAX(idSector) FROM parSector WITH(NOLOCK)
		  IF(@ids =0)
		  BEGIN
		    INSERT INTO parSecuencial VALUES ('Sector',  @idMaxs)  
		  END 
		  ELSE
		  BEGIN
			 UPDATE parSecuencial SET ultimaSecuencia = @idMaxs WHERE tabla ='Sector'
		  END
        END
		ELSE IF EXISTS(SELECT * FROM parSector WITH(NOLOCK) WHERE nombre IN(SELECT SECTOR FROM #TMP_AJUSTE_MASIVO) AND activo=0)
		BEGIN
			UPDATE parSector 
			SET activo = 1,
				fechaHoraModificacion=GETDATE(),
			    usuarioModificacion='adminPsCam'
		    WHERE  nombre IN(SELECT SECTOR FROM #TMP_AJUSTE_MASIVO) AND activo=0;

		END

		UPDATE x 
		SET x.idCamaronera= y.ID_CAMARONERA
		FROM parSector  x
		inner join #TMP_AJUSTE_MASIVO y WITH(NOLOCK) ON  x.codigo=y.COD_SECTOR 
		where x.activo = 1 AND y.CAMBIO=1;
	      
		UPDATE x 
		SET x.COD_SECTOR= y.codigo,
		    x.ID_SECTOR=y.idSector
		FROM #TMP_AJUSTE_MASIVO x
		inner join parSector y WITH(NOLOCK) ON  x.SECTOR=y.nombre 
		where y.activo = 1 AND x.CAMBIO=2;

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parMegaUbicaciones' AND TABLE_SCHEMA = 'dbo')
	BEGIN
		--PRINT 'La tabla parMegaUbicaciones no existe. Creando la tabla...';

		CREATE TABLE parMegaUbicaciones
		(
			NUEVOZONA INT,
			ID_ZONA INT,
			COD_ZONA VARCHAR(10),
			COD_ZONA_OLD VARCHAR(10),
			ID_ZONA_OLD INT NULL,
			ZONA VARCHAR(80),
			NUEVOCAMARONERA INT,
			ID_CAMARONERA INT,
			COD_CAMARONERA VARCHAR(10),
			COD_CAMARONERA_OLD VARCHAR(10),
			CAMARONERA VARCHAR(80),
			ID_SECTOR INT,
			COD_SECTOR VARCHAR(10),
			COD_SECTOR_OLD VARCHAR(10),
			SECTOR VARCHAR(80),
			CAMBIO INT,
			NUEVOMZONA INT,
			ID_MZONA INT,
			COD_MZONA VARCHAR(10),
			MEGAZONA VARCHAR(80),
			FECHA DATETIME,
		);
	END


	INSERT INTO parMegaUbicaciones (
    NUEVOZONA, ID_ZONA, COD_ZONA,  COD_ZONA_OLD, ID_ZONA_OLD,  ZONA, NUEVOCAMARONERA, ID_CAMARONERA, 
    COD_CAMARONERA, COD_CAMARONERA_OLD, CAMARONERA, ID_SECTOR, COD_SECTOR,  COD_SECTOR_OLD, SECTOR, CAMBIO, 
    NUEVOMZONA, ID_MZONA, COD_MZONA, MEGAZONA, FECHA
	)
	SELECT 
		t.NUEVOZONA, t.ID_ZONA, t.COD_ZONA, t.COD_ZONA_OLD, t.ID_ZONA_OLD , t.ZONA, t.NUEVOCAMARONERA, t.ID_CAMARONERA, 
		t.COD_CAMARONERA, t.COD_CAMARONERA_OLD, t.CAMARONERA, t.ID_SECTOR, t.COD_SECTOR, t.CODIGO_SECTOR_OLD,
		t.SECTOR, t.CAMBIO, 
		t.NUEVOMZONA, t.ID_MZONA, t.COD_MZONA, t.MEGAZONA, GETDATE()
	FROM 
		#TMP_AJUSTE_MASIVO t;

    /* da error xq debo inactivar el historial de registros de la tabla tempMigracionPiscina */


	UPDATE b SET 
			 b.ZONA_NEW             = z.ZONA
			,b.IDZONA_NEW           = z.ID_ZONA     
			,b.CODIGOZONA_NEW       = z.COD_ZONA     
			,b.CAMARONERA_NEW       = z.CAMARONERA  
			,b.IDCAMARONERA_NEW     = z.ID_CAMARONERA     
			,b.CODIGOCAMARONERA_NEW = z.COD_CAMARONERA 
			,b.SECTOR_NEW           = z.SECTOR                 
			,b.IDSECTOR_NEW         = z.ID_SECTOR
			,b.CODIGOSECTOR_NEW     = z.COD_SECTOR  
			,b.IDLOTE_NEW           = z.ID_SECTOR 
	FROM tempMigracionPiscina b
	LEFT JOIN #TMP_AJUSTE_MASIVO z ON 
	b.CODIGOZONA_OLD=z.COD_ZONA_OLD 
	AND b.CODIGOCAMARONERA_OLD=z.COD_CAMARONERA_OLD
	AND b.CODIGOSECTOR_OLD=z.CODIGO_SECTOR_OLD 
	WHERE b.activo=1;



   
	 IF NOT OBJECT_ID('tempdb..#TMP_AJUSTE_MASIVO') IS NULL  DROP TABLE #TMP_AJUSTE_MASIVO
	 --SELECT * FROM parZona where nombre IN('GOLFOA','GOLFOB', 'GOLFO')
	 --SELECT * FROM parCamaronera where nombre IN('GOLFOA','GOLFOB', 'GOLFO')
	 ----SELECT * FROM parCamaronera where activo=1 -- nombre in ('GOLFOA','GOLFOB')
	 --SELECT * FROM parSector where idCamaronera IN(SELECT idCamaronera FROM parCamaronera where nombre IN('GOLFOA','GOLFOB', 'GOLFO'))
	 ----SELECT * FROM parMegaUbicaciones WHERE CAST(FECHA AS DATE) = CAST(GETDATE() AS DATE)  ORDER BY SECTOR;

	 SELECT  codigoZona, nombreZona, codigoCamaronera	, nombreCamaronera,	codigoSector	,nombreSector, COUNT(idPiscina) AS cantidadPiscina
	 FROM PiscinaUbicacion
	 WHERE  (nombreZona ='GOLFO' OR nombreSector IN('ESPAÑA','KANSAS'))
	 GROUP BY  codigoZona, nombreZona, codigoCamaronera	, nombreCamaronera,	codigoSector	,nombreSector
	 ORDER BY  nombreSector;
	 --select * from parMigracionLog

	COMMIT TRAN
END TRY 
BEGIN CATCH 
	SELECT ERROR_NUMBER() ERR_NUMERO,ERROR_LINE() ERR_LINEA,ERROR_MESSAGE() ERR_DETALLE;
	ROLLBACK TRAN
END CATCH 
GO
 