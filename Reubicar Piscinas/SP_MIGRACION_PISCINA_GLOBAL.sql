CREATE PROCEDURE SP_MIGRACION_PISCINA_GLOBAL
  @aplicaRollback bit
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        EXEC SP_MIGRACION_PISCINA_PARAMETROS_CONTROL
		EXEC SP_MIGRACION_PISCINA_CONTROL_MUESTREO
		EXEC SP_MIGRACION_PISCINA_CONTROL_MUESTREO_POBLACION

		EXEC SP_MIGRACION_PISCINA_INVENTARIO
        
		EXEC SP_MIGRACION_PISCINA_PEDIDO_BINES

		EXEC SP_MIGRACION_PISCINA_PLANIFICACION
		EXEC SP_MIGRACION_PISCINA_RECEPCION
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
        VALUES ('ERROR', 'Error en migración', ERROR_MESSAGE())
        
        -- Propagar el error 
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();
    
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END