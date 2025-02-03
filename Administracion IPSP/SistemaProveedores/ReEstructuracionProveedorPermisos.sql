

CREATE TABLE [genDepartamento] (
  [IdDepartamento] int IDENTITY NOT NULL,
  [NombreDepartamento] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Nemonico] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] varchar(100) NULL,
  [UsuarioModificacion] varchar(255) NULL,
  CONSTRAINT [PK_genDepartamento] PRIMARY KEY CLUSTERED ([IdDepartamento])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genMenu] (
  [IdMenu] int NOT NULL,
  [Nombre] varchar(255) NULL,
  [Icono] varchar(60) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genMenu] PRIMARY KEY CLUSTERED ([IdMenu])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genModulo] (
  [IdModulo] int NOT NULL,
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

CREATE TABLE [genPermisos] (
  [IdUsuario] int NOT NULL,
  [IdTipoUsuario] int NOT NULL,
  [IdSector] varchar(100) NOT NULL,
  [IdCamaronera] varchar(100) NOT NULL,
  [IdZona] varchar(100) NOT NULL,
  [IdDivision] int NOT NULL,
  [IdEmpresa] int NOT NULL,
  [IdDepartamento] int NOT NULL,
  [IdRol] int NOT NULL,
  [IdModulo] int NOT NULL,
  [IdMenu] int NOT NULL,
  [IdSubMenu] int NOT NULL,
  CONSTRAINT [PK_genPermisos] PRIMARY KEY CLUSTERED ([IdUsuario], [IdTipoUsuario], [IdSector], [IdCamaronera], [IdZona], [IdDivision], [IdEmpresa], [IdDepartamento], [IdRol], [IdModulo], [IdMenu], [IdSubMenu])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genRol] (
  [IdRol] int IDENTITY NOT NULL,
  [NombreRol] varchar(100) NULL,
  [Descripcion] varchar(100) NULL,
  [Nemonico] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genRol] PRIMARY KEY CLUSTERED ([IdRol])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genSubMenu] (
  [IdSubMenu] int NOT NULL,
  [Nombre] varchar(60) NULL,
  [Icono] varchar(60) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genSubMenu] PRIMARY KEY CLUSTERED ([IdSubMenu])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO



CREATE TABLE [genUsuario] (
  [IdUsuario] int IDENTITY NOT NULL,
  [IdTipoIdentificacion] int NOT NULL,
  [IdTipoSangre] int NULL,
  [Nombres] varchar(100) NULL,
  [Apellidos] varchar(100) NULL,
  [Correo] varchar(60) NULL,
  [CodigoUsuario] varchar(100) NULL,
  [Clave] varchar(100) NULL,
  [AD] bit NULL,
  [QR] bit NULL,
  [RutaQR] varchar(255) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genUsuario] PRIMARY KEY CLUSTERED ([IdUsuario])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO


CREATE TABLE [genUsuDepRol] (
  [IdUsuario] int NOT NULL,
  [IdDepartamento] int NOT NULL,
  [IdRol] int NOT NULL,
  CONSTRAINT [PK_genUsuDepRol] PRIMARY KEY CLUSTERED ([IdUsuario], [IdDepartamento], [IdRol])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [ModuloMenu] (
  [IdModulo] int NOT NULL,
  [IdMenu] int NOT NULL,
  [IdSubmenu] int NOT NULL,
  [Controlador] varchar(60) NULL,
  [Vista] varchar(50) NULL,
  CONSTRAINT [PK_ModuloMenu] PRIMARY KEY CLUSTERED ([IdModulo], [IdMenu], [IdSubmenu])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [genPermisos] ADD CONSTRAINT [fk_genPermisos_genUsuDepRol_IdUsuario_IdDepartamento_IdRol] FOREIGN KEY ([IdUsuario], [IdDepartamento], [IdRol]) REFERENCES [genUsuDepRol] ([IdUsuario], [IdDepartamento], [IdRol])
GO
ALTER TABLE [genPermisos] ADD CONSTRAINT [fk_genPermisos_ModuloMenu_IdModulo_IdMenu_IdSubmenu] FOREIGN KEY ([IdModulo], [IdMenu], [IdSubMenu]) REFERENCES [ModuloMenu] ([IdModulo], [IdMenu], [IdSubmenu])
GO
ALTER TABLE [genUsuario] ADD CONSTRAINT [fk_genUsuario_genTipoIdentificacion_IdTipoIdentificacion] FOREIGN KEY ([IdTipoIdentificacion]) REFERENCES [genTipoIdentificacion] ([IdTipoIdentificacion])
GO
ALTER TABLE [genUsuario] ADD CONSTRAINT [fk_genUsuario_genTipoSangre_IdTipoSangre] FOREIGN KEY ([IdTipoSangre]) REFERENCES [genTipoSangre] ([IdTipoSangre])
GO
ALTER TABLE [genUsuDepRol] ADD CONSTRAINT [fk_genUsuDepRol_genUsuario_IdUsuario] FOREIGN KEY ([IdUsuario]) REFERENCES [genUsuario] ([IdUsuario])
GO
ALTER TABLE [genUsuDepRol] ADD CONSTRAINT [fk_genUsuDepRol_genDepartamento_IdDepartamento] FOREIGN KEY ([IdDepartamento]) REFERENCES [genDepartamento] ([IdDepartamento])
GO
ALTER TABLE [genUsuDepRol] ADD CONSTRAINT [fk_genUsuDepRol_genRol_1] FOREIGN KEY ([IdRol]) REFERENCES [genRol] ([IdRol])
GO
ALTER TABLE [ModuloMenu] ADD CONSTRAINT [fk_ModuloMenu_genModulo_IdModulo] FOREIGN KEY ([IdModulo]) REFERENCES [genModulo] ([IdModulo])
GO
ALTER TABLE [ModuloMenu] ADD CONSTRAINT [fk_ModuloMenu_genMenu_IdMenu] FOREIGN KEY ([IdMenu]) REFERENCES [genMenu] ([IdMenu])
GO
ALTER TABLE [ModuloMenu] ADD CONSTRAINT [fk_ModuloMenu_genSubMenu_IdSubMenu] FOREIGN KEY ([IdSubmenu]) REFERENCES [genSubMenu] ([IdSubMenu])
GO

