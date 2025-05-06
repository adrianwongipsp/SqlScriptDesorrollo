USE [IPSPCamaroneraPre]
GO

/****** Object:  Table [dbo].[parMigracionLog]    Script Date: 5/5/2025 13:48:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[parMigracionLog]') AND type in (N'U'))
DROP TABLE [dbo].[parMigracionLog]
GO

/****** Object:  Table [dbo].[parMigracionLog]    Script Date: 5/5/2025 13:48:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[parMigracionLog](
	[estado] [varchar](30) NOT NULL,
	[mensaje] [varchar](500) NOT NULL,
	error_info [varchar](500) NULL,
	[fechaRegistro] [datetime] NOT NULL
) ON [PRIMARY]
GO


