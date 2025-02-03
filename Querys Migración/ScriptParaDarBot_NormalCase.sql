DECLARE @idGrupoWhatsappDetalleActual INT;
-- Get the maximum value from the existing table
SELECT  MAX(idGrupoWhatsappDetalle) 
FROM parGrupoWhatsappDetalle;

SELECT @idGrupoWhatsappDetalleActual = MAX(idGrupoWhatsappDetalle) 
FROM parGrupoWhatsappDetalle;
  
IF OBJECT_ID('tempdb..#PreviewCodigoGrupos') IS NOT NULL
	DROP TABLE #PreviewCodigoGrupos;
IF OBJECT_ID('tempdb..#PreviewCodigoGrupos2') IS NOT NULL
	DROP TABLE #PreviewCodigoGrupos2;
IF OBJECT_ID('tempdb..#PreviewCodigoGrupos3') IS NOT NULL
	DROP TABLE #PreviewCodigoGrupos3;
 
-- Create the temporary table to store the results
CREATE TABLE #PreviewCodigoGrupos (
    idGrupoWhatsappDetalle INT,
    idGrupoWhatsapp INT,
    tipoTransaccion NVARCHAR(50),
    orden INT,
    nivelGrupo NVARCHAR(50),
    codigoZona NVARCHAR(50),
    nombreZona NVARCHAR(100),
    codigoCamaronera NVARCHAR(50),
    nombreCamaronera NVARCHAR(100),
    codigoSector NVARCHAR(50),
    nombreSector NVARCHAR(100),
    jefeGrupo NVARCHAR(100),
    codigoGrupo NVARCHAR(50),
    enlaceGrupo NVARCHAR(255),
    activo BIT,
    usuarioCreacion NVARCHAR(50),
    estacionCreacion NVARCHAR(50),
    fechaHoraCreacion DATETIME,
    usuarioModificacion NVARCHAR(50),
    estacionModificacion NVARCHAR(50),
    fechaHoraModificacion DATETIME
);

WITH CTE_Sector AS (
    SELECT 
        z.codigo AS codigoZona, 
        z.nombre AS nombreZona,        
        c.codigo AS codigoCamaronera, 
        c.nombre AS nombreCamaronera,        
        s.codigo AS codigoSector,    
        s.nombre AS nombreSector, 
        n.idGrupoWhatsapp,
        n.tipoTransaccion,
        -- Partition by codigoZona, codigoCamaronera, and codigoSector to group the ROW_NUMBER properly
        ROW_NUMBER() OVER (PARTITION BY z.codigo, c.codigo, s.codigo ORDER BY z.codigo, c.codigo, s.codigo) AS orden
    FROM parZona z
    INNER JOIN parCamaronera c ON c.idZona = z.idZona        
    INNER JOIN parSector s ON s.idCamaronera = c.idCamaronera    
    CROSS JOIN parGrupoWhatsapp n
    WHERE z.activo = 1 
      AND c.activo = 1 
      AND s.activo = 1  
      AND z.codigo IN ('01')
	 -- AND s.nombre NOT IN ('JAMAICA','SINGAPUR')
      -- Limit repetitions to 4 times as per your requirement
      AND n.idGrupoWhatsapp <= 4
) ,
CTE_Zona AS (
    SELECT 
        z.codigo AS codigoZona, 
        z.nombre AS nombreZona,        
        NULL AS codigoCamaronera, 
        NULL AS nombreCamaronera,        
        NULL AS codigoSector,    
        NULL AS nombreSector, 
        n.idGrupoWhatsapp,
        n.tipoTransaccion,
        -- Partition by codigoZona to group the ROW_NUMBER properly for the ZONA level
        ROW_NUMBER() OVER (PARTITION BY z.codigo ORDER BY z.codigo) AS orden
    FROM parZona z 
    CROSS JOIN parGrupoWhatsapp n
    WHERE z.activo = 1 
      AND z.codigo IN ('01')
      -- Limit repetitions to 4 times as per your requirement
      AND n.idGrupoWhatsapp <= 4
)
-- Insert the combined results into the #PreviewCodigoGrupos temporary table
INSERT INTO #PreviewCodigoGrupos
SELECT 
    @idGrupoWhatsappDetalleActual + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS idGrupoWhatsappDetalle,
    idGrupoWhatsapp,
    tipoTransaccion,
    orden,
    'SECTOR' AS nivelGrupo,
    codigoZona,
    nombreZona,
    codigoCamaronera,
    nombreCamaronera,
    codigoSector,
    nombreSector,
    NULL AS jefeGrupo,	
    '' AS codigoGrupo, 
    '' AS enlaceGrupo,
    1 AS activo,
    'adminPsCam' AS usuarioCreacion,
    ':::' AS estacionCreacion,	
    GETDATE() AS fechaHoraCreacion,
    'adminPsCam' AS usuarioModificacion,
    ':::' AS estacionModificacion,
    GETDATE() AS fechaHoraModificacion 
