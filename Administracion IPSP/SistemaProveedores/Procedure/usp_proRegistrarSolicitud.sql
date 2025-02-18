USE [BDProveedor]
GO
/****** Object:  StoredProcedure [dbo].[usp_proRegistrarSolicitud]    Script Date: 28/5/2024 14:18:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[usp_proRegistrarSolicitud](
@jsonSolicitud varchar(max),
@jsonContacto varchar(max),
@Resultado int output

)
as begin


BEGIN TRY
--declare @jsonSolicitud varchar(max),@jsonContacto varchar(max);
declare @Numero varchar(6);
--set @jsonSolicitud=N'{"IdSolicitudRegistro":0,"Numero":null,"NumeroRuc":"0993367660001","RazonSocial":"A&M ANGASA STORE S.A.S.","NombreComercial":"A&M ANGASA STORE S.A.S.","SitioWebCorporativo":null,"AnioInicioActividad":2021,"IdProvincia":10,"IdCanton":86,"IdParroquia":35,"InterseccionReferencia":"LAS MERCEDES DIAGONAL SALON DEL REINO","TipoIdentificacionPropietario":1,"NumeroIdentificacionPropietario":"0654987987","NombrePropietario":"edgar","ApellidoPropietario":"barrera","IdContactoAutorizado":0,"Email":"edbarrera001@gmail.com","Contrasenia":null,"CorreoDepartamento":"edgar.barrera@ipsp-profremar.com","IdEstado":0,"FechaRegistroSolicitud":null,"HoraRegistroSolicitud":null,"Activo":false,"FechaRegistro":null,"UsuarioRegistro":null,"FechaModificacion":null,"UsuarioModificacion":null,"Provincia":null,"Canton":null,"fileArchivoRUC":null,"fileArchivoCI":null,"NombreArchivoRUC":null,"NombreArchivoCI":null,"Contacto":null,"Parroquia":null,"DomicilioTributario":"GUAYAQUIL","ActividadEconomicaPrincipal":null,"NombreArchivo":"RUC A&M ANGASA STORE (1).pdf","ExtensionArchivo":".pdf","RutaArchivo":"\\\\192.168.1.122\\Files\\Sistemas\\Desarrollo\\Archivos\\PROVEEDOR\\EMPLEADOS\\PDF\\RUC A&M ANGASA STORE (1).pdf"}';
--set @jsonContacto=N'{"IdContacto":0,"TipoIdentificacion":1,"NumeroIdentificacion":"1719142905","Nombres":" ALVEAR PATRICIO RAMIRO","Apellidos":"JARAMILLO","NumeroCelular":"0930929104","Activo":false,"FechaRegistro":null,"UsuarioRegistro":null,"FechaModificacion":null,"UsuarioModifcacion":null,"Genero":null,"NombreArchivo":"Cedula nueva - copia.png","ExtensionArchivo":".png","RutaArchivo":"\\\\192.168.1.122\\Files\\Sistemas\\Desarrollo\\Archivos\\PROVEEDOR\\EMPLEADOS\\JPG\\Cedula nueva - copia.png"}';
declare @tablaSolicitud table(
  [Numero] varchar(8) NULL,
  [NumeroRuc] varchar(13) NULL,
  [RazonSocial] varchar(200) NULL,
  [NombreComercial] varchar(200) NULL,
  [SitioWebCorporativo] varchar(100) NULL,
  [AnioInicioActividad] int NULL,
  [IdProvincia] int NOT NULL,
  [IdCanton] int NOT NULL,
  [IdParroquia] int NOT NULL,
  [InterseccionReferencia] varchar(max) NULL,
  [TipoIdentificacionPropietario] int NULL,
  [NumeroIdentificacionPropietario] varchar(13) NULL,
  [NombrePropietario] varchar(200) NULL,
  [ApellidoPropietario] varchar(200) NULL,
  [Email] varchar(255) NULL,
  [CorreoDepartamento] varchar(255) NULL
);
declare @tablaArchivoSolicitud table(
NombreArchivo varchar(100),
ExtensionArchivo varchar(10),
RutaArchivo varchar(350)
);

declare @tablaContacto table(
TipoIdentificacion int,
NumeroIdentificacion varchar(13),
Nombres varchar(200),
Apellidos varchar(200),
NumeroCelular varchar(15)
);
declare @tablaArchivoContacto table(
NombreArchivo varchar(100),
ExtensionArchivo varchar(10),
RutaArchivo varchar(350)
);

BEGIN TRAN tri	
		--COLOCAR EL NUMERO
set @Numero= (SELECT RIGHT(REPLICATE('0', 6) + CAST(ISNULL(MAX(IdSolicitudRegistro), 0) + 1 AS VARCHAR(10)), 6) AS Numero FROM proSolicitudRegistro);
declare @IdSolicitud int=0;

insert into @tablaSolicitud(NumeroRuc,RazonSocial,NombreComercial,SitioWebCorporativo
,AnioInicioActividad,IdProvincia,IdCanton,IdParroquia,InterseccionReferencia
,TipoIdentificacionPropietario,NumeroIdentificacionPropietario,NombrePropietario,ApellidoPropietario,Email,CorreoDepartamento)
select *from OPENJSON(@jsonSolicitud)
with(
		--Numero varchar(8) '$.Numero',
		NumeroRuc varchar(13) '$.NumeroRuc',
		RazonSocial varchar(200) '$.RazonSocial',
		NombreComercial varchar(200) '$.NombreComercial',
		SitioWebCorporativo varchar(200) '$.SitioWebCorporativo',
		AnioInicioActividad int '$.AnioInicioActividad',
		IdProvincia int '$.IdProvincia',
		IdCanton int '$.IdCanton',
		IdParroquia int '$.IdParroquia',
		InterseccionReferencia varchar(max) '$.InterseccionReferencia',
		TipoIdentificacionPropietario int '$.TipoIdentificacionPropietario',
		NumeroIdentificacionPropietario varchar(13) '$.NumeroIdentificacionPropietario',
		NombrePropietario varchar(200) '$.NombrePropietario',
		ApellidoPropietario varchar(200) '$.ApellidoPropietario',
		Email varchar(255) '$.Email',
		CorreoDepartamento varchar(255) '$.CorreoDepartamento'
		);
		
		--set @IdSolicitud=SCOPE_IDENTITY()
--update proSolicitudRegistro set Numero=@Numero where IdSolicitudRegistro=@IdSolicitud;

declare @IdContacto int=0;

insert into @tablaContacto(TipoIdentificacion,NumeroIdentificacion,Nombres,Apellidos,NumeroCelular)
select *from OPENJSON(@jsonContacto)
with(
		TipoIdentificacion int '$.TipoIdentificacion',
		NumeroIdentificacion varchar(13) '$.NumeroIdentificacion',
		Nombres varchar(255) '$.Nombres',
		Apellidos varchar(255) '$.Apellidos',
		NumeroCelular varchar(15) '$.NumeroCelular'
		)
--set @IdContacto  = SCOPE_IDENTITY();
--update proSolicitudRegistro set IdContactoAutorizado=@IdContacto where IdSolicitudRegistro=@IdSolicitud;

insert into @tablaArchivoSolicitud(NombreArchivo,ExtensionArchivo,RutaArchivo)
select * from OPENJSON(@jsonSolicitud)
with(
		NombreArchivo varchar(100) '$.NombreArchivo',
		ExtensionArchivo varchar(10) '$.ExtensionArchivo',
		RutaArchivo varchar(350) '$.RutaArchivo'
		)

insert into @tablaArchivoContacto(NombreArchivo,ExtensionArchivo,RutaArchivo)
select * from OPENJSON(@jsonContacto)
with(
		NombreArchivo varchar(100) '$.NombreArchivo',
		ExtensionArchivo varchar(10) '$.ExtensionArchivo',
		RutaArchivo varchar(350) '$.RutaArchivo'
		)
		set @IdContacto = (select ISNULL(MAX(IdContacto), 0) + 1 as IdContacto from proContacto);
		insert into proContacto(IdContacto,TipoIdentificacion,NumeroIdentificacion,Nombres,Apellidos,NumeroCelular,Activo,FechaRegistro)
		select @IdContacto,*,1,GETDATE() from @tablaContacto
		
		select @IdContacto;

		declare @IdEstado int;
		set @IdEstado = (select IdEstado from genEstado where Descripcion='PENDIENTE')
		 select @IdEstado;
		 set @IdSolicitud = (select ISNULL(MAX(IdSolicitudRegistro), 0) + 1 as IdSolicitud from proSolicitudRegistro);
		
		insert into proSolicitudRegistro(
		IdSolicitudRegistro,
		Numero,
		NumeroRuc,
		RazonSocial,
		NombreComercial,
		SitioWebCorporativo,
		AnioInicioActividad,
		IdProvincia,
		IdCanton,
		IdParroquia,
		InterseccionReferencia,
		TipoIdentificacionPropietario,
		NumeroIdentificacionPropietario,
		NombrePropietario,
		ApellidoPropietario,
		Email,
		CorreoDepartamento,
		IdContactoAutorizado,
		IdEstado,
		FechaRegistroSolicitud,
		HoraRegistroSolicitud,
		Activo,
		FechaRegistro)
		select @IdSolicitud, 
		@Numero,
		NumeroRuc,
		RazonSocial,
		NombreComercial,
		SitioWebCorporativo,
		AnioInicioActividad,
		IdProvincia,
		IdCanton,
		IdParroquia,
		InterseccionReferencia,
		TipoIdentificacionPropietario,
		NumeroIdentificacionPropietario,
		NombrePropietario,
		ApellidoPropietario,
		Email,
		CorreoDepartamento,
		@IdContacto,
		@IdEstado,
		CAST(GETDATE() as date),
		CONVERT(VARCHAR(5), GETDATE(), 108) AS HoraRegistroSolicitud,
		1,GETDATE()
		from @tablaSolicitud
		--set @IdSolicitud = SCOPE_IDENTITY();
		select @IdSolicitud;

		declare @IdDocumentoRuc int,@IdTipoDocumentoRuc int, @IdDocumentoCI int,@IdTipoDocumentoCI int;
		declare @IdArchivoRuc int=0, @IdArchivoCI int=0;
		set @IdDocumentoRuc = (select IdDocumento from genDocumento where Nombre='RUC');
		set @IdDocumentoCI = (select IdDocumento from genDocumento where Nombre='CÉDULA');
		set @IdTipoDocumentoRuc = (select IdTipoDocumento from genDocumento where Nombre='RUC');
		set @IdTipoDocumentoCI = (select IdTipoDocumento from genDocumento where Nombre='CÉDULA');

		--ARCHIVO RUC SOLICITUD
		insert into genArchivo(NombreArchivo,Extension,RutaPrivada,Activo,FechaCreacion)
		select *,1,GETDATE() from @tablaArchivoSolicitud
		set @IdArchivoRuc = SCOPE_IDENTITY();
		select @IdArchivoRuc;
		--IMAGEN CÉDULA DEL CONTACTO
		insert into genArchivo(NombreArchivo,Extension,RutaPrivada,Activo,FechaCreacion)
	    select *,1,GETDATE() from @tablaArchivoContacto
		set @IdArchivoCI = SCOPE_IDENTITY();
		select @IdArchivoCI;

		--INSERT TABLAS INTERMEDIAS
		insert into proSolicitudDocumento(IdArchivo,IdSolicitudProveedor,IdDocumento,IdTipoDocumento,FechaEmision)
		values (@IdArchivoRuc,@IdSolicitud,@IdDocumentoRuc,@IdTipoDocumentoRuc,GETDATE())

		insert into proContactoDocumento(IdArchivo,IdContacto,IdDocumento,IdTipoDocumento,FechaEmision)
		values (@IdArchivoCI,@IdContacto,@IdDocumentoCI,@IdTipoDocumentoCI,GETDATE())

		--select *from proSolicitudRegistro
		--select *from proSolicitudDocumento
		--select *from proContacto
		--select *from proContactoDocumento
		--select *from genArchivo
set @Resultado = 1;
COMMIT;
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
 END CATCH
END