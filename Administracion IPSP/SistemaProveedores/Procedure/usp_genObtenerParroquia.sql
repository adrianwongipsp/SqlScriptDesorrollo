USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_genObtenerParroquia]    Script Date: 30/5/2024 16:12:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_genObtenerParroquia](
@IdCanton int,
@Todos bit
)
as 
begin
select IdParroquia,Descripcion,Numero,IdCanton,IdProvincia,Activo from genParroquia
where IdCanton = @IdCanton

end