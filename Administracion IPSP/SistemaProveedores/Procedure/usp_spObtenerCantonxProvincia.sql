USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_spObtenerCantonxProvincia]    Script Date: 30/5/2024 16:11:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_spObtenerCantonxProvincia] (@IdProvincia int) as
begin
select * from genCanton where Activo=1 and IdProvincia=@IdProvincia
end