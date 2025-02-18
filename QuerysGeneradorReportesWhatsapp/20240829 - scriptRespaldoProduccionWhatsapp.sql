USE [IPSPCamaroneraProduccion]
GO
/****** Object:  Table [dbo].[parGrupoWhatsapp]    Script Date: 29/08/2024 10:54:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[parGrupoWhatsapp](
	[idGrupoWhatsapp] [int] NOT NULL,
	[empresa] [char](2) NOT NULL,
	[division] [char](2) NOT NULL,
	[tipoTransaccion] [varchar](50) NOT NULL,
	[mensaje] [varchar](250) NOT NULL,
	[variable] [varchar](25) NULL,
	[frecuencia] [int] NOT NULL,
	[esquemaTransaccion] [varchar](5) NULL,
	[formatoGeneracion] [varchar](10) NULL,
	[unidadFrecuencia] [varchar](10) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioCreacion] [varchar](25) NOT NULL,
	[estacionCreacion] [varchar](75) NOT NULL,
	[fechaHoraCreacion] [datetime] NOT NULL,
	[usuarioModificacion] [varchar](25) NOT NULL,
	[estacionModificacion] [varchar](75) NOT NULL,
	[fechaHoraModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_parGrupoWhatsapp] PRIMARY KEY CLUSTERED 
(
	[idGrupoWhatsapp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[parGrupoWhatsappDetalle]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[parGrupoWhatsappDetalle](
	[idGrupoWhatsappDetalle] [int] NOT NULL,
	[idGrupoWhatsapp] [int] NULL,
	[orden] [int] NULL,
	[nivelGrupo] [varchar](10) NULL,
	[zona] [char](2) NULL,
	[camaronera] [varchar](5) NULL,
	[sector] [varchar](5) NULL,
	[jefeGrupo] [varchar](25) NULL,
	[codigoGrupo] [varchar](50) NULL,
	[enlaceGrupo] [varchar](50) NULL,
	[activo] [bit] NULL,
	[usuarioCreacion] [varchar](25) NULL,
	[estacionCreacion] [varchar](75) NULL,
	[fechaHoraCreacion] [datetime] NULL,
	[usuarioModificacion] [varchar](25) NULL,
	[estacionModificacion] [varchar](75) NULL,
	[fechaHoraModificacion] [datetime] NULL,
 CONSTRAINT [PK_GrupoWhatsappDetalle] PRIMARY KEY CLUSTERED 
(
	[idGrupoWhatsappDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[CatalogoGrupoWhatsappGenerator_ObtenerDatosGrupoWhatsappDetalle]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CatalogoGrupoWhatsappGenerator_ObtenerDatosGrupoWhatsappDetalle]
		@idGrupoWhatsapp INT,
		@codigoZona            VARCHAR(2),
		@codigoCamaronera      VARCHAR(5),
		@codigoSector          VARCHAR(5)
	AS
	BEGIN
		SELECT codigoGrupo 
		FROM   pargrupowhatsappdetalle 
		WHERE    
				 nivelGrupo       = 'ZONA'           and
				 idGrupoWhatsapp  = @idGrupoWhatsapp and 
				 zona			  = @codigoZona      
			 
		UNION all 
	
		SELECT codigoGrupo 
		FROM   pargrupowhatsappdetalle 
		WHERE    
				 nivelGrupo       = 'SECTOR'               and
				 idGrupoWhatsapp  = @idGrupoWhatsapp       and 
				 zona			  = @codigoZona			   and 
				 camaronera		  = @codigoCamaronera      and 
				 sector			  = @codigoSector 
	END
GO
/****** Object:  StoredProcedure [dbo].[CatalogoTipoTransaccionGenerator_ObtenerCatalogoAEliminar]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE    PROCEDURE [dbo].[CatalogoTipoTransaccionGenerator_ObtenerCatalogoAEliminar]
 AS
 BEGIN
 	     SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion 
				FROM (
					SELECT TOP 1 'pro' AS esquema, 'histogramaLongitud' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera
					FROM parParametro
					WHERE codigo = 'TESMHISTO'
				) AS TESM
				JOIN (
					SELECT TOP 1 'pro' AS esquema, 'histogramaLongitud' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion
					FROM parParametro
					WHERE codigo = 'TLEMHISTO'
				) AS TLEM
				ON TESM.esquema = TLEM.esquema
				AND TESM.tipoTransaccion = TLEM.tipoTransaccion
				AND TESM.formatoGeneracion = TLEM.formatoGeneracion

				 UNION

				SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion 
				FROM (
					SELECT TOP 1 'pro' AS esquema, 'histograma' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera
					FROM parParametro
					WHERE codigo = 'TESMHISTO'
				) AS TESM
				JOIN (
					SELECT TOP 1 'pro' AS esquema, 'histograma' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion
					FROM parParametro
					WHERE codigo = 'TLEMHISTO'
				) AS TLEM
				ON TESM.esquema = TLEM.esquema
				AND TESM.tipoTransaccion = TLEM.tipoTransaccion
				AND TESM.formatoGeneracion = TLEM.formatoGeneracion

			 	UNION  

				SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion 
				FROM (
					SELECT TOP 1 'pro' AS esquema, 'muestreoPoblacion' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera
					FROM parParametro
					WHERE codigo = 'TESMMPOB'
				) AS TESM
				JOIN (
					SELECT TOP 1 'pro' AS esquema, 'muestreoPoblacion' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion
					FROM parParametro
					WHERE codigo = 'TLEMMPOB'
				) AS TLEM
				ON TESM.esquema = TLEM.esquema
				AND TESM.tipoTransaccion = TLEM.tipoTransaccion
				AND TESM.formatoGeneracion = TLEM.formatoGeneracion
				 
				 			 	 UNION  

				SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion 
				FROM (
					SELECT TOP 1 'pro' AS esquema, 'muestreoPeso' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera
					FROM parParametro
					WHERE codigo = 'TESMMPESO'
				) AS TESM
				JOIN (
					SELECT TOP 1 'pro' AS esquema, 'muestreoPeso' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion
					FROM parParametro
					WHERE codigo = 'TLEMMPESO'
				) AS TLEM
				ON TESM.esquema = TLEM.esquema
				AND TESM.tipoTransaccion = TLEM.tipoTransaccion
				AND TESM.formatoGeneracion = TLEM.formatoGeneracion

			 	 UNION  

			    SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion 
				FROM (
					SELECT TOP 1 'pro' AS esquema, 'reporteParametrosAmbientalesDiaHora' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera
					FROM parParametro
					WHERE codigo = 'TESMREPAH'
				) AS TESM
				JOIN (
					SELECT TOP 1 'pro' AS esquema, 'reporteParametrosAmbientalesDiaHora' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion
					FROM parParametro
					WHERE codigo = 'TLEMPARH'
				) AS TLEM
				ON  TESM.esquema           = TLEM.esquema
				AND TESM.tipoTransaccion   = TLEM.tipoTransaccion
				AND TESM.formatoGeneracion = TLEM.formatoGeneracion 
 END

 
GO
/****** Object:  StoredProcedure [dbo].[CatalogoTipoTransaccionGenerator_ObtenerCatalogoDisponible]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE   PROCEDURE [dbo].[CatalogoTipoTransaccionGenerator_ObtenerCatalogoDisponible]  
 AS  
 BEGIN  
 
	  SELECT  esquemaTransaccion as esquema, 
			  tipoTransaccion, 
			  formatoGeneracion, 
			  frecuencia as tiempoEspera, 
			  30 as tiempoEliminacion, 
			  idGrupoWhatsapp 
		FROM  parGrupoWhatsapp 
		WHERE activo = 1

    --SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion, TESM.tiempoEspera, TLEM.tiempoEliminacion   
    --FROM (  
    -- SELECT TOP 1 'pro' AS esquema, 'histograma' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera  
    -- FROM parParametro  
    -- WHERE codigo = 'TESMHISTO'  
    --) AS TESM  
    --JOIN (  
    -- SELECT TOP 1 'pro' AS esquema, 'histograma' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion  
    -- FROM parParametro  
    -- WHERE codigo = 'TLEMHISTO'  
    --) AS TLEM  
    --ON TESM.esquema = TLEM.esquema  
    --AND TESM.tipoTransaccion = TLEM.tipoTransaccion  
    --AND TESM.formatoGeneracion = TLEM.formatoGeneracion  
       
    --UNION   
  
    --SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion   
    --FROM (  
    -- SELECT TOP 1 'pro' AS esquema, 'histogramaLongitud' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera  
    -- FROM parParametro  
    -- WHERE codigo = 'TESMHISTO'  
    --) AS TESM  
    --JOIN (  
    -- SELECT TOP 1 'pro' AS esquema, 'histogramaLongitud' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion  
    -- FROM parParametro  
    -- WHERE codigo = 'TLEMHISTO'  
    --) AS TLEM  
    --ON TESM.esquema = TLEM.esquema  
    --AND TESM.tipoTransaccion = TLEM.tipoTransaccion  
    --AND TESM.formatoGeneracion = TLEM.formatoGeneracion  
	 
	-- UNION    
  
    --SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion   
    --FROM (  
    -- SELECT TOP 1 'pro' AS esquema, 'muestreoPoblacion' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera  
    -- FROM parParametro  
    -- WHERE codigo = 'TESMMPOB'  
    --) AS TESM  
    --JOIN (  
    -- SELECT TOP 1 'pro' AS esquema, 'muestreoPoblacion' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion  
    -- FROM parParametro  
    -- WHERE codigo = 'TLEMMPOB'  
    --) AS TLEM  
    --ON TESM.esquema = TLEM.esquema  
    --AND TESM.tipoTransaccion = TLEM.tipoTransaccion  
    --AND TESM.formatoGeneracion = TLEM.formatoGeneracion  
       
     -- UNION    
  ---reporte de parametros de control
    --   SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion   
    --FROM (  
    -- SELECT TOP 1 'pro' AS esquema, 'reporteParametrosAmbientalesDiaHora' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera  
    -- FROM parParametro  
    -- WHERE codigo = 'TESMREPAH'  
    --) AS TESM  
    --JOIN (  
    -- SELECT TOP 1 'pro' AS esquema, 'reporteParametrosAmbientalesDiaHora' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion  
    -- FROM parParametro  
    -- WHERE codigo = 'TLEMPARH'  
    --) AS TLEM  
    --ON  TESM.esquema           = TLEM.esquema  
    --AND TESM.tipoTransaccion   = TLEM.tipoTransaccion  
    --AND TESM.formatoGeneracion = TLEM.formatoGeneracion   
 END   
 
 
GO
/****** Object:  StoredProcedure [dbo].[ObtenerDatosGrupoWhatsappDetalle]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[ObtenerDatosGrupoWhatsappDetalle]
		@idGrupoWhatsapp INT,
		@zona            VARCHAR(2),
		@camaronera      VARCHAR(5),
		@sector          VARCHAR(5)
	AS
	BEGIN
		SELECT codigoGrupo 
		FROM   pargrupowhatsappdetalle 
		WHERE    
				 nivelGrupo       = 'ZONA'           and
				 idGrupoWhatsapp  = @idGrupoWhatsapp and 
				 zona			  = @zona      
			 
		UNION 
	
		SELECT codigoGrupo 
		FROM   pargrupowhatsappdetalle 
		WHERE    
				 nivelGrupo       = 'SECTOR'         and
				 idGrupoWhatsapp  = @idGrupoWhatsapp and 
				 zona			  = @zona			 and 
				 camaronera		  = @camaronera      and 
				 sector			  = @sector 
	END
GO
/****** Object:  StoredProcedure [dbo].[ReporteGenerator_ObtenerDatosIniciales]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --EXEC  ReporteGenerator_ObtenerDatosIniciales 'reporteParametrosAmbientalesDiaHora' ,20240826
 --EXEC  ReporteGenerator_ObtenerDatosIniciales 'histogramaLongitud',9910 
  CREATE       PROCEDURE  [dbo].[ReporteGenerator_ObtenerDatosIniciales]
 	   @tipoTransaccion varchar(50),
	   @idImpresion     int
 AS
 BEGIN 
	 --declare @tipoTransaccion varchar(15)
	 --declare @idImpresion     int 
	 --set @tipoTransaccion = 'controlParametro'
	 --set @idImpresion = 2290

	 declare     @idActual     int 
	 if(@tipoTransaccion = 'histogramaLongitud')
	 begin
		select top 1 @idActual = ultimaSecuencia from proSecuencial where tabla = 'histograma'
	 end
	 else
	 begin
		select top 1 @idActual = ultimaSecuencia from proSecuencial where tabla = @tipoTransaccion
	 end

	 if(@tipoTransaccion = 'histograma')
	 begin
	  if(@idActual <> @idImpresion)
	  begin
		select @tipoTransaccion tipoTransaccion,empresa,  codigoZona as zona, codigoCamaronera as camaronera, codigoSector as sector, idHistograma as Id, '' as adicional
		 from proHistograma h inner join PiscinaUbicacion pu on pu.idPiscina = h.idPiscina
			where h.idHistograma > @idImpresion and estado = 'APR' and tipoHistograma ='PPROM'
	   end 
	 end

	if(@tipoTransaccion = 'histogramaLongitud')
	 begin
	  if(@idActual <> @idImpresion)
	  begin
		select @tipoTransaccion tipoTransaccion,empresa,  codigoZona as zona, codigoCamaronera as camaronera, codigoSector as sector, idHistograma as Id, '' as adicional
		 from proHistograma h inner join PiscinaUbicacion pu on pu.idPiscina = h.idPiscina
			where h.idHistograma > @idImpresion and estado = 'APR'  and tipoHistograma ='PLONG'
	   end 
	 end

	 if(@tipoTransaccion = 'muestreoPeso')
	 begin
	  if(@idActual <> @idImpresion)
	  begin
		select @tipoTransaccion tipoTransaccion,empresa, division,   zona,  camaronera, sector, idMuestreo as Id, '' as adicional
		 from proMuestreoPeso p 
			where p.idMuestreo > @idImpresion and estado = 'APR'
	   end 
	 end

	 if(@tipoTransaccion = 'muestreoPoblacion')
	 begin
	  if(@idActual <> @idImpresion)
	  begin
		select @tipoTransaccion tipoTransaccion,empresa, division,  zona,  camaronera, sector, idMuestreo as Id, '' as adicional
		 from proMuestreoPoblacion p 
			where p.idMuestreo > @idImpresion and estado = 'APR'
	   end 
	 end

	 if(@tipoTransaccion = 'controlParametro')
	 begin
	  if(@idActual <> @idImpresion)
	  begin
		select @tipoTransaccion tipoTransaccion,empresa, division,   zona,  camaronera, sector, idControlParametro as id, '' as adicional
		 from proControlParametro p 
			where p.idControlParametro > @idImpresion and estado = 'APR'
	   end 
	 end
	   
	 if(@tipoTransaccion = 'reporteParametrosAmbientalesDiaHora')
	 begin
		 declare @fechaActual Date
		 select  @fechaActual =  getdate() 
		 select  @idActual    = year(@fechaActual) * 10000 + month(@fechaActual) * 100 + day(@fechaActual)  

		  --if(@idActual >= @idImpresion)
		  begin

		    SELECT P.* 
				INTO #tmp_r_proControlParametro
			FROM	( 
					select empresa,	    division,			zona,	camaronera, sector, fechaControl, 
						   horaControl, idControlParametro, 'PRE01' AS adicional  
					from proControlParametro where fechaControl = @fechaActual and estado = 'APR' 
						union
					select empresa,	    division,			zona,	camaronera, sector, fechaControl, 
						   horaControl, idControlParametro, 'ENG01' AS adicional  
					from proControlParametro where fechaControl = @fechaActual and estado = 'APR'
					) AS P;

			select   e.codigo, 
			         e.descripcion 
					 into #horas
				from parCatalogo c inner join parElementoCatalogo e on c.idCatalogo = e.idCatalogo
				where c.codigo ='maeHorasControl';

			WITH tmpw_r_proControlParametro AS (
				SELECT empresa, division, zona, camaronera, sector, fechaControl, horaControl, idControlParametro, adicional,
					   ROW_NUMBER() OVER (PARTITION BY empresa, division, zona, camaronera, sector, fechaControl, adicional
											ORDER BY fechaControl DESC, horaControl DESC) AS rn
				FROM #tmp_r_proControlParametro
			)
			SELECT @tipoTransaccion tipoTransaccion, empresa, division, zona, camaronera, sector,
			h.descripcion as horaControl, @idActual as id, adicional --idControlParametro as id
			, CONVERT(VARCHAR(10), CAST(fechaControl AS DATE), 103) as fechaControl
			FROM tmpw_r_proControlParametro cp inner join #horas h on h.codigo = cp.horaControl 
			WHERE rn = 1
			ORDER BY empresa, division,zona,camaronera, sector, adicional;
	   end 
	 end
 END 
GO
/****** Object:  StoredProcedure [dbo].[ReporteGenerator_ObtenerVistas]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --exec  ReporteGenerator_ObtenerVistas  'muestreoPoblacion'
 CREATE        PROCEDURE [dbo].[ReporteGenerator_ObtenerVistas]
	 @tipoTransaccion varchar(50)
 AS
 BEGIN
	 IF(@tipoTransaccion = 'histograma')
	 BEGIN
	   SELECT '/Procesos/histograma/reportPDF?empresa=@empresa&numeroHistograma=@id&usuario=@usuario&reportCommand=@reportCommand' as ViewWebUrl
	 END 
	 IF(@tipoTransaccion = 'histogramaLongitud')
	 BEGIN
	   SELECT '/Procesos/histogramaLonguitud/reportPDF?empresa=@empresa&numeroHistograma=@id&usuario=@usuario&reportCommand=@reportCommand' as ViewWebUrl
	 END  	 
	 IF(@tipoTransaccion = 'muestreoPoblacion')
	 BEGIN
	   SELECT '/Procesos/muestreoPoblacion/reportPDF?empresa=@empresa&numeroMuestreo=@id&usuario=@usuario&reportCommand=@reportCommand' as ViewWebUrl
	 END  
	 IF(@tipoTransaccion = 'muestreoPeso')
	 BEGIN
	   SELECT '/Procesos/muestreoPeso/reportPDF?empresa=@empresa&numeroMuestreo=@id&usuario=@usuario&reportCommand=@reportCommand' as ViewWebUrl
	 END 
	 IF(@tipoTransaccion = 'reporteParametrosAmbientalesDiaHora')
	 BEGIN
	   SELECT '/Procesos/reporteParametrosAmbientalesDia/reportHoraPDF?empresa=@empresa&division=@division&zona=@zona&camaronera=@camaronera&sector=@sector' +
					'&fecha=@fecha&estado=@estado&tipoReporte=@tipoReporte&codigoRolPiscina=@codigoRolPiscina&reportCommand=@reportCommand' +
					'&userDescripcion=@userDescripcion&showHeaderEveryPage=@showHeaderEveryPage' as ViewWebUrl
	 END 
 END 

GO
/****** Object:  StoredProcedure [dbo].[SecuencialGenerator_ObtenerIdActual]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  CREATE     PROCEDURE [dbo].[SecuencialGenerator_ObtenerIdActual]
	 @esquema         varchar(3),
 	 @tipoTransaccion varchar(50)
 AS
 BEGIN 
	 IF(@esquema = 'pro')
	 BEGIN
	   if(@tipoTransaccion = 'reporteParametrosAmbientalesDiaHora' )
		begin
			SELECT year(GETDATE())*10000 + MONTH(GETDATE())*100 + DAY(GETDATE()) as ultimaSecuencia 
		end
		else if(@tipoTransaccion = 'histograma' )
		begin
			SELECT MAX(idHistograma) as ultimaSecuencia FROM proHistograma WHERE tipoHistograma ='PPROM'  
		end
        else if(@tipoTransaccion = 'histogramaLongitud' )
		begin
			SELECT MAX(idHistograma) as ultimaSecuencia FROM proHistograma WHERE tipoHistograma ='PLONG'
		end
		else
		begin
			SELECT ultimaSecuencia from proSecuencial where tabla = @tipoTransaccion
		end 
	 END 
 END
GO
/****** Object:  StoredProcedure [dbo].[UbicacionGenerator_ObtenerDatosConsulta]    Script Date: 29/08/2024 10:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE     PROCEDURE [dbo].[UbicacionGenerator_ObtenerDatosConsulta]
	@codigoZona       varchar(2) = null, 
	@codigoCamaronera varchar(10)= null,
	@codigoSector     varchar(10)= null
 as
 begin 
	select distinct codigoZona, nombreZona , codigoCamaronera, nombreCamaronera, codigoSector,nombreSector, idSector, idCamaronera, idZona
	from PiscinaUbicacion where          codigoZona       = coalesce(@codigoZona ,codigoZona)
									 and codigoCamaronera = coalesce(@codigoCamaronera,codigoCamaronera)
									 and codigoSector     = coalesce(@codigoSector,codigoSector)
 end
GO
