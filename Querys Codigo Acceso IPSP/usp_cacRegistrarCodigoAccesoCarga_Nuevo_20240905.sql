USE [IPSPAdministracion]
GO
/****** Object:  StoredProcedure [dbo].[usp_cacRegistrarCodigoAccesoCarga]    Script Date: 2/9/2024 12:25:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_cacRegistrarCodigoAccesoCarga](
@IdProveedor int,
@CodigoAcceso varchar(max),
@IdUsuario int,
@IdDepartamento int,
@Usuario nvarchar(100),
@Resultado int output
)as
begin
	begin try
	BEGIN TRANSACTION

	Declare @CodigoId int = 1;
    IF OBJECT_ID('tempdb..#visitantes') IS NOT NULL
	  DROP TABLE #visitantes

	IF OBJECT_ID('tempdb..#codigoAcceso') IS NOT NULL
	  DROP TABLE #codigoAcceso

	IF OBJECT_ID('tempdb..#IdCodigoAcceso') IS NOT NULL
	  DROP TABLE #IdCodigoAcceso
	
	 create table #visitantes(IdCodAcceso int,Fecha date,Ni int,Categoria varchar(10),IdGarita int,PersonaRecibe varchar(200),Actividad varchar(1000),Placa varchar(15),Cedula varchar(20),Apellidos varchar(100),Nombres varchar(100),Validacion varchar(500))
	 create table #codigoAcceso(Id int,Fecha date,Ni int,Categoria varchar(10),IdGarita int,PersonaRecibe varchar(200),Actividad varchar(1000));
	 create table #IdCodigoAcceso(Id int);


	 insert into #visitantes	 
	 SELECT 0,vis.FechaCorrecta,
	 Ni,Categoria,IdGarita,PersonaRecibe,Actividad,Placa,Cedula,Apellidos,Nombres,Validacion
		FROM OPENJSON(@CodigoAcceso) 
		WITH (
			Fecha nvarchar(10) '$.Fecha',
			Ni int '$.Ni',
			Categoria varchar(10) '$.Categoria',
			IdGarita int '$.IdGarita',
			PersonaRecibe varchar(200) '$.PersonaRecibe',
			Actividad  varchar(1000) '$.Actividad',
			Placa varchar(15) '$.Placa',
			Cedula varchar(20) '$.Cedula',
			Apellidos varchar(100) '$.Apellidos',
			Nombres varchar(100) '$.Nombres',
			Validacion varchar(500) '$.Validacion'
		)as x
		-- Convertir la fecha a formato ISO para evitar confusión en el formato
		CROSS APPLY (
			SELECT CONVERT(date, x.Fecha, 103) AS FechaCorrecta
		) AS vis;
		
	insert into #codigoAcceso
	select ROW_NUMBER() over (order by Fecha desc) as id,Fecha,Ni,Categoria,IdGarita,PersonaRecibe,Actividad 
	from #visitantes group by Fecha,Ni,Categoria,IdGarita,PersonaRecibe,Actividad
	
		
   while @CodigoId<=(select COUNT(1) from #codigoAcceso)
	begin

	
	 declare @Fecha date;
	 declare @Ni int;

	 DECLARE @CantidadInicial int;
		set @CantidadInicial=0;

	 select @Fecha=Fecha, @Ni=Ni from #codigoAcceso where id=@CodigoId

	 	WHILE(@CantidadInicial<@Ni)
		BEGIN

		Declare @IdCodigo int;

		insert into CacCodigoAcceso (Fecha, Idzona, IdGarita, IdDepartamento, IdUsuario, PersonaRecibe, Compania, Categoria, Actividad, Activo, FechaRegistro, UsuarioRegistro,IdProveedor,Tipo)
		select @Fecha,
		       (select g.IdZona from cacGarita g where g.IdGarita=c.IdGarita),
			   c.IdGarita,
			   @IdDepartamento,
			   @IdUsuario,
			   c.PersonaRecibe,
			   (select Nombre from cacProveedor where IdProveedor=@IdProveedor),
			   c.Categoria,
			   c.Actividad,
			   1,
			   GETDATE(),
			   @Usuario,
			   @IdProveedor,
			   'CARGA_EXCEL_MASIVO'
		from #codigoAcceso c where c.id=@CodigoId

		set @IdCodigo = Scope_identity();

		insert into #IdCodigoAcceso values( @IdCodigo)
		             

		--------------------------------------------------
		Declare @CodigoDiario varchar(10);

		Declare @CodigoDiarioDepartamento varchar(5);
		Declare @SecuenciaCodigo int;

		
		select @CodigoDiarioDepartamento = d.CodigoDiario
		from genDepartamento d with(nolock)
		where d.IdDepartamento = @IdDepartamento

		set @SecuenciaCodigo =  isnull((select top(1) max(cast(SUBSTRING(c.Codigo, CHARINDEX('.', c.Codigo) + 1, 6) as int))
		from cacCodigoAcceso c with(nolock)
		where c.IdDepartamento = @IdDepartamento and Codigo is not null
		group by IdCodigo
		order by IdCodigo desc), 0) + 1

		set @CodigoDiario = @CodigoDiarioDepartamento + '.' + RIGHT('000000' + convert(varchar(max), @SecuenciaCodigo), 6);

		declare @Semana int

		 exec usp_genNumeroSemana @Fecha,@Semana output

		update cacCodigoAcceso
		set Codigo = @CodigoDiario,
		    Semana= @Semana
		where IdCodigo = @IdCodigo;
		--------------------------------------------------
		insert into CacVisitante (IdCodigo, Placa, Cedula, Apellidos, Nombres, Activo, FechaRegistro, UsuarioRegistro,Validacion)
		select @IdCodigo,
		      v.Placa,
			  v.Cedula,
			  v.Apellidos,
			  v.Nombres,
			  1,
			  GETDATE(),
			  @Usuario,
			  v.Validacion
		from #visitantes v,
		#codigoAcceso c
		where v.Fecha=c.Fecha
		  and v.Ni=c.Ni
		  and v.IdGarita=c.IdGarita
		  and v.Categoria=c.Categoria
		  and v.PersonaRecibe=c.PersonaRecibe
		  and v.Actividad=c.Actividad
		  and c.Id=@CodigoId

		set @CantidadInicial = @CantidadInicial + 1;
		end 
		
	set @CodigoId = @CodigoId + 1

	end 
   
	SET @Resultado = 1

	commit;

	select format(ca.Fecha,'dd/MM/yyyy') as Fecha, ca.Codigo, z.Nombre as NombreZona, cg.Nombre as NombreGarita
	from cacCodigoAcceso ca with(nolock),
	     cacGarita cg with(nolock),
		 cacZona z with(nolock),
	    #IdCodigoAcceso i
	where ca.IdZona=cg.IdZona
	  and ca.IdGarita=cg.IdGarita
	  and cg.IdZona=z.IdZona
	  and ca.IdCodigo=i.Id
	  /**/
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
