USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_proRegistrarTransporte]    Script Date: 05/07/2024 15:17:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create or Alter procedure [dbo].[usp_proRegistrarEmpleadoProveedor](
@jsonEmpleado varchar(max),@jsonArchivo varchar(max),@Usuario varchar(50),@Resultado int output,@Error varchar(Max) output)
as
BEGIN
	BEGIN TRY
		BEGIN TRAN tri

		DECLARE @tbEmpleado table(
		IdEmpleadoProveedor	int,
		Numero	varchar(10),
		IdProveedor	int,
		IdDocumentoIdentificacion int,
		NumeroIdentificacion varchar(13),
		IdTipoSangre	int,
		Apellido	varchar(100),
		Nombre	varchar(100),
		Correo	varchar(100),
		Activo	bit
		)
		
		Declare @tbArchivos table(
		IdArchivo int,
		NombreArchivo varchar(500),
		Extension varchar(10),
		IdDocumento int,
		IdTipoDocumento int,
		RutaPrivada varchar(max)
		)

		declare @IdEmpleadoProveedor int;

		insert into @tbEmpleado(IdEmpleadoProveedor, Numero, IdProveedor, IdDocumentoIdentificacion, NumeroIdentificacion, IdTipoSangre, Apellido, Nombre, Correo, Activo)
		select * from OPENJSON(@jsonEmpleado)
		with(
				IdEmpleadoProveedor int '$.IdEmpleadoProveedor',
				Numero varchar(100) '$.Numero',
				IdProveedor varchar(100) '$.IdProveedor',
				IdDocumentoIdentificacion int '$.IdDocumentoIdentificacion',
				NumeroIdentificacion varchar(13) '$.NumeroIdentificacion',
				IdTipoSangre varchar(100) '$.IdTipoSangre',
				Apellido varchar(100) '$.Apellido',
				Nombre varchar(100) '$.Nombre',
				Correo varchar(100) '$.Correo',
				Activo bit '$.Activo'
			);
	
		--select *from @tbTansporte;
		insert into @tbArchivos(IdArchivo,NombreArchivo,Extension,IdDocumento,IdTipoDocumento,RutaPrivada)
		select * from OPENJSON(@jsonArchivo)
		with	(
				IdArchivo int '$.IdArchivo',
				NombreArchivo varchar(100) '$.NombreArchivo',
				Extension varchar(10) '$.Extension',
				IdDocumento int '$.IdDocumento',
				IdTipoDocumento int '$.IdTipoDocumento',
				RutaPrivada varchar(max) '$.RutaPrivada'
				);

		
		SELECT @IdEmpleadoProveedor = max(IdEmpleadoProveedor) +1 FROM proEmpleadoProveedor WITH (TABLOCKX)

		--Insert a proTransporte
		insert into proEmpleadoProveedor(IdEmpleadoProveedor,Numero,IdProveedor,IdDocumentoIdentificacion,NumeroIdentificacion,IdTipoSangre,Apellido,Nombre,Correo,Activo,FechaRegistro,UsuarioRegistro)
		select							 @IdEmpleadoProveedor,Numero,IdProveedor,IdDocumentoIdentificacion,NumeroIdentificacion,IdTipoSangre,Apellido,Nombre,Correo,Activo,GETDATE(),@Usuario 
		from @tbEmpleado

		declare @IdArchivo int,@Id int;

		while exists (select top 1 1 from @tbArchivos)
			begin
				select top(1) @Id = IdArchivo from @tbArchivos
				DECLARE @IdDocumento int ;
				DECLARE @IdTipoDocumento int ;

				set @Id = (SELECT TOP 1 IdArchivo from @tbArchivos);
				set @IdDocumento = (SELECT TOP 1 IdDocumento from @tbArchivos);
				set @IdTipoDocumento = (SELECT TOP 1 IdTipoDocumento from @tbArchivos);

				insert into genArchivo(NombreArchivo,Extension,RutaPrivada,Activo,FechaCreacion,UsuarioCreacion)
				select  NombreArchivo,Extension,RutaPrivada,1,GETDATE(),@Usuario from @tbArchivos where IdArchivo = @Id
				set @IdArchivo = SCOPE_IDENTITY();
		
				--select @IdArchivo IdArchivo;
				insert into proEmpleadoDocumento(IdArchivo,IdEmpleadoProveedor,IdDocumento,IdTipoDocumento,FechaEmision)
				values(@IdArchivo,@IdEmpleadoProveedor,@IdDocumento,@IdTipoDocumento,GETDATE());
		
				delete from @tbArchivos where IdArchivo = @Id;
			end

		SET @Resultado = 1;
		COMMIT
		--ROLLBACK TRAN
	END TRY
	BEGIN CATCH
			ROLLBACK TRAN tri
			SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
			SET @Resultado = 0;
			set @Error = ERROR_MESSAGE();
	 END CATCH
 END