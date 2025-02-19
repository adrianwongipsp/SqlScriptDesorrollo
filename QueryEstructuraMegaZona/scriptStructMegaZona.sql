GO

/****** Object:  Table [dbo].[parMegaZona]    Script Date: 05/02/2025 09:48:47 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[parMegaZona](
	[idMegaZona] [int] NOT NULL,
	[idDivision] [int] NOT NULL,
	[codigo] [char](2) NOT NULL,
	[nombre] [varchar](75) NOT NULL,
	[descripcion] [varchar](255) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioCreacion] [varchar](25) NOT NULL,
	[estacionCreacion] [varchar](75) NOT NULL,
	[fechaHoraCreacion] [datetime] NOT NULL,
	[usuarioModificacion] [varchar](25) NOT NULL,
	[estacionModificacion] [varchar](75) NOT NULL,
	[fechaHoraModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_parMegaZona] PRIMARY KEY CLUSTERED 
(
	[idMegaZona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_parMegaZona] UNIQUE NONCLUSTERED 
(
	[idDivision] ASC,
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[parMegaZona]  WITH CHECK ADD  CONSTRAINT [FK_parMegaZona_parDivision] FOREIGN KEY([idDivision])
REFERENCES [dbo].[parDivision] ([idDivision])
GO

ALTER TABLE [dbo].[parMegaZona] CHECK CONSTRAINT [FK_parMegaZona_parDivision]
GO


