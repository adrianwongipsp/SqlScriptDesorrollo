USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_genObtenerTipoIdentificacion]    Script Date: 30/5/2024 16:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_genObtenerTipoIdentificacion]
as
begin
select IdTipoIdentificacion,Nombre,Descripcion from genTipoIdentificacion
where Activo=1
end