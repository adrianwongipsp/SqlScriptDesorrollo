  
alter PROCEDURE [dbo].[SP_MIGRACION_PISCINA_GLOBAL]  
  @aplicaRollback bit  
AS  
BEGIN  
    BEGIN TRY  
        BEGIN TRANSACTION  
  declare @Modifica varchar(75) = 'MIGRACION_PISCINA_20250505';  
  
  UPDATE B SET  
    B.zona                 = MP.CODIGOZONA_NEW,  
    B.camaronera           = MP.CODIGOCAMARONERA_NEW,  
    B.sector               = MP.CODIGOSECTOR_NEW,  
    B.nombre               = MP.SECTOR_NEW + NOMBREPISCINA,  
    B.estacionModificacion = @Modifica  
   FROM   tempMigracionPiscina MP INNER JOIN maePiscina B   
    ON    B.zona                 = MP.CODIGOZONA_OLD  
    AND   B.camaronera           = MP.CODIGOCAMARONERA_OLD  
    AND   B.sector               = MP.CODIGOSECTOR_OLD  
    AND   B.idPiscina            = MP.IDPISCINA  
  
     update p set p.lote = l.codigo  
     from maePiscina p inner join tempMigracionPiscina tp on tp.IDPISCINA = p.idPiscina   
            inner join parLote l on l.idLote = tp.IDLOTE_NEW  
              
     ----Maestro: BODEGAS   
    UPDATE B SET  
    B.zona                 = MP.CODIGOZONA_NEW,  
    B.camaronera           = MP.CODIGOCAMARONERA_NEW,  
    B.sector               = MP.CODIGOSECTOR_NEW,  
    B.nombre               = MP.SECTOR_NEW + NOMBREPISCINA,  
    B.estacionModificacion = @Modifica  
   FROM   tempMigracionPiscina MP INNER JOIN INVBODEGA B   
    ON    B.zona                 = MP.CODIGOZONA_OLD  
    AND   B.camaronera           = MP.CODIGOCAMARONERA_OLD  
    AND   B.sector               = MP.CODIGOSECTOR_OLD  
    AND   B.idPiscina            = MP.IDPISCINA  
  
  
  
          
        EXEC SP_MIGRACION_PISCINA_PARAMETROS_CONTROL  
  EXEC SP_MIGRACION_PISCINA_CONTROL_MUESTREO  
  EXEC SP_MIGRACION_PISCINA_CONTROL_MUESTREO_POBLACION  
  
  --  
          
  EXEC SP_MIGRACION_PISCINA_PEDIDO_BINES  
  
  EXEC SP_MIGRACION_PISCINA_PLANIFICACION 1  
  EXEC SP_MIGRACION_PISCINA_RECEPCION 1  
  EXEC SP_MIGRACION_PISCINA_INVENTARIO  
  
  
  --select distinct   
  --  mp.CODIGOZONA_OLD, mp.CODIGOCAMARONERA_OLD, mp.CODIGOSECTOR_OLD,MP.SECTOR_OLD ,'---',MP.IDPISCINA,MP.NOMBREPISCINA,  
  -- zona, c.camaronera, c.sector, mp.CODIGOZONA_NEW, mp.CODIGOCAMARONERA_NEW, mp.CODIGOSECTOR_NEW, MP.SECTOR_NEW   
  -- from proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro  
  -- inner join tempMigracionPiscina mp on mp.IDPISCINA = d.idPiscina  
  -- where zona in('22','29')AND D.activo = 1    
  -- and zona='29'  
  -- order by  mp.CODIGOZONA_NEW  
  
  --  select distinct d.* ,'---',c.*, '----',  
  --  mp.CODIGOZONA_OLD, mp.CODIGOCAMARONERA_OLD, mp.CODIGOSECTOR_OLD,MP.SECTOR_OLD ,'---',MP.IDPISCINA,MP.NOMBREPISCINA,  
  -- zona, c.camaronera, c.sector, mp.CODIGOZONA_NEW, mp.CODIGOCAMARONERA_NEW, mp.CODIGOSECTOR_NEW, MP.SECTOR_NEW   
  -- from proControlParametro c inner join proControlParametroDetalle d on c.idControlParametro = d.idControlParametro  
  -- inner join tempMigracionPiscina mp on mp.IDPISCINA = d.idPiscina  
  -- where zona in('22','29')AND D.activo = 1    
  -- and mp.idPiscina = 297  
  -- order by  mp.CODIGOZONA_NEW  

    select distinct   
    mp.CODIGOZONA_OLD, mp.CODIGOCAMARONERA_OLD, mp.CODIGOSECTOR_OLD,MP.SECTOR_OLD ,'---',MP.IDPISCINA,MP.NOMBREPISCINA,  
   zona, c.camaronera, c.sector, mp.CODIGOZONA_NEW, mp.CODIGOCAMARONERA_NEW, mp.CODIGOSECTOR_NEW, MP.SECTOR_NEW   
   from proRecepcionEspecie c inner join proRecepcionEspecieDetalle d on c.idRecepcion = d.idRecepcion  
   inner join tempMigracionPiscina mp on mp.IDPISCINA = d.idPiscina  
   where zona in('22','29')AND D.activo = 1    
   and zona='29'  
   order by  mp.CODIGOZONA_NEW  
  
    select distinct d.* ,'---',c.*, '----',  
    mp.CODIGOZONA_OLD, mp.CODIGOCAMARONERA_OLD, mp.CODIGOSECTOR_OLD,MP.SECTOR_OLD ,'---',MP.IDPISCINA,MP.NOMBREPISCINA,  
   zona, c.camaronera, c.sector, mp.CODIGOZONA_NEW, mp.CODIGOCAMARONERA_NEW, mp.CODIGOSECTOR_NEW, MP.SECTOR_NEW   
   from proRecepcionEspecie c inner join proRecepcionEspecieDetalle d on c.idRecepcion = d.idRecepcion  
   inner join tempMigracionPiscina mp on mp.IDPISCINA = d.idPiscina  
   where zona in('22','29')AND D.activo = 1    
   and mp.idPiscina = 297  
   order by  mp.CODIGOZONA_NEW  
        -- otros módulos...  
  if (@aplicaRollback = 0)  
   COMMIT TRANSACTION  
  else   
   ROLLBACK TRANSACTION  
  
        -- Registrar éxito en log  
  INSERT INTO parMigracionLog (estado, mensaje, fechaRegistro)   
  VALUES (  
   CASE WHEN @aplicaRollback = 0 THEN 'COMPLETADO' ELSE 'SIMULACION' END,  
   CASE WHEN @aplicaRollback = 0 THEN 'Migración finalizada correctamente'   
     ELSE 'Simulación de migración finalizada (rollback aplicado)' END,  
      GETDATE()  
  )  
  
  
    END TRY  
    BEGIN CATCH  
        IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION  
              
        -- Registrar error en log  
        INSERT INTO parMigracionLog (estado, mensaje, error_info, fechaRegistro)   
        VALUES ('ERROR', 'Error en migración', ERROR_MESSAGE(), GETDATE())  
          
        -- Propagar el error   
   DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
   DECLARE @ErrorSeverity INT = ERROR_SEVERITY();  
   DECLARE @ErrorState INT = ERROR_STATE();  
      
   RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
    END CATCH  
END  