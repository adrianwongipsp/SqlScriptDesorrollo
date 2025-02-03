--------------------**************Script de revisión de creación de usuarios*************--------------------
--------------------Variables de filtro----------------------------------------------------------------------
DECLARE @codigoZona VARCHAR(2);
DECLARE @codigoCamaronera VARCHAR(6);
DECLARE @codigoSector VARCHAR(6);

SET @codigoZona = NULL;--'11'
SET @codigoCamaronera = NULL;--'00002'
SET @codigoSector = NULL;

----------------------------------------Consulta de usuarios por zona-camaronera-sector ----------------------------------
WITH UserRoles AS (
    SELECT 
        usuario AS UsuarioDelSistema,		
        u.[description] AS nombresUsuario, 
        pu.nombrezona AS NombreZona, 
        pu.nombreCamaronera AS NombreCamaronera, 
        pu.nombreSector AS NombreSector,
        r.[description] AS roleDescription,
        FORMAT(u.createDateTime, 'dd/MM/yyyy') AS FechaCreacion,
        CASE u.isActiveDirectory 
            WHEN 0 THEN 'NO' 
            WHEN 1 THEN 'SI' 
        END AS UsaDirectorioActivo,
        CASE u.active 
            WHEN 0 THEN 'NO' 
            WHEN 1 THEN 'SI' 
        END AS ActivoSistema,
        ROW_NUMBER() OVER (PARTITION BY usuario,nombreSECTOR ORDER BY r.[description]) AS rn
    FROM 
        parSectorUsuario psu 
        INNER JOIN SectoresUbicacion pu ON pu.idSector = psu.idSector
        INNER JOIN IPSPLightweightCore_Produccion.dbo.secUser u ON u.userLogin = psu.usuario 
        INNER JOIN secUserRoleAssignment ur ON u.userId = ur.userId AND ur.active = 1
        INNER JOIN secRole r ON r.roleId = ur.roleId 
    WHERE  
        r.roleId NOT IN (2, 3, 4) --perfil base(usuario basico)
        AND codigoZona = ISNULL(@codigoZona, codigoZona)
        AND codigoCamaronera = ISNULL(@codigoCamaronera, codigoCamaronera)
        AND codigoSector = ISNULL(@codigoSector, codigoSector)
        AND usuario NOT IN ('rossana.gordillo', 'allison.reyes', 'admin', 'adminPsCam', 'camSysProcesador', 'adrian.wong', 'UsuarioAdminstrador') -- excluir usuarios de capacitación y administradores
)

--select * from UserRoles;
 
SELECT 
    UsuarioDelSistema,
    nombresUsuario,
    NombreZona,
    NombreCamaronera,
    NombreSector,
     ISNULL(MAX(CASE WHEN rn = 1 THEN roleDescription END),'') AS Rol1,
     ISNULL(MAX(CASE WHEN rn = 2 THEN roleDescription END),'') AS Rol2,
     ISNULL(MAX(CASE WHEN rn = 3 THEN roleDescription END),'') AS Rol3,
     ISNULL(MAX(CASE WHEN rn = 4 THEN roleDescription END),'') AS Rol4,
     ISNULL(MAX(CASE WHEN rn = 5 THEN roleDescription END),'') AS Rol5,
     ISNULL(MAX(CASE WHEN rn = 6 THEN roleDescription END),'') AS Rol6,
     ISNULL(MAX(CASE WHEN rn = 7 THEN roleDescription END),'') AS Rol7,
     ISNULL(MAX(CASE WHEN rn = 8 THEN roleDescription END),'')AS Rol8,
     ISNULL(MAX(CASE WHEN rn = 9 THEN roleDescription END),'')AS Rol9,
     ISNULL(MAX(CASE WHEN rn = 10 THEN roleDescription END),'') AS Rol10,
    FechaCreacion,
    UsaDirectorioActivo,
    ActivoSistema
FROM 
    UserRoles
GROUP BY 
    UsuarioDelSistema,
    nombresUsuario,
    NombreZona,
    NombreCamaronera,
    NombreSector,
    FechaCreacion,
    UsaDirectorioActivo,
    ActivoSistema
ORDER BY 
    UsuarioDelSistema,
    nombresUsuario,
    NombreZona,
    NombreCamaronera,
    NombreSector;
