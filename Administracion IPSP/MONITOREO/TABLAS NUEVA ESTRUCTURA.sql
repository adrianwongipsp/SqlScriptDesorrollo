/*
DEPARTMENTS
USERINFO
Machines
acc_door
acc_reader
*/

CREATE TABLE Departamento(
ID int identity,
IdDepartamento int primary key,
Nombre varchar(500),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)

CREATE TABLE Usuario(
ID int identity,
IdUsuario int primary key,
Badgenumber int,
Nombres varchar(500),
Apellidos varchar(500),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)

CREATE TABLE Biometrico(
ID int identity,
IdBiometrico int primary key,
IP varchar(20),
Puerto varchar(20),
Baudrate bigint,
UserCount bigint,
FingerCount bigint,
FirmWareVersion varchar(200),
SerialNumber varchar(200),
DeviceName varchar(200),
Alias varchar(200),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)

CREATE TABLE LugarFisico(
ID int identity,
IdLugar int primary key,
NoLugar int,
Nombre varchar(200),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)
CREATE TABLE Evento(
ID int identity,
IdEvento int primary key,
Nombre varchar(200),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)

CREATE TABLE Turno (
IdTurno int primary key identity,
Descripcion varchar(200),
HoraInicio varchar(50),
HoraFin varchar(50),
HoraIngresoMin varchar(50),
HoraSalidaMax varchar(50),
TieneDiaSigt bit,
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)


CREATE TABLE TipoDescanso(
IdTipoDescanso int primary key identity,
Descripcion varchar(200),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)

CREATE TABLE Restriccion (
IdRestriccion int primary key identity,
Descripcion varchar(200),
Cantidad int,
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)
CREATE TABLE Descanso(
IdDescanso int primary key,
Descripcion varchar(200),
HoraInicio varchar(50),
HoraFin varchar(50),
Valor_Minutos int,
IdTipoDescanso int foreign key references TIPODESCANSO(IdTipoDescanso),
IdRestriccion int foreign key references RESTRICCION(IdRestriccion),
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime
)

CREATE TABLE DescansoXTurno(
IdTurno int,
IdDescanso int,
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime

PRIMARY KEY(IdTurno,IdDescanso),
FOREIGN KEY (IdTurno) REFERENCES TURNO(IdTurno),
FOREIGN KEY (IdDescanso) REFERENCES DESCANSO(IdDescanso),

)

CREATE TABLE UsuarioXTurno (
    IdUsuario int,
    IdTurno int,
    IdDescanso int,
	FechaTurnoAsignado datetime,
	Activo bit,
	UsuarioCreacion varchar(50),
	FechaCreacion datetime,
	UsuarioModificacion varchar(50),
	FechaModificacion datetime

    PRIMARY KEY (IdUsuario, IdTurno, IdDescanso),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
    FOREIGN KEY (IdTurno,IdDescanso) REFERENCES DescansoXTurno(IdTurno,IdDescanso)
);

CREATE TABLE UsuarioXTurnoLOG(
	IdLog int primary key IDENTITY,
	IdUsuario int,
    IdTurno int,    
	FechaTurnoAsignadoAnterior datetime,
	Activo bit,
	UsuarioCreacion varchar(50),
	FechaCreacion datetime
);


CREATE TABLE LugarXEvento(
IdBiometrico int,
IdLugar int,
IdEvento int,
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime

Primary key (IdBiometrico,IdLugar,IdEvento),
FOREIGN KEY (IdBiometrico) REFERENCES Biometrico(IdBiometrico),
FOREIGN KEY (IdLugar) REFERENCES LugarFisico(IdLugar),
FOREIGN KEY (IdEvento) REFERENCES Evento(IdEvento)
)


CREATE TABLE DepartamentoXBiometrico(
IdDepartamento int,
IdBiometrico int,
IdLugar int,
IdEvento int,
Activo bit,
UsuarioCreacion varchar(50),
FechaCreacion datetime,
UsuarioModificacion varchar(50),
FechaModificacion datetime

PRIMARY KEY (IdDepartamento, IdBiometrico,IdLugar,IdEvento),
FOREIGN KEY (IdDepartamento) REFERENCES Departamento(IdDepartamento),
FOREIGN KEY (IdBiometrico,IdLugar,IdEvento) REFERENCES LugarXEvento(IdBiometrico,IdLugar,IdEvento)
--FOREIGN KEY (IdBiometrico) REFERENCES Biometrico(IdBiometrico),
--FOREIGN KEY (IdLugar) REFERENCES LugarFisico(IdLugar),
--FOREIGN KEY (IdEvento) REFERENCES Evento(IdEvento)


)

CREATE TABLE UsuarioXMarcacion(
IdUsuario int,
IdDepartamento int,
IdBiometrico int,
IdLugar int,
IdEvento int,
Fecha datetime,
Hora time,
Duracion time,
Alerta bit,
TipoAlerta varchar(50),
PRIMARY KEY (IdUsuario, IdDepartamento, IdBiometrico,IdLugar,IdEvento,Fecha),
FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
FOREIGN KEY (IdDepartamento,IdBiometrico,IdLugar,IdEvento) REFERENCES DepartamentoXBiometrico(IdDepartamento,IdBiometrico,IdLugar,IdEvento)
)

/*
DROP TABLE UsuarioXMarcacion
DROP TABLE DepartamentoXBiometrico
DROP TABLE LugarXEvento
DROP TABLE UsuarioXTurno
DROP TABLE UsuarioXTurnoLOG
DROP TABLE DescansoXTurno
DROP TABLE Descanso
DROP TABLE Restriccion
DROP TABLE TipoDescanso
DROP TABLE Turno
DROP TABLE LugarFisico
DROP TABLE Biometrico
DROP TABLE Usuario
DROP TABLE Departamento

*/