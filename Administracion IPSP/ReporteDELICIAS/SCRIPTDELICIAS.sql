USE [IPSPAdministracion]
GO

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
           ,[UsuarioModificacion]
           ,[IdModulo])
     VALUES
           ('CORREOS_DELICIAS_REPORTE', 
            'Lista de correo para envio de reporte DELICIAS', 
            NULL, 
            'erick.valverde@ipsp-produccion.com;lenin.barrera@ipsp-produccion.com;jordan.avellan@ipsp-produccion.com;',
            null,
            null,
            0,
            GETDATE(),
            'erick.valverde',
            GETDATE(),
            'erick.valverde',
            17)
GO