FROM CTE_Sector

UNION ALL

-- Dynamically increment the second part based on the previous maximum + count of CTE_Sector records
SELECT 
    @idGrupoWhatsappDetalleActual + (SELECT COUNT(*) FROM CTE_Sector) + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS idGrupoWhatsappDetalle,
    idGrupoWhatsapp,
    tipoTransaccion,
    orden,
    'ZONA' AS nivelGrupo,
    codigoZona,
    nombreZona,
    codigoCamaronera,
    nombreCamaronera,
    codigoSector,
    nombreSector,
    NULL AS jefeGrupo,	
    '' AS codigoGrupo, 
    '' AS enlaceGrupo,
    1 AS activo,
    'adminPsCam' AS usuarioCreacion,
    ':::' AS estacionCreacion,	
    GETDATE() AS fechaHoraCreacion,
    'adminPsCam' AS usuarioModificacion,
    ':::' AS estacionModificacion,
    GETDATE() AS fechaHoraModificacion 
FROM CTE_Zona;

select * from #PreviewCodigoGrupos
-- Optional: Verify the contents of the temporary table -- revisar los ordenes
SELECT   
         @idGrupoWhatsappDetalleActual + ROW_NUMBER() OVER (ORDER BY pv.codigoZona, pv.nombreSector, pv.idGrupoWhatsapp) AS idGrupoWhatsappDetalle 
		,pv.idGrupoWhatsapp 
		,pv.tipoTransaccion 
		,ROW_NUMBER() OVER (PARTITION BY pv.codigoZona, pv.codigoCamaronera, pv.codigoSector, p.estacionModificacion ORDER BY  p.estacionModificacion , pv.nombreSector, pv.idGrupoWhatsapp) AS orden   
		,pv.nivelGrupo
		,pv.codigoZona 
		,pv.nombreZona 
		,pv.codigoCamaronera
		,pv.nombreCamaronera
		,pv.codigoSector
		,pv.nombreSector
		,pv.jefeGrupo 
		,REPLACE(p.codigoGrupo, '@GRUPAL', '') AS codigoGrupo
		,REPLACE(p.codigoGrupo, '@GRUPAL', '')  as enlaceGrupo
		,p.activo 
		,pv.usuarioCreacion
		,pv.estacionCreacion 
		,pv.fechaHoraCreacion 
		,pv.usuarioModificacion 
		,p.estacionModificacion 
		,pv.fechaHoraModificacion  
	   into #PreviewCodigoGrupos2
	FROM #PreviewCodigoGrupos pv 
		INNER JOIN  PlantillaGrupoCodigo p on  pv.nombreSector = p.nombreSector and pv.tipoTransaccion = p.tipoTransaccion AND pv.nivelGrupo= P.nivelGrupo
	WHERE pv.nivelGrupo='SECTOR'   and p.procesado = 0
	ORDER BY  p.estacionModificacion ,PV.nombreSector

	DECLARE @idGrupoWhatsappDetalleActual2 INT
	SELECT @idGrupoWhatsappDetalleActual2 = MAX(idGrupoWhatsappDetalle) FROM #PreviewCodigoGrupos2

	SELECT   
         @idGrupoWhatsappDetalleActual2 + ROW_NUMBER() OVER (ORDER BY pv.nombreZona, pv.idGrupoWhatsapp) AS idGrupoWhatsappDetalle 
		,pv.idGrupoWhatsapp 
		,pv.tipoTransaccion 
		,ROW_NUMBER() OVER (PARTITION BY pv.codigoZona, pv.codigoCamaronera, pv.codigoSector, p.estacionModificacion ORDER BY  p.estacionModificacion , pv.nombreSector, pv.idGrupoWhatsapp) AS orden   
		,pv.nivelGrupo
		,pv.codigoZona 
		,pv.nombreZona 
		,pv.codigoCamaronera
		,pv.nombreCamaronera
		,pv.codigoSector
		,pv.nombreSector
		,pv.jefeGrupo 
		,REPLACE(p.codigoGrupo, '@GRUPAL', '') AS codigoGrupo
		,REPLACE(p.codigoGrupo, '@GRUPAL', '')  as enlaceGrupo
		,p.activo 
		,pv.usuarioCreacion
		,pv.estacionCreacion 
		,pv.fechaHoraCreacion 
		,pv.usuarioModificacion 
		,p.estacionModificacion 
		,pv.fechaHoraModificacion 
      into #PreviewCodigoGrupos3
	FROM #PreviewCodigoGrupos pv 
		INNER JOIN  PlantillaGrupoCodigo p on  pv.nombreZona = p.nombreZona and pv.tipoTransaccion = p.tipoTransaccion AND pv.nivelGrupo= p.nivelGrupo
	WHERE pv.nivelGrupo='ZONA'   and p.procesado = 0
	ORDER BY  p.estacionModificacion ,PV.nombreSector

