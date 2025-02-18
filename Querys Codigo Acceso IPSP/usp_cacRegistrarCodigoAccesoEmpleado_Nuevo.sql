USE [IPSPAdministracion]
GO
/****** Object:  StoredProcedure [dbo].[usp_cacRegistrarCodigoAccesoEmpleado]    Script Date: 30/8/2024 11:43:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[usp_cacRegistrarCodigoAccesoEmpleado](
@FechaVisitaDesde date,
@FechaVisitaHasta date,
@CodigoAcceso varchar(max),
@Cantidad int,
@Usuario nvarchar(100),
@Resultado int output
)as
begin
	begin try
		BEGIN TRANSACTION

		DECLARE @FechaInicial DATE;
        DECLARE @FechaFinal DATE;
		DECLARE @IdTemporal int;
		
		create TABLE #TablaTemporal (IdCodigo int)

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

		insert into CacCodigoAcceso (Fecha, Idzona, IdGarita, IdDepartamento, IdUsuario, Compania, Categoria, Actividad,MotivoAlcance,TransporteIpsp,Estado,Empleado, Activo, FechaRegistro, UsuarioRegistro,Placa,Chofer,EsPartida)
		select @FechaInicial,
		cod.IdZona,
		cod.IdGarita,
		cod.IdDepartamento,
		cod.IdUsuario,
		'INDUSTRIAL PESQUERA SANTA PRISCILA',
		'M',
		cod.Actividad,
		cod.Observacion,
		cod.TransporteIpsp,
		'PLA',
		1,
		1,
		GETDATE(),
		@Usuario,
		cod.PlacaVisitante,
		cod.Chofer,
		cod.EsPartida
		FROM OPENJSON(@CodigoAcceso) WITH
		(
			IdZona int '$.IdZona',
			IdGarita int '$.IdGarita',
			IdDepartamento int '$.IdDepartamento',
			IdUsuario int '$.IdUsuario',
			Actividad nvarchar(max) '$.Actividad',
			Observacion nvarchar(max) '$.Observacion',
			TransporteIpsp bit '$.TransporteIpsp',
			PlacaVisitante varchar(10) '$.PlacaVisitante',
			Chofer varchar(50) '$.Chofer',
			EsPartida varchar(3) '$.EsPartida'
		) AS cod

		set @IdCodigo = Scope_identity();

		insert into #TablaTemporal(IdCodigo) values(@IdCodigo);
		 
		--------------------------------------------------
		Declare @CodigoDiario varchar(10);

		Declare @CodigoDiarioDepartamento varchar(5);
		Declare @SecuenciaCodigo int;

		select @CodigoDiarioDepartamento = d.CodigoDiario
		from CacCodigoAcceso c with(nolock)
			inner join
			genDepartamento d with(nolock)
		on d.IdDepartamento = c.IdDepartamento
		where c.IdCodigo = @IdCodigo;

		select @SecuenciaCodigo = isnull(max(cast(SUBSTRING(c.Codigo, CHARINDEX('.', c.Codigo) + 1, 6) as int)), 0) + 1
		from CacCodigoAcceso c with(nolock)
		where c.IdDepartamento = (select IdDepartamento from CacCodigoAcceso where IdCodigo = @IdCodigo)

		set @CodigoDiario = @CodigoDiarioDepartamento + '.' + RIGHT('000000' + convert(varchar(max), @SecuenciaCodigo), 6);

		declare @Semana int

		 exec usp_genNumeroSemana @FechaInicial,@Semana output

		update CacCodigoAcceso
		set Codigo = @CodigoDiario,
		    Semana= @Semana
		where IdCodigo = @IdCodigo;
		--------------------------------------------------

		insert into CacVisitante (IdCodigo, Cedula, Apellidos, Nombres, Activo, FechaRegistro, UsuarioRegistro,Estado)
		select @IdCodigo,
			vis.Cedula,
			vis.Apellidos,
			vis.Nombres,
			1,
			GETDATE(),
			@Usuario,
			'PLA'
		FROM OPENJSON(@CodigoAcceso,'$.listaDet')WITH
		(
			Cedula varchar(15) '$.Cedula',
			Apellidos varchar(50) '$.Apellidos',
			Nombres varchar(50) '$.Nombres'
		
		)AS vis;
			set @CantidadInicial = @CantidadInicial + 1;
			END
		SET @FechaInicial = DATEADD(DD,1,@FechaInicial)

	end

	select @IdTemporal =min(IdCodigo) from #TablaTemporal

	 update e set e.IdCodigoPadre = @IdTemporal
	 from CacCodigoAcceso e,
	      #TablaTemporal t
	where e.IdCodigo=t.IdCodigo

	update c 
	set c.Placa=(select cc.Placa from cacCodigoAcceso cc where cc.IdCodigo=c.IdCodigo)
	from  CacVisitante c
	where c.IdCodigo = @IdTemporal
	--where c.IdVisitante = (select min(ct.IdVisitante) from 
	--						CacVisitante ct with(nolock),
	--						#TablaTemporal t
	--						where ct.IdCodigo=t.IdCodigo) 


	drop table #TablaTemporal
	
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
