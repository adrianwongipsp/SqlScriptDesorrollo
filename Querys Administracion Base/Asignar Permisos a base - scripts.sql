--USE IPSPCamaroneraProduccion;
GO

-- Verificar si el usuario existe en esa base de datos
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usrdbcamaronera')
BEGIN
    CREATE USER [usrdbcamaronera] FOR LOGIN [usrdbcamaronera] WITH DEFAULT_SCHEMA=[dbo];
END
GO

-- Asignar permisos al usuario
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [usrdbcamaronera];
GO


USE master;
GO
ALTER DATABASE [IPSPCamaroneraProduccion] SET MULTI_USER;
GO
ALTER AUTHORIZATION ON DATABASE::[IPSPCamaroneraProduccion] TO [usrdbcamaronera];