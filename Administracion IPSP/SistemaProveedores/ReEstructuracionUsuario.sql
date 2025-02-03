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
  [IdProveedor] int NOT NULL,
  [IdTipoUsuario] int NOT NULL,
  [IdDepartamento] int NOT NULL,
  [IdRol] int NOT NULL,
  [IdModulo] int NOT NULL,
  [IdMenu] int NOT NULL,
  [IdSubMenu] int NOT NULL,
  CONSTRAINT [PK_genPermisos] PRIMARY KEY CLUSTERED ([IdProveedor], [IdTipoUsuario], [IdDepartamento], [IdRol], [IdModulo], [IdMenu], [IdSubMenu])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genProDepRol] (
  [IdProveedor] int NOT NULL,
  [IdTipoUsuario] int NOT NULL,
  [IdDepartamento] int NOT NULL,
  [IdRol] int NOT NULL,
  CONSTRAINT [PK_genUsuDepRol] PRIMARY KEY CLUSTERED ([IdProveedor], [IdTipoUsuario], [IdDepartamento], [IdRol])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE TABLE [genProveedorXAsignacion] (
  [IdProveedor] int NOT NULL,
  [IdTipoUsuario] int NOT NULL,
  CONSTRAINT [PK_genUsuarioXAsignacion] PRIMARY KEY CLUSTERED ([IdProveedor], [IdTipoUsuario])
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

CREATE TABLE [genTipoUs] (
  [IdTipoUusario] int IDENTITY NOT NULL,
  [NombreTipoUusario] varchar(100) NULL,
  [Activo] bit NULL,
  [FechaRegistro] datetime NULL,
  [UsuarioRegistro] varchar(100) NULL,
  [FechaModificacion] datetime NULL,
  [UsuarioModificacion] varchar(100) NULL,
  CONSTRAINT [PK_genTipoUsuario] PRIMARY KEY CLUSTERED ([IdTipoUusario])
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

--CREATE TABLE [proProveedor] (
--  [IdProveedor] int IDENTITY NOT NULL,
--  [Nombre] varchar(100) NULL,
--  [IdTipoIdentificacion] int NULL,
--  [NumeroIdentificacion] varchar(26) NULL,
--  [Direccion] varchar(1000) NULL,
--  [CorreoElectronico] varchar(100) NULL,
--  [Contacto] varchar(100) NULL,
--  [CodigoUsuario] varchar(100) NULL,
--  [Contraseña] varchar(100) NULL,
--  [IdProvincia] int NULL,
--  [IdCanton] int NULL,
--  [IdParoquia] int NULL,
--  [Activo] bit NULL,
--  [FechaRegistro] datetime NULL,
--  [UsuarioRegistro] varchar(200) NULL,
--  [FechaModificacion] datetime NULL,
--  [UsuarioModificacion] varchar(200) NULL,
--  CONSTRAINT [PK_cacProveedor] PRIMARY KEY CLUSTERED ([IdProveedor])
--WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)
--GO

ALTER TABLE [genPermisos] ADD CONSTRAINT [fk_genPermisos_ModuloMenu_IdModulo_IdMenu_IdSubmenu] FOREIGN KEY ([IdModulo], [IdMenu], [IdSubMenu]) REFERENCES [ModuloMenu] ([IdModulo], [IdMenu], [IdSubmenu])
GO
ALTER TABLE [genPermisos] ADD CONSTRAINT [fk_genPermisos_genProDepRol_IdProveedor_IdTipoUsuario_IdDepartamento_IdRol] FOREIGN KEY ([IdProveedor], [IdTipoUsuario], [IdDepartamento], [IdRol]) REFERENCES [genProDepRol] ([IdProveedor], [IdTipoUsuario], [IdDepartamento], [IdRol])
GO
ALTER TABLE [genProDepRol] ADD CONSTRAINT [fk_genProDepRol_genDepartamento_1] FOREIGN KEY ([IdDepartamento]) REFERENCES [genDepartamento] ([IdDepartamento])
GO
ALTER TABLE [genProDepRol] ADD CONSTRAINT [fk_genProDepRol_genRol_1] FOREIGN KEY ([IdRol]) REFERENCES [genRol] ([IdRol])
GO
ALTER TABLE [genProDepRol] ADD CONSTRAINT [fk_genProDep_genProveedorXAsignacion_IdProveedor_IdTipoUsuario] FOREIGN KEY ([IdProveedor], [IdTipoUsuario]) REFERENCES [genProveedorXAsignacion] ([IdProveedor], [IdTipoUsuario])
GO
ALTER TABLE [genProveedorXAsignacion] ADD CONSTRAINT [fk_genProveedorXAsignacion_proProveedor_1] FOREIGN KEY ([IdProveedor]) REFERENCES [proProveedor] ([IdProveedor])
GO
ALTER TABLE [genProveedorXAsignacion] ADD CONSTRAINT [fk_genProveedorXAsignacion_genTipoUs_1] FOREIGN KEY ([IdTipoUsuario]) REFERENCES [genTipoUs] ([IdTipoUusario])
GO
ALTER TABLE [ModuloMenu] ADD CONSTRAINT [fk_ModuloMenu_genModulo_IdModulo] FOREIGN KEY ([IdModulo]) REFERENCES [genModulo] ([IdModulo])
GO
ALTER TABLE [ModuloMenu] ADD CONSTRAINT [fk_ModuloMenu_genMenu_IdMenu] FOREIGN KEY ([IdMenu]) REFERENCES [genMenu] ([IdMenu])
GO
ALTER TABLE [ModuloMenu] ADD CONSTRAINT [fk_ModuloMenu_genSubMenu_IdSubMenu] FOREIGN KEY ([IdSubmenu]) REFERENCES [genSubMenu] ([IdSubMenu])
GO

