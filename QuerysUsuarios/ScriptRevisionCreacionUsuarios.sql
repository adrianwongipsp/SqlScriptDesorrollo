
--------------------**************Script de revision de creación de usuarios*************--------------------
--------------------variables de filtro----------------------------------------------------------------------
declare @codigoZona varchar(2)
declare @codigoCamaronera varchar(6)
declare @codigoSector varchar(6)

set @codigoZona = null--'11'
set @codigoCamaronera = null--'00002'
set @codigoSector  = null

----------------------------------------consulta de usuarios por zona-camaronera-sector ----------------------------------
SELECT DISTINCT
			    usuario as UsuarioDelSistema,		
				u.description as nombresUsuario, 
                --pu.codigoZona,  
				pu.nombrezona as NombreZona, 
				--pu.codigoCamaronera, 
				pu.nombreCamaronera as NombreCamaronera, 
				--pu.codigoSector, 
				pu.nombreSector as NombreSector,
				--r.description as roleDescription,
				STRING_AGG(r.description, ', ')  WITHIN GROUP (ORDER BY r.description) AS RolesUsuario,
				FORMAT(u.createDateTime, 'dd/MM/yyyy') as FechaCreacion,
				case u.isActiveDirectory 
				WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END as UsaDirectorioActivo,
				case u.active 
				WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS ActivoSistema
FROM        parSectorUsuario psu 
 inner join SectoresUbicacion pu                          on pu.idSector = psu.idSector
 inner join IPSPLightweightCore_Produccion.dbo.secUser u				 on u.userLogin = psu.usuario 
 inner join secUserRoleAssignment ur					 on u.userId = ur.userId and ur.active = 1
 inner join secRole r									 on r.roleId = ur.roleId 
 where  r.roleId		    NOT IN (2,3,4)   --perfil base(usuario basico),
		and codigoZona       = ISNULL(@codigoZona, codigoZona)
		and codigoCamaronera = ISNULL(@codigoCamaronera, codigoCamaronera)
		and codigoSector     =  ISNULL(@codigoSector, codigoSector)
		--and u.active         = 1
		and usuario NOT IN ('rossana.gordillo','allison.reyes',
		'admin','adminPsCam','camSysProcesador', 'adrian.wong', 'UsuarioAdminstrador')  -- excluir usuarios de capacitación y administradores
		group by 
		usuario, u.[description], pu.codigoZona, pu.nombrezona, pu.codigoCamaronera, 
				pu.nombreCamaronera, pu.codigoSector, pu.nombreSector, u.createDateTime, u.isActiveDirectory, u.active
 order by 	
    usuario,         u.[description] ,
    pu.nombrezona,	 pu.nombreCamaronera,	
	pu.nombreSector 
----------------------------------------------------------------------------------------------------------------------------


