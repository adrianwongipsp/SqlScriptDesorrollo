CREATE TABLE [genArchivo] (
  [IdArchivo] int IDENTITY NOT NULL,
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

CREATE TABLE [genCanton] (
  [IdCanton] int NOT NULL,
  [Numero] varchar(4) NULL,
  [Descripcion] varchar(200) NOT NULL,
  [IdProvincia] int NOT NULL,
  [Activo] bit NOT NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  PRIMARY KEY CLUSTERED ([IdCanton], [IdProvincia])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genDocumento] (
  [IdDocumento] int NOT NULL,
  [IdTipoDocumento] int NOT NULL,
  [Nombre] varchar(50) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genClasificacion] PRIMARY KEY CLUSTERED ([IdDocumento], [IdTipoDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genParroquia] (
  [IdParroquia] int NOT NULL,
  [Numero] varchar(4) NULL,
  [Descripcion] varchar(200) NULL,
  [IdProvincia] int NOT NULL,
  [IdCanton] int NOT NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  PRIMARY KEY CLUSTERED ([IdParroquia])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genProvincia] (
  [IdProvincia] int NOT NULL,
  [Numero] varchar(4) NULL,
  [Descripcion] varchar(200) NOT NULL,
  [Activo] bit NOT NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  PRIMARY KEY CLUSTERED ([IdProvincia])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genTipoDocumento] (
  [IdTipoDocumento] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genDocumento] PRIMARY KEY CLUSTERED ([IdTipoDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genTipoIdentificacion] (
  [IdTipoIdentificacion] int IDENTITY NOT NULL,
  [Nombre] varchar(50) NULL,
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

CREATE TABLE [proEmpleadoDocumento] (
  [IdArchivo] int NOT NULL,
  [IdEmpleadoProveedor] int NOT NULL,
  [IdDocumento] int NOT NULL,
  [IdTipoDocumento] int NOT NULL,
  [FechaEmision] datetime NULL,
  [FechaVencimiento] datetime NULL,
  [BitAntecedentes] bit NULL,
  [IdEstado] int NULL,
  [FechaEstado] datetime NULL,
  CONSTRAINT [PK_cacEmpleadoDocumento] PRIMARY KEY CLUSTERED ([IdArchivo], [IdEmpleadoProveedor], [IdDocumento], [IdTipoDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proEmpleadoProveedor] (
  [IdEmpleadoProveedor] int NOT NULL,
  [Numero] varchar(10) NULL,
  [IdProveedor] int NULL,
  [IdDocumentoIdentificacion] int NULL,
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

CREATE TABLE [proProveedor] (
  [IdProveedor] int IDENTITY NOT NULL,
  [Nombre] varchar(100) NULL,
  [IdTipoIdentificacion] int NULL,
  [NumeroIdentificacion] varchar(26) NULL,
  [Direccion] varchar(1000) NULL,
  [CorreoElectronico] varchar(100) NULL,
  [Contacto] varchar(100) NULL,
  [CodigoUsuario] varchar(100) NULL,
  [Contraseña] varchar(100) NULL,
  [IdProvincia] int NULL,
  [IdCanton] int NULL,
  [IdParoquia] int NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(200) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(200) NULL,
  CONSTRAINT [PK_cacProveedor] PRIMARY KEY CLUSTERED ([IdProveedor])
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
  CONSTRAINT [PK_proTransporte] PRIMARY KEY CLUSTERED ([IdTransporte], [IdTipoTransporte], [IdTipoPropiedadTransporte], [IdFormaTransporte], [IdMarcaTransporte], [IdModeloTransporte], [IdProveedor])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [proTransporteDocumento] (
  [IdArchivo] int NOT NULL,
  [IdTransporte] int NOT NULL,
  [IdDocumento] int NOT NULL,
  [IdTipoDocumento] int NOT NULL,
  [FechaEmision] datetime NULL,
  PRIMARY KEY CLUSTERED ([IdArchivo], [IdTransporte], [IdDocumento], [IdTipoDocumento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

--ALTER TABLE [genArchivo] ADD CONSTRAINT [fk_genArchivo_genModulo_IdModulo] FOREIGN KEY ([IdModulo]) REFERENCES [genModulo] ([IdModulo])
--GO
--ALTER TABLE [genCanton] ADD CONSTRAINT [IdProvincia] FOREIGN KEY ([IdProvincia]) REFERENCES [genProvincia] ([IdProvincia])
--GO
--ALTER TABLE [genDocumento] ADD CONSTRAINT [fk_genClasificacion_genDocumento_IdDocumento] FOREIGN KEY ([IdTipoDocumento]) REFERENCES [genTipoDocumento] ([IdTipoDocumento])
--GO
--ALTER TABLE [genParroquia] ADD CONSTRAINT [IdCanton] FOREIGN KEY ([IdCanton], [IdProvincia]) REFERENCES [genCanton] ([IdCanton], [IdProvincia])
--GO
--ALTER TABLE [proEmpleadoDocumento] ADD CONSTRAINT [fk_cacEmpleadoDocumento_cacEmpleadoProveedor_IdEmpleadoProveedor] FOREIGN KEY ([IdEmpleadoProveedor]) REFERENCES [proEmpleadoProveedor] ([IdEmpleadoProveedor])
--GO
--ALTER TABLE [proEmpleadoDocumento] ADD CONSTRAINT [fk_cacEmpleadoDocumento_genArchivo_IdArchivo] FOREIGN KEY ([IdArchivo]) REFERENCES [genArchivo] ([IdArchivo])
--GO
--ALTER TABLE [proEmpleadoDocumento] ADD CONSTRAINT [fk_cacEmpleadoDocumento_genClasificacion_IdClasificacion_IdDocumento] FOREIGN KEY ([IdDocumento], [IdTipoDocumento]) REFERENCES [genDocumento] ([IdDocumento], [IdTipoDocumento])
--GO
--ALTER TABLE [proEmpleadoProveedor] ADD CONSTRAINT [fk_cacEmpleadoProveedor_cacProveedor_IdProveedor] FOREIGN KEY ([IdProveedor]) REFERENCES [proProveedor] ([IdProveedor])
--GO
--ALTER TABLE [proEmpleadoProveedor] ADD CONSTRAINT [fk_cacEmpleadoProveedor_genTipoSangre_IdTipoSangre] FOREIGN KEY ([IdTipoSangre]) REFERENCES [genTipoSangre] ([IdTipoSangre])
--GO
--ALTER TABLE [proEmpleadoProveedor] ADD CONSTRAINT [fk_cacEmpleadoProveedor_genTipoIdentificacion_IdTipoIdentificacion] FOREIGN KEY ([IdTipoIdentificacion]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
--GO
--ALTER TABLE [proProveedor] ADD CONSTRAINT [fk_cacProveedor_genTipoIdentificacion_IdTipoIdentificacion] FOREIGN KEY ([IdTipoIdentificacion]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
--GO
--ALTER TABLE [proProveedor] ADD FOREIGN KEY ([IdProvincia]) REFERENCES [genProvincia] ([IdProvincia])
--GO
--ALTER TABLE [proProveedor] ADD FOREIGN KEY ([IdCanton]) REFERENCES [genCanton] ([IdCanton])
--GO
--ALTER TABLE [proProveedor] ADD FOREIGN KEY ([IdParoquia]) REFERENCES [genParroquia] ([IdParroquia])
--GO
--ALTER TABLE [proTipoTransporte] ADD CONSTRAINT [fk_proTipoTransporte_proMedioTransporte_IdMedioTransporte] FOREIGN KEY ([IdMedioTransporte]) REFERENCES [proMedioTransporte] ([IdMedioTransporte])
--GO
--ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proTipoTransporte_IdTipoTransporte] FOREIGN KEY ([IdTipoTransporte]) REFERENCES [proTipoTransporte] ([IdTipoTransporte])
--GO
--ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proTipoPropiedadTransporte_IdTipoPropiedadTransporte] FOREIGN KEY ([IdTipoPropiedadTransporte]) REFERENCES [proTipoPropiedadTransporte] ([IdTipoPropiedadTransporte])
--GO
--ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proFormaTransporte_IdFormaTransporte] FOREIGN KEY ([IdFormaTransporte]) REFERENCES [proFormaTransporte] ([IdFormaTransporte])
--GO
--ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proMarcaTransporte_IdMarcaTransporte] FOREIGN KEY ([IdMarcaTransporte]) REFERENCES [proMarcaTransporte] ([IdMarcaTransporte])
--GO
--ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_proModeloTransporte_IdModeloTransporte] FOREIGN KEY ([IdModeloTransporte]) REFERENCES [proModeloTransporte] ([IdModeloTransporte])
--GO
--ALTER TABLE [proTransporte] ADD CONSTRAINT [fk_proTransporte_cacProveedor_IdProveedor] FOREIGN KEY ([IdProveedor]) REFERENCES [proProveedor] ([IdProveedor])
--GO
ALTER TABLE [proTransporteDocumento] ADD CONSTRAINT [fk_proTransporteDocumento_proTransporte_1] FOREIGN KEY ([IdArchivo]) REFERENCES [proTransporte] ([IdTransporte])
GO
ALTER TABLE [proTransporteDocumento] ADD CONSTRAINT [fk_proTransporteDocumento_genArchivo_1] FOREIGN KEY ([IdArchivo]) REFERENCES [genArchivo] ([IdArchivo])
GO
ALTER TABLE [proTransporteDocumento] ADD CONSTRAINT [fk_proTransporteDocumento_genDocumento_IdDocumento_IdTipoDocumento] FOREIGN KEY ([IdDocumento], [IdTipoDocumento]) REFERENCES [genDocumento] ([IdDocumento], [IdTipoDocumento])
GO
ALTER TABLE proEmpleadoProveedor ADD CONSTRAINT [fk_proEmpleadoProveedor_genDocumento_IdDocumento] FOREIGN KEY ([IdDocumentoIdentificacion]) REFERENCES [genDocumento] ([IdDocumentoIdentificacion])
GO
