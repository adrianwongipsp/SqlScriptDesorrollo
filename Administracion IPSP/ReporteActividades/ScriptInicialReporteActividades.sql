SELECT * FROM genParametros
where IdParametro = 'CORREOS_ACTIVIDADES_REPORTE'
/*
INSERT INTO [dbo].[genParametros]
           ([IdParametro]
           ,[Descripcion]
           ,[ValorInt]
           ,[ValorVarchar]
           ,[ValorDecimal]
           ,[ValorDatetime]
           ,[Activo]
           ,[FechaRegistro]
           ,[UsuarioRegistro]
           ,[FechaModificacion]
           ,[UsuarioModificacion])
     VALUES
           ('CORREOS_ACTIVIDADES_REPORTE', 
            'Lista de correo para envio de reporte ACTIVIDADES', 
            NULL, 
            'erick.valverde@ipsp-produccion.com;lenin.barrera@ipsp-produccion.com;jordan.avellan@ipsp-produccion.com;',
            null,
            null,
            1,
            GETDATE(),
            'erick.valverde',
            GETDATE(),
            'erick.valverde')
GO

*/

