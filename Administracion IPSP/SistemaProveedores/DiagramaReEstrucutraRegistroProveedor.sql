--CREATE TABLE [genArchivo] (
--  [IdArchivo] int IDENTITY NOT NULL,
--  [Nombre] varchar(100) NULL,
--  [Extension] varchar(10) NULL,
--  [Directorio] varchar(30) NULL,
--  [RutaPrivada] varchar(350) NULL,
--  [RutaPublica] varchar(350) NULL,
--  [Activo] bit NULL,
--  [FechaCreacion] datetime NULL,
--  [UsuarioCreacion] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  [FechaEliminacion] datetime NULL,
--  [UsuarioEliminacion] varchar(100) NULL,
--  CONSTRAINT [PK_genArchivo] PRIMARY KEY CLUSTERED ([IdArchivo])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

--CREATE TABLE [genCanton] (
--  [IdCanton] int NOT NULL,
--  [Nombre] varchar(200) NOT NULL,
--  [IdProvincia] int NOT NULL,
--  [Activo] bit NOT NULL,
--  [FechaRegistro] datetime NULL,
--  [UsuarioRegistro] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  CONSTRAINT [PK_genCanton] PRIMARY KEY CLUSTERED ([IdCanton], [IdProvincia])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

--CREATE TABLE [genDocumento] (
--  [IdDocumento] int NOT NULL,
--  [IdTipoDocumento] int NOT NULL,
--  [Nombre] varchar(50) NULL,
--  [Activo] bit NULL,
--  [FechaRegistro] datetime NULL,
--  [UsuarioRegistro] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  CONSTRAINT [PK_genClasificacion] PRIMARY KEY CLUSTERED ([IdDocumento], [IdTipoDocumento])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

CREATE TABLE [genEstado] (
  [IdEstado] int NOT NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  PRIMARY KEY CLUSTERED ([IdEstado])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

--CREATE TABLE [genParroquia] (
--  [IdParroquia] int NOT NULL,
--  [Nombre] varchar(200) NULL,
--  [IdCanton] int NOT NULL,
--  [IdProvincia] int NOT NULL,
--  [Activo] bit NULL,
--  [FechaRegistro] datetime NULL,
--  [UsuarioRegistro] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  CONSTRAINT [PK_genParroquia] PRIMARY KEY CLUSTERED ([IdParroquia])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

--CREATE TABLE [genProvincia] (
--  [IdProvincia] int NOT NULL,
--  [Nombre] varchar(200) NOT NULL,
--  [Activo] bit NOT NULL,
--  [Usuarioregistro] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  CONSTRAINT [PK_genProvincia] PRIMARY KEY CLUSTERED ([IdProvincia])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

--CREATE TABLE [genTipoDocumento] (
--  [IdTipoDocumento] int IDENTITY NOT NULL,
--  [Nombre] varchar(100) NULL,
--  [Descripcion] varchar(100) NULL,
--  [Activo] bit NULL,
--  [FechaRegistro] datetime NULL,
--  [UsuarioRegistro] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  CONSTRAINT [PK_genDocumento] PRIMARY KEY CLUSTERED ([IdTipoDocumento])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

--CREATE TABLE [genTipoIdentificacion] (
--  [IdTipoIdentificacion] int IDENTITY NOT NULL,
--  [Nombre] varchar(50) NULL,
--  [Descripcion] varchar(100) NULL,
--  [Activo] bit NULL,
--  [FechaRegistro] datetime NULL,
--  [UsuarioRegistro] varchar(100) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(100) NULL,
--  CONSTRAINT [PK_genTipoIdentificacion] PRIMARY KEY CLUSTERED ([IdTipoIdentificacion])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

CREATE TABLE [proActividadEconomica] (
  [IdActividadEconomica] int NOT NULL,
  [Descripcion] varchar(max) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  PRIMARY KEY CLUSTERED ([IdActividadEconomica])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proActXProveedor] (
  [IdActividad] int NOT NULL,
  [IdProveedor] int NOT NULL,
  PRIMARY KEY CLUSTERED ([IdActividad], [IdProveedor])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proContacto] (
  [IdContacto] int NOT NULL,
  [TipoIdentificacion] int NULL,
  [NumeroIdentificacion] varchar(13) NULL,
  [Nombres] varchar(255) NULL,
  [Apellidos] varchar(255) NULL,
  [NumeroCelular] varchar(15) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModifcacion] varchar(100) NULL,
  CONSTRAINT [PK_proContacto] PRIMARY KEY CLUSTERED ([IdContacto])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proSolicitudDocumento] (
  [IdArchivo] int NOT NULL,
  [IdSolicitudProveedor] int NOT NULL,
  [IdDocumento] int NOT NULL,
  [IdTipoDocumento] int NOT NULL,
  [FechaEmision] datetime NULL,
  [FechaVencimiento] datetime NULL,
  [IdEstado] int NULL,
  CONSTRAINT [PK_proSolicitudDocumento] PRIMARY KEY CLUSTERED ([IdArchivo], [IdSolicitudProveedor], [IdDocumento], [IdTipoDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proSolicitudRegistro] (
  [IdSolicitudRegistro] int NOT NULL,
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
  [IdContactoAutorizado] int NULL,
  [Email] varchar(255) NULL,
  [Contrasenia] varchar(max) NULL,
  [CorreoDepartamento] varchar(255) NULL,
  [IdEstado] int NULL,
  [FechaRegistroSolicitud] date NULL,
  [HoraRegistroSolicitud] varchar(5) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [_copy_6] PRIMARY KEY CLUSTERED ([IdSolicitudRegistro])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

--ALTER TABLE [genCanton] ADD CONSTRAINT [IdProvincia] FOREIGN KEY ([IdProvincia]) REFERENCES [genProvincia] ([IdProvincia])
--GO
--ALTER TABLE [genDocumento] ADD CONSTRAINT [fk_genClasificacion_genDocumento_IdDocumento] FOREIGN KEY ([IdDocumento]) REFERENCES [genTipoDocumento] ([IdTipoDocumento])
--GO
--ALTER TABLE [genParroquia] ADD FOREIGN KEY ([IdCanton], [IdProvincia]) REFERENCES [genCanton] ([IdCanton], [IdProvincia])
--GO
ALTER TABLE [proActXProveedor] ADD CONSTRAINT [fk_proActXProveedor_proActividadEconomica_1] FOREIGN KEY ([IdActividad]) REFERENCES [proActividadEconomica] ([IdActividadEconomica])
GO
ALTER TABLE [proActXProveedor] ADD CONSTRAINT [fk_proActXProveedor_proSolicitudRegistro_1] FOREIGN KEY ([IdProveedor]) REFERENCES [proSolicitudRegistro] ([IdSolicitudRegistro])
GO
ALTER TABLE [proContacto] ADD CONSTRAINT [fk_proContacto_genTipoIdentificacion_1] FOREIGN KEY ([TipoIdentificacion]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
GO
ALTER TABLE [proSolicitudDocumento] ADD CONSTRAINT [fk_proSolicitudDocumento_proSolicitudRegistro_1] FOREIGN KEY ([IdSolicitudProveedor]) REFERENCES [proSolicitudRegistro] ([IdSolicitudRegistro])
GO
ALTER TABLE [proSolicitudDocumento] ADD CONSTRAINT [fk_proSolicitudDocumento_genDocumento_1] FOREIGN KEY ([IdDocumento], [IdTipoDocumento]) REFERENCES [genDocumento] ([IdDocumento], [IdTipoDocumento])
GO
ALTER TABLE [proSolicitudDocumento] ADD CONSTRAINT [fk_proSolicitudDocumento_genArchivo_1] FOREIGN KEY ([IdArchivo]) REFERENCES [genArchivo] ([IdArchivo])
GO
ALTER TABLE [proSolicitudDocumento] ADD CONSTRAINT [fk_proSolicitudDocumento_genEstado_1] FOREIGN KEY ([IdEstado]) REFERENCES [genEstado] ([IdEstado])
GO
ALTER TABLE [proSolicitudRegistro] ADD CONSTRAINT [fk_proSolicitudRegistro_genTipoIdentificacion_1] FOREIGN KEY ([TipoIdentificacionPropietario]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
GO
ALTER TABLE [proSolicitudRegistro] ADD CONSTRAINT [fk_proSolicitudRegistro_proContacto_1] FOREIGN KEY ([IdContactoAutorizado]) REFERENCES [proContacto] ([IdContacto])
GO
ALTER TABLE [proSolicitudRegistro] ADD CONSTRAINT [fk_proSolicitudRegistro_genProvincia_1] FOREIGN KEY ([IdProvincia]) REFERENCES [genProvincia] ([IdProvincia])
GO
ALTER TABLE [proSolicitudRegistro] ADD CONSTRAINT [fk_proSolicitudRegistro_genCanton_1] FOREIGN KEY ([IdCanton]) REFERENCES [genCanton] ([IdCanton])
GO
ALTER TABLE [proSolicitudRegistro] ADD CONSTRAINT [fk_proSolicitudRegistro_genParroquia_1] FOREIGN KEY ([IdParroquia]) REFERENCES [genParroquia] ([IdParroquia])
GO
ALTER TABLE [proSolicitudRegistro] ADD CONSTRAINT [fk_proSolicitudRegistro_genEstado_1] FOREIGN KEY ([IdEstado]) REFERENCES [genEstado] ([IdEstado])
GO

