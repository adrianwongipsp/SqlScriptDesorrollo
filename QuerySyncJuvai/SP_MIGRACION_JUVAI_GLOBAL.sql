CREATE PROCEDURE [dbo].[SP_MIGRACION_JUVAI_GLOBAL]    
  @aplicaRollback BIT,
  @fechaParametro DATE   
AS    
BEGIN    
    BEGIN TRY    
        BEGIN TRANSACTION 
	IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AuditoriaMigracionJuvai' AND xtype='U')
	CREATE TABLE AuditoriaMigracionJuvai (
		IdJuvai INT NULL,
		IdInsigne INT NULL,
		TipoTransaccion VARCHAR(60),
		Fecha DATE,
	);
  		
  EXEC  SP_MIGRACION_MUESTREOS_JUVAI     @fechaParametro; 
  EXEC  SP_MIGRACION_RECEPCION_JUVAI     @fechaParametro; 
  EXEC  SP_MIGRACION_TRANSFERENCIA_JUVAI @fechaParametro; 
     
  if (@aplicaRollback = 0)    
   COMMIT TRANSACTION    
  else     
   ROLLBACK TRANSACTION    
    
        -- Registrar éxito en log    
  INSERT INTO parMigracionLog (estado, mensaje, fechaRegistro)     
  VALUES (    
   CASE WHEN @aplicaRollback = 0 THEN 'COMPLETA' ELSE 'SIMULACION' END,    
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
        VALUES ('ERROR', 'Error en migración juvai', ERROR_MESSAGE(), GETDATE())    
            
        -- Propagar el error     
   DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();    
   DECLARE @ErrorSeverity INT = ERROR_SEVERITY();    
   DECLARE @ErrorState INT = ERROR_STATE();    
        
   RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);    
    END CATCH    
END   
