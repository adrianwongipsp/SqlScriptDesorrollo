USE [IPSPCamaroneraZonificacion]
GO
/* ??????????????????????????????????????????????????????????????
   SP definitivo – agosto 2025
   ?????????????????????????????????????????????????????????????? */
ALTER PROCEDURE dbo.SP_MIGRACION_PISCINA_PARAMETROS_CONTROL_2
AS
BEGIN
--begin tran
    SET NOCOUNT ON;

    DECLARE @Modifica VARCHAR(75) = 'MIGRACION_PISCINA_20250801'; 

    /* ????????????????????????????????????????????????????????????
       1??  Tablas temporales base
       ???????????????????????????????????????????????????????????? */
    IF OBJECT_ID('tempdb..#idsControlDetalle') IS NOT NULL DROP TABLE #idsControlDetalle;
    IF OBJECT_ID('tempdb..#TotalPiscinas')    IS NOT NULL DROP TABLE #TotalPiscinas;
    IF OBJECT_ID('tempdb..#Comparacion')      IS NOT NULL DROP TABLE #Comparacion;
    IF OBJECT_ID('tempdb..#Lotes')            IS NOT NULL DROP TABLE #Lotes;
	/*Unificar*/
    UPDATE p
    SET    p.zona   = c.CODIGOZONA_NEW,
           p.camaronera = c.CODIGOCAMARONERA_NEW,
           p.sector     = c.CODIGOSECTOR_NEW,
           p.estacionModificacion = @Modifica + '_UNI'
    FROM   dbo.proControlParametro p
    JOIN   tempMigracionPiscina c ON
            p.zona               = c.CODIGOZONA_OLD
          AND p.camaronera         = c.CODIGOCAMARONERA_OLD
          AND p.sector             = c.CODIGOSECTOR_OLD
    WHERE  c.unificacion = 1;

    /* Detalles que deben migrar */
    SELECT DISTINCT
           de.idControlParametro,
           de.idControlParametroDetalle,
           de.idPiscina,
           ca.zona,
           ca.camaronera,
           ca.sector,
           mp.CODIGOZONA_NEW,
           mp.CODIGOCAMARONERA_NEW,
           mp.CODIGOSECTOR_NEW
    INTO   #idsControlDetalle
    FROM   dbo.proControlParametroDetalle de
    JOIN   dbo.tempMigracionPiscina       mp ON de.idPiscina = mp.IDPISCINA
    JOIN   dbo.proControlParametro        ca ON de.idControlParametro = ca.idControlParametro
    WHERE  isnull(unificacion,0) = 0 and de.idPiscina > 0;
    /* Piscinas totales por cabecera (solo las involucradas) */
    SELECT d.idControlParametro,
           COUNT(DISTINCT d.idPiscina) AS TotalPiscinas
    INTO   #TotalPiscinas
    FROM   dbo.proControlParametroDetalle d
    WHERE  EXISTS (SELECT 1
                   FROM   #idsControlDetalle icd
                   WHERE  icd.idControlParametro = d.idControlParametro)
		AND   d.idPiscina > 0
    GROUP  BY d.idControlParametro;

    /* Cuadro comparativo */
    SELECT d.idControlParametro,
           d.zona,
           d.camaronera,
           d.sector,
           d.CODIGOZONA_NEW,
           d.CODIGOCAMARONERA_NEW,
           d.CODIGOSECTOR_NEW,
           COUNT(DISTINCT d.idPiscina)          AS CountMigrar,
           MAX(t.TotalPiscinas)                 AS TotalPiscinas
    INTO   #Comparacion
    FROM   #idsControlDetalle d
    JOIN   #TotalPiscinas     t
           ON t.idControlParametro = d.idControlParametro
    GROUP  BY d.idControlParametro, d.zona, d.camaronera, d.sector,
             d.CODIGOZONA_NEW, d.CODIGOCAMARONERA_NEW, d.CODIGOSECTOR_NEW;

    /* ????????????????????????????????????????????????????????????
       2??  Actualizar cabeceras (migración completa)
       ???????????????????????????????????????????????????????????? */
    UPDATE p
    SET    p.zona   = c.CODIGOZONA_NEW,
           p.camaronera = c.CODIGOCAMARONERA_NEW,
           p.sector     = c.CODIGOSECTOR_NEW,
           p.estacionModificacion = @Modifica + '_MOD'
    FROM   dbo.proControlParametro p
    JOIN   #Comparacion c
           ON p.idControlParametro = c.idControlParametro
          AND p.zona               = c.zona
          AND p.camaronera         = c.camaronera
          AND p.sector             = c.sector
    WHERE  c.CountMigrar = c.TotalPiscinas;

    /* ????????????????????????????????????????????????????????????
       3??  Lotes que SÍ generan nueva cabecera
       ???????????????????????????????????????????????????????????? */

	   --    SELECT '#Lotes' as Tabla,
    --       icd.idControlParametro,
    --       icd.CODIGOZONA_NEW,
    --       icd.CODIGOCAMARONERA_NEW,
    --       icd.CODIGOSECTOR_NEW,
    --       COUNT(*) AS IdsNecesarios 
    --FROM   #idsControlDetalle icd
    --JOIN   #Comparacion c
    --       ON c.idControlParametro = icd.idControlParametro
    --      AND c.CountMigrar       <> c.TotalPiscinas
    --GROUP  BY icd.idControlParametro,
    --         icd.CODIGOZONA_NEW,
    --         icd.CODIGOCAMARONERA_NEW,
    --         icd.CODIGOSECTOR_NEW; 
    SELECT
           icd.idControlParametro,
           icd.CODIGOZONA_NEW,
           icd.CODIGOCAMARONERA_NEW,
           icd.CODIGOSECTOR_NEW,
           COUNT(*) AS IdsNecesarios
    INTO   #Lotes
    FROM   #idsControlDetalle icd
    JOIN   #Comparacion c
           ON c.idControlParametro = icd.idControlParametro
          AND c.CountMigrar       <> c.TotalPiscinas
    GROUP  BY icd.idControlParametro,
             icd.CODIGOZONA_NEW,
             icd.CODIGOCAMARONERA_NEW,
             icd.CODIGOSECTOR_NEW;

    ALTER TABLE #Lotes
        ADD InicioSecuencia BIGINT,
            FinSecuencia    BIGINT;

    /* ????????????????????????????????????????????????????????????
       4??  Reservar bloques en proSecuencial
       ???????????????????????????????????????????????????????????? */
    DECLARE @UltCab BIGINT,
            @UltDet BIGINT,
            @TotCab BIGINT,
            @TotDet BIGINT;

    SELECT @UltCab = ultimaSecuencia
    FROM   dbo.proSecuencial
    WHERE  tabla = 'ControlParametro';

    SELECT @UltDet = ultimaSecuencia
    FROM   dbo.proSecuencial
    WHERE  tabla = 'ControlParametroDetalle';

    SELECT @TotCab = COUNT(*)             FROM #Lotes;
    SELECT @TotDet = SUM(IdsNecesarios)   FROM #Lotes;

	if(@TotDet <=0 or @TotCab <=0)
	begin
		return;
	end 
    UPDATE dbo.proSecuencial
    SET    ultimaSecuencia = ultimaSecuencia + @TotCab
    WHERE  tabla = 'ControlParametro';

    UPDATE dbo.proSecuencial
    SET    ultimaSecuencia = ultimaSecuencia + @TotDet
    WHERE  tabla = 'ControlParametroDetalle';

    /* Rangos sin solaparse */
    ;WITH R AS (
        SELECT l.*,
               SUM(IdsNecesarios) OVER (ORDER BY l.idControlParametro
                                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS OffsetPrev
        FROM   #Lotes l
    )
    UPDATE l
    SET    InicioSecuencia = @UltDet + ISNULL(R.OffsetPrev,0) + 1,
           FinSecuencia    = @UltDet + ISNULL(R.OffsetPrev,0) + l.IdsNecesarios
    FROM   #Lotes l
    JOIN   R ON R.idControlParametro       = l.idControlParametro
            AND R.CODIGOZONA_NEW           = l.CODIGOZONA_NEW
            AND R.CODIGOCAMARONERA_NEW     = l.CODIGOCAMARONERA_NEW
            AND R.CODIGOSECTOR_NEW         = l.CODIGOSECTOR_NEW;

    /* ????????????????????????????????????????????????????????????
       5??  Insertar nuevas cabeceras
       ???????????????????????????????????????????????????????????? */
    ;WITH Cab AS (
        SELECT l.*,
               @UltCab + ROW_NUMBER() OVER (ORDER BY l.idControlParametro) AS NuevoID
        FROM   #Lotes l
    )
    INSERT INTO dbo.proControlParametro (
           idControlParametro, empresa, division, zona, secuencia,
           fechaRegistro, fechaControl, horaControl,
           camaronera, sector, longitud, latitud,
           idResponsable, usuarioResponsable, tiposParametro,
           descripcion, estado, usuarioCreacion, estacionCreacion,
           fechaHoraCreacion, usuarioModificacion, estacionModificacion,
           fechaHoraModificacion, responsable, codigoRolPiscina
    )
    SELECT c.NuevoID,
           p.empresa, p.division,
           c.CODIGOZONA_NEW, c.NuevoID,
           p.fechaRegistro, p.fechaControl, p.horaControl,
           c.CODIGOCAMARONERA_NEW, c.CODIGOSECTOR_NEW,
           p.longitud, p.latitud,
           p.idResponsable, p.usuarioResponsable, p.tiposParametro,
           p.descripcion, p.estado,
           p.usuarioCreacion, p.estacionCreacion, p.fechaHoraCreacion,
           p.usuarioModificacion, @Modifica + '_CRE',
           p.fechaHoraModificacion, p.responsable, p.codigoRolPiscina
    FROM   Cab c
    JOIN   dbo.proControlParametro p
           ON p.idControlParametro = c.idControlParametro;

    /* ????????????????????????????????????????????????????????????
       6??  Insertar detalles (ROW_NUMBER particionado por lote completo)
       ???????????????????????????????????????????????????????????? */
    INSERT INTO dbo.proControlParametroDetalle (
           idControlParametroDetalle , idControlParametro ,
           orden , idParametroControl , idPiscina ,
           horaRegistro , valor , idPiscinaEjecucion ,
           observacion , activo , usuarioCreacion ,
           estacionCreacion , fechaHoraCreacion ,
           usuarioModificacion , estacionModificacion ,
           fechaHoraModificacion , IdPiscinaPuntosToma )
    SELECT
        l.InicioSecuencia
          + ROW_NUMBER() OVER (
                PARTITION BY l.idControlParametro,
                             l.CODIGOZONA_NEW,
                             l.CODIGOCAMARONERA_NEW,
                             l.CODIGOSECTOR_NEW             -- ? partición por lote completo
                ORDER BY      d.idControlParametroDetalle
            ) - 1                                               AS idControlParametroDetalle ,
        c.NuevoID                                               ,
        d.orden, d.idParametroControl, d.idPiscina              ,
        d.horaRegistro, d.valor, d.idPiscinaEjecucion           ,
        d.observacion, d.activo, d.usuarioCreacion              ,
        d.estacionCreacion, d.fechaHoraCreacion                 ,
        d.usuarioModificacion, @Modifica + '_CRE'               ,
        d.fechaHoraModificacion, d.IdPiscinaPuntosToma
    FROM   #idsControlDetalle icd
    JOIN   #Lotes              l  ON l.idControlParametro         = icd.idControlParametro
                                 AND l.CODIGOZONA_NEW             = icd.CODIGOZONA_NEW
                                 AND l.CODIGOCAMARONERA_NEW       = icd.CODIGOCAMARONERA_NEW
                                 AND l.CODIGOSECTOR_NEW           = icd.CODIGOSECTOR_NEW
    JOIN   dbo.proControlParametroDetalle d
           ON d.idControlParametroDetalle = icd.idControlParametroDetalle
    JOIN  ( /* cabeceras nuevas */
        SELECT l.idControlParametro, l.CODIGOZONA_NEW,
               l.CODIGOCAMARONERA_NEW, l.CODIGOSECTOR_NEW,
               @UltCab + ROW_NUMBER() OVER (ORDER BY l.idControlParametro) AS NuevoID
        FROM   #Lotes l
    ) c  ON c.idControlParametro       = icd.idControlParametro
        AND c.CODIGOZONA_NEW           = icd.CODIGOZONA_NEW
        AND c.CODIGOCAMARONERA_NEW     = icd.CODIGOCAMARONERA_NEW
        AND c.CODIGOSECTOR_NEW         = icd.CODIGOSECTOR_NEW
		AND d.idPiscina > 0;

    /* Desactivar detalles antiguos */
    UPDATE d
    SET    d.activo = 0,
           d.estacionModificacion = @Modifica + '_ANU'
    FROM   dbo.proControlParametroDetalle d
    JOIN   #idsControlDetalle icd
           ON icd.idControlParametroDetalle = d.idControlParametroDetalle
    WHERE  icd.idControlParametro IN (
               SELECT idControlParametro
               FROM   #Comparacion
               WHERE  CountMigrar <> TotalPiscinas
           )
		   AND d.idPiscina > 0;

    /* ????????????????????????????????????????????????????????????
       7??  Anular cabeceras sin detalles activos
       ???????????????????????????????????????????????????????????? */
	UPDATE p
	SET    p.estado = 'ANU',
		   p.estacionModificacion = @Modifica + '_ANUCAB'
	FROM   dbo.proControlParametro p
	JOIN  (
			SELECT d.idControlParametro
			FROM   dbo.proControlParametroDetalle d
			JOIN   dbo.tempMigracionPiscina mp
				   ON d.idPiscina = mp.IDPISCINA
			GROUP  BY d.idControlParametro
			HAVING COUNT(*) = SUM(CASE WHEN d.activo = 0 THEN 1 ELSE 0 END)
		  ) x
		  ON x.idControlParametro = p.idControlParametro;


    SET NOCOUNT OFF;
	--ROLLBACK TRAN
END
GO
