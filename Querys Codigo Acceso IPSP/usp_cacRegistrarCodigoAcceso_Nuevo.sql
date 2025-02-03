USE [IPSPAdministracion]
GO
/****** Object:  StoredProcedure [dbo].[usp_cacRegistrarCodigoAcceso]    Script Date: 30/8/2024 16:03:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER       PROCEDURE [dbo].[usp_cacRegistrarCodigoAcceso](
@FechaVisitaDesde date,
@FechaVisitaHasta date,
@Cantidad int,
@CodigoAcceso varchar(max),
@Usuario nvarchar(100),
@Resultado int output
)as
begin
	begin try
		BEGIN TRANSACTION

		DECLARE @FechaInicial DATE;
        DECLARE @FechaFinal DATE;
		

		

		SET @FechaInicial = CONVERT(DATE,@FechaVisitaDesde); /*LA FECHA INICIAL*/
        SET @FechaFinal = CONVERT(DATE,@FechaVisitaHasta);
        set @FechaFinal = DATEADD(DD,1,@FechaFinal);

    WHILE(@FechaInicial<@FechaFinal)
	
     BEGIN
		
		DECLARE @CantidadInicial int;
		set @CantidadInicial=0;

		WHILE(@CantidadInicial<@Cantidad)

		BEGIN

		Declare @IdCodigo int;

		insert into CacCodigoAcceso (Fecha, Idzona, IdGarita, IdDepartamento, IdUsuario, PersonaRecibe, Compania, Categoria, Actividad, HoraIngreso, HoraSalida, Observacion, Activo, FechaRegistro, UsuarioRegistro,IdProveedor,MotivoAlcance)
		select @FechaInicial,
		cod.IdZona,
		cod.IdGarita,
		cod.IdDepartamento,
		cod.IdUsuario,
		cod.PersonaRecibe,
		cod.Compania,
		cod.Categoria,
		cod.Actividad,
		cod.HoraIngreso,
		cod.HoraSalida,
		'',
		1,
		GETDATE(),
		@Usuario,
		IIF(cod.IdProveedor=0,null,cod.IdProveedor),
		cod.Observacion
		FROM OPENJSON(@CodigoAcceso) WITH
		(
			IdZona int '$.IdZona',
			IdGarita int '$.IdGarita',
			IdDepartamento int '$.IdDepartamento',
			IdUsuario int '$.IdUsuario',
			PersonaRecibe varchar(100) '$.PersonaRecibe',
			Compania varchar(500) '$.Compania',
			Categoria varchar(2) '$.Categoria',
			Actividad nvarchar(max) '$.Actividad',
			HoraIngreso varchar(10) '$.HoraIngreso',
			HoraSalida varchar(10) '$.HoraSalida',
			Observacion nvarchar(max) '$.Observacion',
			IdProveedor int '$.IdProveedor'
		) AS cod
		set @IdCodigo = Scope_identity();


		--------------------------------------------------
		Declare @CodigoDiario varchar(10);

		Declare @CodigoDiarioDepartamento varchar(5);
		Declare @SecuenciaCodigo int;

		select @CodigoDiarioDepartamento = d.CodigoDiario
		from cacCodigoAcceso c
			inner join
			genDepartamento d
		on d.IdDepartamento = c.IdDepartamento
		where c.IdCodigo = @IdCodigo;

		select @SecuenciaCodigo = isnull(max(cast(SUBSTRING(c.Codigo, CHARINDEX('.', c.Codigo) + 1, 6) as int)), 0) + 1
		from cacCodigoAcceso c
		where c.IdDepartamento = (select IdDepartamento from cacCodigoAcceso where IdCodigo = @IdCodigo)

		set @CodigoDiario = @CodigoDiarioDepartamento + '.' + RIGHT('000000' + convert(varchar(max), @SecuenciaCodigo), 6);

		declare @Semana int

		 exec usp_genNumeroSemana @FechaInicial,@Semana output

		update cacCodigoAcceso
		set Codigo = @CodigoDiario,
		    Semana= @Semana
		where IdCodigo = @IdCodigo;
		--------------------------------------------------


		insert into CacVisitante (IdCodigo, Placa, Cedula, Apellidos, Nombres, CorreoElectronico, HoraIngreso, HoraSalida, Activo, FechaRegistro, UsuarioRegistro,Validacion)
		select @IdCodigo,
			vis.Placa,
			vis.Cedula,
			vis.Apellidos,
			vis.Nombres,
			vis.CorreoElectronico,
			'',
			'',
			1,
			GETDATE(),
			@Usuario,
			vis.Validacion
		FROM OPENJSON(@CodigoAcceso,'$.listaDet')WITH
		(
			Placa varchar(10) '$.Placa',
			Cedula varchar(13) '$.Cedula',
			Apellidos varchar(50) '$.Apellidos',
			Nombres varchar(50) '$.Nombres',
			CorreoElectronico varchar(500) '$.CorreoElectronico',
		    Validacion varchar(200) '$.Validacion'
		)AS vis;
		set @CantidadInicial = @CantidadInicial + 1;
		end
		SET @FechaInicial = DATEADD(DD,1,@FechaInicial)

	end
		SET @Resultado = 1
	    
		commit;
	end try
		begin catch
		ROLLBACK
		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
		SET @Resultado = 0
	end catch
end