--select * from #PreviewCodigoGrupos2
 

 begin tran
 insert into parGrupoWhatsappDetalle (
			 idGrupoWhatsappDetalle
			,idGrupoWhatsapp
			,orden
			,nivelGrupo
			,zona
			,camaronera
			,sector
			,jefeGrupo
			,codigoGrupo
			,enlaceGrupo
			,activo
			,usuarioCreacion
			,estacionCreacion
			,fechaHoraCreacion
			,usuarioModificacion
			,estacionModificacion
			,fechaHoraModificacion)
 select 
    idGrupoWhatsappDetalle ,
    idGrupoWhatsapp ,
    --tipoTransaccion ,--comentar
    orden ,
    nivelGrupo,
    codigoZona ,
    --nombreZona ,--comentar
    codigoCamaronera,
    --nombreCamaronera,--comentar
    codigoSector,
    ---nombreSector,--comentar
    jefeGrupo ,
    codigoGrupo,
    enlaceGrupo,
    activo ,
    usuarioCreacion,
    estacionCreacion ,
    fechaHoraCreacion ,
    usuarioModificacion ,
    estacionModificacion ,
    fechaHoraModificacion 
 from 
 (select * from #PreviewCodigoGrupos2 union select * from #PreviewCodigoGrupos3) p
 order by idGrupoWhatsappDetalle

   update p set p.procesado = 1 
 	FROM #PreviewCodigoGrupos pv 
		INNER JOIN  PlantillaGrupoCodigo p on  pv.nombreSector = p.nombreSector and pv.tipoTransaccion = p.tipoTransaccion AND pv.nivelGrupo= P.nivelGrupo
	WHERE pv.nivelGrupo='SECTOR'   and p.procesado = 0 
  
     update p set p.procesado = 1 
  	FROM #PreviewCodigoGrupos pv 
		INNER JOIN  PlantillaGrupoCodigo p on  pv.nombreZona = p.nombreZona and pv.tipoTransaccion = p.tipoTransaccion AND pv.nivelGrupo= p.nivelGrupo
	WHERE pv.nivelGrupo='ZONA'   and p.procesado = 0 

   select 'final',* from parGrupoWhatsappDetalle where idGrupoWhatsappDetalle > @idGrupoWhatsappDetalleActual
 
   --select * from PlantillaGrupoCodigo
  rollback tran

    
 --select * from PlantillaGrupoCodigo where procesado is null 
 

   
  
 
 

 