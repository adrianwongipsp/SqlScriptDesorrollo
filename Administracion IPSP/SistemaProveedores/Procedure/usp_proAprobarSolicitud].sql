ALTER procedure [dbo].[usp_proAprobarSolicitud](
@jsonSolicitud varchar(max),
@IdSolicitudRegistro int=0,
@usuario varchar(30),
@Resultado int output

)
as begin
BEGIN TRY
BEGIN TRAN tri

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
  [CorreoDepartamento] varchar(255) NULL,
  [IdContactoAutorizado] int NULL,
  [Contrasenia] varchar(max) NULL
);

insert into @tablaSolicitud(NumeroRuc,RazonSocial,NombreComercial,SitioWebCorporativo
,AnioInicioActividad,IdProvincia,IdCanton,IdParroquia,InterseccionReferencia
,TipoIdentificacionPropietario,NumeroIdentificacionPropietario,NombrePropietario,ApellidoPropietario,Email,CorreoDepartamento,IdContactoAutorizado,Contrasenia)
select *from OPENJSON(@jsonSolicitud)
with(
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
		CorreoDepartamento varchar(255) '$.CorreoDepartamento',
		IdContactoAutorizado int '$.IdContactoAutorizado',
		Contrasenia varchar(max) '$.Contrasenia'
		);
--SELECT *FROM @tablaSolicitud;
declare @idEstado int = (select IdEstado from genEstado where Descripcion='APROBADO')
update proSolicitudRegistro set IdEstado = @idEstado, FechaModificacion=GETDATE(),UsuarioRegistro=@usuario where IdSolicitudRegistro=@IdSolicitudRegistro
declare @IdProveedor int=0;
insert into proProveedor(Nombre,NumeroIdentificacion,IdTipoIdentificacion,CorreoElectronico,IdContacto,IdProvincia,IdCanton,IdParoquia
						,CodigoUsuario,Contrasenia,Direccion,Activo,FechaRegistro,UsuarioRegistro)
				select RazonSocial,NumeroRuc,3,Email,IdContactoAutorizado,IdProvincia,IdCanton,IdParroquia
				,NumeroRuc,Contrasenia,InterseccionReferencia,1,GETDATE(),@usuario
				from @tablaSolicitud
set @IdProveedor=SCOPE_IDENTITY();
--select @IdProveedor;
--select *from proProveedor where IdProveedor=@IdProveedor;

declare @idTipoUsuario int=(select IdTipoUsuario from genTipoUs where NombreTipoUsuario='PROVEEDOR');
declare @idRol int=(select IdRol from genRol where NombreRol='PROVEEDOR');

insert into genProveedorXAsignacion(IdProveedor,IdTipoUsuario)
values(@IdProveedor,@idTipoUsuario)

insert into genProDepRol(IdProveedor,IdTipoUsuario,IdRol)
values(@IdProveedor,@idTipoUsuario,@idRol)

declare @idModulo int = (select IdModulo from genModulo where Nombre='PROVEEDORES');
--select @idModulo
insert into genPermisos(IdProveedor,IdTipoUsuario,IdRol,IdModulo,IdMenu,IdSubMenu)
select @IdProveedor,@idTipoUsuario,@idRol, a.IdModulo,IdMenu,IdSubmenu
from ModuloMenu a
inner join genModulo a1 on a1.IdModulo=a.IdModulo
where a.IdModulo=@idModulo;

--select *from genPermisos where IdProveedor = @IdProveedor;

set @Resultado = 1;
COMMIT;
	-- ROLLBACK TRAN tri

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
