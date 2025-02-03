USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_genObtenerModulosUsuario]    Script Date: 28/5/2024 10:26:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_genObtenerModulosUsuario](
@IdUsuario int
)
as
begin
	select distinct
		mod.IdModulo,
		mod.Nombre,
		mod.Logo,
		1 as Orden,
		mod.Activo,
		--isnull(modme.Controlador, '') as ControladorIni,
		'' as ControladorIni,
		--isnull(modme.Vista, '') as VistaIni
		'' as VistaIni
		from genPermisos p
		inner join ModuloMenu modme on p.IdModulo = modme.IdModulo
		inner join genModulo mod on modme.IdModulo = mod.IdModulo
		inner join genMenu me on modme.IdMenu = me.IdMenu
		inner join genSubMenu sme on modme.IdSubMenu = sme.IdSubMenu
	where p.IdProveedor =  @IdUsuario
	--and p.Activo = 1
end