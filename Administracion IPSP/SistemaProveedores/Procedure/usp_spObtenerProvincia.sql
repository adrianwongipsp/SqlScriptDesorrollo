USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_spObtenerProvincia]    Script Date: 30/5/2024 16:11:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[usp_spObtenerProvincia] as   
begin  
	select * from genProvincia where Activo=1 order by IdProvincia
end