USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_genObtenerUsuarioPorCodigo]    Script Date: 30/5/2024 16:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDMIENTO PARA OBTENER USUARIOS
ALTER  PROCEDURE [dbo].[usp_genObtenerUsuarioPorCodigo](@CodigoUsuario varchar(100))
as
begin
	select u.IdProveedor,
		u.CodigoUsuario,
		u.Nombre,
		u.CorreoElectronico,
		u.Contrasenia,
		r.IdRol,
		u.Activo,
		u.FechaRegistro,
		gr.Descripcion[DescripcionRol],
		u.Activo,
		gr.Nemonico,
		gr.NombreRol,
		ISNULL(u.NumeroIdentificacion,'')NumeroIdentificacion
	from proProveedor u,
		genProDepRol r,
		genRol gr
	where r.IdProveedor = u.IdProveedor
	and gr.IdRol = r.IdRol
	and u.CodigoUsuario=@CodigoUsuario
	and u.Activo=1

end


