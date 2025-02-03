
ALTER procedure usp_proRegistrarTransporte(
@jsonTransporte varchar(max),@jsonArchivo varchar(max),@Usuario varchar(50),@IdTipoDocumento int,@IdDocumento int,@Resultado int output,@Error varchar(Max) output
)
as
BEGIN
BEGIN TRY
BEGIN TRAN tri

DECLARE @tbTansporte table(
IdTransporte int,
IdSubTipoTransporte int,
IdTipoPropiedadTransporte int,
IdFormaTransporte int,
IdMarcaTransporte int,
IdModeloTransporte int,
IdProveedor int,
Identificacion varchar(20),
Placa varchar(10),
Serie varchar(10),
CapacidadMaximaPersonas int,
Horometro bit,
AplicaDescuento bit,
Activo bit
)

Declare @tbArchivos table(
IdArchivo int,
NombreArchivo varchar(500),
Extension varchar(10),
RutaPrivada varchar(max)
)

declare @IdTransporte int;
--set @IdTransporte = (select ISNULL(MAX(IdTransporte), 0) + 1 as IdTransporte from proTransporte);
--select @IdTransporte;
insert into @tbTansporte(IdTransporte,IdSubTipoTransporte,IdTipoPropiedadTransporte,IdFormaTransporte,IdMarcaTransporte
,IdModeloTransporte,IdProveedor,Identificacion,Placa,Serie,CapacidadMaximaPersonas,Horometro,AplicaDescuento,Activo)
select *from OPENJSON(@jsonTransporte)
with(
		IdTransporte int '$.IdTransporte',
		IdSubTipoTransporte int '$.IdSubTipoTransporte',
		IdTipoPropiedadTransporte int '$.IdTipoPropiedadTransporte',
		IdFormaTransporte int '$.IdFormaTransporte',
		IdMarcaTransporte int '$.IdMarcaTransporte',
		IdModeloTransporte int '$.IdModeloTransporte',
		IdProveedor int '$.IdProveedor',
		Identificacion varchar(20) '$.Identificacion',
		Placa varchar(20) '$.Placa',
		Serie varchar(20) '$.Serie',		
		CapacidadMaximaPersonas int '$.CapacidadMaximaPersonas',
		Horometro bit '$.Horometro',
		AplicaDescuento bit '$.AplicaDescuento',
		Activo bit '$.Activo'
	);
	
	--select *from @tbTansporte;
	insert into @tbArchivos(IdArchivo,NombreArchivo,Extension,RutaPrivada)
select * from OPENJSON(@jsonArchivo)
with(
		IdArchivo int '$.IdArchivo',
		NombreArchivo varchar(100) '$.NombreArchivo',
		Extension varchar(10) '$.Extension',
		RutaPrivada varchar(max) '$.RutaPrivada'
		);

		--select *from @tbArchivos;

--Insert a proTransporte
insert into proTransporte(IdSubTipoTransporte,IdTipoPropiedadTransporte,IdFormaTransporte,IdMarcaTransporte
,IdModeloTransporte,IdProveedor,Identificacion,Placa,Serie,CapacidadMaximaPersonas,Horometro,AplicaDescuento,Activo,FechaRegistro,UsuarioRegistro)
select IdSubTipoTransporte,IdTipoPropiedadTransporte,IdFormaTransporte,IdMarcaTransporte
,IdModeloTransporte,IdProveedor,Identificacion,Placa,Serie,CapacidadMaximaPersonas,Horometro,AplicaDescuento,Activo,GETDATE(),@Usuario 
from @tbTansporte
set @IdTransporte =SCOPE_IDENTITY();


declare @IdArchivo int,@Id int;
--set @IdArchivo = (select ISNULL(MAX(IdArchivo), 0) + 1 as IdArchivo from genArchivo);
--select @IdArchivo;
while exists (select *from @tbArchivos)
	begin
		select top(1) @Id = IdArchivo from @tbArchivos
		--select @Id;
		insert into genArchivo(NombreArchivo,Extension,RutaPrivada,Activo,FechaCreacion,UsuarioCreacion)
		select  NombreArchivo,Extension,RutaPrivada,1,GETDATE(),@Usuario from @tbArchivos where IdArchivo = @Id
		set @IdArchivo = SCOPE_IDENTITY();
		
		--select @IdArchivo IdArchivo;
		insert into proTransporteDocumento(IdArchivo,IdTransporte,IdDocumento,IdTipoDocumento,FechaEmision)
		values(@IdArchivo,@IdTransporte,@IdDocumento,@IdTipoDocumento,GETDATE());
		
		delete from @tbArchivos where IdArchivo = @Id;
	end

SET @Resultado = 1;
COMMIT;

--select *from proTransporte;
--select *from genArchivo;
--select *from proTransporteDocumento;
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