CREATE TABLE [cacEmpleadoDocumento] (
  [IdArchivo] int NOT NULL,
  [IdEmpleadoProveedor] int NOT NULL,
  [IdClasificacion] int NOT NULL,
  [IdDocumento] int NOT NULL,
  [FechaEmision] datetime NULL,
  [FechaVencimiento] datetime NULL,
  [BitAntecedentes] bit NULL,
  [IdEstado] int NULL,
  [FechaEstado] datetime NULL,
  CONSTRAINT [PK_cacEmpleadoDocumento] PRIMARY KEY CLUSTERED ([IdArchivo], [IdEmpleadoProveedor], [IdClasificacion], [IdDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [cacEmpleadoProveedor] (
  [IdEmpleadoProveedor] int NOT NULL,
  [IdProveedor] int NULL,
  [IdTipoIdentificacion] int NULL,
  [IdTipoSangre] int NULL,
  [Apellido] varchar(100) NULL,
  [Nombre] varchar(100) NULL,
  [Correo] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_cacEmpleadoProveedor] PRIMARY KEY CLUSTERED ([IdEmpleadoProveedor])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [cacProveedor] (
  [IdProveedor] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [IdTipoIdentificacion] int NULL,
  [NumeroIdentificacion] varchar(26) NULL,
  [Direccion] varchar(1000) NULL,
  [CorreoElectronico] varchar(100) NULL,
  [Contacto] varchar(100) NULL,
  [CodigoUsuario] varchar(100) NULL,
  [Contraseña] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(200) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(200) NULL,
  CONSTRAINT [PK_cacProveedor] PRIMARY KEY CLUSTERED ([IdProveedor])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genArchivo] (
  [IdArchivo] int IDENTITY NOT NULL,
  [IdModulo] int NULL,
  [Nombre] varchar(100) NULL,
  [Extension] varchar(10) NULL,
  [Directorio] varchar(30) NULL,
  [RutaPrivada] varchar(350) NULL,
  [RutaPublica] varchar(350) NULL,
  [Activo] bit NULL,
  [FechaCreacion] datetime NULL,
  [UsuarioCreacion] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  [FechaEliminacion] datetime NULL,
  [UsuarioEliminacion] varchar(100) NULL,
  CONSTRAINT [PK_genArchivo] PRIMARY KEY CLUSTERED ([IdArchivo])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genClasificacion] (
  [IdClasificacion] int NOT NULL,
  [IdDocumento] int NOT NULL,
  [Nombre] varchar(50) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genClasificacion] PRIMARY KEY CLUSTERED ([IdClasificacion], [IdDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genDocumento] (
  [IdDocumento] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genDocumento] PRIMARY KEY CLUSTERED ([IdDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genModulo] (
  [IdModulo] int IDENTITY NOT NULL,
  [Nombre] varchar(60) NULL,
  [Logo] varchar(60) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genModulo] PRIMARY KEY CLUSTERED ([IdModulo])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genTipoIdentificacion] (
  [IdTipoIdentificacion] int IDENTITY NOT NULL,
  [Nombre] varchar(4) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genTipoIdentificacion] PRIMARY KEY CLUSTERED ([IdTipoIdentificacion])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genTipoSangre] (
  [IdTipoSangre] int IDENTITY NOT NULL,
  [Nombre] varchar(4) NULL,
  [Signo] varchar(10) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genTipoSangre] PRIMARY KEY CLUSTERED ([IdTipoSangre])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proFormaTransporte] (
  [IdFormaTransporte] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_proFormaTransporte] PRIMARY KEY CLUSTERED ([IdFormaTransporte])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proMarcaTransporte] (
  [IdMarcaTransporte] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_proMarcaTransporte] PRIMARY KEY CLUSTERED ([IdMarcaTransporte])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proMedioTransporte] (
  [IdMedioTransporte] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_proMedioTransporte] PRIMARY KEY CLUSTERED ([IdMedioTransporte])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proModeloTransporte] (
  [IdModeloTransporte] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_proModeloTransporte] PRIMARY KEY CLUSTERED ([IdModeloTransporte])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proTipoPropiedadTransporte] (
  [IdTipoPropiedadTransporte] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  PRIMARY KEY CLUSTERED ([IdTipoPropiedadTransporte])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proTipoTransporte] (
  [IdTipoTransporte] int IDENTITY NOT NULL,
  [IdMedioTransporte] int NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_proTipoTransporte] PRIMARY KEY CLUSTERED ([IdTipoTransporte])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proTransporte] (
  [IdTransporte] int IDENTITY NOT NULL,
  [IdTipoTransporte] int NOT NULL,
  [IdTipoPropiedadTransporte] int NOT NULL,
  [IdFormaTransporte] int NOT NULL,
  [IdMarcaTransporte] int NOT NULL,
  [IdModeloTransporte] int NOT NULL,
  [IdProveedor] int NOT NULL,
  [IdClasificacion] int NOT NULL,
  [IdDocumento] int NOT NULL,
  [Identificacion] varchar(100) NULL,
  [Serie] varchar(100) NULL,
  [Descripcion] varchar(300) NULL,
  [CapacidadMaximaPersonas] int NULL,
  [Horometro] bit NULL,
  [AplicaDescuento] bit NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_proTransporte] PRIMARY KEY CLUSTERED ([IdTransporte], [IdTipoTransporte], [IdTipoPropiedadTransporte], [IdFormaTransporte], [IdMarcaTransporte], [IdModeloTransporte], [IdProveedor], [IdClasificacion], [IdDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [cacEmpleadoDocumento] ADD CONSTRAINT [fk_cacEmpleadoDocumento_cacEmpleadoProveedor_IdEmpleadoProveedor] FOREIGN KEY ([IdEmpleadoProveedor]) REFERENCES [cacEmpleadoProveedor] ([IdEmpleadoProveedor])
GO
ALTER TABLE [cacEmpleadoDocumento] ADD CONSTRAINT [fk_cacEmpleadoDocumento_genArchivo_IdArchivo] FOREIGN KEY ([IdArchivo]) REFERENCES [genArchivo] ([IdArchivo])
GO
ALTER TABLE [cacEmpleadoDocumento] ADD CONSTRAINT [fk_cacEmpleadoDocumento_genClasificacion_IdClasificacion_IdDocumento] FOREIGN KEY ([IdClasificacion], [IdDocumento]) REFERENCES [genClasificacion] ([IdClasificacion], [IdDocumento])
GO
ALTER TABLE [cacEmpleadoProveedor] ADD CONSTRAINT [fk_cacEmpleadoProveedor_cacProveedor_IdProveedor] FOREIGN KEY ([IdProveedor]) REFERENCES [cacProveedor] ([IdProveedor])
GO
ALTER TABLE [cacEmpleadoProveedor] ADD CONSTRAINT [fk_cacEmpleadoProveedor_genTipoSangre_IdTipoSangre] FOREIGN KEY ([IdTipoSangre]) REFERENCES [genTipoSangre] ([IdTipoSangre])
GO
ALTER TABLE [cacEmpleadoProveedor] ADD CONSTRAINT [fk_cacEmpleadoProveedor_genTipoIdentificacion_IdTipoIdentificacion] FOREIGN KEY ([IdTipoIdentificacion]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
GO
ALTER TABLE [cacProveedor] ADD CONSTRAINT [fk_cacProveedor_genTipoIdentificacion_IdTipoIdentificacion] FOREIGN KEY ([IdTipoIdentificacion]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
GO
ALTER TABLE [genArchivo] ADD CONSTRAINT [fk_genArchivo_genModulo_IdModulo] FOREIGN KEY ([IdModulo]) REFERENCES [genModulo] ([IdModulo])
GO
ALTER TABLE [genClasificacion] ADD CONSTRAINT [fk_genClasificacion_genDocumento_IdDocumento] FOREIGN KEY ([IdDocumento]) REFERENCES [genDocumento] ([IdDocumento])
GO
ALTER TABLE [proTipoTransporte] ADD CONSTRAINT [fk_proTipoTransporte_proMedioTransporte_IdMedioTransporte] FOREIGN KEY ([IdMedioTransporte]) REFERENCES [proMedioTransporte] ([IdMedioTransporte])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proTipoTransporte_IdTipoTransporte] FOREIGN KEY ([IdTipoTransporte]) REFERENCES [proTipoTransporte] ([IdTipoTransporte])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proTipoPropiedadTransporte_IdTipoPropiedadTransporte] FOREIGN KEY ([IdTipoPropiedadTransporte]) REFERENCES [proTipoPropiedadTransporte] ([IdTipoPropiedadTransporte])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proFormaTransporte_IdFormaTransporte] FOREIGN KEY ([IdFormaTransporte]) REFERENCES [proFormaTransporte] ([IdFormaTransporte])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proMarcaTransporte_IdMarcaTransporte] FOREIGN KEY ([IdMarcaTransporte]) REFERENCES [proMarcaTransporte] ([IdMarcaTransporte])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proModeloTransporte_IdModeloTransporte] FOREIGN KEY ([IdModeloTransporte]) REFERENCES [proModeloTransporte] ([IdModeloTransporte])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_cacProveedor_IdProveedor] FOREIGN KEY ([IdProveedor]) REFERENCES [cacProveedor] ([IdProveedor])
GO
ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_genClasificacion_IdClasificacion_IdDocumento] FOREIGN KEY ([IdClasificacion], [IdDocumento]) REFERENCES [genClasificacion] ([IdClasificacion], [IdDocumento])
GO

