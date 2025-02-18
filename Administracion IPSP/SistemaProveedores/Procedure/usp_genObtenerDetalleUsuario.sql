USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_genObtenerDetalleUsuario]    Script Date: 30/5/2024 16:13:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDMIENTO PARA OBTENER DETALLE USUARIO
ALTER   PROCEDURE [dbo].[usp_genObtenerDetalleUsuario](
@IdUsuario int,
@IdModulo int
)
as
begin

;WITH Usuario AS (
		  SELECT 
				u.IdProveedor,
				CodigoUsuario,
				Nombre,
				CorreoElectronico,
				Contrasenia,
				udr.IdRol,
				u.Activo,
				u.FechaRegistro,
				u.UsuarioRegistro,
				u.FechaModificacion,
				u.UsuarioModificacion,
				u.NumeroIdentificacion as NumeroIdentificacion
			FROM genProDepRol udr
			inner join proProveedor u on u.IdProveedor = udr.IdProveedor
			where udr.IdProveedor = @IdUsuario
			--inner join genRol r on r.IdRol = udr.IdRol
			--inner join genDepartamento d on d.IdDepartamento = udr.IdDepartamento
),
--select * from Usuario
DetalleRol AS (
    SELECT 
        r.IdRol,
        COALESCE(r.Descripcion,'') Descripcion,
        r.Activo,
        r.FechaRegistro,
        r.UsuarioRegistro,
        r.Nemonico
		from Usuario u
		inner join genRol r on r.IdRol = u.IdRol
),
DetalleSubMenu AS (
   SELECT 
		mm.IdModulo,
        sm.IdSubMenu,
        sm.Nombre AS NombreSubMenu,
        mm.Controlador,
        mm.Vista,
        sm.Icono AS IconoSubMenu,
        0 AS VerMovil,
        NULL AS IconoMovil,
        sm.Activo,
        mm.IdMenu as IdMenuSB
    FROM genPermisos p
    inner JOIN ModuloMenu mm ON p.IdModulo = mm.IdModulo and p.IdMenu = mm.IdMenu and p.IdSubMenu = mm.IdSubMenu
	inner join genSubMenu sm on sm.IdSubMenu = mm.IdSubmenu
	where p.IdProveedor=@IdUsuario and mm.IdModulo = @IdModulo
),
DetalleMenu AS (
 --   SELECT 
 --       m.IdMenu as IdMenu,
 --       m.Nombre AS NombreMenu,
 --       m.Icono AS IconoMenu,
 --       ds.*
 --   FROM genMenu m
 --   JOIN DetalleSubMenu ds ON m.IdMenu = ds.IdMenuSB
	--where ds.IdModulo = @IdModulo

	SELECT 
        m.IdMenu as IdMenu,
        m.Nombre AS NombreMenu,
        m.Icono AS IconoMenu,
        ds.*
    FROM  genPermisos p
	inner JOIN ModuloMenu mm ON p.IdModulo = mm.IdModulo and p.IdMenu = mm.IdMenu and p.IdSubMenu = mm.IdSubMenu
	inner JOIN genMenu m on p.IdMenu = mm.IdMenu
    inner JOIN DetalleSubMenu ds ON m.IdMenu = ds.IdMenuSB
	where p.IdProveedor=@IdUsuario and ds.IdModulo = @IdModulo
)


SELECT 
    u.IdProveedor,
    u.CodigoUsuario,
    u.Nombre,
    u.CorreoElectronico,
    u.Contrasenia,
    u.IdRol,
    u.Activo,
    u.FechaRegistro,
    u.UsuarioRegistro,
    u.FechaModificacion,
    u.UsuarioModificacion,
    u.NumeroIdentificacion,
    (
        SELECT 
            dr.IdRol,
            COALESCE(dr.Descripcion,'') Descripcion,
            dr.Activo,
            dr.FechaRegistro,
            dr.UsuarioRegistro,
            dr.Nemonico
        FROM DetalleRol dr
        FOR XML PATH('DetalleRol'), TYPE
    ),
    (
        SELECT 
            dmenu.IdMenu,
            dmenu.NombreMenu,
            dmenu.IconoMenu AS Icono,
            (
                SELECT 
                    dsubmenu.IdSubMenu,
                    dsubmenu.NombreSubMenu,
                    dsubmenu.Controlador,
                    dsubmenu.Vista,
                    dsubmenu.IconoSubMenu AS Icono,
                    dsubmenu.VerMovil,
                    COALESCE(dsubmenu.IconoMovil,'') AS IconoMovil,
                    dsubmenu.Activo
                FROM DetalleSubMenu dsubmenu
                WHERE dsubmenu.IdMenuSB = dmenu.IdMenu
                FOR XML PATH('SubMenu'), TYPE
            ) AS DetalleSubMenu
        FROM DetalleMenu dmenu
        GROUP BY dmenu.IdMenu, dmenu.NombreMenu, dmenu.IconoMenu
        FOR XML PATH('Menu'), TYPE
    ) AS DetalleMenu
FROM Usuario u
FOR XML PATH('Usuario')



end


