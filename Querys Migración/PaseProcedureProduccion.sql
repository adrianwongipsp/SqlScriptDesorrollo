USE [IPSPCamaroneraTesting]
GO
/****** Object:  StoredProcedure [dbo].[viewProcessCiclos]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[viewProcessCiclos]
GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTMOVIMIENTOTRANSFERENCIAS]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_SCRIPTMOVIMIENTOTRANSFERENCIAS]
GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTMOVIMIENTORECEPCIONES]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_SCRIPTMOVIMIENTORECEPCIONES]
GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTINSERTTRANSFERENCIASDESTINO]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_SCRIPTINSERTTRANSFERENCIASDESTINO]
GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTINSERTRECEPCIONES]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_SCRIPTINSERTRECEPCIONES]
GO
/****** Object:  StoredProcedure [dbo].[USP_REGULARIZACIONCICLOSEXCEL]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_REGULARIZACIONCICLOSEXCEL]
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERTEJECUCIONINITIAL]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_INSERTEJECUCIONINITIAL]
GO
/****** Object:  StoredProcedure [dbo].[usp_FiltrarPiscinaMontadasPorSector]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[usp_FiltrarPiscinaMontadasPorSector]
GO
/****** Object:  StoredProcedure [dbo].[USP_ANULARTRANSFERENCIASSOBRANTES]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[USP_ANULARTRANSFERENCIASSOBRANTES]
GO
/****** Object:  StoredProcedure [dbo].[usp_ActualizarSoloCiclos]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[usp_ActualizarSoloCiclos]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_TRANSFERENCIA]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_TRANSFERENCIA]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_RECEPCION]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_RECEPCION]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_POBLACION]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_POBLACION]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_PESO]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_PESO]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_COSECHAS]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_COSECHAS]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_CONTROL]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_CONTROL]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_PESCA_CIERRE_HISTORIAL]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_CREATE_PESCA_CIERRE_HISTORIAL]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_PESCA_CIERRE_FINAL]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_CREATE_PESCA_CIERRE_FINAL]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_CYCLES_FINALLY]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_CREATE_CYCLES_FINALLY]
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_CYCLES_FINAL]    Script Date: 20/06/2024 14:56:10 ******/
DROP PROCEDURE [dbo].[PROCESS_CREATE_CYCLES_FINAL]
GO
/****** Object:  View [dbo].[SectoresUbicacion]    Script Date: 20/06/2024 14:56:10 ******/
DROP VIEW [dbo].[SectoresUbicacion]
GO
/****** Object:  View [dbo].[EjecucionesPiscinaViewEstructura]    Script Date: 20/06/2024 14:56:10 ******/
DROP VIEW [dbo].[EjecucionesPiscinaViewEstructura]
GO
/****** Object:  View [dbo].[EjecucionesPiscinaView]    Script Date: 20/06/2024 14:56:10 ******/
DROP VIEW [dbo].[EjecucionesPiscinaView]
GO
/****** Object:  View [dbo].[CATALOGO_ELEMENTS]    Script Date: 20/06/2024 14:56:10 ******/
DROP VIEW [dbo].[CATALOGO_ELEMENTS]
GO
/****** Object:  View [dbo].[EjecucionesKey]    Script Date: 20/06/2024 14:56:10 ******/
DROP VIEW [dbo].[EjecucionesKey]
GO
/****** Object:  View [dbo].[PiscinaUbicacion]    Script Date: 20/06/2024 14:56:10 ******/
DROP VIEW [dbo].[PiscinaUbicacion]
GO
/****** Object:  View [dbo].[PiscinaUbicacion]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view  [dbo].[PiscinaUbicacion] as       
select z.codigo as codigoZona, z.nombre as nombreZona,      
    c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,      
    s.codigo as codigoSector    , s.nombre as nombreSector,      
    p.codigo as codigoPiscina   , p.nombre as nombrePiscina,      
    p.superficieValor,     
 p.superficieUnidad,     
 p.idPiscina  ,    
 s.idSector   ,    
 s.idCamaronera ,    
 z.idZona   ,  
 replace(s.nombre +  p.nombre, ' ', '')  KeyPiscina  ,
 p.profundidadValor,     
 p.profundidadUnidad
from parZona z inner join parCamaronera c on c.idZona = z.idZona      
      inner join parSector     s on s.idCamaronera = c.idCamaronera       
      inner join maePiscina    p on p.zona = z.codigo and p.camaronera = c.codigo and p.sector = s.codigo      
where  z.activo = 1 and c.activo = 1 and s.activo =1 and p.activo = 1
GO
/****** Object:  View [dbo].[EjecucionesKey]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[EjecucionesKey] as 
	select pu.nombreSector + pu.nombrePiscina + '.' + CONVERT(varchar(10), pe.ciclo) as Cod_Ciclo, pu.nombreSector + pu.nombrePiscina as KeyUnit, 
	CONVERT(varchar(10), pe.fechaInicio, 126) as fecha_Inicio, pu.nombreZona, pu.nombreCamaronera, pu.nombreSector, pu.nombrePiscina, ec.nombre, pe.ciclo, 
	CONVERT(VARCHAR(10), pe.fechaSiembra, 126) as fecha_Siembra, CONVERT(VARCHAR(10), pe.fechaCierre, 126) as fecha_Cierre, pe.cantidadEntrada,
	pe.idPiscinaEjecucion, pe.idPiscina
	from proPiscinaEjecucion pe
	inner join PiscinaUbicacion pu on pe.idPiscina = pu.idPiscina
	inner join parElementoCatalogo ec on ec.idCatalogo = 5 and ec.codigo = pe.rolPiscina
	 

GO
/****** Object:  View [dbo].[CATALOGO_ELEMENTS]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
create view [dbo].[CATALOGO_ELEMENTS] as  
select ca.idCatalogo, ca.codigo as codigoCatalogo, ca.nombre as nombreCatalogo, ec.codigo as codigoElemento, ec.nombre as nombreElemento  from parElementoCatalogo ec  
inner join parCatalogo ca on ec.idCatalogo = ca.idCatalogo  
where ca.activo = 1 and ec.activo = 1  
GO
/****** Object:  View [dbo].[EjecucionesPiscinaView]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[EjecucionesPiscinaView] as
select zo.nombre +' '+ ca.nombre +' '+ se.nombre +' '+ pis.nombre as Piscina,   pis.idPiscina, pej.idPiscinaEjecucion,   
pej.ciclo as Ciclo, pej.fechaInicio as FechaInicio, pej.fechaSiembra as FechaSiembra, pej.fechaCierre as FechaCierre,   pej.cantidadEntrada as CantidadEntrada,   pej.cantidadSalida as CantidadSalida,  pej.cantidadPerdida as CantidadPerdida, 
pej.estado,REPLACE(se.nombre,' ','') + pis.nombre as keyPiscina, 
REPLACE(se.nombre,' ','') + pis.nombre+'.'+ cast(pej.ciclo as varchar(10)) as cod_ciclo,  pej.idPiscinaEjecucionSiguiente, REPLACE(se.nombre,' ','') AS nombreSector, rolPiscina, tipoCierre
from parZona zo inner join parCamaronera ca on zo.idZona = ca.idZona 
inner join parSector se on ca.idCamaronera = se.idCamaronera 
inner join maePiscina pis on zo.codigo = pis.zona and ca.codigo = pis.camaronera and se.codigo = pis.sector 
inner join proPiscinaEjecucion pej on pis.idPiscina = pej.idPiscina 
left join parElementoCatalogo ec on ec.codigo = pej.rolPiscina and ec.idCatalogo = 5 where pej.estado in ('INI','EJE','PRE','CER','ANU') AND zo.activo = 1 and ca.activo = 1 and se.activo = 1 and PIS.activo = 1 and pej.activo = 1

GO
/****** Object:  View [dbo].[EjecucionesPiscinaViewEstructura]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[EjecucionesPiscinaViewEstructura]
as
select zo.nombre +' '+ ca.nombre +' '+ se.nombre +' '+ pis.nombre as Piscina,   
pis.idPiscina, 
pej.idPiscinaEjecucion,   
pej.ciclo           as Ciclo, 
pej.fechaInicio     as FechaInicio, 
pej.fechaSiembra    as FechaSiembra, 
pej.fechaCierre     as FechaCierre,   
pej.cantidadEntrada as CantidadEntrada,   
pej.cantidadSalida  as CantidadSalida,  
pej.cantidadPerdida as CantidadPerdida, 
pej.estado,REPLACE(se.nombre,' ','') + pis.nombre as keyPiscina, 
REPLACE(se.nombre,' ','') + pis.nombre+'.'+ cast(pej.ciclo as varchar(10)) as cod_ciclo,  
pej.idPiscinaEjecucionSiguiente, 
REPLACE(se.nombre,' ','') as nombreSector, 
rolPiscina, 
tipoCierre,
zo.codigo as codigoZona, 
ca.codigo as codigoCamaronera, 
se.codigo as codigoSector,
pis.nombre as nombrePiscina
from parZona zo inner join parCamaronera ca on zo.idZona = ca.idZona 
inner join parSector se on ca.idCamaronera = se.idCamaronera 
inner join maePiscina pis on zo.codigo = pis.zona and ca.codigo = pis.camaronera and se.codigo = pis.sector 
inner join proPiscinaEjecucion pej on pis.idPiscina = pej.idPiscina 
left join parElementoCatalogo ec on ec.codigo = pej.rolPiscina and ec.idCatalogo = 5
where pej.estado in ('INI','EJE','PRE','CER','ANU') AND zo.activo = 1 and ca.activo = 1 
and se.activo = 1 and PIS.activo = 1 and pej.activo = 1
GO
/****** Object:  View [dbo].[SectoresUbicacion]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view  [dbo].[SectoresUbicacion] as   
select z.codigo as codigoZona, z.nombre as nombreZona,  
    c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,  
    s.codigo as codigoSector    , s.nombre as nombreSector,  
	s.idSector   ,
	s.idCamaronera ,
	z.idZona 
from parZona z inner join parCamaronera c on c.idZona = z.idZona  
      inner join parSector     s on s.idCamaronera = c.idCamaronera    
where  z.activo = 1 and c.activo = 1 and s.activo =1
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_CYCLES_FINAL]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
          
               
/*              
    Stored Procedure: PROCESS_CREATE_CYCLES              
    Author: Adrian Wong Macías              
    Created Date: 2024-05-22              
    Description: Proceso de creación de ejecuciones y ciclos.              
                
    Revision History:              
        Date        Author           Description              
        2024-05-22  Adrian Wong      Inicio              
*/              
CREATE PROCEDURE [dbo].[PROCESS_CREATE_CYCLES_FINAL]              
  @idPiscina int ,              
  @usuario varchar(10),              
  @fechaProceso datetime,              
  @displayContent bit,              
  @idPicinaEjecucionCierre int output              
AS              
BEGIN               
  /*declare  @idPiscina int ,              
    @usuario varchar(10),              
    @fechaProceso datetime,              
    @displayContent bit,              
    @idPicinaEjecucionCierre int              
 select @idPiscina = 2002, @usuario='AdminPsCam', @fechaProceso = GETDATE() , @displayContent = 1   */          
              
 -- Drop the temporary table if it exists              
 IF OBJECT_ID('tempdb..#ciclo_regularizar') IS NOT NULL              
     DROP TABLE #ciclo_regularizar;              
              
 -- Create and populate the temporary table              
 SELECT                
  ROW_NUMBER() OVER (ORDER BY ori_c.ciclo DESC) AS rn,              
  p.idPiscina,              
  ej.ciclo,               
  ej.FechaSiembra,               
  ej.fechaInicio,               
  ej.fechaCierre,               
  ej.idPiscinaEjecucion,               
  ej.cantidadEntrada,               
  ej.cantidadSalida,               
  ej.cantidadPerdida,               
  ori_c.Ciclo AS CicloOrigen,              
  ori_c.[Fecha_IniSec] AS fechaInicioOrigen,              
  ori_c.[Fecha_Siembra] AS fechaSiembraOrigen,               
  IIF(ori_c.[Fecha_Pesca] <> '', CAST(ori_c.[Fecha_Pesca] AS DATE), NULL) AS fechaPescaOrigen,               
  ori_c.[Fecha_Pesca] AS fechaTransferenciaOrigen,              
  ori_c.[Cantidad_Sembrada] AS cantidadSembradaOrigen,              
  ori_c.Tipo AS rolOrigen,              
  mp.lote              
   INTO #ciclo_regularizar              
 FROM [dbo].[CICLOS_PRODUCCION] ori_c              
 inner join PiscinaUbicacion p on p.KeyPiscina = ori_c.Key_Piscina           
 inner join maePiscina mp on mp.idPiscina = p.idPiscina            
 LEFT JOIN proPiscinaEjecucion ej ON P.idPiscina     = ej.idPiscina                
  AND ori_c.[Fecha_Siembra] >= DATEADD(day, -2, ej.FechaSiembra) --ej.FechaSiembra                 
  AND ori_c.[Fecha_Siembra] <= DATEADD(day, 1, ej.FechaSiembra)              
 WHERE p.idPiscina = @idPiscina              
 AND ori_c.Ciclo >= (              
   SELECT MIN(ej2.Ciclo)              
   FROM EjecucionesPiscinaView ej2              
   WHERE  ej2.estado in ('EJE', 'PRE') AND ej2.keyPiscina = ori_c.Key_Piscina          
  )              
  DECLARE  @keyPiscina VARCHAR(30)  
 SELECT TOP 1 @keyPiscina = keyPiscina FROM PiscinaUbicacion WHERE idPiscina= @idPiscinA    
 -- Display the contents of the temporary table              
 IF(@displayContent = 1)              
 BEGIN      
  SELECT 'ARCHIVO' AS TABLA, * FROM #ciclo_regularizar              
  SELECT 'ANTES proPiscinaEjecucion: '+ @keyPiscina AS TABLA, * FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina ORDER BY ciclo              
  --SELECT 'ANTES maePiscinaCiclo'     AS TABLA, * FROM maePiscinaCiclo     WHERE idPiscina = @idPiscina ORDER BY ciclo              
 END           
 -- Declare variables              
 DECLARE @secuencialPiscinaEjecucion INT               
 DECLARE @secuencialPiscinaCiclo INT              
 DECLARE @secuencialPiscinaEjecucionSiguiente INT               
 DECLARE @rn INT              
 DECLARE @cicloPivot  int               
 SET @rn = 0              
              
 --BEGIN TRAN              
              
 -- Check if there are any remaining rows in the temporary table              
    -- Continue processing as long as there are rows in #ciclo_regularizar              
 WHILE EXISTS (SELECT TOP 1 1 FROM #ciclo_regularizar)              
 BEGIN              
     --set cursor variable              
  SELECT TOP 1 @rn = rn FROM #ciclo_regularizar ORDER BY rn                
                
  --Insert new register (fisrt conditional)              
  IF NOT EXISTS (              
   SELECT TOP 1 rn               
   FROM proPiscinaEjecucion pe               
   INNER JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion              
   WHERE rn = @rn              
  )              
  BEGIN              
   PRINT '1'              
   UPDATE proSecuencial               
   SET ultimaSecuencia = ultimaSecuencia + 1                
   WHERE tabla = 'piscinaEjecucion'              
              
   SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia               
   FROM proSecuencial               
   WHERE tabla = 'piscinaEjecucion'              
              
   SET @secuencialPiscinaEjecucionSiguiente = NULL               
   -- select @rn          
   SELECT @cicloPivot =  cr.CicloOrigen FROM #ciclo_regularizar cr  WHERE cr.rn = @rn              
                 
   INSERT INTO proPiscinaEjecucion (              
    idPiscinaEjecucion, idPiscina, ciclo, rolPiscina, numEtapa, lote, fechaInicio,               
    fechaSiembra, fechaCierre, tipoCierre, idEspecie, cantidadEntrada, cantidadAdicional,               
    cantidadSalida, cantidadPerdida, idPiscinaEjecucionSiguiente, estado, tieneRaleo,               
    tieneRepanio, tieneCosecha, activo, usuarioCreacion, estacionCreacion, fechaHoraCreacion,               
    usuarioModificacion, estacionModificacion, fechaHoraModificacion              
   )              
   SELECT               
    @secuencialPiscinaEjecucion, cr.idPiscina, cr.CicloOrigen,              
    CASE               
     WHEN cr.rolOrigen = 'PRECRIADERO' THEN 'PRE01'               
     WHEN cr.rolOrigen = 'PISCINA' THEN 'ENG01'               
     ELSE 'ENG01'               
    END,               
    1,               
    cr.lote, fechaInicioOrigen, fechaSiembraOrigen, fechaPescaOrigen,               
    CASE               
     WHEN cr.fechaPescaOrigen IS NOT NULL THEN 'PES'                
     WHEN cr.fechaTransferenciaOrigen IS NOT NULL THEN 'TRA'               
     ELSE ''                
    END,               
    CASE               
     WHEN cr.fechaPescaOrigen IS NOT NULL THEN 1                 
     WHEN cr.fechaTransferenciaOrigen IS NOT NULL THEN 1                  
     ELSE 1                
    END,                
    ISNULL(cantidadSembradaOrigen, 0), 0, 0,              
    0, @secuencialPiscinaEjecucionSiguiente,              
    CASE               
     WHEN fechaPescaOrigen IS NULL THEN 'EJE'               
     ELSE 'PRE'               
    END,              
    0, 0, 0,              
    1, @Usuario, '::3', @fechaProceso, @usuario, '::3', @fechaProceso              
   FROM #ciclo_regularizar cr               
   WHERE cr.rn = @rn              
              
   UPDATE maeSecuencial               
   SET ultimaSecuencia = ultimaSecuencia + 1                
   WHERE tabla = 'piscinaCiclo'              
              
   SELECT TOP 1 @secuencialPiscinaCiclo = ultimaSecuencia               
   FROM maeSecuencial               
   WHERE tabla = 'piscinaCiclo'              
              
   INSERT INTO maePiscinaCiclo (              
    idPiscinaCiclo, idPiscina, ciclo, fecha, origen, idOrigen,               
    idOrigenEquivalente, rolCiclo, activo, usuarioCreacion,               
    estacionCreacion, fechaHoraCreacion, usuarioModificacion,               
    estacionModificacion, fechaHoraModificacion     
   )              
   SELECT               
    @secuencialPiscinaCiclo, cr.idPiscina, cr.CicloOrigen, cr.fechaInicioOrigen,               
    'EJE', @secuencialPiscinaEjecucion, NULL,               
    CASE               
     WHEN cr.rolOrigen = 'PRECRIADERO' THEN 'PRE01'               
     WHEN cr.rolOrigen = 'PISCINA' THEN 'ENG01'               
     ELSE 'ENG01'               
    END,               
    1, @Usuario, '::3', @fechaProceso, @usuario, '::3', @fechaProceso              
   FROM #ciclo_regularizar cr               
   WHERE cr.rn = @rn              
              
  END              
  ELSE  --Update old register (second conditional)              
  BEGIN              
   PRINT '2'               
   UPDATE pe               
   SET               
    pe.cantidadEntrada = cr.cantidadSembradaOrigen,              
    pe.fechaCierre = cr.fechaPescaOrigen,              
    --pe.tipoCierre = CASE               
    -- WHEN cr.fechaPescaOrigen IS NOT NULL THEN 'PES'                
    -- WHEN cr.fechaTransferenciaOrigen IS NOT NULL THEN 'TRA'               
    -- ELSE ''                
    --END,              
     pe.tipoCierre = CASE               
     WHEN cr.rolOrigen ='PISCINA' THEN 'PES'                
     WHEN cr.rolOrigen ='PRECRIADERO' THEN 'TRA'            
     ELSE ''                
    END,              
    pe.estado = CASE               
     WHEN cr.fechaPescaOrigen IS NOT NULL THEN 'PRE'                
     WHEN cr.fechaTransferenciaOrigen IS NOT NULL THEN 'PRE'               
     ELSE 'EJE'               
    END,              
    --pe.cantidadPerdida = cr.cantidadSembradaOrigen + pe.cantidadAdicional - pe.cantidadSalida,              
  pe.cantidadPerdida = CASE       
        WHEN cr.cantidadSembradaOrigen + pe.cantidadAdicional - pe.cantidadSalida < 0 THEN 0       
        ELSE cr.cantidadSembradaOrigen + pe.cantidadAdicional - pe.cantidadSalida       
    END,       
    pe.idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucionSiguiente,              
    pe.usuarioModificacion = @usuario,              
    pe.estacionModificacion = '::2',              
    pe.fechaHoraModificacion = @fechaProceso,              
    pe.ciclo = cr.CicloOrigen              
   FROM proPiscinaEjecucion pe               
   INNER JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion               
   WHERE rn = @rn              
              
   UPDATE pc               
   SET               
    pc.ciclo = pe.ciclo,              
    pc.usuarioModificacion = @usuario,              
    pc.estacionModificacion = '::2',              
    pc.fechaHoraModificacion = @fechaProceso              
   FROM proPiscinaEjecucion pe               
   INNER JOIN maePiscinaCiclo pc ON pe.idPiscina = pc.idPiscina AND pe.idPiscinaEjecucion = pc.idOrigen              
   INNER JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion               
   WHERE rn = @rn              
  END              
              
  --move cursor with delete row in while setence              
  DELETE FROM #ciclo_regularizar WHERE rn = @rn              
 END;              
              
 WITH CTE_PiscinaEjecucion AS (              
    SELECT              
  idPiscina,              
        idPiscinaEjecucion,              
        idPiscinaEjecucionSiguiente,              
  LEAD(IdPiscinaEjecucion) OVER (ORDER BY IdPiscinaEjecucion) AS NextIdPiscinaEjecucion              
    FROM              
        proPiscinaEjecucion              
  where idPiscina = @idPiscina and ciclo >0             
 )               
 UPDATE CTE_PiscinaEjecucion              
 SET idPiscinaEjecucionSiguiente = NextIdPiscinaEjecucion              
 where idPiscina = @idPiscina ;                
              
           
 select top 1 @idPicinaEjecucionCierre = idPiscinaEjecucion from proPiscinaEjecucion where idPiscina = @idPiscina and ciclo = @cicloPivot-1              
               
 -- Display the updated contents of the tables              
 IF(@DisplayContent = 1)              
 BEGIN            
     SELECT  @cicloPivot-1 AS cicloCerrar, @idPicinaEjecucionCierre AS idPicinaEjecucionCerrar              
  --SELECT 'DESPUES proPiscinaEjecucion' AS TABLA, * FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina ORDER BY ciclo              
  --SELECT 'DESPUES maePiscinaCiclo'     AS TABLA, * FROM maePiscinaCiclo     WHERE idPiscina = @idPiscina ORDER BY ciclo              
 END              
                 
   --- ROLLBACK TRAN -- Uncomment this line if you need to rollback the transaction              
 -- COMMIT TRAN   -- Uncomment this line to commit the transaction              
END 

 
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_CYCLES_FINALLY]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[PROCESS_CREATE_CYCLES_FINALLY]                      
  @idPiscina  int ,                      
  @usuario   varchar(10),                      
  @fechaProceso  datetime,                      
  @displayContent bit,          
  @rangoDiasSiembra int,
  @idPicinaEjecucionCierre int output                      
AS                      
BEGIN     

--declare     @idPiscina int ,                      
--            @usuario varchar(10),                      
--            @fechaProceso datetime,                      
--            @displayContent bit,                      
--            @idPicinaEjecucionCierre int,
--			@rangoDiasSiembra int
			
-- select @idPiscina = 464, @usuario='AdminPsCam', @fechaProceso = GETDATE() , @displayContent = 1, @rangoDiasSiembra = 5
                      
 -- Drop the temporary table if it exists                      
 IF OBJECT_ID('tempdb..#ciclo_regularizar') IS NOT NULL                      
     DROP TABLE #ciclo_regularizar;                      
                      
 -- Create and populate the temporary table                      
 SELECT                        
  ROW_NUMBER() OVER (ORDER BY ori_c.ciclo DESC) AS rn,                      
  p.idPiscina,                      
  ej.ciclo,                       
  ej.FechaSiembra,                       
  ej.fechaInicio,                       
  ej.fechaCierre,                       
  ej.idPiscinaEjecucion,                       
  ej.cantidadEntrada,                       
  ej.cantidadSalida,                       
  ej.cantidadPerdida,                       
  ori_c.Ciclo AS CicloOrigen,                      
  ori_c.[Fecha_IniSec] AS fechaInicioOrigen,                      
  ori_c.[Fecha_Siembra] AS fechaSiembraOrigen,                       
  IIF(ori_c.[Fecha_Pesca] <> '', CAST(ori_c.[Fecha_Pesca] AS DATE), NULL) AS fechaPescaOrigen,                       
  IIF(ori_c.[Fecha_Pesca] <> '', CAST(ori_c.[Fecha_Pesca] AS DATE), NULL) AS fechaTransferenciaOrigen,                      
  ori_c.[Cantidad_Sembrada] AS cantidadSembradaOrigen,                      
  ori_c.Tipo AS rolOrigen,                      
  mp.lote                      
   INTO #ciclo_regularizar                      
 FROM [dbo].[CICLOS_PRODUCCION] ori_c                      
 inner join PiscinaUbicacion p on p.keyPiscina = ori_c.Key_Piscina  
 inner join maePiscina mp on mp.idPiscina = p.idPiscina  
 LEFT JOIN proPiscinaEjecucion ej ON P.idPiscina     = ej.idPiscina  
 --AND DATEDIFF(day, ori_c.[Fecha_Siembra], ej.FechaSiembra) BETWEEN -100 AND 100  
  AND ori_c.[Fecha_Siembra] >= DATEADD(day, -@rangoDiasSiembra, ej.FechaSiembra)  
  AND ori_c.[Fecha_Siembra] <= DATEADD(day,  @rangoDiasSiembra, ej.FechaSiembra)  
 WHERE p.idPiscina = @idPiscina  
 AND ori_c.Ciclo >= (  
   SELECT MIN(ej2.Ciclo)  
   FROM EjecucionesPiscinaView ej2  
   WHERE  ej2.estado in ('EJE', 'PRE') AND ej2.keyPiscina = ori_c.Key_Piscina  
  )             
    
  DECLARE  @keyPiscina VARCHAR(30)          
 SELECT TOP 1 @keyPiscina = keyPiscina FROM PiscinaUbicacion WHERE idPiscina= @idPiscinA            
 -- Display the contents of the temporary table                      
 IF(@displayContent = 1)                      
 BEGIN              
  SELECT 'ARCHIVO' AS TABLA, * FROM #ciclo_regularizar                      
  SELECT 'ANTES proPiscinaEjecucion: '+ @keyPiscina AS TABLA, * FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina ORDER BY ciclo                      
  --SELECT 'ANTES maePiscinaCiclo'     AS TABLA, * FROM maePiscinaCiclo     WHERE idPiscina = @idPiscina ORDER BY ciclo                      
 END                   
 -- Declare variables                      
 DECLARE @secuencialPiscinaEjecucion INT                       
 DECLARE @secuencialPiscinaCiclo INT                   
 DECLARE @secuencialPiscinaEjecucionSiguiente INT           
 DECLARE @rn INT        
 DECLARE @cicloPivot  int           
 DECLARE @cicloMaximo int      
      
 SELECT @cicloMaximo = max(CicloOrigen) from #ciclo_regularizar      
 SET @rn = 0                              
  
 --BEGIN TRAN      
                      
 -- Check if there are any remaining rows in the temporary table                      
    -- Continue processing as long as there are rows in #ciclo_regularizar    
   
DECLARE @cicloMaximoSistema int  
set @cicloMaximoSistema = (select MAX(ciclo) from proPiscinaEjecucion where idPiscina = @idPiscina and estado = 'EJE')  
  
 WHILE EXISTS (SELECT TOP 1 1 FROM #ciclo_regularizar)                      
	BEGIN                      
			 --set cursor variable                      
		  SELECT TOP 1 @rn = rn FROM #ciclo_regularizar ORDER BY rn                        
			  --SELECT * FROM #ciclo_regularizar WHERE rn = @RN      
		  --Insert new register (fisrt conditional)                      
		IF ( NOT EXISTS (                      
			SELECT TOP 1 rn                       
			FROM proPiscinaEjecucion pe                       
			INNER JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion                      
			WHERE rn = @rn )        
			or exists (  SELECT TOP 1 rn                       
			FROM proPiscinaEjecucion pe                       
			left JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion                      
			WHERE rn = @rn      and pe.idPiscinaEjecucion is null   ))      
				BEGIN         
       
				   select @cicloMaximo cicloMaximo,  @cicloMaximoSistema cicloMaximoSistema  
				   SELECT TOP 1 1 FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina and estado = 'EJE'  
							  AND ciclo = @cicloMaximo  
						IF(@cicloMaximo = @cicloMaximoSistema AND EXISTS (SELECT TOP 1 1 FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina and estado = 'EJE'  
								  AND ciclo = @cicloMaximo))  
						BEGIN  
								SELECT 'CICLO IGUALES'  
								SELECT PE.fechaSiembra, CR.fechaSiembraOrigen FROM proPiscinaEjecucion PE INNER JOIN #ciclo_regularizar CR ON CR.CicloOrigen = PE.ciclo AND CR.idPiscina = PE.idPiscina  
									WHERE PE.idPiscina = @idPiscina and estado = 'EJE' AND PE.ciclo = @cicloMaximo  
  
  
								UPDATE PE SET   PE.fechaSiembra =  CR.fechaSiembraOrigen ,  
									pe.cantidadEntrada = CR.cantidadSembradaOrigen,
									pe.fechaCierre = CR.fechaPescaOrigen
								FROM proPiscinaEjecucion PE INNER JOIN #ciclo_regularizar CR ON CR.CicloOrigen = PE.ciclo AND CR.idPiscina = PE.idPiscina  
									WHERE PE.idPiscina = @idPiscina and estado = 'EJE' AND PE.ciclo = @cicloMaximo  
  
								UPDATE pcl SET   pcl.fecha =  CR.fechaInicioOrigen   
								FROM  maePiscinaCiclo pcl    INNER JOIN #ciclo_regularizar CR ON CR.CicloOrigen = pcl.ciclo AND CR.idPiscina = pcl.idPiscina  
								inner join proPiscinaEjecucion pe on pe.idPiscina = pcl.idPiscina and pe.idPiscinaEjecucion = pcl.idOrigen  
									WHERE pcl.idPiscina = @idPiscina and estado = 'EJE' AND pcl.ciclo = @cicloMaximo  
							END  
					ELSE  
						BEGIN
								SELECT 'SEGUNDA VALIDACION'  
								 UPDATE proSecuencial                       
								 SET ultimaSecuencia = ultimaSecuencia + 1                        
								 WHERE tabla = 'piscinaEjecucion'                      
                      
								 SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia                       
								 FROM proSecuencial                       
								 WHERE tabla = 'piscinaEjecucion'                      
                      
								 SET @secuencialPiscinaEjecucionSiguiente = NULL                       
								 -- select @rn                  
								 SELECT @cicloPivot =  cr.CicloOrigen FROM #ciclo_regularizar cr  WHERE cr.rn = @rn                      
                         
								 INSERT INTO proPiscinaEjecucion (                      
							   idPiscinaEjecucion, idPiscina, ciclo, rolPiscina, numEtapa, lote, fechaInicio,                       
							   fechaSiembra, fechaCierre, tipoCierre, idEspecie, cantidadEntrada, cantidadAdicional,                       
							   cantidadSalida, cantidadPerdida, idPiscinaEjecucionSiguiente, estado, tieneRaleo,                       
							   tieneRepanio, tieneCosecha, activo, usuarioCreacion, estacionCreacion, fechaHoraCreacion,                       
							   usuarioModificacion, estacionModificacion, fechaHoraModificacion                      
								 )                      
								 SELECT                       
							   @secuencialPiscinaEjecucion, cr.idPiscina, cr.CicloOrigen,                      
							   CASE                       
									WHEN cr.rolOrigen = 'PRECRIADERO' THEN 'PRE01'                       
									WHEN cr.rolOrigen = 'PISCINA' THEN 'ENG01'                       
									ELSE 'ENG01'                       
							   END,                       
							   1,                       
							   cr.lote, fechaInicioOrigen, fechaSiembraOrigen, fechaPescaOrigen,                       
							   CASE                       
									WHEN  cr.fechaPescaOrigen IS NOT NULL   and rolOrigen ='PISCINA'  THEN 'COS'                    --@cicloMaximo > cr.CicloOrigen and    
									WHEN  cr.fechaPescaOrigen IS NOT NULL   and rolOrigen ='PRECRIADERO'  THEN 'TRA'                --@cicloMaximo > cr.CicloOrigen and     
									ELSE ''                        
							   END,                       
							   CASE                       
									WHEN cr.fechaPescaOrigen IS NOT NULL THEN 1                         
									WHEN cr.fechaTransferenciaOrigen IS NOT NULL THEN 1                          
									ELSE 1                        
							   END,             
							   ISNULL(cantidadSembradaOrigen, 0), 0, 0,          
							   0, @secuencialPiscinaEjecucionSiguiente,                      
							   CASE                       
									WHEN   @cicloMaximo > cr.CicloOrigen and fechaPescaOrigen IS NULL     AND cantidadSembradaOrigen> 0 THEN 'EJE'  --      
									WHEN   @cicloMaximo > cr.CicloOrigen and fechaPescaOrigen IS NOT NULL AND cantidadSembradaOrigen > 0 THEN 'PRE' --     
									ELSE 'INI'                       
							   END,                      
							   0, 0, 0,                      
							   1, @Usuario, '::PROCESS_CREATE_CYCLES_FINALLY SEGUNDA VALIDACION', @fechaProceso, 
							   @usuario,    '::PROCESS_CREATE_CYCLES_FINALLY SEGUNDA VALIDACION', @fechaProceso                      
								 FROM #ciclo_regularizar cr                       
								 WHERE cr.rn = @rn                      
                      
								 UPDATE maeSecuencial                       
								 SET ultimaSecuencia = ultimaSecuencia + 1                        
								 WHERE tabla = 'piscinaCiclo'                      
                      
								 SELECT TOP 1 @secuencialPiscinaCiclo = ultimaSecuencia                       
								 FROM maeSecuencial                       
								 WHERE tabla = 'piscinaCiclo'                      
                      
								 INSERT INTO maePiscinaCiclo (                      
							   idPiscinaCiclo, idPiscina, ciclo, fecha, origen, idOrigen,                       
							   idOrigenEquivalente, rolCiclo, activo, usuarioCreacion,                       
							   estacionCreacion, fechaHoraCreacion, usuarioModificacion,                       
							   estacionModificacion, fechaHoraModificacion             
								 )                      
								 SELECT                       
								 @secuencialPiscinaCiclo, cr.idPiscina, cr.CicloOrigen, cr.fechaInicioOrigen, 
								 'EJE', @secuencialPiscinaEjecucion, NULL, 
							   CASE 
									WHEN cr.rolOrigen = 'PRECRIADERO' THEN 'PRE01'                       
									WHEN cr.rolOrigen = 'PISCINA' THEN 'ENG01'                       
									ELSE 'ENG01'                       
							   END,       
							   1, @Usuario, '::PROCESS_CREATE_CYCLES_FINALLY SEGUNDA VALIDACION', @fechaProceso, @usuario, '::PROCESS_CREATE_CYCLES_FINALLY SEGUNDA VALIDACION', @fechaProceso                      
								 FROM #ciclo_regularizar cr                       
								 WHERE cr.rn = @rn                      
							END                   
				END                      
		  ELSE  --Update old register (second conditional)                      
			BEGIN                      
					PRINT '2 ???'                       
					UPDATE pe                       
					SET                       
					pe.cantidadEntrada = cr.cantidadSembradaOrigen,                      
					pe.fechaCierre = cr.fechaPescaOrigen,                      
					--pe.tipoCierre = CASE                       
					-- WHEN cr.fechaPescaOrigen IS NOT NULL THEN 'PES'                        
					-- WHEN cr.fechaTransferenciaOrigen IS NOT NULL THEN 'TRA'                       
					-- ELSE ''                        
					--END,                      
						pe.tipoCierre = CASE       
						WHEN    cr.rolOrigen ='PISCINA' AND cr.fechaPescaOrigen is not null THEN 'COS'      --@cicloMaximo > cr.CicloOrigen  AND    
						WHEN    cr.rolOrigen ='PRECRIADERO' AND cr.fechaPescaOrigen is not null THEN 'TRA'  --@cicloMaximo > cr.CicloOrigen  AND     
						ELSE ''                        
					END,                      
					pe.estado = CASE                       
						WHEN   cr.fechaPescaOrigen IS NOT NULL			-- @cicloMaximo > cr.CicloOrigen  AND    
					AND cantidadSembradaOrigen> 0  THEN 'PRE'                        
						WHEN   cr.fechaTransferenciaOrigen IS NOT NULL  -- @cicloMaximo > cr.CicloOrigen  AND
					AND cantidadSembradaOrigen> 0  THEN 'PRE'                       
						ELSE 'EJE'                       
					END,                      
					--pe.cantidadPerdida = cr.cantidadSembradaOrigen + pe.cantidadAdicional - pe.cantidadSalida,                      
					pe.cantidadPerdida = CASE               
						WHEN cr.cantidadSembradaOrigen + pe.cantidadAdicional - pe.cantidadSalida < 0 THEN 0               
						ELSE cr.cantidadSembradaOrigen + pe.cantidadAdicional - pe.cantidadSalida             
					END,               
					pe.idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucionSiguiente,                      
					pe.usuarioModificacion = @usuario,                      
					pe.estacionModificacion = '::2',                      
					pe.fechaHoraModificacion = @fechaProceso,                      
					pe.ciclo = cr.CicloOrigen    
					
					FROM proPiscinaEjecucion pe                       
					INNER JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion                       
					WHERE rn = @rn                      
                      
					UPDATE pc                       
					SET                       
					pc.ciclo = pe.ciclo,                      
					pc.usuarioModificacion = @usuario,                      
					pc.estacionModificacion = '::2',                      
					pc.fechaHoraModificacion = @fechaProceso                      
					FROM proPiscinaEjecucion pe                       
					INNER JOIN maePiscinaCiclo pc ON pe.idPiscina = pc.idPiscina AND pe.idPiscinaEjecucion = pc.idOrigen                      
					INNER JOIN #ciclo_regularizar cr ON cr.idPiscinaEjecucion = pe.idPiscinaEjecucion                       
					WHERE rn = @rn                      
		END                      

			--move cursor with delete row in while setence                      
			DELETE FROM #ciclo_regularizar WHERE rn = @rn                      
END;                      
                      
 WITH CTE_PiscinaEjecucion AS (                      
    SELECT                      
  idPiscina,                      
        idPiscinaEjecucion,                      
        idPiscinaEjecucionSiguiente,                      
  LEAD(IdPiscinaEjecucion) OVER (ORDER BY Ciclo) AS NextIdPiscinaEjecucion                      
    FROM                      
   proPiscinaEjecucion                  
  where idPiscina = @idPiscina and ciclo >0                     
 )                       
 UPDATE CTE_PiscinaEjecucion                      
 SET idPiscinaEjecucionSiguiente = NextIdPiscinaEjecucion                      
 where idPiscina = @idPiscina ;                        
                     
update pe      
set       
--select pe.CantidadSalida ,ej.cod_ciclo, coalesce( (select sum(Cantidad_Transf) from TRANSFERENCIAS_PRODUCCION t where t.Cod_Ciclo_Origen = ej.cod_ciclo),0)      
pe.CantidadSalida = coalesce( (select sum(Cantidad_Transf) from TRANSFERENCIAS_PRODUCCION t where t.Cod_Ciclo_Origen = ej.cod_ciclo),0)      
from EjecucionesPiscinaView ej inner join proPiscinaEjecucion pe on pe.idPiscinaEjecucion = ej.idPiscinaEjecucion      
where  ej.idPiscina = @idPiscina and pe.rolPiscina = 'PRE01'      
        
update pe      
set      
---select pe.CantidadSalida , ej.cod_ciclo, coalesce((select sum(Animales) from PESCA_PRODUCCION t where t.keyPiscina+'.'+CAST(ciclo as varchar(10)) = ej.cod_ciclo AND EstatusPesca='PROCESADO'),0)      
pe.CantidadSalida =  coalesce((select sum(Animales) from PESCA_PRODUCCION t where t.keyPiscina+'.'+CAST(ciclo as varchar(10)) = ej.cod_ciclo AND EstatusPesca='PROCESADO'),0)      
from EjecucionesPiscinaView ej inner join proPiscinaEjecucion pe on pe.idPiscinaEjecucion = ej.idPiscinaEjecucion      
where  ej.idPiscina = @idPiscina and pe.rolPiscina = 'ENG01'      
      
update pe      
set        
pe.cantidadPerdida =  CASE               
						WHEN pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida < 0 THEN 0 
						WHEN pe.cantidadSalida <= 0 THEN 0   
						ELSE  pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida   END
from EjecucionesPiscinaView ej inner join proPiscinaEjecucion pe on pe.idPiscinaEjecucion = ej.idPiscinaEjecucion      
where  ej.idPiscina = @idPiscina and pe.rolPiscina = 'PRE01'      
  
  
--  WITH CTE_PiscinaEjecucion AS (                      
--    SELECT                      
--  idPiscina,                      
--        idPiscinaEjecucion,                      
--        idPiscinaEjecucionSiguiente,                      
--  LEAD(IdPiscinaEjecucion) OVER (ORDER BY Ciclo) AS NextIdPiscinaEjecucion                      
--    FROM                      
--        proPiscinaEjecucion                      
--  where idPiscina = @idPiscina and ciclo >0           
-- )                       
--SELECT   idPiscinaEjecucion,      idPiscinaEjecucionSiguiente  ,     NextIdPiscinaEjecucion      
-- --SET idPiscinaEjecucionSiguiente = NextIdPiscinaEjecucion         
-- FROM CTE_PiscinaEjecucion      
-- where idPiscina = @idPiscina ;                        
                      
    UPDATE proPiscinaEjecucion SET estado= 'ANU', activo = 0, usuarioModificacion='AdminPsCam', estacionModificacion=':::2', fechaHoraModificacion= GETDATE()  
    where idPiscina = @idPiscina AND ESTADO IN ('INI') AND ciclo = 0  
  
 update pcl set pcl.activo = PE.activo  
  from proPiscinaEjecucion PE INNER JOIN maePiscinaCiclo pcl on pcl.idPiscina = PE.idPiscina and pcl.idOrigen = PE.idPiscinaEjecucion  
  where PE.idPiscina = @idPiscina AND PE.ESTADO IN ('ANU') AND pe.ciclo = 0 AND PE.activo = 0  
  
 UPDATE proPiscinaEjecucion SET estado= 'EJE' where idPiscina = @idPiscina AND ESTADO IN ('INI') AND cantidadEntrada > 0 AND cantidadSalida <=0 AND ciclo > 0  
   
  IF(@cicloPivot-1  > 0)          
  BEGIN  
 select top 1 @idPicinaEjecucionCierre = idPiscinaEjecucion from proPiscinaEjecucion where idPiscina = @idPiscina and ciclo = @cicloPivot-1  
 SET  @cicloPivot  =  @cicloPivot-1  
 END  
 ELSE   
 BEGIN   
      select top 1 @idPicinaEjecucionCierre = idPiscinaEjecucion from proPiscinaEjecucion where idPiscina = @idPiscina and ciclo = @cicloPivot  
  END  
  
  
 -- Display the updated contents of the tables                      
 IF(@DisplayContent = 1)          
 BEGIN         
     SELECT  @cicloPivot AS cicloCerrar, @idPicinaEjecucionCierre AS idPicinaEjecucionCerrar                      
   SELECT 'DESPUES proPiscinaEjecucion' AS TABLA, * FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina ORDER BY ciclo                      
   SELECT 'DESPUES maePiscinaCiclo'     AS TABLA, * FROM maePiscinaCiclo     WHERE idPiscina = @idPiscina ORDER BY ciclo                      
 END                      
      
                         
 --ROLLBACK TRAN -- Uncomment this line if you need to rollback the transaction                      
 -- COMMIT TRAN   -- Uncomment this line to commit the transaction                      
END   





GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_PESCA_CIERRE_FINAL]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELPTEXT PROCESS_CREATE_PESCA_CIERRE_FINAL;


               
CREATE     PROCEDURE [dbo].[PROCESS_CREATE_PESCA_CIERRE_FINAL]              
    @idPiscinaEjecucion INT,              
    @idPiscina INT,              
    @fechaProceso DATETIME,              
    @usuario VARCHAR(10),              
	@ciclo  INT,              
    @displayContent BIT              
AS              
BEGIN               
-- Drop the temporary table if it exists              
IF OBJECT_ID('tempdb..#PescaTemporal') IS NOT NULL              
     DROP TABLE #PescaTemporal;               
            
 
  
SELECT	  t.Num,           t.Zona,              t.Camaronera,    t.Sector,   t.Piscina,               
		  t.Tipo,          t.Estatus,           t.Hectarea,      t.Ciclo,       t.Fecha_IniSec,               
		  t.Fecha_Siembra, t.Cantidad_Sembrada, t.Densidad,      t.EstatusPesca,      t.InicioPesca,               
		  t.FinPesca,      t.Fecha_DS,          t.Bines,         t.Libras,   t.Peso,               
		  t.Animales,	   pu.idPiscina              
 INTO #PescaTemporal               
FROM  [PESCA_PRODUCCION] t  INNER JOIN PiscinaUbicacion pu ON pu.nombreSector = t.Sector and pu.nombrePiscina = t.Piscina              
WHERE  pu.idPiscina = @idPiscina               
   and CICLO = @ciclo       AND Fecha_DS IS NOT NULL       
              
    -- Variables locales              
    DECLARE @horaInicioHistograma TIME = '06:00';              
    DECLARE @horaFinHistograma TIME = '07:00';              
    DECLARE @descripcion VARCHAR(250) = 'REGISTRO GENERADO POR PROCESO DE REGULARIZACION SOLICITADO POR USUARIO PARA LA PISCINA (' + CAST(@idPiscina AS VARCHAR(10)) + ')';              
 DECLARE @origenHistograma VARCHAR(10) ='PES'              
 DECLARE @estadoProceso VARCHAR(10) ='APR'              
    DECLARE @secuencialHistograma INT;              
    DECLARE @secuencialHistogramaDetalle INT;              
    DECLARE @secuencialPedidoBin INT;              
    DECLARE @secuencialPedidoBinDetalle INT;              
    DECLARE @secuencialPiscinaCosecha INT;              
    DECLARE @horaInicioPesca TIME = '09:00';              
    DECLARE @horaFinPesca TIME = '10:00';              
    -- Actualización de secuenciales              
    UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla IN ('histograma', 'HistogramaDetalle', 'pedidoBin', 'pedidoBinDetalle', 'piscinaCosecha');               
    -- Obtener nuevos secuenciales              
    SELECT TOP 1 @secuencialHistograma = ultimaSecuencia FROM proSecuencial WHERE tabla = 'histograma';              
    SELECT TOP 1 @secuencialHistogramaDetalle = ultimaSecuencia FROM proSecuencial WHERE tabla = 'HistogramaDetalle';              
    SELECT TOP 1 @secuencialPedidoBin = ultimaSecuencia FROM proSecuencial WHERE tabla = 'pedidoBin';              
    SELECT TOP 1 @secuencialPedidoBinDetalle = ultimaSecuencia FROM proSecuencial WHERE tabla = 'pedidoBinDetalle';              
    SELECT TOP 1 @secuencialPiscinaCosecha = ultimaSecuencia FROM proSecuencial WHERE tabla = 'piscinaCosecha';              
              
    -- Insertar en proHistograma              
    INSERT INTO proHistograma (              
        idHistograma, empresa, secuencia, idPiscina, idPiscinaEjecucion, origenHistograma, fechaRegistro,              
        fechaMuestreo, UsuarioResponsable, horaInicio, horaFinal, cantidadMuestreo, descripcion,              
        numeroPicadoLeve, numeroPicadoFuerte, numeroPicadoSano, numeroTexturaDuro, numeroTexturaFlacido, numeroTexturaMudado,              
        estado, usuarioCreacion, estacionCreacion, fechaHoraCreacion,              
        usuarioModificacion, estacionModificacion, fechaHoraModificacion, responsable, tipoHistograma              
    )              
    SELECT @secuencialHistograma, p.empresa, @secuencialHistograma, pesc.IdPiscina, @idPiscinaEjecucion, @origenHistograma, @fechaProceso,             
           DATEADD(day, -1, pesc.Fecha_DS), @usuario, @horaInicioHistograma, @horaFinHistograma, 1, @descripcion,              
        0, 0, 1, 1, 0, 0, @estadoProceso,               
           @usuario, ':::2', @fechaProceso,              
           @usuario, ':::2', @fechaProceso, @usuario   , 'PPROM'          
    FROM #PescaTemporal pesc              
    INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina;              
              
    -- Insertar en proHistogramaDetalle              
    INSERT INTO proHistogramaDetalle (              
        idHistogramaDetalle, idHistograma, orden,              
        pesoUnitario, idTalla, idTallaCola, activo,              
        usuarioCreacion, estacionCreacion, fechaHoraCreacion,              
        usuarioModificacion, estacionModificacion, fechaHoraModificacion ,          
  longitud, medidaLongitud, cantidadMuestra          
    )              
    SELECT @secuencialHistogramaDetalle, @secuencialHistograma, 1, pesc.Peso, tiEntero.idTallaItem, tiCola.idTallaItem, 1,              
           @usuario, ':::2', @fechaProceso,              
           @usuario, ':::2', @fechaProceso,          
     null, null, 1          
    FROM #PescaTemporal pesc              
    INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina              
    INNER JOIN invTallaItem tiEntero ON ROUND(pesc.Peso,0) BETWEEN tiEntero.pesoMinimo AND tiEntero.pesoMaximo AND tiEntero.histograma = 1              
    INNER JOIN invTipoItemTalla tipEntero ON tipEntero.talla = tiEntero.codigo AND tipEntero.idTipoItem = 1              
    INNER JOIN invTallaItem tiCola ON ROUND(pesc.Peso,0) BETWEEN tiCola.pesoMinimo AND tiCola.pesoMaximo AND tiCola.histograma = 1              
    INNER JOIN invTipoItemTalla tipCola ON tipCola.talla = tiCola.codigo AND tipCola.idTipoItem = 2;              
              
    -- Insertar en proPedidoBin              
    INSERT INTO proPedidoBin (              
        idPedidoBin, empresa, division, zona,              
        fechaPedido, idEspecie, idTipoIngreso, descripcion,              
        fechaRegistro, usuarioResponsable, tipoPedido, idMotivoAuditoria,              
        estado, usuarioCreacion, estacionCreacion, fechaHoraCreacion,              
        usuarioModificacion, estacionModificacion, fechaHoraModificacion              
    )              
    SELECT @secuencialPedidoBin, p.empresa, p.division, p.zona,              
           DATEADD(day, -1, pesc.Fecha_DS), 1, 41, @descripcion,              
           @fechaProceso, @usuario, '00002', NULL,              
           @estadoProceso, @usuario, ':::2', @fechaProceso,              
           @usuario, ':::2', @fechaProceso              
    FROM #PescaTemporal pesc              
    INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina              
    WHERE pesc.idPiscina = @idPiscina;              
              
    -- Insertar en proPedidoBinDetalle              
    INSERT INTO proPedidoBinDetalle (              
        idPedidoBinDetalle, idPedidoBin, idPiscina, idPiscinaEjecucion,              
        tipoPesca, cantidadPesca, tipoUnidadMedida,              
        unidadMedida, cantidadBinesRequerido, numeroCompuertas,              
        idHistograma, pesoHistograma, horaInicio,              
        observacion, motivoAuditoria, activo,              
        usuarioCreacion, estacionCreacion, fechaHoraCreacion,              
        usuarioModificacion, estacionModificacion, fechaHoraModificacion, numeroTinas              
    )              
    SELECT @secuencialPedidoBinDetalle, @secuencialPedidoBin, @idPiscina, @idPiscinaEjecucion,              
           @origenHistograma, pesc.Libras,'PES',              
           'LIBRA', pesc.Bines, 1,              
       @secuencialHistograma, pesc.Peso, @horaInicioPesca,              
           '', '', 1,              
           @usuario, ':::2', @fechaProceso,              
           @usuario, ':::2', @fechaProceso, 1              
    FROM #PescaTemporal pesc              
  INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina              
    WHERE pesc.idPiscina = @idPiscina;              
              
    -- Insertar en proPiscinaCosecha              
    INSERT INTO proPiscinaCosecha (              
        idPiscinaCosecha, empresa, secuencia, secuenciaPiscina, idPiscinaEjecucion,              
        idPiscina, idPiscinaEjecucionAnterior, idPiscinaAnterior,              
        fechaInicio, fechaFin, horaInicio, fechaLiquidacion, horaFinal, idEmpacadora,              
        fechaRegistro, horaRegistro, usuarioResponsable, numeroBins, numeroViajes, numeroPersonas,              
        cantidadCosechada, pesoCosechaLibras, pesoPromedioGramos, diasAyuno, origenCosecha, personal,              
        tipoPesca, liquidado, descripcion, motivoCambioPiscina, motivoCambioTipoPesca, estado,              
        idMotivoAuditoria, binesTotales, binesBaja, binesStock, idHistograma, pesoHistograma,              
        usuarioCreacion, estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion, fechaHoraModificacion,              
        estadoTrabajo, binesParciales              
    )              
    SELECT @secuencialPiscinaCosecha, p.empresa, @secuencialPiscinaCosecha, 1, @idPiscinaEjecucion,              
           @idPiscina, @idPiscinaEjecucion, @idPiscina,              
           pesc.Fecha_DS, pesc.Fecha_DS, @horaInicioPesca, pesc.Fecha_DS, @horaFinPesca, NULL,              
           CAST(@fechaProceso AS DATE), CAST(@fechaProceso AS TIME), @usuario,              
           pesc.Bines, 0, 0,              
           pesc.Animales, pesc.Libras, pesc.Peso,              
           NULL, 'HIST', 0,              
           @origenHistograma, 1, '',              
           '', '', @estadoProceso,              
           NULL, pesc.Bines, 0,              
           0, @secuencialHistograma, pesc.Peso,              
           @usuario, ':::2', @fechaProceso,              
           @usuario, ':::2', @fechaProceso, 'FIN', 0              
    FROM #PescaTemporal pesc              
    INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina              
    WHERE pesc.idPiscina = @idPiscina;              
              
   INSERT INTO [dbo].[proPedidoCosecha]             ([idPiscinaCosecha],     [idPedidoBinDetalle],   [idMotivoAuditoria],      [activo],       [estado],      [cantidadBinSobrante],      [usuarioCreacion],     [estacionCreacion],    [fechaHoraCreacion],   



   [usuarioModificacion],    [estacionModificacion],   [fechaHoraModificacion])      VALUES (     @secuencialPiscinaCosecha,  @secuencialPedidoBinDetalle, NULL,     1,        'APR',       0,    
   @usuario,      ':::2',       @fechaProceso,             @usuario,      ':::2',       @fechaProceso)  
  
 UPDATE pe set pe.cantidadSalida =  pesc.Animales   --pe.cantidadSalida + pesc.Animales              
 FROM  #PescaTemporal pesc              
    INNER JOIN maePiscina p    ON pesc.IdPiscina       = p.idPiscina              
 INNER JOIN proPiscinaEjecucion pe   ON pe.idPiscina         = p.idPiscina              
    WHERE pesc.idPiscina = @idPiscina and pe.idPiscinaEjecucion = @idPiscinaEjecucion;              
              
  update pe set         
  --pe.cantidadPerdida  =  (pe.cantidadEntrada  + pe.cantidadAdicional) - pe.cantidadSalida              
    pe.cantidadPerdida = CASE         
        WHEN pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida < 0 THEN 0         
        ELSE pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida 
    END         
  FROM   proPiscinaEjecucion   pe               
  WHERE  pe.idPiscinaEjecucion = @idPiscinaEjecucion;              
              
    -- Mostrar contenido si displayContent es 1              
    --IF(@displayContent = 1)              
    --BEGIN              
    --   -- SELECT 'proHistograma'        as TABLA, * FROM proHistograma WHERE idHistograma = @secuencialHistograma;              
    --   -- SELECT 'proHistogramaDetalle' as TABLA, * FROM proHistogramaDetalle WHERE idHistograma = @secuencialHistograma;              
    --   -- SELECT 'proPedidoBin'         as TABLA, * FROM proPedidoBin WHERE idPedidoBin = @secuencialPedidoBin;              
    --   -- SELECT 'proPedidoBinDetalle'  as TABLA, * FROM proPedidoBinDetalle WHERE idPedidoBinDetalle = @secuencialPedidoBinDetalle;              
    --   -- SELECT 'proPiscinaCosecha'    as TABLA, *  FROM proPiscinaCosecha WHERE idPiscinaCosecha = @secuencialPiscinaCosecha;              
    --   --SELECT 'proPiscinaCosecha Pesca'    as TABLA, *  FROM proPiscinaEjecucion WHERE idPiscinaEjecucion = @idPiscinaEjecucion;              
    --END              
END 
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_CREATE_PESCA_CIERRE_HISTORIAL]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
CREATE   PROCEDURE [dbo].[PROCESS_CREATE_PESCA_CIERRE_HISTORIAL]    
	@keyPiscina Varchar(30),
    @idPiscinaEjecucion INT,            
    @idPiscina INT,     --no es necesario 
	@Cod_Piscina Varchar(100),
	@fechaCierre DATE,    
    @fechaProceso DATETIME,            
    @usuario VARCHAR(10),            
	@ciclo  INT,            
    @displayContent BIT            
AS 
BEGIN             
-- Drop the temporary table if it exists            
IF OBJECT_ID('tempdb..#PescaTemporal') IS NOT NULL            
     DROP TABLE #PescaTemporal;   

SELECT	  t.Num,			t.Zona,              t.Camaronera,    t.Sector,			t.Piscina,             
		  t.Tipo,			t.Estatus,           t.Hectarea,      t.Ciclo,			t.Fecha_IniSec,             
		  t.Fecha_Siembra,	t.Cantidad_Sembrada, t.Densidad,      t.EstatusPesca,	t.InicioPesca,             
		  t.FinPesca,		t.Fecha_DS,          t.Bines,         t.Libras,			t.Peso,             
		  t.Animales,		pu.idPiscina            
 INTO #PescaTemporal             
FROM  [PESCA_PRODUCCION] t  INNER JOIN PiscinaUbicacion pu ON pu.KeyPiscina = t.keyPiscina          
WHERE  pu.KeyPiscina = @keyPiscina             
		and CICLO = @ciclo and t.Fecha_DS is not null  

select 'ESTOESPESCATEMPORAL',* from #PescaTemporal
IF EXISTS (SELECT * FROM #PescaTemporal)
	BEGIN 
		-- Variables locales            
		DECLARE @horaInicioHistograma TIME = '06:00';
		DECLARE @horaFinHistograma TIME = '07:00';        
		DECLARE @descripcion VARCHAR(250) = 'REGISTRO GENERADO POR PROCESO DE REGULARIZACION SOLICITADO POR USUARIO PARA LA PISCINA (' + CAST(@idPiscina AS VARCHAR(10)) + ')';    
		DECLARE @origenHistograma VARCHAR(10) ='PES'
		DECLARE @estadoProceso VARCHAR(10) ='APR'
		DECLARE @secuencialHistograma INT;
		DECLARE @secuencialHistogramaDetalle INT;
		DECLARE @secuencialPedidoBin INT;            
		DECLARE @secuencialPedidoBinDetalle INT;
		DECLARE @secuencialPiscinaCosecha INT;
		DECLARE @horaInicioPesca TIME = '09:00'; 
		DECLARE @horaFinPesca TIME = '10:00';
		-- Actualización de secuenciales            
		UPDATE proSecuencial SET ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla IN ('histograma', 'HistogramaDetalle', 'pedidoBin', 'pedidoBinDetalle', 'piscinaCosecha');             
		-- Obtener nuevos secuenciales            
		SELECT TOP 1 @secuencialHistograma = ultimaSecuencia FROM proSecuencial WHERE tabla = 'histograma';            
		SELECT TOP 1 @secuencialHistogramaDetalle = ultimaSecuencia FROM proSecuencial WHERE tabla = 'HistogramaDetalle';            
		SELECT TOP 1 @secuencialPedidoBin = ultimaSecuencia FROM proSecuencial WHERE tabla = 'pedidoBin';            
		SELECT TOP 1 @secuencialPedidoBinDetalle = ultimaSecuencia FROM proSecuencial WHERE tabla = 'pedidoBinDetalle';            
		SELECT TOP 1 @secuencialPiscinaCosecha = ultimaSecuencia FROM proSecuencial WHERE tabla = 'piscinaCosecha';            
            
		-- Insertar en proHistograma            
		INSERT INTO proHistograma (
			idHistograma, empresa, secuencia, idPiscina, idPiscinaEjecucion, origenHistograma, fechaRegistro,            
			fechaMuestreo, UsuarioResponsable, horaInicio, horaFinal, cantidadMuestreo, descripcion,            
			numeroPicadoLeve, numeroPicadoFuerte, numeroPicadoSano, numeroTexturaDuro, numeroTexturaFlacido, numeroTexturaMudado,            
			estado, usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion, responsable, tipoHistograma            
		)            
		SELECT @secuencialHistograma, p.empresa, @secuencialHistograma, pesc.IdPiscina, @idPiscinaEjecucion, @origenHistograma, @fechaProceso,           
			   DATEADD(day, -1, pesc.Fecha_DS), @usuario, @horaInicioHistograma, @horaFinHistograma, 1, @descripcion,            
			0, 0, 1, 1, 0, 0, @estadoProceso,             
			   @usuario, ':::2', @fechaProceso,       
			   @usuario, ':::2', @fechaProceso, @usuario   , 'PPROM'        
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina;            
            
		-- Insertar en proHistogramaDetalle            
		INSERT INTO proHistogramaDetalle (            
			idHistogramaDetalle, idHistograma, orden,            
			pesoUnitario, idTalla, idTallaCola, activo,            
			usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion ,        
	  longitud, medidaLongitud, cantidadMuestra        
		)            
		SELECT @secuencialHistogramaDetalle, @secuencialHistograma, 1, pesc.Peso, tiEntero.idTallaItem, tiCola.idTallaItem, 1,            
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso,        
		 null, null, 1        
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		INNER JOIN invTallaItem tiEntero ON ROUND(pesc.Peso,0) BETWEEN tiEntero.pesoMinimo AND tiEntero.pesoMaximo AND tiEntero.histograma = 1            
		INNER JOIN invTipoItemTalla tipEntero ON tipEntero.talla = tiEntero.codigo AND tipEntero.idTipoItem = 1            
		INNER JOIN invTallaItem tiCola ON ROUND(pesc.Peso,0) BETWEEN tiCola.pesoMinimo AND tiCola.pesoMaximo AND tiCola.histograma = 1            
		INNER JOIN invTipoItemTalla tipCola ON tipCola.talla = tiCola.codigo AND tipCola.idTipoItem = 2;            
            
		-- Insertar en proPedidoBin            
		INSERT INTO proPedidoBin (            
			idPedidoBin, empresa, division, zona,            
			fechaPedido, idEspecie, idTipoIngreso, descripcion,            
			fechaRegistro, usuarioResponsable, tipoPedido, idMotivoAuditoria,            
			estado, usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion            
		)            
		SELECT @secuencialPedidoBin, p.empresa, p.division, p.zona,            
			   DATEADD(day, -1, pesc.Fecha_DS), 1, 41, @descripcion,            
			   @fechaProceso, @usuario, '00002', NULL,            
			   @estadoProceso, @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso            
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina;            
            
		-- Insertar en proPedidoBinDetalle            
		INSERT INTO proPedidoBinDetalle (            
			idPedidoBinDetalle, idPedidoBin, idPiscina, idPiscinaEjecucion,            
			tipoPesca, cantidadPesca, tipoUnidadMedida,            
			unidadMedida, cantidadBinesRequerido, numeroCompuertas,            
			idHistograma, pesoHistograma, horaInicio,            
			observacion, motivoAuditoria, activo,            
			usuarioCreacion, estacionCreacion, fechaHoraCreacion,            
			usuarioModificacion, estacionModificacion, fechaHoraModificacion, numeroTinas            
		)            
		SELECT @secuencialPedidoBinDetalle, @secuencialPedidoBin, @idPiscina, @idPiscinaEjecucion,            
			   @origenHistograma, pesc.Libras,'PES',            
			   'LIBRA', pesc.Bines, 1,            
		   @secuencialHistograma, pesc.Peso, @horaInicioPesca,            
			   '', '', 1,            
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso, 1            
		FROM #PescaTemporal pesc            
	  INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina;            
            
		-- Insertar en proPiscinaCosecha            
		INSERT INTO proPiscinaCosecha (            
			idPiscinaCosecha, empresa, secuencia, secuenciaPiscina, idPiscinaEjecucion,            
			idPiscina, idPiscinaEjecucionAnterior, idPiscinaAnterior,            
			fechaInicio, fechaFin, horaInicio, fechaLiquidacion, horaFinal, idEmpacadora,            
			fechaRegistro, horaRegistro, usuarioResponsable, numeroBins, numeroViajes, numeroPersonas,            
			cantidadCosechada, pesoCosechaLibras, pesoPromedioGramos, diasAyuno, origenCosecha, personal,            
			tipoPesca, liquidado, descripcion, motivoCambioPiscina, motivoCambioTipoPesca, estado,            
			idMotivoAuditoria, binesTotales, binesBaja, binesStock, idHistograma, pesoHistograma,            
			usuarioCreacion, estacionCreacion, fechaHoraCreacion, usuarioModificacion, estacionModificacion, fechaHoraModificacion,            
			estadoTrabajo, binesParciales            
		)            
		SELECT @secuencialPiscinaCosecha, p.empresa, @secuencialPiscinaCosecha, 1, @idPiscinaEjecucion,            
			   @idPiscina, @idPiscinaEjecucion, @idPiscina,            
			   pesc.Fecha_DS, pesc.Fecha_DS, @horaInicioPesca, pesc.Fecha_DS, @horaFinPesca, NULL,            
			   CAST(@fechaProceso AS DATE), CAST(@fechaProceso AS TIME), @usuario,            
			   pesc.Bines, 0, 0,            
			   pesc.Animales, pesc.Libras, pesc.Peso,            
			   NULL, 'HIST', 0,            
			   @origenHistograma, 1, '',            
			   '', '', @estadoProceso,            
			   NULL, pesc.Bines, 0,            
			   0, @secuencialHistograma, pesc.Peso,            
			   @usuario, ':::2', @fechaProceso,            
			   @usuario, ':::2', @fechaProceso, 'FIN', 0            
		FROM #PescaTemporal pesc            
		INNER JOIN maePiscina p ON pesc.IdPiscina = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina;            

		INSERT INTO [dbo].[proPedidoCosecha] 
           ([idPiscinaCosecha],					[idPedidoBinDetalle],			[idMotivoAuditoria],
		   [activo],							[estado],						[cantidadBinSobrante],
		   [usuarioCreacion],					[estacionCreacion],				[fechaHoraCreacion],
		   [usuarioModificacion],				[estacionModificacion],			[fechaHoraModificacion])
		   VALUES (
				@secuencialPiscinaCosecha,		@secuencialPedidoBinDetalle,	NULL,
				1,								'APR',							0,	
				@usuario,						':::2',							@fechaProceso,            
			    @usuario,						':::2',							@fechaProceso)


	 UPDATE pe set pe.cantidadSalida =  pesc.Animales   --pe.cantidadSalida + pesc.Animales  
	 FROM  #PescaTemporal pesc            
		INNER JOIN maePiscina p    ON pesc.IdPiscina       = p.idPiscina            
	 INNER JOIN proPiscinaEjecucion pe   ON pe.idPiscina         = p.idPiscina            
		WHERE pesc.idPiscina = @idPiscina and pe.idPiscinaEjecucion = @idPiscinaEjecucion;            
            
	  update pe set       
	  --pe.cantidadPerdida  =  (pe.cantidadEntrada  + pe.cantidadAdicional) - pe.cantidadSalida            
		pe.cantidadPerdida = CASE       
			WHEN pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida < 0 THEN 0       
			ELSE pe.cantidadEntrada + pe.cantidadAdicional - pe.cantidadSalida       
		END       ,
		pe.estado = 'PRE',--CERRAR
		pe.fechaCierre =  @fechaCierre,
		pe.tipoCierre = 'COS'
	  FROM   proPiscinaEjecucion   pe             
	  WHERE  pe.idPiscinaEjecucion = @idPiscinaEjecucion;            
            

		IF NOT EXISTS(select top 1 1 from EjecucionesPiscinaView where cod_ciclo = @Cod_Piscina)
			BEGIN 
		
				DECLARE @secuencialPiscinaEjecucion  INT
				DECLARE @secuencialMaeCiclo          INT

				SELECT TOP 1 @secuencialPiscinaEjecucion  = ultimaSecuencia + 1
							FROM	proSecuencial 
							WHERE	tabla = 'piscinaEjecucion' 

				SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
							FROM	maeSecuencial 
							WHERE	tabla = 'PiscinaCiclo' 
						
				  INSERT INTO proPiscinaEjecucion (
									idPiscinaEjecucion,					 idPiscina,				      ciclo,			rolPiscina,			numEtapa,			lote,				fechaInicio, 
									fechaSiembra,						 fechaCierre,			      tipoCierre,		idEspecie,			cantidadEntrada,	cantidadAdicional,  cantidadSalida,				
									cantidadPerdida,					 idPiscinaEjecucionSiguiente, estado,			tieneRaleo,			tieneRepanio,		tieneCosecha,		activo,
									usuarioCreacion,					 estacionCreacion,			  fechaHoraCreacion, 
									usuarioModificacion,				 estacionModificacion,		  fechaHoraModificacion) 

					SELECT top 1	@secuencialPiscinaEjecucion,		 idPiscina,					  0,				'',					0,					codigoSector,		DATEADD(DAY, 1, @fechaCierre), 
									NULL,								 NULL,							'',					0,					0,				0,					0, 
									0,									 NULL,						    'INI',				0,					0,				0,					1,
									@usuario,							'::2',							@fechaProceso,
									@usuario,							'::2',							@fechaProceso
						FROM PiscinaUbicacion where KeyPiscina = @keyPiscina;

					INSERT INTO [dbo].[maePiscinaCiclo] (
								idPiscinaCiclo,						idPiscina,			    ciclo,		
								fecha,								origen,				    idOrigen, 
								idOrigenEquivalente,				rolCiclo,			    activo, 
								usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
								usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
					SELECT top 1
								@secuencialMaeCiclo,			idPiscina,				0, 
								DATEADD(DAY, 1, @FechaCierre),		'PRE',					@secuencialPiscinaEjecucion, 
								null as idOrigenEquivalente,		'',						1, 
								@usuario,							'::2',					@fechaProceso, 
								@usuario,							'::2',					@fechaProceso
						 from PiscinaUbicacion where KeyPiscina = @keyPiscina;

				 
				UPDATE pe set   pe.idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucion
				FROM   proPiscinaEjecucion   pe             
				WHERE  pe.idPiscinaEjecucion = @idPiscinaEjecucion; 
	  
			   --ABRO EL NUEVO CICLO
   				UPDATE proSecuencial 
							SET    ultimaSecuencia = @secuencialPiscinaEjecucion
							WHERE  tabla		   = 'piscinaEjecucion' 
					
				UPDATE maeSecuencial 
							SET   ultimaSecuencia = @secuencialMaeCiclo
							WHERE tabla = 'PiscinaCiclo' 
			END
		--ELSE
		--	BEGIN
				
		--		UPDATE pe
		--			SET 
		--				ciclo						= @cicloMax , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
		--				rolPiscina					= 'ENG01',
		--				numEtapa					= 1,
		--				fechaSiembra				= @fechaSiembraMin, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
		--				tipoCierre					= '',
		--				idEspecie					= 1,
		--				--cantidadEntrada				= sum(c.cantidadTransferida),
		--				cantidadEntrada				= @sumaTransDetalle,
		--				cantidadAdicional			=  0,
		--				cantidadSalida				= 0,
		--				cantidadPerdida				= CASE WHEN cantidadSalida > 0 THEN (cantidadEntrada + cantidadAdicional) - cantidadSalida ELSE 0 END,
		--				estado						= 'EJE',
		--				usuarioModificacion			= @usuarioAudit,
		--				fechaHoraModificacion		= @fechaProceso
		--		--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
		--		--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
		--		--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
		--		FROM   proPiscinaCosecha c  
		--				INNER JOIN proPiscinaEjecucion pe on pe.idPiscinaEjecucion = c.idPiscinaEjecucion and c.fechaLiquidacion BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
		--				WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
		--				AND t.estado NOT IN ('ANU','ING') AND pe.estado IN ('EJE', 'INI', 'PRE')

		--				--MAEPISCINA CICLO
		--				UPDATE pc
		--					SET 
		--						ciclo						= @cicloMax, --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
		--						origen						= 'EJE',
		--						rolCiclo					= 'ENG01',
		--						usuarioModificacion			= @usuarioAudit,
		--						fechaHoraModificacion		= @fechaProceso
		--				--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
		--				--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
		--				--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
		--				FROM  proTransferenciaEspecieDetalle c  
		--						INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia 
		--						INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate()) 
		--						INNER JOIN maePiscinaCiclo pc on pe.idPiscinaEjecucion = pc.idOrigen
		--						WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
		--						AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

		--	END

	END

END 
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_CONTROL]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_CONTROL]  
 @IdPiscina INT,  
    @displayContent BIT  
AS  
BEGIN  
  -- Mostrar contenido si displayContent es 1  
  --  IF(@displayContent = 1)  
  --  BEGIN  
  -- SELECT  
  --       'proceso de proControlParametro' AS TABLA,  
  --        d.idPiscinaEjecucion  AS idPiscinaEjecucionOld,   
  --     pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,  
  --  pe.fechaInicio,  
  --  pe.fechaCierre,  
  --     c.fechaControl,  
  --     d.idPiscina,  
  --     c.idControlParametro  
  -- FROM   proControlParametro c   
  --  INNER JOIN proControlParametroDetalle d on c.idControlParametro = d.idControlParametro   
  --  INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = d.idPiscina             and c.fechaControl  
  --  BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE    
  --  pe.idPiscina   =  @IdPiscina AND  
  --  c.estado NOT IN ('ANU')      AND  
  --  d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
  --  pe.estado IN ('EJE', 'INI', 'PRE')  
  --END  
  
  UPDATE d SET  d.idPiscinaEjecucion  = pe.idPiscinaEjecucion    
  FROM   proControlParametro c   
   INNER JOIN proControlParametroDetalle d on c.idControlParametro = d.idControlParametro   
   INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = d.idPiscina             and c.fechaControl  
   BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE    
   pe.idPiscina   =  @IdPiscina AND  
   c.estado NOT IN ('ANU')      AND  
   d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
   pe.estado IN ('EJE', 'INI', 'PRE')  
  
END
 
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_COSECHAS]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_COSECHAS]
    @IdPiscina      INT,  
    @displayContent BIT  ,
    @TransactAppy   BIT
AS  
BEGIN  
  -- Mostrar contenido si displayContent es 1  
IF @TransactAppy = 1
BEGIN
  BEGIN TRAN  
END
  
  
  IF OBJECT_ID('tempdb..#ControlIdsPiscinaCosecha')       IS NOT NULL              
     DROP TABLE #ControlIdsPiscinaCosecha;     
  IF OBJECT_ID('tempdb..#ControlIdsPiscinaHistograma')     IS NOT NULL              
     DROP TABLE #ControlIdsPiscinaHistograma;     
 IF OBJECT_ID('tempdb..#ControlIdsPiscinaPedidoBinDetalle') IS NOT NULL              
     DROP TABLE #ControlIdsPiscinaPedidoBinDetalle;     
   --*******************************COSECHAS Y RALEOS*************************************************************************************
  SELECT  c.idPiscinaEjecucion  AS idPiscinaEjecucionOld,   
          pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,  
          pe.fechaInicio        AS fechaInicioEjecucion,  
          pe.fechaSiembra,  
          pe.fechaCierre,  
          c.fechaInicio,  
          c.idPiscina,  
          c.idPiscinaCosecha 
    INTO #ControlIdsPiscinaCosecha
    FROM   proPiscinaCosecha c    
    INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
										 c.fechaInicio BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
	WHERE   pe.idPiscina   =  @IdPiscina				   AND  
			c.estado NOT IN ('ANU')						   AND  
			c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
			pe.estado IN ('EJE', 'INI', 'PRE')		 	   AND  
			tipoPesca = 'RAL'
       
	UPDATE c 
	SET    c.idPiscinaEjecucion  = pe.idPiscinaEjecucion,
		   c.idPiscinaEjecucionAnterior = pe.idPiscinaEjecucion
    FROM   proPiscinaCosecha c    
    INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
										 c.fechaInicio BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
	WHERE   pe.idPiscina   =  @IdPiscina				   AND  
			c.estado NOT IN ('ANU')						   AND  
			c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
			pe.estado IN ('EJE', 'INI', 'PRE')     

	--*******************************HISTOGRAMA*************************************************************************************
     SELECT  c.idPiscinaEjecucion  AS idPiscinaEjecucionOld,   
          pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,  
          pe.fechaInicio        AS fechaInicioEjecucion,  
          pe.fechaSiembra,  
          pe.fechaCierre,  
          c.fechaMuestreo,  
          c.idPiscina,  
          c.idHistograma 
    INTO #ControlIdsPiscinaHistograma
    FROM   proHistograma c    
    INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
										 c.fechaMuestreo BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
	WHERE   pe.idPiscina   =  @IdPiscina				   AND  
			c.estado NOT IN ('ANU')						   AND  
			c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
			pe.estado IN ('EJE', 'INI', 'PRE')    
       
	UPDATE c 
	SET    c.idPiscinaEjecucion  = pe.idPiscinaEjecucion    
    FROM   proHistograma c    
    INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
										 c.fechaMuestreo BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
	WHERE   pe.idPiscina   =  @IdPiscina				   AND  
			c.estado NOT IN ('ANU')						   AND  
			c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
			pe.estado IN ('EJE', 'INI', 'PRE')    

	--*******************************PEDIDO BIN DETALLE*************************************************************************************
     SELECT   c.idPiscinaEjecucion  AS idPiscinaEjecucionOld,   
			  pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,  
			  pe.fechaInicio        AS fechaInicioEjecucion,  
			  pe.fechaSiembra,  
			  pe.fechaCierre,  
			  pb.fechaPedido,  
			  c.idPiscina,  
			  c.idPedidoBinDetalle ,
			  pb.idPedidoBin 
     INTO #ControlIdsPiscinaPedidoBinDetalle
    FROM   proPedidoBinDetalle c    
	INNER JOIN proPedidoBin pb on pb.idPedidoBin = c.idPedidoBin
    INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
										 pb.fechaPedido BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
	WHERE   pe.idPiscina   =  @IdPiscina				   AND  
			pb.estado NOT IN ('ANU')                       AND  
			c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
			pe.estado IN ('EJE', 'INI', 'PRE')    
       
	UPDATE c 
	SET    c.idPiscinaEjecucion  = pe.idPiscinaEjecucion    
    FROM   proPedidoBinDetalle c    
	INNER JOIN proPedidoBin pb on pb.idPedidoBin = c.idPedidoBin
    INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
										 pb.fechaPedido BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
	WHERE   pe.idPiscina   =  @IdPiscina				   AND  
			pb.estado NOT IN ('ANU')                       AND  
			c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
			pe.estado IN ('EJE', 'INI', 'PRE')    

   IF(@displayContent = 1)  
    BEGIN    
     SELECT 'ACTUALIZACION proPiscinaCosecha' as Tabla , idPiscinaEjecucionOld, idPiscinaEjecucionNew,  fechaInicioEjecucion, fechaSiembra,  fechaCierre,  fechaInicio,  idPiscina,  idPiscinaCosecha 
			FROM #ControlIdsPiscinaCosecha    where idPiscina = @IdPiscina

	 SELECT  'POST ACTUALIZACION proPiscinaCosecha'     as Tabla , c.*  
			FROM   proPiscinaCosecha c    
			INNER JOIN proPiscinaEjecucion pe ON pe.idPiscina = C.idPiscina  AND 
												 c.fechaInicio BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  
			WHERE   pe.idPiscina   =  @IdPiscina				   AND  
					c.estado NOT IN ('ANU')						   AND   
					pe.estado IN ('EJE', 'INI', 'PRE')		 	   AND  
					tipoPesca = 'RAL'

	 SELECT 'ACTUALIZACION proHistograma'     as Tabla , idPiscinaEjecucionOld, idPiscinaEjecucionNew,  fechaInicioEjecucion, fechaSiembra,  fechaCierre,  fechaMuestreo,  idPiscina,  idHistograma 
			FROM #ControlIdsPiscinaHistograma where idPiscina = @IdPiscina
	
     SELECT 'ACTUALIZACION proPedidoBinDetalle'     as Tabla , idPiscinaEjecucionOld, idPiscinaEjecucionNew,  fechaInicioEjecucion, fechaSiembra,  fechaCierre,  fechaPedido,
				idPiscina,  idPedidoBinDetalle, idPedidoBin 
			FROM #ControlIdsPiscinaPedidoBinDetalle where idPiscina = @IdPiscina 
    END

	IF @TransactAppy = 1
	BEGIN
	  ROLLBACK TRAN  
	END

END  
   
   
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_PESO]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_PESO]    
 @IdPiscina INT,    
    @displayContent BIT    
AS    
BEGIN    
  -- Mostrar contenido si displayContent es 1    
     SELECT d.idPiscinaEjecucion  AS idPiscinaEjecucionOld,     
       pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,    
    pe.fechaInicio,    
    pe.fechaCierre,    
       c.fechaMuestreo,    
       d.idPiscina,    
       c.idMuestreo    
   INTO #ControlIdsEjecucionPoblacion    
   FROM   proMuestreoPeso c     
    INNER JOIN proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo     
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = d.idPiscina  and c.fechaMuestreo    
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE      
    pe.idPiscina   =  @IdPiscina AND    
    c.estado NOT IN ('ANU')      AND    
    d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND    
    pe.estado IN ('EJE', 'INI', 'PRE')    
         
  UPDATE d SET  d.idPiscinaEjecucion  = pe.idPiscinaEjecucion      
  FROM     proMuestreoPeso c     
    INNER JOIN proMuestreoPesoDetalle d on c.idMuestreo = d.idMuestreo     
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = d.idPiscina  and c.fechaMuestreo    
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE      
    pe.idPiscina   =  @IdPiscina AND    
    c.estado NOT IN ('ANU')      AND    
    d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND    
    pe.estado IN ('EJE', 'INI', 'PRE')    
    
  -- IF(@displayContent = 1)    
  --  BEGIN    
  --SELECT 'TEMPORAL DE EJECUCION PARA PESO' AS TABLA,* FROM #ControlIdsEjecucionPoblacion    
  --SELECT 'ANTES  proPiscinaControlPeso'           AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew , cpb.*      
  --FROM  proPiscinaControlPeso cpb INNER JOIN #ControlIdsEjecucionPoblacion cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld     
  --                    AND cpb.fechaMuestreo = cejb.fechaMuestreo    
  --                        WHERE cejb.idPiscina = @IdPiscina    
  --END    
    
   --LA TABLA    
   UPDATE cpb SET cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionNEW FROM  proPiscinaControlPeso cpb INNER JOIN #ControlIdsEjecucionPoblacion cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld     
                   AND cpb.fechaMuestreo = cejb.fechaMuestreo    
                  WHERE cejb.idPiscina = @IdPiscina    
  -- IF(@displayContent = 1)    
  --  BEGIN     
  --SELECT 'DESPUES proPiscinaControlPeso' AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew, cpb.*    FROM  proPiscinaControlPeso cpb INNER JOIN #ControlIdsEjecucionPoblacion cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld    

 
  --                    AND cpb.fechaMuestreo = cejb.fechaMuestreo    
  --                        WHERE cejb.idPiscina = @IdPiscina    
  --END    
END
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_POBLACION]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
CREATE PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_POBLACION]    
 @IdPiscina INT,    
    @displayContent BIT    
AS    
BEGIN    
  -- Mostrar contenido si displayContent es 1    
     SELECT d.idPiscinaEjecucion  AS idPiscinaEjecucionOld,     
       pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,    
    pe.fechaInicio,    
    pe.fechaCierre,    
       c.fechaMuestreo,    
       d.idPiscina,    
       c.idMuestreo    
   INTO #ControlIdsEjecucionPoblacion    
   FROM   proMuestreoPoblacion c     
    INNER JOIN proMuestreoPoblacionDetalleLance d on c.idMuestreo = d.idMuestreo     
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = d.idPiscina  and c.fechaMuestreo    
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE      
    pe.idPiscina   =  @IdPiscina AND    
    c.estado NOT IN ('ANU')      AND    
    d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND    
    pe.estado IN ('EJE', 'INI', 'PRE')    
    
     
    
  UPDATE d SET  d.idPiscinaEjecucion  = pe.idPiscinaEjecucion      
  FROM     proMuestreoPoblacion c     
    INNER JOIN proMuestreoPoblacionDetalleLance d on c.idMuestreo = d.idMuestreo     
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = d.idPiscina  and c.fechaMuestreo    
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE      
    pe.idPiscina   =  @IdPiscina AND    
    c.estado NOT IN ('ANU')      AND    
    d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND    
    pe.estado IN ('EJE', 'INI', 'PRE')    
  -- IF(@displayContent = 1)    
  --  BEGIN    
  --SELECT 'TEMPORAL DE EJECUCION PARA POBLACION' AS TABLA,* FROM #ControlIdsEjecucionPoblacion    
  --SELECT 'ANTES  proPiscinaControlPoblacion'           AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew , cpb.*      
  --FROM  proPiscinaControlPoblacion cpb INNER JOIN #ControlIdsEjecucionPoblacion cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld     
  --                    AND cpb.fechaMuestreo = cejb.fechaMuestreo    
  --                        WHERE cejb.idPiscina = @IdPiscina    
  --END    
    
   --LA TABLA    
   UPDATE cpb SET cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionNEW FROM  proPiscinaControlPoblacion cpb INNER JOIN #ControlIdsEjecucionPoblacion cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld     
                   AND cpb.fechaMuestreo = cejb.fechaMuestreo    
                  WHERE cejb.idPiscina = @IdPiscina    
--   IF(@displayContent = 1)    
--    BEGIN     
--  SELECT 'DESPUES proPiscinaControlPoblacion'           AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew, cpb.*  
--FROM  proPiscinaControlPoblacion cpb INNER JOIN #ControlIdsEjecucionPoblacion cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld     
--                      AND cpb.fechaMuestreo = cejb.fechaMuestreo    
--                          WHERE cejb.idPiscina = @IdPiscina    
--  END    
END
 
GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_RECEPCION]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
    Stored Procedure: PROCESS_CREATE_PESCA_CIERRE
    Author: Adrian Wong Macías
    Created Date: 2024-05-23
    Description: Proceso de actualización de ejecución para transferencias.
  
    Revision History:
        Date        Author           Description
	    2024-05-30  Adrian Wong      Inicio
*/       
create  PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_RECEPCION]
		@IdPiscina INT,
    @displayContent BIT
AS
BEGIN
  -- Mostrar contenido si displayContent es 1 

		SELECT d.idPiscinaEjecucion  AS idPiscinaEjecucionOld, 
			    pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,
				pe.fechaInicio,
			    pe.fechaSiembra,
				pe.fechaCierre,
			    c.fechaRecepcion,
			    d.idPiscina,
			    c.idRecepcion,
				d.idRecepcionDetalle
		  INTO #ControlIdsRecepcionDet
		 FROM   proRecepcionEspecie c 
			 INNER JOIN proRecepcionEspecieDetalle d on c.idRecepcion = d.idRecepcion 
			 INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina          = d.idPiscina  and c.fechaRecepcion BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  WHERE  
			 pe.idPiscina   =  @IdPiscina AND
			 c.estado NOT IN ('ANU')      AND
			 d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND
			 pe.estado IN ('EJE', 'INI', 'PRE')  
			  
	 UPDATE d SET  d.idPiscinaEjecucion  = pe.idPiscinaEjecucion  
	  FROM   proRecepcionEspecie c 
			 INNER JOIN proRecepcionEspecieDetalle d on c.idRecepcion = d.idRecepcion 
			 INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina          = d.idPiscina  and c.fechaRecepcion BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  WHERE  
			 pe.idPiscina   =  @IdPiscina AND
			 c.estado NOT IN ('ANU')      AND
			 d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND
			 pe.estado IN ('EJE', 'INI', 'PRE')  

   IF(@displayContent = 1)
    BEGIN 
		SELECT 'TEMPORAL DE EJECUCION PARA RECEPCION  DETALLE (DET)' AS TABLA,* FROM #ControlIdsRecepcionDet
		  
		SELECT 'ANTES  proRecepcionEspeciedDetalle'      AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew , cpb.*    
							FROM  proRecepcionEspecieDetalle cpb 
							      INNER JOIN #ControlIdsRecepcionDet cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld 
								  INNER JOIN proRecepcionEspecie cab on cab.idRecepcion = cpb.idRecepcion
																											AND cab.fechaRecepcion = cejb.fechaRecepcion
							  WHERE cejb.idPiscina = @IdPiscina
	 END
END
 

GO
/****** Object:  StoredProcedure [dbo].[PROCESS_UPDATE_EJECUCIONES_TRANSFERENCIA]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	--EXEC PROCESS_UPDATE_EJECUCIONES_TRANSFERENCIA 1654, 1

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
/*  
    Stored Procedure: PROCESS_CREATE_PESCA_CIERRE  
    Author: Adrian Wong Macías  
    Created Date: 2024-05-23  
    Description: Proceso de actualización de ejecución para transferencias.  
    
    Revision History:  
        Date        Author           Description  
     2024-05-30  Adrian Wong      Inicio  
*/         
CREATE PROCEDURE [dbo].[PROCESS_UPDATE_EJECUCIONES_TRANSFERENCIA]  
 @IdPiscina INT,  
    @displayContent BIT  
AS  
BEGIN  
  -- Mostrar contenido si displayContent es 1  
     SELECT c.idPiscinaEjecucion  AS idPiscinaEjecucionOld,   
       pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,  
    pe.fechaInicio,  
       pe.fechaSiembra,  
    pe.fechaCierre,  
       c.fechaTransferencia,  
       c.idPiscina,  
       c.idTransferencia  
   INTO #ControlIdsTransferenciaCab  
   FROM   proTransferenciaEspecie c    
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = c.idPiscina  and c.fechaTransferencia  
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE    
    pe.idPiscina   =  @IdPiscina AND  
    c.estado NOT IN ('ANU')      AND  
    --c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
    pe.estado IN ('EJE', 'INI', 'PRE')  
  
  
  
     --ASIGNA EL ID CORRECTO DE LA EJECUCION  
  UPDATE c SET  c.idPiscinaEjecucion  = pe.idPiscinaEjecucion    
  FROM    proTransferenciaEspecie c    
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina         = c.idPiscina  and c.fechaTransferencia  
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE    
    pe.idPiscina   =  @IdPiscina AND  
    c.estado NOT IN ('ANU')      AND  
   -- c.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
    pe.estado IN ('EJE', 'INI', 'PRE')  
       
  
  SELECT d.idPiscinaEjecucion  AS idPiscinaEjecucionOld,   
       pe.idPiscinaEjecucion AS idPiscinaEjecucionNew,  
    C.idPiscina,  
    pe.fechaInicio,  
       pe.fechaSiembra,  
    pe.fechaCierre,  
       c.fechaTransferencia,  
       d.idPiscina AS IdPiscinaDestino,  
       c.idTransferencia  
   INTO #ControlIdsTransferenciaDet  
   FROM   proTransferenciaEspecie c   
    INNER JOIN proTransferenciaEspecieDetalle d on c.idTransferencia = d.idTransferencia   
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina          = d.idPiscina  and c.fechaTransferencia  
    BETWEEN pe.fechaInicio and COALESCE(pe.fechaCierre, getdate())  WHERE    
    pe.idPiscina   =  @IdPiscina AND  
    c.estado NOT IN ('ANU')      AND  
   -- d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
    pe.estado IN ('EJE', 'INI', 'PRE') AND C.idPiscina = @IdPiscina  
       
  UPDATE d SET  d.idPiscinaEjecucion  = pe.idPiscinaEjecucion    
  FROM     proTransferenciaEspecie c   
    INNER JOIN proTransferenciaEspecieDetalle d on c.idTransferencia = d.idTransferencia   
    INNER JOIN proPiscinaEjecucion       pe on pe.idPiscina          = d.idPiscina  and c.fechaTransferencia  
    BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  WHERE    
    pe.idPiscina   =  @IdPiscina AND  
    c.estado NOT IN ('ANU')      AND  
   -- d.idPiscinaEjecucion <> pe.idPiscinaEjecucion  AND  
    pe.estado IN ('EJE', 'INI', 'PRE')  
  
   IF(@displayContent = 1)  
    BEGIN  
  SELECT 'TEMPORAL DE EJECUCION PARA TRANSFERENCIA ORIGEN(CAB)'   AS TABLA,* FROM #ControlIdsTransferenciaCab  
  SELECT 'TEMPORAL DE EJECUCION PARA TRANSFERENCIA DETALLE (DET)' AS TABLA,* FROM #ControlIdsTransferenciaDet  
  
  SELECT 'ANTES  proTransferenciaEspecie'      AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew , cpb.*      
       FROM  proTransferenciaEspecie cpb INNER JOIN #ControlIdsTransferenciaCab cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld   
                           AND cpb.fechaTransferencia = cejb.fechaTransferencia  
         WHERE cejb.idPiscina = @IdPiscina  
  
  SELECT 'ANTES  proTransferenciaEspeciedDetalla'      AS TABLA, cejb.idPiscinaEjecucionOld,  cejb.idPiscinaEjecucionNew , cpb.*      
       FROM  proTransferenciaEspecieDetalle cpb INNER JOIN #ControlIdsTransferenciaDet cejb ON cpb.idPiscinaEjecucion = cejb.idPiscinaEjecucionOld   
          inner join proTransferenciaEspecie cab on cab.idTransferencia = cpb.idTransferencia  
                           AND cab.fechaTransferencia = cejb.fechaTransferencia  
         WHERE cejb.idPiscina = @IdPiscina  
  END  
  
  
     
END  
   
  
GO
/****** Object:  StoredProcedure [dbo].[usp_ActualizarSoloCiclos]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_ActualizarSoloCiclos]
	@idPiscina int,
	@debeActualizar bit out
AS
BEGIN
--DECLARE @idPiscina int = 606

IF OBJECT_ID('tempdb..#ciclo_regularizar') IS NOT NULL
BEGIN
 DROP TABLE #ciclo_regularizar
END

SELECT                        
  ROW_NUMBER() OVER (ORDER BY ori_c.ciclo DESC) AS rn,                      
  p.idPiscina,                      
  ej.ciclo,                       
  ej.FechaSiembra,                       
  ej.fechaInicio,                       
  ej.fechaCierre,                       
  ej.idPiscinaEjecucion,                     
  ori_c.Ciclo AS CicloOrigen,                      
  ori_c.[Fecha_IniSec] AS fechaInicioOrigen,                      
  ori_c.[Fecha_Siembra] AS fechaSiembraOrigen,                       
  IIF(ori_c.[Fecha_Pesca] <> '', CAST(ori_c.[Fecha_Pesca] AS DATE), NULL) AS fechaPescaOrigen,                          
  ori_c.Tipo AS rolOrigen               
   INTO #ciclo_regularizar                      
 FROM [dbo].[CICLOS_PRODUCCION] ori_c                      
 inner join PiscinaUbicacion p on p.keyPiscina = ori_c.Key_Piscina  
 inner join maePiscina mp on mp.idPiscina = p.idPiscina  
 LEFT JOIN proPiscinaEjecucion ej ON P.idPiscina     = ej.idPiscina  
 --AND DATEDIFF(day, ori_c.[Fecha_Siembra], ej.FechaSiembra) BETWEEN -100 AND 100  
  AND ori_c.[Fecha_Siembra] >= DATEADD(day, -3, ej.FechaSiembra)  
  AND ori_c.[Fecha_Siembra] <= DATEADD(day, 2, ej.FechaSiembra)  
 WHERE p.idPiscina = @idPiscina  
 AND ori_c.Ciclo >= (  
   SELECT MIN(ej2.Ciclo)  
   FROM EjecucionesPiscinaView ej2  
   WHERE  ej2.estado in ('EJE', 'PRE') AND ej2.keyPiscina = ori_c.Key_Piscina  
  )    
  and   ori_c.[Fecha_IniSec]  >= (select MIN(fechaInicio) from proPiscinaEjecucion pejw where pejw.idPiscina = @idPiscina)
 

  IF NOT EXISTS (SELECT 1 FROM #ciclo_regularizar WHERE ciclo IS NULL) 
	 AND EXISTS (SELECT 1 FROM #ciclo_regularizar  where ciclo - CicloOrigen != 0)
  BEGIN
   SET @debeActualizar = 1
  END
  ELSE
  BEGIN
   SET @debeActualizar = 0
  END 
 --SELECT  @debeActualizar AS debeActualizar
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ANULARTRANSFERENCIASSOBRANTES]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE    PROCEDURE [dbo].[USP_ANULARTRANSFERENCIASSOBRANTES] (@idPiscina int)
as begin

		with CTE as (
			select TE.fechaTransferencia, ej.keyPiscina, ej.cod_ciclo, ted.* from proTransferenciaEspecieDetalle ted
					INNER JOIN proTransferenciaEspecie te on te.idTransferencia = ted.idTransferencia
					INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = ted.idPiscinaEjecucion
					where  te.estado = 'APR')
		SELECT 
			ts.fechaTransferencia,
			ts.keyPiscina,
			ts.cod_ciclo,
			ts.cantidadTransferida,
			ts.idTransferencia, 
			ts.idTransferenciaDetalle
		into #idsAnularTransferencias
		FROM 
			CTE ts
		LEFT JOIN 
			TRANSFERENCIAS_PRODUCCION ta
		ON 
			ts.fechaTransferencia = ta.Fecha_Transf AND 
			ts.keyPiscina = ta.KeyPiscinaDestino AND 
			ts.cod_ciclo = ta.Cod_Ciclo_Destino AND 
			ts.cantidadTransferida = ta.Cantidad_Transf
		WHERE 
			ta.Fecha_Transf IS NULL
			AND ta.KeyPiscinaDestino IS NULL
			AND ta.Cod_Ciclo_Destino IS NULL
			AND ta.Cantidad_Transf IS NULL
			and ts.idPiscina = @idPiscina;

		   DECLARE @idTransferencia int 
		   SELECT DISTINCT idTransferencia INTO #idTransferencia FROM #idsAnularTransferencias
		   while exists(select top 1 1 from #idTransferencia)
		   begin
				set @idTransferencia = (select top 1 idTransferencia from #idTransferencia)
				--inicio proceso
					if((select count(1) from proTransferenciaEspecieDetalle where idTransferencia = @idTransferencia)  = 1)
					begin
						update proTransferenciaEspecie
						set estado = 'ANU',
							fechaHoraModificacion = GETDATE(),
							estacionModificacion  = '::ANULADOPORREGULA',
							usuarioModificacion   = 'AdminPsCam'
						where idTransferencia = @idTransferencia
					end
					else if((select count(1) from proTransferenciaEspecieDetalle where idTransferencia = @idTransferencia)  > 1)
					begin
						update dt set dt.activo = 0,
									fechaHoraModificacion = GETDATE(),
									estacionModificacion  = '::ANULADOPORREGULA',
									usuarioModificacion   = 'AdminPsCam'
						from proTransferenciaEspecieDetalle dt inner join #idsAnularTransferencias ia 
						                on dt.idTransferenciaDetalle = ia.idTransferenciaDetalle
						where dt.idTransferencia = @idTransferencia
					end
				--fin proceso
				delete from #idTransferencia where idTransferencia = @idTransferencia
		   end

			--if exists(select top 1 1 from #idsAnularTransferencias)
			--	BEGIN
			--		--update proTransferenciaEspecie
			--		--set estado = 'ANU',
			--		--	fechaHoraModificacion = GETDATE(),
			--		--	usuarioModificacion = '::ANULADOPORREGULA'
			--		--where idTransferencia in (select idTransferencia from #idsAnularTransferencias)
			--	END

	end 
GO
/****** Object:  StoredProcedure [dbo].[usp_FiltrarPiscinaMontadasPorSector]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE     procedure [dbo].[usp_FiltrarPiscinaMontadasPorSector] (@SECTORFILTER  VARCHAR(100))
as begin
	--DECLARE @SECTORFILTER VARCHAR(100) = 'SANFRANCISCO'
 
	DROP TABLE IF EXISTS #EJECUCIONESTEMP			

	/*Nomenclatura Preparacion = "PRE"; Manual = "MAN"; EjecucionPiscina = "EJE"; MantenimientoPiscina = "MNT";*/
	--STEP 1: Query para poblar temporal de ejecuciones moldeado a keys de excel
		SELECT	pu.codigoZona,	       pu.nombreZona,       pu.codigoCamaronera, pu.nombreCamaronera, 
				pu.codigoSector,       pu.nombreSector,     pu.codigoPiscina,    pu.nombrePiscina, 
				ce.codigoElemento,     ce.nombreElemento,   pe.idPiscina,        
				pu.nombreSector + pu.nombrePiscina + '.' + CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, 
				pu.nombreSector + pu.nombrePiscina AS keyPiscina, 
				pe.idPiscinaEjecucion, pe.ciclo,            pe.fechaInicio,      pe.fechaSiembra, 
				pe.fechaCierre,			pe.cantidadEntrada
		INTO #EJECUCIONESTEMP 
		FROM proPiscinaEjecucion pe 
			INNER JOIN PiscinaUbicacion  pu ON  pe.idPiscina	 = pu.idPiscina 
			INNER JOIN CATALOGO_ELEMENTS ce ON ce.codigoElemento = pe.rolPiscina AND ce.codigoCatalogo = 'maeRolPiscina' 
		WHERE estado in ('EJE', 'PRE')
   

	
   --FILTRAMOS LAS PISCINAS A REGULARIZAR
		SELECT cp.Key_Piscina, cp.Ciclo, cp.Cantidad_Sembrada, CP.Fecha_IniSec, CP.Fecha_Siembra, ''''+cp.Key_Piscina+''','
		from CICLOS_PRODUCCION cp
		left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
		WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
		AND REPLACE(cp.Sector,' ','') = @SECTORFILTER and ej.ciclo is null
		ORDER BY CP.Fecha_IniSec, CP.Fecha_Siembra
	end
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERTEJECUCIONINITIAL]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[USP_INSERTEJECUCIONINITIAL](
@idPiscina INT
)
AS BEGIN

	DECLARE @secuencialPiscinaEjecucion INT
	DECLARE @secuencialPiscinaEjecucionActualizar INT
	DECLARE @secuencialMaeCiclo INT
	DECLARE @fechaProceso dateTime = getdate()
	DECLARE @fechaInicio date 
	DECLARE @lote varchar(10) 
	DECLARE @usuarioAudit varchar(50) = 'AdminPsCam'

	SELECT @fechaInicio =  DATEADD(day, 1, MAX(fechaCierre))
	FROM proPiscinaEjecucion WHERE idPiscina = @idPiscina

	SELECT @lote = codigoSector 
	FROM PiscinaUbicacion where idPiscina = @idPiscina

--BEGIN TRAN
	
	SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia + 1
	FROM	proSecuencial 
	WHERE	tabla = 'piscinaEjecucion' 

	SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
	FROM	maeSecuencial 
	WHERE	tabla = 'PiscinaCiclo' 

	------- EJECUCION PISCINA

		INSERT INTO proPiscinaEjecucion (
			idPiscinaEjecucion,				idPiscina,					 ciclo,					rolPiscina,		numEtapa,			lote,					fechaInicio, 
			fechaSiembra,					fechaCierre,				 tipoCierre,			idEspecie,		cantidadEntrada,	cantidadAdicional,		cantidadSalida, 
			cantidadPerdida,				idPiscinaEjecucionSiguiente, estado,				tieneRaleo,		tieneRepanio,		tieneCosecha,			activo, 
			usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion, 
			usuarioModificacion,			estacionModificacion,		 fechaHoraModificacion)
			VALUES (
			@secuencialPiscinaEjecucion,	@idPiscina,					 0,						'',				0,					@lote,					@fechaInicio, 
			NULL,							NULL,						'',						0,				0,					0,						0, 
			0,								NULL,						'INI',			0,					0,						0,						
			1,								@usuarioAudit,				'::MANUALCICLO',		@fechaProceso,		
			@usuarioAudit,					'::MANUALCICLO',			@fechaProceso)
		
		------- CICLO PISCINA
		INSERT INTO [dbo].[maePiscinaCiclo] (
			idPiscinaCiclo,						idPiscina,			    ciclo,		
			fecha,								origen,				    idOrigen, 
			idOrigenEquivalente,				rolCiclo,			    activo, 
			usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
			usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
		VALUES(
			@secuencialMaeCiclo,				@idPiscina,				0, 
			@fechaInicio,						'PRE',					@secuencialPiscinaEjecucion, 
			null,								'',						1, 
			@usuarioAudit,					    '::MANUALCICLO',				@fechaProceso,
			@usuarioAudit,					    '::MANUALCICLO',				@fechaProceso)
	
	select top 1 @secuencialPiscinaEjecucionActualizar = idPiscinaEjecucion 
	from proPiscinaEjecucion where idPiscina = @idPiscina order by ciclo desc

	UPDATE p 
	SET idPiscinaEjecucionSiguiente =  @secuencialPiscinaEjecucion
	from proPiscinaEjecucion p
	where idPiscinaEjecucion = @secuencialPiscinaEjecucionActualizar

	UPDATE proSecuencial 
	SET    ultimaSecuencia = @secuencialPiscinaEjecucion   
	WHERE  tabla		   = 'piscinaEjecucion' 

	UPDATE maeSecuencial 
	SET ultimaSecuencia = @secuencialMaeCiclo
	WHERE tabla = 'PiscinaCiclo' 
	END

--ROLLBACK TRAN
--COMMIT TRAN
GO
/****** Object:  StoredProcedure [dbo].[USP_REGULARIZACIONCICLOSEXCEL]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[USP_REGULARIZACIONCICLOSEXCEL](

--declare  
@keyPiscina varchar(50)
	)           
	AS 
	BEGIN
	
		 --select @idPiscina = 2010, @usuario='AdminPsCam', @fechaProceso = GETDATE() , @displayContent = 1   
		 -- Drop the temporary table if it exists                
		 --IF OBJECT_ID('tempdb..#ciclo_regularizar') IS NOT NULL                
			 --DROP TABLE ciclo_regularizar;                
                
		 -- Create and populate the temporary table      
		 insert into ciclo_regularizar
		 SELECT                  
		  ROW_NUMBER() OVER (ORDER BY ori_c.ciclo DESC) AS rn,                
		  p.idPiscina,            
		  ej.ciclo,                 
		  ej.FechaSiembra,                 
		  ej.fechaInicio,                 
		  ej.fechaCierre,                 
		  ej.idPiscinaEjecucion,                 
		  ej.cantidadEntrada,                 
		  ej.cantidadSalida,                 
		  ej.cantidadPerdida,                 
		  ori_c.Ciclo AS CicloOrigen,                
		  ori_c.[Fecha_IniSec] AS fechaInicioOrigen,                
		  ori_c.[Fecha_Siembra] AS fechaSiembraOrigen,                 
		  IIF(ori_c.[Fecha_Pesca] <> '', CAST(ori_c.[Fecha_Pesca] AS DATE), NULL) AS fechaPescaOrigen,                 
		  ori_c.[Fecha_Pesca] AS fechaTransferenciaOrigen,                
		  ori_c.[Cantidad_Sembrada] AS cantidadSembradaOrigen,  
		  case when ori_c.tipo = 'PRECRIADERO' then 'PRE01' when ori_c.tipo = 'PISCINA' then 'ENG01' else '' end AS rolOrigen, 
		  mp.lote, 'USUARIO' as usuario,
		  CASE WHEN ori_c.[Fecha_Pesca] IS NULL then 'EJE' else 'PRE' END AS ESTADO
                
		 FROM [dbo].[CICLOS_PRODUCCION] ori_c                
		 inner join PiscinaUbicacion p on p.keyPiscina = ori_c.Key_Piscina                        
		 inner join maePiscina mp on mp.idPiscina = p.idPiscina              
		 LEFT JOIN proPiscinaEjecucion ej ON P.idPiscina     = ej.idPiscina                  
		  AND ori_c.[Fecha_Siembra] >= DATEADD(day, -2, ej.FechaSiembra) --ej.FechaSiembra                   
		  AND ori_c.[Fecha_Siembra] <= DATEADD(day, 1, ej.FechaSiembra)                
		 WHERE p.KeyPiscina = @keyPiscina                
		 AND ori_c.Ciclo >= (                
		   SELECT MIN(ej2.Ciclo)                
		   FROM EjecucionesPiscinaView ej2                
		   WHERE  ej2.estado in ('EJE', 'PRE') AND ej2.keyPiscina = ori_c.Key_Piscina            
		  )


  
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTINSERTRECEPCIONES]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE     PROC [dbo].[USP_SCRIPTINSERTRECEPCIONES]( @PISCINATEMP VARCHAR(100), @usarTrans bit = 0)
		AS BEGIN
		--DECLARE @usarTrans BIT = 1
		--DECLARE @PISCINATEMP VARCHAR(100) = 'DAKARPCB'
 
		DROP TABLE IF EXISTS #RecepcionesTemp;

with CTE as (
			select r.fechaRecepcion, ej.ciclo, ej.FechaInicio, ej.FechaSiembra, ej.FechaCierre, ej.keyPiscina, ej.cod_Ciclo, 
			ej.codigoZona , ej.codigoCamaronera, ej.codigoSector, rd.* 
			from proRecepcionEspecieDetalle rd
			INNER JOIN proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
			INNER JOIN EjecucionesPiscinaViewEstructura ej on ej.idPiscinaEjecucion = rd.idPiscinaEjecucion
			where  r.estado = 'APR')

	SELECT 
	0 as idRecepcion,							'01' as empresa,							'01' as division,				pu.codigoZona,	
	pu.codigoCamaronera,						pu.codigoSector, 							pu.idPiscina,					
	ta.Ciclo,									
	CASE WHEN ta.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN ta.tipo = 'PISCINA' THEN 'ENG01' ELSE '' END rolPiscina,								
	0 as secuencia,					'PLA' as origen,							
	null idOrdenCompra,					 		null idDespacho,							null idPlanificacionSiembra,
	COALESCE(LP.idLaboratorio,0) idLaboratorio,	COALESCE(LP.idLaboratorioLarva,0) idLaboratorioLarva,	COALESCE(LM.idLaboratorioLarva,0) idLaboratorioMaduracion,	
	Peso_Siembra,								PlGr_Guia as plGramoLab,			        COALESCE(PlGr_Llegada,PlGr_Guia) as plGramoCam,		ta.Fecha_Siembra as fechaRegistro,		
	DATEADD(DAY, -1, ta.Fecha_Siembra) as fechaDespacho, 	ta.Fecha_Siembra as fechaRecepcion,		'06:00:00' as horaDespacho,	 '07:00:00' as horaRecepcion,
	0 as idResponsableSiembra,					1 as idEspecie,										'00001' AS tipoLarva,		  ta.Cantidad_Sembrada as cantidad, 
	1 as cantidadPlus,							(ta.Cantidad_Sembrada * 0.15) as porcentajePlus,
	'UNIDAD' as unidadMedida,					ta.Cantidad_Sembrada as cantidadRecibida,	ta.Guia_Remision as guiasRemision,	  0 as tieneFactura, 
	'Regularizada' as descripcion,				'' as responsableEntrega,					'APR' AS estado,					  'AdminPsCam' as usuarioResponsable,
	'adminPsCam'   as usuarioCreacion,			'::RECEP' AS estacionCreacion,				GETDATE() AS fechaHoraCreacion,		
	'adminPsCam'   as usuarioModificacion,		'::RECEP' AS estacionModificacion,			GETDATE() AS fechaHoraModificacion,		null AS reprocesoContable,
	0 procesado,								ta.Fecha_Siembra,							ta.KeyPiscina,						  ta.Cod_Ciclo,
    ta.Cantidad_Sembrada			
	into #RecepcionesTemp
FROM 
    RECEPCIONES_PRODUCCION ta
LEFT JOIN 
    CTE ts
ON 
    ta.Fecha_Siembra = ts.fechaRecepcion AND 
    ta.KeyPiscina = ts.keyPiscina AND 
    ta.Cod_Ciclo = ts.cod_ciclo --AND 
INNER JOIN PiscinaUbicacion pu on ta.KeyPiscina = pu.keyPiscina
LEFT JOIN LABORATORIO_PROCEDENCIA_PRODUCCION LP ON LP.Procedencia_Laboratorio = ta.Procedencia_Laboratorio
LEFT JOIN LABORATORIO_MADURACION_PRODUCCION  LM ON LM.Maduracion = ta.Maduracion
WHERE 
    ts.fechaRecepcion IS NULL
    AND ts.keyPiscina IS NULL
    AND ts.cod_ciclo IS NULL
    AND ts.cantidadRecibida IS NULL
	AND ta.KeyPiscina = @PISCINATEMP
	AND ta.ciclo >= (select min(ciclo) from EjecucionesPiscinaView p where p.keyPiscina = ta.KeyPiscina and p.estado IN ('PRE','EJE'));

		BEGIN TRY
			if @usarTrans = 1 BEGIN BEGIN TRAN END

			declare @EjecucionExistente bit = 1
		
			declare @secuencialPiscinaEjecucion int = 0
			declare @secuencialPiscinaEjecucionSiguiente int = null
			declare @secuencialMaeCiclo int = 0
			declare @secuencialRecepcion int = 0
			declare @secuencialRecepcionDetalle int = 0

			declare @secuencia int = 0
			declare @cicloRecepcion varchar(100)
			declare @MESAJEERROR varchar(100)
			declare @fechaProceso dateTime = getdate()
			declare @usuarioAudit varchar(50) = 'AdminPsCam'

			declare @keyPiscina varchar(50)
			--Bloqueamos las tablas de secuenciales
			SELECT top 1 1 FROM proSecuencial WITH (TABLOCKX)
			SELECT top 1 1 FROM maeSecuencial WITH (TABLOCKX)
				
			DROP TABLE IF EXISTS #InsertRecepTemp  

			select '#RecepcionesTemp', * from #RecepcionesTemp 
			set @cicloRecepcion = (SELECT TOP 1 Cod_Ciclo from #RecepcionesTemp);

			IF(@cicloRecepcion IS NULL)
				BEGIN
					SELECT 'NO EXISTE NINGUNA PISCINA A INGRESAR'
					if @usarTrans = 1 BEGIN ROLLBACK TRAN END
					RETURN;
				END
			--/***************FIN VARIABLES INICIALES****************/--
			IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion) > 0
				BEGIN 
				select 1 AS CONDICION, @cicloRecepcion AS CICLO

					set @secuencialPiscinaEjecucion			 = (select idPiscinaEjecucion from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion)
					set @secuencialPiscinaEjecucionSiguiente = (select idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion)

					select @secuencialPiscinaEjecucion qwe,@secuencialPiscinaEjecucionSiguiente qwesgt

					set @secuencialMaeCiclo = (select idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion)
					set @EjecucionExistente = 1
				END
			ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
					AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
					AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado = 'INI'
					WHERE CP.Cod_Ciclo = @cicloRecepcion)
				BEGIN
				select 2 AS CONDICION, @cicloRecepcion AS CICLO
					SELECT TOP 1  @secuencialPiscinaEjecucion = E.idPiscinaEjecucion
						FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
								AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
								AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
								WHERE CP.Cod_Ciclo = @cicloRecepcion

								   
						SELECT TOP 1 @secuencialPiscinaEjecucionSiguiente = ultimaSecuencia + 1
						FROM	proSecuencial 
						WHERE	tabla = 'piscinaEjecucion' 

						select @secuencialMaeCiclo = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion

							SET @EjecucionExistente = 1
							 
						select @secuencialPiscinaEjecucion AS ID, @secuencialPiscinaEjecucionSiguiente AS IDSGT
				END
			ELSE
				BEGIN 
					set @MESAJEERROR = 'NO EXISTE EJECUCIÓN PARA LA PISCINA ' + @PISCINATEMP

					RAISERROR('NO EXISTE EJECUCIÓN PARA LA PISCINA ', 16,1)

				END
		
				select 'recepcion'
				--/*INICIO SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
							
				SELECT TOP 1 @secuencialRecepcion = ultimaSecuencia
				FROM	proSecuencial 
				WHERE	tabla = 'recepcionEspecie' 

				SELECT TOP 1 @secuencialRecepcionDetalle = ultimaSecuencia 
				FROM  proSecuencial 
				WHERE tabla = 'recepcionEspecieDetalle' 

				--/*FIN SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
						
				-------STEP 5 GENERAMOS LA RECEPCION (TEMPORAL, CABECERA Y DETALLE)
				SELECT
					ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcion		AS idRecepcion,
					ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcionDetalle AS idRecepcionDetalle,
					empresa,				 division,			   codigoZona,				codigoCamaronera,		codigoSector,				0 as secuencia,			origen, 
					idOrdenCompra,			 idDespacho,	       idPiscina,				rolPiscina,				idPlanificacionSiembra,		idLaboratorio,			idLaboratorioLarva,		
					idLaboratorioMaduracion, fechaRegistro,        fechaDespacho,		    fechaRecepcion,         horaDespacho,				horaRecepcion,			idResponsableSiembra, 
					idEspecie,				 tipoLarva,            cantidad,				cantidadPlus,			porcentajePlus,				unidadMedida,			cantidadRecibida, 
					guiasRemision,           plGramoCam,           plGramoLab,				tieneFactura,			descripcion,				responsableEntrega,		estado,
					usuarioResponsable,      usuarioCreacion,      estacionCreacion,		fechaHoraCreacion,
					usuarioModificacion,     estacionModificacion, fechaHoraModificacion,	Cod_Ciclo,				Ciclo--, reprocesoContable 
					into #InsertRecepTemp 
				FROM #RecepcionesTemp 
				where Cod_Ciclo = @cicloRecepcion and procesado = 0 ; 
				
				SELECT 'PSDFS',* FROM #InsertRecepTemp
				-------CABECERA RECEPCION
				INSERT INTO [dbo].[proRecepcionEspecie] (
					idRecepcion,         empresa,              division,            zona,                   camaronera,            sector,             secuencia, 
					origen,              idOrdenCompra,        idDespacho,          idPlanificacionSiembra, idLaboratorio,         idLaboratorioLarva, fechaRegistro,
					fechaDespacho,       fechaRecepcion,       horaDespacho,        horaRecepcion,          idResponsableSiembra,  idEspecie,          tipoLarva, 
					cantidad,            cantidadPlus,         porcentajePlus,      unidadMedida,           cantidadRecibida,
					guiasRemision,       tieneFactura,         descripcion,         responsableEntrega,     estado,                usuarioResponsable, 
					usuarioCreacion,     estacionCreacion,     fechaHoraCreacion, 
					usuarioModificacion, estacionModificacion, fechaHoraModificacion)						--, reprocesoContable)
				SELECT
					idRecepcion,		 empresa,				division,			codigoZona,					codigoCamaronera,		codigoSector,		idRecepcion, 
					origen,				 idOrdenCompra,			idDespacho,			idPlanificacionSiembra,		idLaboratorio,			idLaboratorioLarva, fechaRegistro, 
					fechaDespacho,		 fechaRecepcion,		horaDespacho,		horaRecepcion,				idResponsableSiembra,	idEspecie,			tipoLarva, 
					cantidad,			 cantidadPlus,			porcentajePlus,		unidadMedida,				cantidadRecibida,		
					guiasRemision,		 tieneFactura,		    descripcion,	    responsableEntrega,         estado,				    usuarioResponsable,		
					usuarioCreacion,	 estacionCreacion,		fechaHoraCreacion,
					usuarioModificacion, estacionModificacion,  fechaHoraModificacion							--, reprocesoContable
				FROM #InsertRecepTemp

				-------DETALLE RECEPCION 
				INSERT INTO [dbo].[proRecepcionEspecieDetalle] (
						idRecepcionDetalle,			idRecepcion,				idPiscinaPlanificacion,		orden,					idPiscina,			      rolPiscina,			
						cantidad,					unidadMedida,				cantidadRecibida,			cantidadAdicional,		idPiscinaEjecucion,		  idCodigoGenetico,	
						idLaboratorioMaduracion,	codigoLarva,				biomasa,				    oxigeno,                salinidad,                temperatura,   
						costoLarva,					costoServiciosPrestados,	costoFlete,					amonio,					ph,						  alcalinidad,			
						conteoAlgas,			    descripcion,				numeroCajas,				numeroTinas,            tanqueOrigen,             plGramoLab, 
						plGramoCam,				    numeroArtemia,				calidadAgua,			    tanqueCalidadAguaBuena, tanqueCalidadAguaRegular, tanqueCalidadAguaMala,
						observacionParametro,       observacionCaracteristica,	activo,						idMotivoAuditoria,
						usuarioCreacion,            estacionCreacion,			fechaHoraCreacion,			usuarioModificacion,
						estacionModificacion,		fechaHoraModificacion)		--, origenPlGramo)
				SELECT
						idRecepcionDetalle,				idRecepcion,						0 as idPiscinaPlanificacion,	1,							idPiscina,						rolPiscina, 
						cantidad,						unidadMedida,						cantidadRecibida,				porcentajePlus,				@secuencialPiscinaEjecucion,    null as idCodigoGenetico, 
						idLaboratorioMaduracion,		null as codigoLarva,				null as biomasa,				null as oxigeno,			null as salinidad,			    null as temperatura, 
						null as costoLarva,				null as costoServiciosPrestados,	null as costoFlete,				null as amonio,			    null as ph,					    null as alcalinidad, 
						null as conteoAlgas,			'' as descripcion,					null as numeroCajas,			3 as numeroTinas,			null as tanqueOrigen,			plGramoLab, 
						plGramoCam,						null as numeroArtemia,				null as calidadAgua,		    1 as tanqueCalidadAguaBuena, 1 as tanqueCalidadAguaRegular, 1 as tanqueCalidadAguaMala,
						null as observacionParametro,	null as observacionCaracteristica,	1 as activo,                    null as idMotivoAuditoria,
						usuarioCreacion,				estacionCreacion,					fechaHoraCreacion,			    usuarioModificacion,
						estacionModificacion,			fechaHoraModificacion				--, 'CAM' as origenPlGramo
				FROM #InsertRecepTemp;

				UPDATE proSecuencial 
				SET    ultimaSecuencia = (select MAX(idRecepcion) from #InsertRecepTemp )
				WHERE  tabla		   = 'recepcionEspecie' 
							
				UPDATE proSecuencial 
				SET    ultimaSecuencia = (select MAX(idRecepcionDetalle) from #InsertRecepTemp )
				WHERE  tabla		   = 'recepcionEspecieDetalle' 

				
			if @usarTrans = 1 BEGIN ROLLBACK TRAN END
		END TRY
		BEGIN CATCH
			-----REVERSA DE LA TRANSACCION
			if @usarTrans = 1 BEGIN ROLLBACK TRAN END
			SELECT  
				 ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  

				DECLARE @ErrorMessage  NVARCHAR(4000), 
						@ErrorSeverity INT, 
						@ErrorState INT;

				SELECT  @ErrorMessage  = ERROR_MESSAGE(), 
						@ErrorSeverity = ERROR_SEVERITY(), 
						@ErrorState    = ERROR_STATE();
			
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END CATCH
	END


	

GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTINSERTTRANSFERENCIASDESTINO]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE     PROC [dbo].[USP_SCRIPTINSERTTRANSFERENCIASDESTINO] (@keyDestino VARCHAR(100))
	AS BEGIN

		--DECLARE @SECTORFILTER VARCHAR(100) = 'CAPULSA' --'COSTARICAI';
		--DECLARE @PiscinaTemp VARCHAR(100) ;
		--select @PiscinaTemp = 'CAPULSA5';
		--DECLARE @ISROOLBACK bit = 1
		DROP TABLE IF EXISTS #TranferenciaTemp;

	with CTE2 as (
		select TE.fechaTransferencia, ej.keyPiscina, ej.cod_ciclo, ted.* from proTransferenciaEspecieDetalle ted
				INNER JOIN proTransferenciaEspecie te on te.idTransferencia = ted.idTransferencia
				INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = ted.idPiscinaEjecucion
				where  te.estado = 'APR')


	SELECT	'01' AS empresa,			'01' AS division,	  pu.codigoZona AS zona,		 pu.codigoCamaronera AS camaronera,			pu.codigoSector AS sector, 
			pu.idPiscina,				 pu.codigoPiscina,  

			CASE WHEN ta.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN ta.tipo = 'PISCINA' THEN 'ENG01' WHEN ta.tipo = 'REPRODUCTOR' THEN 'REP01' ELSE '' END AS ROL,  
			REPLACE(Sector_Origen ,' ','')	 +   CONVERT(VARCHAR(200),Piscina_Origen)    AS keyOrigen, 

			Cod_Ciclo_Origen,					fecha_Transf,		pu.codigoZona AS Zona_Origen,   pu.codigoCamaronera as Camaronera_Origen,   pu.nombreSector,			 pu.codigoSector as Sector_Origen, 
			Piscina_Origen,					   Ciclo_Origen,		ta.Tipo,							Sub_Tipo,									Estatus_Origen, 
			Hectarea_Origen,					ta.Fecha_Siembra,	ta.Cantidad_Sembrada,			ta.Densidad,									Peso_Siembra, 
			Estatus_Transf,					   Cons_Balanc,		    Guia_Transf,					Forma_Transf,   

			CASE WHEN ta.linea = 'TANQUERO'         THEN '001' 	  WHEN ta.linea = 'TUBERÍA' THEN '002' 
			WHEN ta.linea = 'TUBERÍA-TANQUERO' THEN '003'    WHEN ta.linea = 'A PIE'   THEN '004' 
			WHEN ta.linea = 'DESCUELGUE'       THEN '006'    ELSE '001'			   END	 AS tipoTransferencia,

			REPLACE(Sector_Destino ,' ','') + CONVERT(VARCHAR(200),Piscina_Destino) AS keyDestino,	
			Cod_Ciclo_Destino,			          puD.codigoZona   AS Zona_Destino,			puD.codigoCamaronera AS  Camaronera_Destino,		puD.codigoSector AS  Sector_DestinoCOD,		puD.idPiscina AS idPiscinaDestino,
			Piscina_Destino,					  Ciclo_Destino,							Estatus_Destino,									Hectarea_Destino,							Cantidad_Transf, 
			Peso_Transf,						  Peso_Real,								Libras_Transf,										Conv,										Procedencia_Laboratorio, 
			Linea,								  Maduracion,								Superv,												Balanc,										Lib_Transf_C, 
			Anio,								  Estatus_Transf   AS TipoTransfTOTAL,		'APR' AS estado,									'AdminPsCam'     AS usuarioResponsable,
			'adminPsCam' AS usuarioCreacion,	  ':TRANSINSERT' AS estacionCreacion,      GETDATE() AS fechaHoraCreacion, 
			'adminPsCam' AS usuarioModificacion,  ':TRANSINSERT' AS estacionModificacion,  GETDATE() AS fechaHoraModificacion,					0 procesado,
			(SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = puD.idPiscina AND pp.ciclo = ta.Ciclo_Destino) idPiscinaEjecucionDestino,
			(SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = pu.idPiscina AND pp.ciclo = ta.Ciclo_Origen) idPiscinaEjecucionOrigen

	INTO #TranferenciaTemp
	FROM 
		TRANSFERENCIAS_PRODUCCION ta
	LEFT JOIN 
		CTE2 ts
	ON 
		ta.Fecha_Transf = ts.fechaTransferencia AND 
		ta.KeyPiscinaDestino = ts.keyPiscina AND 
		ta.Cod_Ciclo_Destino = ts.cod_ciclo --AND 
		--ta.Cantidad_Transf = ts.cantidadTransferida
	INNER JOIN PiscinaUbicacion pu on ta.keyPiscinaOrigen = pu.keyPiscina
	INNER JOIN PiscinaUbicacion puD on ta.keyPiscinaDestino = puD.keyPiscina
	WHERE 
		ts.fechaTransferencia IS NULL
		AND ts.keyPiscina IS NULL
		AND ts.cod_ciclo IS NULL
		AND ts.cantidadTransferida IS NULL
		and ta.keyPiscinaDestino = @keyDestino
		AND ta.Ciclo_Destino >= (select min(ciclo) from EjecucionesPiscinaView p where p.keyPiscina = ta.keyPiscinaDestino and p.estado IN ('PRE','EJE'))
		AND (SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = puD.idPiscina AND pp.ciclo = ta.Ciclo_Destino) is not null
		AND	(SELECT top 1 idPiscinaEjecucion FROM proPiscinaEjecucion pp where pp.idPiscina = pu.idPiscina AND pp.ciclo = ta.Ciclo_Origen) is not null;

		BEGIN TRY

			declare @secuencialTransferencia int = 0
			declare @secuencialTransferenciaDetalle int = 0

			declare @usuarioAudit varchar(50) = 'AdminPsCam'
			DECLARE @MESAJEERROR VARCHAR(100)

			--Bloqueamos las tablas de secuenciales
			SELECT top 1 1 FROM proSecuencial WITH (TABLOCKX)
			SELECT top 1 1 FROM maeSecuencial WITH (TABLOCKX)
	--/***************INCIO VARIABLES INICIALES****************/--
	SELECT distinct keyDestino FROM #TranferenciaTemp
	IF NOT exists (SELECT distinct keyDestino FROM #TranferenciaTemp) 
		BEGIN
			SELECT 'NO EXISTE NINGUNA TRANSFERENCIA A INGRESAR'
			RETURN;
		END


	DROP TABLE IF EXISTS #InsertTransfTemp  

		SELECT TOP 1 @secuencialTransferencia = ultimaSecuencia 
		FROM	proSecuencial 
		WHERE	tabla = 'transferenciaEspecie' 

		SELECT TOP 1 @secuencialTransferenciaDetalle = ultimaSecuencia 
		FROM	proSecuencial 
		WHERE	tabla = 'transferenciaEspecieDetalle' 
								
		SELECT top 1
			ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferencia		  AS idTransferencia,
			ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferenciaDetalle AS idTransferenciaDetalle,
			empresa,			                    fecha_Transf  AS fechaRegistro,		     fecha_Transf                AS fechaTransferencia,      ROL,
			Sector_Origen,							Cod_Ciclo_Origen,						 Ciclo_Origen,
			tipoTransferencia,				        idPiscina,								 1                            AS idEspecie,              0   AS guiaTransferencia,		
			Cantidad_Transf AS cantidadTransferida, Peso_Transf  AS pesoTransferidoGramos,   0	AS esTotal,    
			Sector_DestinoCOD,                      null         AS cantidadRemanente,       densidad,												 0 as balanceado, 
			''             AS descripcion,          usuarioResponsable,						 estado,												 usuarioCreacion,
			estacionCreacion,						fechaHoraCreacion,                       usuarioModificacion,                                    estacionModificacion,
			Peso_Siembra,							Peso_Transf,							 Peso_Real,												 Lib_Transf_C, 
			Libras_Transf  AS librasDeclaradas,		Ciclo_Destino,						     fechaHoraModificacion, null as reprocesoContable,       Cod_Ciclo_Destino, 
			idPiscinaDestino,						TipoTransfTOTAL,						 procesado = 0,								 			 keyDestino,
			idPiscinaEjecucionOrigen,				idPiscinaEjecucionDestino
		INTO #InsertTransfTemp
		FROM #TranferenciaTemp

		select 'ESTO ES #InsertTransfTemp', * FROM #InsertTransfTemp

		IF exists (select 1 from #InsertTransfTemp)
				BEGIN
							
			select 'trans'
							
					INSERT INTO [dbo].[proTransferenciaEspecie] (
						idTransferencia,				empresa,						secuencia,				fechaRegistro,		    fechaTransferencia,
						tipoTransferencia,				idPiscina,						idEspecie,				guiaTransferencia,     
						cantidadTransferida,            pesoTransferidoGramos,			idPiscinaEjecucion,		esTotal,				
						cantidadRemanente,				densidad,						balanceado,				descripcion,
						usuarioResponsable,				estado,							usuarioCreacion,
						estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, reprocesoContable)
					SELECT
						idTransferencia,				empresa,						idTransferencia,		fechaRegistro,			fechaTransferencia,
						tipoTransferencia,				idPiscina,						idEspecie,				RIGHT('0000000000' + CAST(idTransferencia AS VARCHAR(9)),9)   AS guiaTransferencia, 
						cantidadTransferida,			pesoTransferidoGramos,			idPiscinaEjecucionOrigen,		
						CASE WHEN (ROW_NUMBER() OVER (PARTITION BY fechaTransferencia ORDER BY idTransferencia)) = 1 THEN 1 ELSE 0 END AS esTotal, 
						cantidadRemanente,				densidad,						balanceado,				descripcion, 
						usuarioResponsable,				estado,							usuarioCreacion, 
						estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, reprocesoContable
					FROM #InsertTransfTemp;
					
									
					INSERT INTO [dbo].[proTransferenciaEspecieDetalle] (
								idTransferenciaDetalle,			idTransferencia,			 orden,									idPiscina,				rolPiscina,				cantidadTransferida,
								pesoPromedioTransferencia,		biomasa,					 
								idPiscinaEjecucion,				tipoTransferencia,			 horaInicioTransferencia,				horaFinTransferencia, 
								observacion,					observacionParametro,		 observacionCaracteristica,				usuarioResponsable,		activo, 
								usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
								librasDeclaradas,				cantidadDeclarada,			 pesoDeclaradoTransferido,				numeroViajes)
					SELECT
								idTransferenciaDetalle,			idTransferencia,			 1,										idPiscinaDestino,		ROL as rolPiscina,		cantidadTransferida,
								pesoTransferidoGramos,			(cantidadTransferida * pesoTransferidoGramos) * 0.00220462 as biomasa, 
								idPiscinaEjecucionDestino,		tipoTransferencia,			'06:00:00' as horaInicioTransferencia, '06:00:00' as horaFinTransferencia, 
								'' as observacion,				null,						null,									usuarioResponsable,		1, 
								usuarioCreacion,				estacionCreacion,			fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
								librasDeclaradas,				cantidadTransferida,		pesoTransferidoGramos,					null
					FROM		#InsertTransfTemp

								
					UPDATE proSecuencial 
					SET    ultimaSecuencia = (SELECT MAX(idTransferencia) FROM #InsertTransfTemp)  
					WHERE tabla		   = 'transferenciaEspecie' 

					UPDATE proSecuencial 
					SET    ultimaSecuencia = (SELECT MAX(idTransferenciaDetalle) FROM #InsertTransfTemp) 
					WHERE  tabla		   = 'transferenciaEspecieDetalle' 

				END
			
		END TRY
		BEGIN CATCH
			-----REVERSA DE LA TRANSACCION
			SELECT  
				 ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  

				DECLARE @ErrorMessage  NVARCHAR(4000), 
						@ErrorSeverity INT, 
						@ErrorState INT;

				SELECT  @ErrorMessage  = ERROR_MESSAGE(), 
						@ErrorSeverity = ERROR_SEVERITY(), 
						@ErrorState    = ERROR_STATE();
			
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END CATCH
	END

GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTMOVIMIENTORECEPCIONES]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



	--sp_helptext USP_SCRIPTMOVIMIENTOTRANSFERENCIAS  


	CREATE    PROC [dbo].[USP_SCRIPTMOVIMIENTORECEPCIONES]( @SECTORFILTER VARCHAR(100),
	@PISCINATEMP VARCHAR(100), @usarTrans bit = 0)
		AS BEGIN
		--DECLARE @usarTrans BIT = 1
		--DECLARE @SECTORFILTER VARCHAR(100) = 'LOSANGELES'
		--DECLARE @PISCINATEMP VARCHAR(100) = 'LOSANGELESPC3'
		--select * from CICLOS_PRODUCCION where Key_Piscina ='CAPULSAPC2'
		--DECLARE @PISCINALLAVE VARCHAR(100) = 'CAPULSAPC4.91'
 
		DROP TABLE IF EXISTS #EJECUCIONESTEMP			
		DROP TABLE IF EXISTS #FILTERPISCINAKEYTEMP		
		DROP TABLE IF EXISTS #RecepcionesTemp			
		DROP TABLE IF EXISTS #TranferenciaTempPrev		
		DROP TABLE IF EXISTS #TranferenciaTemp			

		/*Nomenclatura Preparacion = "PRE"; Manual = "MAN"; EjecucionPiscina = "EJE"; MantenimientoPiscina = "MNT";*/
		--STEP 1: Query para poblar temporal de ejecuciones moldeado a keys de excel
			SELECT	pu.codigoZona,	       pu.nombreZona,       pu.codigoCamaronera, pu.nombreCamaronera, 
					pu.codigoSector,       pu.nombreSector,     pu.codigoPiscina,    pu.nombrePiscina, 
					ce.codigoElemento,     ce.nombreElemento,   pe.idPiscina,        
					pu.nombreSector + pu.nombrePiscina + '.' + CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, 
					pu.nombreSector + pu.nombrePiscina AS keyPiscina, 
					pe.idPiscinaEjecucion, pe.ciclo,            pe.fechaInicio,      pe.fechaSiembra, 
					pe.fechaCierre,			pe.cantidadEntrada
			INTO #EJECUCIONESTEMP 
			FROM proPiscinaEjecucion pe 
				INNER JOIN PiscinaUbicacion  pu ON  pe.idPiscina	 = pu.idPiscina 
				INNER JOIN CATALOGO_ELEMENTS ce ON ce.codigoElemento = pe.rolPiscina AND ce.codigoCatalogo = 'maeRolPiscina' 
			WHERE estado in ('EJE', 'PRE')

		--select cp.Cod_Ciclo, Key_Piscina, cp.Ciclo as CicloExcel, Fecha_IniSec, Fecha_Siembra, Fecha_Pesca, Cantidad_Sembrada, Zona, Camaronera, Sector, Piscina, Tipo,Tipo_Siembra, Densidad,
		--ej.fechaInicio, ej.fechaSiembra, ej.fechaCierre, ej.cantidadEntrada, ej.ciclo, DATEDIFF(day, Fecha_IniSec, ej.fechaInicio) InicioDiff, DATEDIFF(day, Fecha_Siembra, ej.fechaSiembra) SiembraDiff,DATEDIFF(day, Fecha_Pesca, ej.fechaCierre) CierreDiff,
		--(Cantidad_Sembrada - ej.cantidadEntrada) CantidadDiff, idPiscina, idPiscinaEjecucion
		----into #FILTERPISCINAKEYTEMP
		--from CICLOS_PRODUCCION cp
		--left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
		--WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) AND Sector =@SECTORFILTER order by 1 --and ej.ciclo is null

	   --FILTRAMOS LAS PISCINAS A REGULARIZAR
			SELECT cp.Key_Piscina, cp.Ciclo, cp.Cantidad_Sembrada
			into #FILTERPISCINAKEYTEMP
			from CICLOS_PRODUCCION cp
			left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
			WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
			AND cp.Key_Piscina = @PISCINATEMP and ej.ciclo is null

	   --STEP 2: Query para creación de tabla de transferencia con homologaciones de piscinas con códigos de Insigne
		SELECT  DISTINCT
				'01' AS empresa,			'01' AS division,	  pu.codigoZona AS zona,		 pu.codigoCamaronera AS camaronera,			pu.codigoSector AS sector, 
				 pu.idPiscina,				 pu.codigoPiscina,  

				 CASE WHEN t.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN t.tipo = 'PISCINA' THEN 'ENG01' ELSE '' END AS ROL,  
				 Sector_Origen	 +   CONVERT(VARCHAR(200),Piscina_Origen)    AS keyOrigen, 

				 Cod_Ciclo_Origen,					   fecha_Transf,		pu.codigoZona AS Zona_Origen,   pu.codigoCamaronera as Camaronera_Origen,   pu.nombreSector,			 pu.codigoSector as Sector_Origen, 
				 Piscina_Origen,					   Ciclo_Origen,		Tipo,							Sub_Tipo,									Estatus_Origen, 
				 Hectarea_Origen,					   Fecha_Siembra,		Cantidad_Sembrada,				Densidad,									Peso_Siembra, 
				 Estatus_Transf,					   Cons_Balanc,		    Guia_Transf,					Forma_Transf,   

				 CASE WHEN t.linea = 'TANQUERO'         THEN '001' 	  WHEN t.linea = 'TUBERÍA' THEN '002' 
					  WHEN t.linea = 'TUBERÍA-TANQUERO' THEN '003'    WHEN t.linea = 'A PIE'   THEN '004' 
					  WHEN t.linea = 'DESCUELGUE'       THEN '006'    ELSE '001'			   END	 AS tipoTransferencia,

				Sector_Destino + CONVERT(VARCHAR(200),Piscina_Destino) AS keyDestino,	
				Cod_Ciclo_Destino,			          puD.codigoZona   AS Zona_Destino,			puD.codigoCamaronera AS  Camaronera_Destino,		puD.codigoSector AS  Sector_DestinoCOD,		puD.idPiscina AS idPiscinaDestino,
				Piscina_Destino,					  Ciclo_Destino,							Estatus_Destino,									Hectarea_Destino,							Cantidad_Transf, 
				Peso_Transf,						  Peso_Real,								Libras_Transf,										Conv,										Procedencia_Laboratorio, 
				Linea,								  Maduracion,								Superv,												Balanc,										Lib_Transf_C, 
				Anio,								  Estatus_Transf   AS TipoTransfTOTAL,		'APR' AS estado,									'AdminPsCam'     AS usuarioResponsable,
			   'adminPsCam' AS usuarioCreacion,		 '::RECEP' AS estacionCreacion,      GETDATE() AS fechaHoraCreacion, 
			   'adminPsCam' AS usuarioModificacion,  '::RECEP' AS estacionModificacion,  GETDATE() AS fechaHoraModificacion
		 INTO #TranferenciaTempPrev
		FROM TRANSFERENCIAS_PRODUCCION t   
			left join #EJECUCIONESTEMP pu  ON pu.keyPiscina  = t.keyPiscinaOrigen   
			INNER join #EJECUCIONESTEMP puD ON puD.keyPiscina = t.keyPiscinaDestino
		WHERE T.keyPiscinaOrigen IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) 
			AND t.Ciclo_Origen >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = t.keyPiscinaOrigen)
		ORDER BY 1

		SELECT 	ROW_NUMBER ( ) OVER ( order by t.fecha_Transf,  t.keyOrigen,  t.keyDestino)  as rowKeySecuencia#,
				ROW_NUMBER ( ) OVER ( PARTITION BY keyOrigen order by  t.fecha_Transf, keyDestino ,Piscina_Origen, t.Cod_Ciclo_Origen)  as rowKey#, 
				ROW_NUMBER ( ) OVER ( PARTITION BY t.Cod_Ciclo_Origen order by  t.fecha_Transf, keyOrigen , t.Cod_Ciclo_Origen)  as rowCiclo#, *
				INTO #TranferenciaTemp
				FROM #TranferenciaTempPrev t 
	
		 --STEP 3: Query para creación de tabla de recepciones con homologaciones de piscinas con códigos de Insigne
		SELECT 
			ROW_NUMBER ( ) OVER ( order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowKeySecuencia#,
			ROW_NUMBER ( ) OVER ( PARTITION BY r.KeyPiscina order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)  as rowKey#,   
			ROW_NUMBER ( ) OVER ( PARTITION BY r.Cod_Ciclo order by r.Fecha_Siembra, r.KeyPiscina, r.Cod_Ciclo)   as rowCiclo#, r.Cod_Ciclo,r.KeyPiscina as KeyPiscina,
			0 as idRecepcion,					'01' as empresa,							'01' as division,				pu.nombreZona as NombreZoma,	
			pu.codigoZona as zona,				 pu.nombreCamaronera as nombreCamaronera, 
			pu.codigoCamaronera as camaronera,	 r.Sector as nombreSector,					pu.codigoSector as sector, 
			r.Piscina,							 pu.codigoPiscina,						    pu.idPiscina,					r.Ciclo, 
			case when r.tipo = 'PRECRIADERO' then 'PRE01' when r.tipo = 'PISCINA' then 'ENG01' else '' end AS ROL, 
			0 as secuencia,				 		 'PLA' as origen,							null idOrdenCompra, 
			null idDespacho,				     null idPlanificacionSiembra,
			COALESCE(LP.idLaboratorio,0) as idLaboratorio, COALESCE(LP.idLaboratorioLarva,0) as idLaboratorioLarva,	COALESCE(LM.idLaboratorioLarva,0)  as idLaboratorioMaduracion,	Peso_Siembra, 
			PlGr_Guia as plGramoLab,			           PlGr_Llegada as plGramoCam,								r.Fecha_Siembra as fechaRegistro,								DATEADD(DAY, -1, r.Fecha_Siembra) as fechaDespacho, 
			r.Fecha_Siembra as fechaRecepcion,             '06:00:00' as horaDespacho,								'07:00:00' as horaRecepcion,
			0 as idResponsableSiembra,				       1 as idEspecie,											'00001' AS tipoLarva,											r.Cantidad_Sembrada as cantidad, 
			1 as cantidadPlus,						       (r.Cantidad_Sembrada * 0.15) as porcentajePlus, 
			'UNIDAD' as unidadMedida,				       r.Cantidad_Sembrada as cantidadRecibida,					r.Guia_Remision as guiasRemision,								0 as tieneFactura, 
			'Regularizada' as descripcion,			       '' as responsableEntrega,									'APR' AS estado,											'AdminPsCam' as usuarioResponsable,
			'adminPsCam'   as usuarioCreacion,		       '::RECEP' AS estacionCreacion,									GETDATE() AS fechaHoraCreacion,		
			'adminPsCam'   as usuarioModificacion,         '::RECEP' AS estacionModificacion,							     GETDATE() AS fechaHoraModificacion,						null AS reprocesoContable,
			0 procesado
		INTO #RecepcionesTemp
		FROM RECEPCIONES_PRODUCCION r 
		left join #EJECUCIONESTEMP pu ON pu.Cod_Ciclo = r.Cod_Ciclo 
		LEFT JOIN LABORATORIO_PROCEDENCIA_PRODUCCION LP ON LP.Procedencia_Laboratorio = r.Procedencia_Laboratorio
		LEFT JOIN LABORATORIO_MADURACION_PRODUCCION  LM ON LM.Maduracion = r.Maduracion
		WHERE R.KeyPiscina IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) 
		and R.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = R.KeyPiscina)
		ORDER BY 1;

		with  cte as(
			select  idPiscina, nombreSector+nombrePiscina  KeyPiscina, codigoPiscina, codigoSector sector, nombreSector, nombreCamaronera, codigoCamaronera, codigoZona, nombreZona
				from PiscinaUbicacion   rb -- where   idPiscina is not null
		)
		update ru
		set ru.idPiscina = rb.idPiscina,
			ru.codigoPiscina = rb.codigoPiscina, 
			ru.sector = rb.sector,
			ru.camaronera = rb.codigoCamaronera,
			ru.nombreCamaronera = rb.nombreCamaronera,
			ru.zona  = rb.codigoZona,
			ru.NombreZoma = rb.nombreZona
		from 
		#RecepcionesTemp ru inner join cte rb on ru.KeyPiscina = rb.KeyPiscina   and ru.idPiscina is null;
	 
		
		select * from #RecepcionesTemp rp
		select * from #TranferenciaTemp rp
		
		BEGIN TRY
			if @usarTrans = 1 BEGIN BEGIN TRAN END

			declare @EjecucionExistente bit = 1
			declare @EjecucionExistenteDESTINO bit = 1
			declare @estadoTransferencia varchar(10)
			declare @EXISTE_CICLO_INICIADO bit = 0
		
			declare @secuencialRecepcion int = 0
			declare @secuencialRecepcionDetalle int = 0

			declare @secuencialRowKeyTransferencia int = 0
			declare @secuencialTransferencia int = 0
			declare @secuencialTransferenciaDetalle int = 0
			declare @maxSecuencialRecepcion int = 0

			declare @cantidadTransferencia int = 0 
			declare @FechaCierre date 
	
			declare @secuencialMaeCiclo int = 0
			declare @secuencialPiscinaEjecucion int = 0
			declare @secuencialPiscinaEjecucionSiguiente int = null

			declare @secuencialMaeCicloDESTINO int = 0
			declare @secuencialPiscinaEjecucionDESTINO int = 0
			declare @secuencialPiscinaEjecucionSiguienteDESTINO int = null

			declare @secuencia int = 0
			declare @cicloRecepcion varchar(100)
			declare @rowKeySecuencia int = 0
			declare @cicloTransferencia varchar(100)
			declare @fechaRecep dateTime
			declare @fechaProceso dateTime = getdate()
			declare @usuarioAudit varchar(50) = 'AdminPsCam'

			declare @idPiscina int
			declare @keyPiscina varchar(50)
			--Bloqueamos las tablas de secuenciales
			SELECT top 1 1 FROM proSecuencial WITH (TABLOCKX)
			SELECT top 1 1 FROM maeSecuencial WITH (TABLOCKX)
			
				WHILE exists (select procesado from #RecepcionesTemp where procesado = 0 )
				BEGIN
					--/***************INCIO VARIABLES INICIALES*********	*******/--
					SELECT TOP 1 @secuencia  = rowKeySecuencia# FROM #RecepcionesTemp  WHERE procesado = 0 ORDER BY rowKeySecuencia#;
					select top 1 @cicloRecepcion = Cod_Ciclo, @fechaRecep = fechaRecepcion, @rowKeySecuencia = rowKey# from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
					--SET @cicloRecepcion = @PISCINALLAVE --select top 1 @cicloRecepcion = @PISCINALLAVE from #RecepcionesTemp  where procesado = 0 order by rowKeySecuencia#;
				
					SELECT TOP 1 @idPiscina  = idPiscina, 
								 @keyPiscina = keyPiscina  
						   FROM  #EJECUCIONESTEMP 
						   WHERE Cod_Ciclo = @cicloRecepcion

					DROP TABLE IF EXISTS #InsertRecepTemp  

					--select 'antes propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = @PISCINATEMP and estado in ('INI','EJE', 'PRE') ORDER BY 4
					--ANTES DE INICIAR SE PUEDE REGULARIZAR LAS RECEPCIONES Y TRANSFERENCIAS UBICANDOS SUS IDS CORRECTOS

					select '#RecepcionesTemp', * from #RecepcionesTemp where procesado = 0
					--/***************FIN VARIABLES INICIALES****************/--
					IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion) >0
						BEGIN --yo se que aun falta el cilco 0 y cuando vienen en estado iniciado
						select 1 AS CONDICION, @cicloRecepcion AS CICLO

							set  @secuencialPiscinaEjecucion = (select idPiscinaEjecucion from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion)
							set @secuencialPiscinaEjecucionSiguiente = (select idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloRecepcion)

							select @secuencialPiscinaEjecucion qwe,@secuencialPiscinaEjecucionSiguiente qwesgt

							set @secuencialMaeCiclo = (select idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion)
							set @EjecucionExistente = 1
						END
					ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
							AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
							AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado = 'INI'
						   WHERE CP.Cod_Ciclo = @cicloRecepcion)
						BEGIN
						select 2 AS CONDICION, @cicloRecepcion AS CICLO
							SELECT TOP 1  @secuencialPiscinaEjecucion = E.idPiscinaEjecucion
								FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
										AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
										AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
									   WHERE CP.Cod_Ciclo = @cicloRecepcion

								   
								SELECT TOP 1 @secuencialPiscinaEjecucionSiguiente = ultimaSecuencia + 1
								FROM	proSecuencial 
								WHERE	tabla = 'piscinaEjecucion' 

								select @secuencialMaeCiclo = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucion

								 SET @EjecucionExistente = 1
								 SET @EXISTE_CICLO_INICIADO = 1
							 
								select @secuencialPiscinaEjecucion AS ID, @secuencialPiscinaEjecucionSiguiente AS IDSGT
						END
					ELSE
						BEGIN 
						select 3 AS CONDICION, @cicloRecepcion AS CICLO
							set @EjecucionExistente = 0
							--/*INICIO SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--
							UPDATE proSecuencial 
							SET    ultimaSecuencia = ultimaSecuencia + 1  
							WHERE  tabla		   = 'piscinaEjecucion' 

							SELECT TOP 1 @secuencialPiscinaEjecucion = ultimaSecuencia 
							FROM	proSecuencial 
							WHERE	tabla = 'piscinaEjecucion' 

							UPDATE maeSecuencial 
									SET ultimaSecuencia = ultimaSecuencia + 1 
							WHERE tabla = 'PiscinaCiclo' 

							SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia 
							FROM	maeSecuencial 
							WHERE	tabla = 'PiscinaCiclo' 
							--/*FIN SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--

							--select @secuencialPiscinaEjecucion, @cicloRecepcion
							SET @secuencialPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucion + 1;

							-------STEP 4 GENERAMOS LA EJECUCIÓN Y CICLO DE LA PISCINA A SEMBRAR (RECEPCIONAR)
	 						SELECT @secuencialPiscinaEjecucion, idPiscina,					 Ciclo,				ROL,			1,				sector,					DATEADD(DAY, -1, min(fechaRecepcion)), 
										min(fechaRecepcion),		null,						  '',				 1,				SUM(cantidad),	SUM( porcentajePlus),	0, 
										0,							null,						 'EJE',				 0,				0,				0,						1,
										@usuarioAudit,				'::RECEP',						 @fechaProceso,		
										@usuarioAudit,				'::RECEP',						 @fechaProceso
								FROM   #RecepcionesTemp 
								WHERE  Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
								GROUP BY idPiscina, Ciclo, rol, sector

								-------EJECUCION PISCINA
								INSERT INTO proPiscinaEjecucion (
										idPiscinaEjecucion,			idPiscina,					 ciclo,				rolPiscina,		numEtapa,		 lote,					fechaInicio, 
										fechaSiembra,				fechaCierre,				 tipoCierre,		idEspecie,		cantidadEntrada, cantidadAdicional,		cantidadSalida, 
										cantidadPerdida,			idPiscinaEjecucionSiguiente, estado,			tieneRaleo,		tieneRepanio,	 tieneCosecha,			activo, 
										usuarioCreacion,			estacionCreacion,			 fechaHoraCreacion, 
										usuarioModificacion,		estacionModificacion,		 fechaHoraModificacion) 
								SELECT @secuencialPiscinaEjecucion, idPiscina,					 Ciclo,				ROL,			1,				sector,					DATEADD(DAY, -1, min(fechaRecepcion)), 
										min(fechaRecepcion),		null,						  '',				 1,				SUM(cantidad),	SUM( porcentajePlus),	0, 
										0,							null,						 'EJE',				 0,				0,				0,						1,
										@usuarioAudit,				'::RECEP',						 @fechaProceso,		
										@usuarioAudit,				'::RECEP',						 @fechaProceso
								FROM   #RecepcionesTemp 
								WHERE  Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
								GROUP BY idPiscina, Ciclo, rol, sector
				
								-------CICLO PISCINA
								INSERT INTO [dbo].[maePiscinaCiclo] (
									idPiscinaCiclo,						idPiscina,			    ciclo,		
									fecha,								origen,				    idOrigen, 
									idOrigenEquivalente,				rolCiclo,			    activo, 
									usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
									usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
								SELECT 
									@secuencialMaeCiclo,					idPiscina,			ciclo, 
									DATEADD(DAY, -1, MIN(fechaRecepcion)), 'EJE',				@secuencialPiscinaEjecucion, 
									null as idOrigenEquivalente,            ROL,				1, 
									@usuarioAudit,						   '::RECEP',				@fechaProceso,
									@usuarioAudit,						   '::RECEP',				@fechaProceso
								FROM #RecepcionesTemp 
								WHERE	Cod_Ciclo  = @cicloRecepcion 
								GROUP BY idPiscina,  Ciclo, 
										 rol,        sector;
							--/*FIN SEPARACIÓN DE SECUENCIALES PISCINA EJECUCIÓN Y MAECICLO*/--

							-----------auditamos 
							--EXEC InsertLogEjecucionesCiclosProduccion 
							--			@idPiscina,		    @secuencialPiscinaEjecucion, 
							--			@secuencialMaeCiclo,@keyPiscina, 
							--			@cicloRecepcion,	'proRecepcion',
							--			'EJE',		        'proRecepcion'

						END

						SELECT @fechaRecep fechaRecep
					if not exists ( select top 1 1 from proRecepcionEspecieDetalle re 
									inner join proRecepcionEspecie r on re.idRecepcion = r.idRecepcion
									inner join EjecucionesPiscinaView ej on re.idPiscinaEjecucion = ej.idPiscinaEjecucion
									where ej.Cod_Ciclo = @cicloRecepcion 
									and DATEDIFF(day, r.fechaRecepcion, @fechaRecep) BETWEEN -0 AND 0 )
						BEGIN
							select 'recepcion'
							--/*INICIO SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
							
							SELECT TOP 1 @secuencialRecepcion = ultimaSecuencia
							FROM	proSecuencial 
							WHERE	tabla = 'recepcionEspecie' 

							SELECT TOP 1 @secuencialRecepcionDetalle = ultimaSecuencia 
							FROM  proSecuencial 
							WHERE tabla = 'recepcionEspecieDetalle' 

							--/*FIN SEPARACIÓN DE SECUENCIALES RECEPCION DE ESPECIES*/--
						
							-------STEP 5 GENERAMOS LA RECEPCION (TEMPORAL, CABECERA Y DETALLE)
							SELECT
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcion		AS idRecepcion,
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo) + @secuencialRecepcionDetalle AS idRecepcionDetalle,
								empresa,				 division,			   zona,					camaronera,				 sector,				 0 as secuencia,	origen, 
								idOrdenCompra,			 idDespacho,	       idPiscina,				ROL,					 idPlanificacionSiembra, idLaboratorio,		idLaboratorioLarva,		
								idLaboratorioMaduracion, fechaRegistro,        fechaDespacho,		    fechaRecepcion,          horaDespacho,           horaRecepcion,     idResponsableSiembra, 
								idEspecie,				 tipoLarva,            cantidad,               cantidadPlus,			 porcentajePlus,         unidadMedida,      cantidadRecibida, 
								guiasRemision,           plGramoCam,           plGramoLab,				tieneFactura,			 descripcion,			responsableEntrega, estado,
								usuarioResponsable,      usuarioCreacion,      estacionCreacion,       fechaHoraCreacion,
								usuarioModificacion,     estacionModificacion, fechaHoraModificacion,  Cod_Ciclo,				 Ciclo--, reprocesoContable 
								into #InsertRecepTemp 
							FROM #RecepcionesTemp 
							where Cod_Ciclo = @cicloRecepcion and fechaRecepcion = @fechaRecep and procesado = 0 ; 
				
									SELECT @fechaRecep fechaRecep,* FROM #InsertRecepTemp
							-------CABECERA RECEPCION
							INSERT INTO [dbo].[proRecepcionEspecie] (
								idRecepcion,         empresa,              division,            zona,                   camaronera,            sector,             secuencia, 
								origen,              idOrdenCompra,        idDespacho,          idPlanificacionSiembra, idLaboratorio,         idLaboratorioLarva, fechaRegistro,
								fechaDespacho,       fechaRecepcion,       horaDespacho,        horaRecepcion,          idResponsableSiembra,  idEspecie,          tipoLarva, 
								cantidad,            cantidadPlus,         porcentajePlus,      unidadMedida,           cantidadRecibida,
								guiasRemision,       tieneFactura,         descripcion,         responsableEntrega,     estado,                usuarioResponsable, 
								usuarioCreacion,     estacionCreacion,     fechaHoraCreacion, 
								usuarioModificacion, estacionModificacion, fechaHoraModificacion)--, reprocesoContable)
							SELECT
								idRecepcion,		 empresa,				division,			zona,						camaronera,				sector,				idRecepcion, 
								origen,				 idOrdenCompra,			idDespacho,			idPlanificacionSiembra,		idLaboratorio,			idLaboratorioLarva, fechaRegistro, 
								fechaDespacho,		 fechaRecepcion,		horaDespacho,		horaRecepcion,				idResponsableSiembra,	idEspecie,			tipoLarva, 
								cantidad,			 cantidadPlus,			porcentajePlus,		unidadMedida,				cantidadRecibida,		
								guiasRemision,		 tieneFactura,		    descripcion,	    responsableEntrega,         estado,				    usuarioResponsable,		
								usuarioCreacion,	 estacionCreacion,		fechaHoraCreacion,
								usuarioModificacion, estacionModificacion,  fechaHoraModificacion--, reprocesoContable
							FROM #InsertRecepTemp

							-------DETALLE RECEPCION (**PENDIENTE LA PLANIFICACION DE ORIGEN)
							INSERT INTO [dbo].[proRecepcionEspecieDetalle] (
								  idRecepcionDetalle,			idRecepcion,						idPiscinaPlanificacion,		orden,					idPiscina,			      rolPiscina,			
								  cantidad,					    unidadMedida,						cantidadRecibida,			cantidadAdicional,		idPiscinaEjecucion,		  idCodigoGenetico,	
								  idLaboratorioMaduracion,		codigoLarva,						biomasa,				    oxigeno,                salinidad,                temperatura,   
								  costoLarva,					costoServiciosPrestados,			costoFlete,					amonio,					ph,						  alcalinidad,			
								  conteoAlgas,			        descripcion,						numeroCajas,				numeroTinas,            tanqueOrigen,             plGramoLab, 
								  plGramoCam,				    numeroArtemia,						calidadAgua,			    tanqueCalidadAguaBuena, tanqueCalidadAguaRegular, tanqueCalidadAguaMala,
								  observacionParametro,         observacionCaracteristica,			activo,						idMotivoAuditoria,
								  usuarioCreacion,              estacionCreacion,					fechaHoraCreacion,			usuarioModificacion,
								 estacionModificacion,			fechaHoraModificacion)--, origenPlGramo)
							SELECT
								 idRecepcionDetalle,			idRecepcion,						0 as idPiscinaPlanificacion,	1,							idPiscina,						ROL as rolPiscina, 
								 cantidad,						unidadMedida,						cantidadRecibida,				porcentajePlus,				@secuencialPiscinaEjecucion,    null as idCodigoGenetico, 
								 idLaboratorioMaduracion,		null as codigoLarva,				null as biomasa,				null as oxigeno,			null as salinidad,			    null as temperatura, 
								 null as costoLarva,			null as costoServiciosPrestados,	null as costoFlete,				null as amonio,			    null as ph,					    null as alcalinidad, 
								 null as conteoAlgas,			'' as descripcion,					null as numeroCajas,			3 as numeroTinas,			null as tanqueOrigen,			plGramoLab, 
								 plGramoCam,					null as numeroArtemia,				null as calidadAgua,		    1 as tanqueCalidadAguaBuena, 1 as tanqueCalidadAguaRegular, 1 as tanqueCalidadAguaMala,
								 null as observacionParametro,  null as observacionCaracteristica,  1 as activo,                    null as idMotivoAuditoria,
								 usuarioCreacion,               estacionCreacion,                  fechaHoraCreacion,			    usuarioModificacion,
								 estacionModificacion,          fechaHoraModificacion--, 'CAM' as origenPlGramo
							FROM #InsertRecepTemp;

							UPDATE proSecuencial 
							SET    ultimaSecuencia = (select MAX(idRecepcion) from #InsertRecepTemp )
							WHERE  tabla		   = 'recepcionEspecie' 
							
							UPDATE proSecuencial 
							SET    ultimaSecuencia = (select MAX(idRecepcionDetalle) from #InsertRecepTemp )
							WHERE  tabla		   = 'recepcionEspecieDetalle' 

							if @EjecucionExistente = 1 and @EXISTE_CICLO_INICIADO = 1
								BEGIN
								 SELECT 'HOLISS'
									--/*ACTUALIZAMOS EL IDEJECUCIÓN EN PARA DEJAR LISTO LA ULTIMA SECUENCIA **OJO*/--
				
									--UPDATE	proSecuencial 
									--SET		ultimaSecuencia = @secuencialPiscinaEjecucion
									--WHERE	tabla			= 'piscinaEjecucion' 
								
									--ACTUALIZAMOS EL CICLO INICIADO DEL DESTINO
								
									declare @sumaRecepDetalle int = 0;
									select @sumaRecepDetalle = cantidadRecibida FROM #InsertRecepTemp where Cod_Ciclo = @cicloRecepcion;
									SELECT  @cicloRecepcion;
									SELECT * FROM #InsertRecepTemp -- where Cod_Ciclo = @cicloRecepcion;
									declare @cicloMaxRECEP int, @fechaSiembraMinRECEP date;

									select 
											@fechaSiembraMinRECEP				= min(fechaRecepcion) over (order by c.idPiscina rows unbounded preceding)
									FROM   proRecepcionEspecieDetalle c  
									INNER JOIN proRecepcionEspecie t	  on c.idRecepcion = t.idRecepcion
									INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaRecepcion BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
									WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucion
									AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')
								
									select 
										@cicloMaxRECEP = irt.Ciclo
									FROM   #InsertRecepTemp irt 
									WHERE  irt.Cod_Ciclo = @cicloRecepcion

									UPDATE pe
										SET 
											ciclo						= @cicloMaxRECEP , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
											rolPiscina					= 'ENG01',
											numEtapa					= 1,
											fechaSiembra				= @fechaSiembraMinRECEP, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
											tipoCierre					= '',
											idEspecie					= 1,
											--cantidadEntrada				= sum(c.cantidadTransferida),
											cantidadEntrada				= cantidadEntrada + @sumaRecepDetalle,
											cantidadAdicional			=  0,
											cantidadSalida				= 0,
											cantidadPerdida				= CASE WHEN cantidadSalida > 0 THEN (cantidadEntrada + pe.cantidadAdicional) - cantidadSalida ELSE 0 END,
											estado						= 'EJE',
											usuarioModificacion			= @usuarioAudit,
											fechaHoraModificacion		= @fechaProceso
									--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
									--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
									--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
									FROM   proRecepcionEspecieDetalle c  
											INNER JOIN proRecepcionEspecie t	  on c.idRecepcion = t.idRecepcion
											INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaRecepcion BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
											WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucion
											AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

									--MAEPISCINA CICLO
									UPDATE pc
										SET 
											ciclo						= @cicloMaxRECEP,--(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
											origen						= 'EJE',
											rolCiclo					= 'PRE01',
											usuarioModificacion			= @usuarioAudit,
											fechaHoraModificacion		= @fechaProceso
									--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
									--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
									--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
									FROM  proTransferenciaEspecieDetalle c  
											INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia 
											INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = t.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate()) 
											INNER JOIN maePiscinaCiclo pc on pe.idPiscinaEjecucion = pc.idOrigen
											WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucion
											AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

									--FALTA MAECILO PONERLE EL ROL
								END
						END
				
					-------STEP 6 GENERAMOS LA TRANSFERENCIA (TEMPORAL, CABECERA Y DETALLE)
				
					if not exists ( select 1 from proTransferenciaEspecie t inner join EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = t.idPiscinaEjecucion 
									where ej.cod_ciclo = @cicloRecepcion)
						BEGIN
								--/*INICIO SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
									
									SELECT TOP 1 @secuencialTransferencia = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecie' 

									SELECT TOP 1 @secuencialTransferenciaDetalle = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecieDetalle' 

								--/*FIN SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
						
							SELECT
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferencia		  AS idTransferencia,
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferenciaDetalle AS idTransferenciaDetalle,
								empresa,			                    fecha_Transf  AS fechaRegistro,		     fecha_Transf                AS fechaTransferencia,      ROL,
								tipoTransferencia,				        idPiscina,								 1                            AS idEspecie,              0   AS guiaTransferencia,		
								Cantidad_Transf AS cantidadTransferida, Peso_Transf  AS pesoTransferidoGramos,   @secuencialPiscinaEjecucion  AS idPiscinaEjecucion,     0	AS esTotal,    
								Sector_DestinoCOD,                      null         AS cantidadRemanente,       densidad,												 0 as balanceado, 
								''             AS descripcion,          usuarioResponsable,						 estado,												 usuarioCreacion,
								estacionCreacion,						fechaHoraCreacion,                       usuarioModificacion,                                    estacionModificacion ,
								Peso_Siembra,							Peso_Transf,							 Peso_Real,												 Lib_Transf_C, 
								Libras_Transf  AS librasDeclaradas,		Ciclo_Destino,						     fechaHoraModificacion, null as reprocesoContable,       Cod_Ciclo_Destino, 
								idPiscinaDestino,						TipoTransfTOTAL,						 procesado = 0
							INTO #InsertTransfTemp
							FROM #TranferenciaTemp
							WHERE Cod_Ciclo_Origen = @cicloRecepcion;
				 
							--SELECT * FROM #InsertTransfTemp

							SELECT top 1 @cantidadTransferencia = SUM(cantidadTransferida) FROM #InsertTransfTemp
							SELECT top 1 @FechaCierre			= MAX(fechaTransferencia)  FROM #InsertTransfTemp
						
							IF exists (select 1 from #InsertTransfTemp)
								BEGIN
							
							select 'trans'
								
									INSERT INTO [dbo].[proTransferenciaEspecie] (
										idTransferencia,				empresa,						secuencia,				fechaRegistro,		    fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				guiaTransferencia,     
										cantidadTransferida,            pesoTransferidoGramos,			idPiscinaEjecucion,		esTotal,				
										cantidadRemanente,				densidad,						balanceado,				descripcion,
										usuarioResponsable,				estado,							usuarioCreacion,
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion)--, reprocesoContable)
									SELECT
										idTransferencia,				empresa,						idTransferencia,		fechaRegistro,			fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				RIGHT('0000000000' + CAST(idTransferencia AS VARCHAR(9)),9)   AS guiaTransferencia, 
										cantidadTransferida,			pesoTransferidoGramos,			idPiscinaEjecucion,		CASE WHEN (ROW_NUMBER() OVER (PARTITION BY fechaTransferencia ORDER BY idTransferencia)) = 1 THEN 1 ELSE 0 END AS esTotal, 
										cantidadRemanente,				densidad,						balanceado,				descripcion, 
										usuarioResponsable,				estado,							usuarioCreacion, 
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion--, reprocesoContable
									FROM #InsertTransfTemp;


									select @estadoTransferencia = TipoTransfTOTAL  from #InsertTransfTemp where TipoTransfTOTAL = 'TOTAL'

									if @estadoTransferencia = 'TOTAL'
										BEGIN
											/*ACTUALIZAMOS PISCINA EJECUCIÓN DE LA PISCINA DE ORIGEN*/--

											IF @EXISTE_CICLO_INICIADO = 1
												BEGIN
											
													--UPDATE proSecuencial 
													--SET    ultimaSecuencia = ultimaSecuencia + 1
													--WHERE  tabla		   = 'piscinaEjecucion' 
												
													--SELECT TOP 1 @secuencialPiscinaEjecucionSiguiente = ultimaSecuencia +1
													--FROM	proSecuencial 
													--WHERE	tabla = 'piscinaEjecucion'
												
												
													SELECT TOP 1 @secuencialMaeCiclo = ultimaSecuencia + 1
													FROM	maeSecuencial 
													WHERE	tabla = 'PiscinaCiclo' 

												END

											--/*ACTUALIZAMOS PISCINA EJECUCIÓN*/--
											INSERT INTO proPiscinaEjecucion (
													idPiscinaEjecucion,					 idPiscina,				      ciclo,			rolPiscina,			numEtapa,			lote,				fechaInicio, 
													fechaSiembra,						 fechaCierre,			      tipoCierre,		idEspecie,			cantidadEntrada,	cantidadAdicional,  cantidadSalida,				
													cantidadPerdida,					 idPiscinaEjecucionSiguiente, estado,			tieneRaleo,			tieneRepanio,		tieneCosecha,		activo,
													usuarioCreacion,					 estacionCreacion,			  fechaHoraCreacion, 
													usuarioModificacion,				 estacionModificacion,		  fechaHoraModificacion) 
											SELECT @secuencialPiscinaEjecucionSiguiente, idPiscina,						0,					'',					0,				sector,				DATEADD(DAY, 1, min(@FechaCierre)), 
													NULL,								 NULL,							'',					0,					0,				0,					0, 
													0,									 NULL,						    'INI',				0,					0,				0,					1,
													@usuarioAudit,						'::RECEP',							@fechaProceso,
													@usuarioAudit,						'::RECEP',							@fechaProceso
											FROM #RecepcionesTemp 
											WHERE Cod_Ciclo = @cicloRecepcion -- and fechaRecepcion = @fechaRecep
											GROUP BY idPiscina, Ciclo, rol, sector
				 
											INSERT INTO [dbo].[maePiscinaCiclo] (
												idPiscinaCiclo,						idPiscina,			    ciclo,		
												fecha,								origen,				    idOrigen, 
												idOrigenEquivalente,				rolCiclo,			    activo, 
												usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
												usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
											SELECT 
												@secuencialMaeCiclo,			idPiscina,				0, 
												DATEADD(DAY, 1, min(@FechaCierre)), 'PRE',					@secuencialPiscinaEjecucionSiguiente, 
												null as idOrigenEquivalente,		ROL,					1, 
												@usuarioAudit,						'::RECEP',					@fechaProceso, 
												@usuarioAudit,						'::RECEP',					@fechaProceso
											FROM #RecepcionesTemp 
											WHERE	Cod_Ciclo = @cicloRecepcion 
											GROUP BY idPiscina, Ciclo, 
													 rol,       sector;
											
											--ACTUALIZAMOS LA EJECUCIÓN PASADA
											UPDATE PE
												SET 
													tipoCierre					= 'TRA',
													cantidadSalida				= @cantidadTransferencia,
													cantidadPerdida				= (cantidadEntrada + cantidadAdicional) - @cantidadTransferencia,
													fechaCierre					= @FechaCierre,
													estado						= 'PRE',
													idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucionSiguiente
												FROM #InsertTransfTemp   PTE
												JOIN proPiscinaEjecucion PE ON PTE.idPiscinaEjecucion = PE.idPiscinaEjecucion;
								
											--OBTENEMOS LOS ID DE EJECUCIÓN DESTINO Y CICLOS DE DESTINO **OJO ASUMIENDO QUE NO EXISTE
											UPDATE proSecuencial 
											SET    ultimaSecuencia = @secuencialPiscinaEjecucionSiguiente  
											WHERE  tabla           = 'piscinaEjecucion' 
		
											UPDATE maeSecuencial 
											SET    ultimaSecuencia = @secuencialMaeCiclo + 1
											WHERE  tabla           = 'PiscinaCiclo' 
											--declare @CicloSiguiente int, @KeyPiscinaCicloSiguiente varchar(50);
											--select  @CicloSiguiente = @secuencialMaeCiclo + 1
											--select  @KeyPiscinaCicloSiguiente = @keyPiscina + '.' + @CicloSiguiente
											--   EXEC InsertLogEjecucionesCiclosProduccion 
											--			@idPiscina,						 @secuencialPiscinaEjecucionSiguiente, 
											--			@CicloSiguiente,				 @keyPiscina, 
											--			@KeyPiscinaCicloSiguiente,	    'proTransferencia',
											--			'INI',							'proRecepcion - proTransferencia'

										END
										--UPDATE PICINA EJECUCION
								
									--/*TRANSFERENCIAS DESTINO*/--
								
									SET @EjecucionExistente = 0
									SET @EXISTE_CICLO_INICIADO = 0
									WHILE EXISTS (SELECT * FROM #InsertTransfTemp WHERE procesado = 0)
									BEGIN
											select top 1 @secuencialRowKeyTransferencia = idTransferenciaDetalle, @cicloTransferencia = Cod_Ciclo_Destino from #InsertTransfTemp;

											--VERIFICAR SI EXISTE CICLO DE DESTINO
											IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloTransferencia) >0
												BEGIN
													select @secuencialPiscinaEjecucionDESTINO = idPiscinaEjecucion, @secuencialPiscinaEjecucionSiguienteDESTINO = idPiscinaEjecucionSiguiente from EjecucionesPiscinaView where cod_ciclo = @cicloTransferencia
													SET @EjecucionExistenteDESTINO = 1
													select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
												END
											ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
													AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
													AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
												   WHERE CP.Cod_Ciclo = @cicloTransferencia)
												BEGIN
													SELECT TOP 1  @secuencialPiscinaEjecucionDESTINO = E.idPiscinaEjecucion
														FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
																AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
																AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
															   WHERE CP.Cod_Ciclo = @cicloTransferencia

														select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
													
														SELECT TOP 1 @secuencialPiscinaEjecucionSiguienteDESTINO = ultimaSecuencia + 1
														FROM	proSecuencial 
														WHERE	tabla = 'piscinaEjecucion' 
														SET @EjecucionExistente = 1
														SET @EXISTE_CICLO_INICIADO = 1
												END
											ELSE 
												BEGIN
										
													SELECT TOP 1 @secuencialPiscinaEjecucionDESTINO = ultimaSecuencia + 1
													FROM	proSecuencial 
													WHERE	tabla = 'piscinaEjecucion' 

													SELECT TOP 1 @secuencialMaeCicloDESTINO = ultimaSecuencia + 1
													FROM	maeSecuencial 
													WHERE	tabla = 'PiscinaCiclo' 
													SET @EjecucionExistenteDESTINO = 0
												
													SET @secuencialPiscinaEjecucionSiguienteDESTINO = @secuencialPiscinaEjecucionDESTINO + 1;

													--***OJO CONSULTAR EXISTENTE***--
													INSERT INTO proPiscinaEjecucion (
														idPiscinaEjecucion,				idPiscina,					 ciclo,							rolPiscina,			 numEtapa,					lote,					fechaInicio, 
														fechaSiembra,					fechaCierre,				 tipoCierre,					idEspecie,			 cantidadEntrada,			cantidadAdicional,		cantidadSalida, 
														cantidadPerdida,				idPiscinaEjecucionSiguiente, estado,						tieneRaleo,			 tieneRepanio,				tieneCosecha,			activo, 
														usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,				usuarioModificacion, estacionModificacion,		fechaHoraModificacion)
													SELECT 
														@secuencialPiscinaEjecucionDESTINO,		idPiscinaDestino,			 Ciclo_Destino,					ROL,				 1,							Sector_DestinoCOD,		DATEADD(DAY, -1, MIN(fechaTransferencia)), 
														MIN(fechaTransferencia),		NULL,						 '',							1,					 SUM(cantidadTransferida),	 0,						0, 
														0,								NULL,						'EJE',							0,					 0,							 0,						1,
														@usuarioAudit,					'::RECEP',						 @fechaProceso,					@usuarioAudit,		'::RECEP',						 @fechaProceso
														FROM #InsertTransfTemp 
														GROUP BY idPiscinaDestino, Ciclo_Destino, rol, Sector_DestinoCOD
			
													INSERT INTO [dbo].[maePiscinaCiclo] (
														idPiscinaCiclo,								idPiscina,			    ciclo,		
														fecha,										origen,				    idOrigen, 
														idOrigenEquivalente,						rolCiclo,			    activo, 
														usuarioCreacion,							estacionCreacion,		fechaHoraCreacion, 
														usuarioModificacion,						estacionModificacion,   fechaHoraModificacion)
													SELECT 
														@secuencialMaeCicloDESTINO ,						idPiscinaDestino,		Ciclo_Destino, 
														DATEADD(DAY, -1, min(fechaTransferencia)), 'EJE',					@secuencialPiscinaEjecucionDESTINO, 
														null as idOrigenEquivalente,				ROL,					1, 
														@usuarioAudit,								'::RECEP',					@fechaProceso, 
														@usuarioAudit,								'::RECEP',					@fechaProceso
													FROM	 #InsertTransfTemp 
													GROUP BY idPiscinaDestino, Ciclo_Destino, 
															rol,			   Sector_DestinoCOD

												END
									
									
												INSERT INTO [dbo].[proTransferenciaEspecieDetalle] (
															idTransferenciaDetalle,			idTransferencia,			 orden,									idPiscina,				rolPiscina,				cantidadTransferida,
															pesoPromedioTransferencia,		biomasa,					 
															idPiscinaEjecucion,				tipoTransferencia,			 horaInicioTransferencia,				horaFinTransferencia, 
															observacion,					observacionParametro,		 observacionCaracteristica,				usuarioResponsable,		activo, 
															usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
															librasDeclaradas,				cantidadDeclarada,			 pesoDeclaradoTransferido,				numeroViajes)
												SELECT
															idTransferenciaDetalle,			idTransferencia,			 1,										idPiscinaDestino,		ROL as rolPiscina,		cantidadTransferida,
															pesoTransferidoGramos,			(cantidadTransferida * pesoTransferidoGramos) * 0.00220462 as biomasa, 
															@secuencialPiscinaEjecucionDESTINO,	tipoTransferencia,			'06:00:00' as horaInicioTransferencia, '06:00:00' as horaFinTransferencia, 
															'' as observacion,				null,						null,									usuarioResponsable,		1, 
															usuarioCreacion,				estacionCreacion,			fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
															librasDeclaradas,				cantidadTransferida,		pesoTransferidoGramos,					null
												FROM		#InsertTransfTemp
												where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferencia;

								
												declare @sumaTransDetalle int = 0;
												select @sumaTransDetalle FROM #InsertTransfTemp
												where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferencia;

												--ACTUALIZAMOS EL CICLO INICIADO DEL DESTINO
												declare @cicloMax int,@fechaSiembraMin date;
												select 
														@fechaSiembraMin				= min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding)
												FROM   proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')
													
												select 
													@cicloMax = irt.Ciclo_Destino
												FROM   #InsertTransfTemp irt 
												WHERE  irt.Cod_Ciclo_Destino = @cicloTransferencia

												UPDATE pe
													SET 
														ciclo						= @cicloMax , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														rolPiscina					= 'ENG01',
														numEtapa					= 1,
														fechaSiembra				= @fechaSiembraMin, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
														tipoCierre					= '',
														idEspecie					= 1,
														--cantidadEntrada				= sum(c.cantidadTransferida),
														cantidadEntrada				= cantidadEntrada + @sumaTransDetalle,
														cantidadAdicional			=  0,
														cantidadSalida				= 0,
														cantidadPerdida				= CASE WHEN cantidadSalida > 0 THEN (cantidadEntrada + cantidadAdicional) - cantidadSalida ELSE 0 END,
														estado						= 'EJE',
														usuarioModificacion			= @usuarioAudit,
														fechaHoraModificacion		= @fechaProceso
												--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
												--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
												--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
												FROM   proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

												--MAEPISCINA CICLO
												UPDATE pc
													SET 
														ciclo						= @cicloMax,--(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														origen						= 'EJE',
														rolCiclo					= 'ENG01',
														usuarioModificacion			= @usuarioAudit,
														fechaHoraModificacion		= @fechaProceso
												--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
												--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
												--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
												FROM  proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia 
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate()) 
														INNER JOIN maePiscinaCiclo pc on pe.idPiscinaEjecucion = pc.idOrigen
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

											UPDATE #InsertTransfTemp 
											SET   procesado = 1 
											WHERE Cod_Ciclo_Destino = @cicloTransferencia and idTransferenciaDetalle = @secuencialRowKeyTransferencia --and fechaRecepcion = @fechaRecep
									END
								
									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferencia) FROM #InsertTransfTemp)  
									WHERE  tabla		   = 'transferenciaEspecie' 

									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferenciaDetalle) FROM #InsertTransfTemp) 
									WHERE  tabla		   = 'transferenciaEspecieDetalle' 

							END
						END

						print 'secuencia ' + cast( @cicloRecepcion as varchar(50)) + ' ' + cast( @fechaRecep as varchar(10))
					
					--select 'despues propiscinaejecucion',* from EjecucionesPiscinaView where nombreSector = @PISCINATEMP and estado in ('INI','EJE', 'PRE') ORDER BY 4
					
					--exec viewProcessCiclos  @PISCINATEMP, 1
					UPDATE #RecepcionesTemp 
					SET   procesado = 1 
					WHERE Cod_Ciclo = @cicloRecepcion and rowKeySecuencia# = @rowKeySecuencia --and fechaRecepcion = @fechaRecep

				END

			-----CONFIRMACION DE LA TRANSACCION
			--SELECT * FROM proRecepcionEspecie WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proRecepcionEspecieDetalle WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proTransferenciaEspecieDetalle where  idPiscinaEjecucion = @secuencialPiscinaEjecucion
			--select * from  proPiscinaEjecucion where idPiscina = 2002
		
			--select 'FINAL propiscinaejecucion',* from EjecucionesPiscinaView where nombreSector = @SECTORFILTER and estado  in ('INI','EJE', 'PRE')  ORDER BY 4
			
			if @usarTrans = 1 BEGIN ROLLBACK TRAN END
		END TRY
		BEGIN CATCH
			-----REVERSA DE LA TRANSACCION
			if @usarTrans = 1 BEGIN ROLLBACK TRAN END
			SELECT  
				 ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  

				DECLARE @ErrorMessage  NVARCHAR(4000), 
						@ErrorSeverity INT, 
						@ErrorState INT;

				SELECT  @ErrorMessage  = ERROR_MESSAGE(), 
						@ErrorSeverity = ERROR_SEVERITY(), 
						@ErrorState    = ERROR_STATE();
			
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END CATCH
	END


	


GO
/****** Object:  StoredProcedure [dbo].[USP_SCRIPTMOVIMIENTOTRANSFERENCIAS]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE    PROC [dbo].[USP_SCRIPTMOVIMIENTOTRANSFERENCIAS]
	(@PiscinaTemp VARCHAR(100), @SECTORFILTER VARCHAR(100))
	AS BEGIN

		--DECLARE @SECTORFILTER VARCHAR(100) = 'CAPULSA' --'COSTARICAI';
		--DECLARE @PiscinaTemp VARCHAR(100) ;
		--select @PiscinaTemp = 'CAPULSA5';
		--DECLARE @ISROOLBACK bit = 1
		DROP TABLE IF EXISTS #EJECUCIONESTEMP 
		DROP TABLE IF EXISTS #FILTERPISCINAKEYTEMP 
		DROP TABLE IF EXISTS #TranferenciaTempPrev 
		DROP TABLE IF EXISTS #TranferenciaTemp 

		/*Nomenclatura Preparacion = "PRE"; Manual = "MAN"; EjecucionPiscina = "EJE"; MantenimientoPiscina = "MNT";*/
		--STEP 1: Query para poblar temporal de ejecuciones moldeado a keys de excel
			SELECT	pu.codigoZona,	       pu.nombreZona,       pu.codigoCamaronera, pu.nombreCamaronera, 
					pu.codigoSector,       pu.nombreSector,     pu.codigoPiscina,    pu.nombrePiscina, 
					ce.codigoElemento,     ce.nombreElemento,   pe.idPiscina,        
					pu.nombreSector + pu.nombrePiscina + '.' +	CONVERT(VARCHAR(200),pe.ciclo) as Cod_Ciclo, 
					pu.nombreSector + pu.nombrePiscina AS keyPiscina, 
					pe.idPiscinaEjecucion, pe.ciclo,            pe.fechaInicio,      pe.fechaSiembra, 
					pe.fechaCierre,		   pe.cantidadEntrada	
			INTO #EJECUCIONESTEMP 
			FROM proPiscinaEjecucion pe 
				INNER JOIN PiscinaUbicacion  pu ON  pe.idPiscina	 = pu.idPiscina 
				INNER JOIN CATALOGO_ELEMENTS ce ON ce.codigoElemento = pe.rolPiscina AND ce.codigoCatalogo = 'maeRolPiscina' 
			WHERE estado in ('EJE', 'PRE')
   

		/*
		select cp.Cod_Ciclo, Key_Piscina, cp.Ciclo as CicloExcel, Fecha_IniSec, Fecha_Siembra, Fecha_Pesca, Cantidad_Sembrada, Zona, Camaronera, Sector, Piscina, Tipo,Tipo_Siembra, Densidad,
		ej.fechaInicio, ej.fechaSiembra, ej.fechaCierre, ej.cantidadEntrada, ej.ciclo, DATEDIFF(day, Fecha_IniSec, ej.fechaInicio) InicioDiff, DATEDIFF(day, Fecha_Siembra, ej.fechaSiembra) SiembraDiff,DATEDIFF(day, Fecha_Pesca, ej.fechaCierre) CierreDiff,
		(Cantidad_Sembrada - ej.cantidadEntrada) CantidadDiff, idPiscina, idPiscinaEjecucion
		--into #FILTERPISCINAKEYTEMP
		from CICLOS_PRODUCCION cp
		left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
		WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) AND Sector = 'ARGENTINA' order by 1 -- @SECTORFILTER --and ej.ciclo is null
		*/

	   --FILTRAMOS LAS PISCINAS A REGULARIZAR
			SELECT cp.Key_Piscina, cp.Ciclo, cp.Cantidad_Sembrada
			into #FILTERPISCINAKEYTEMP
			from CICLOS_PRODUCCION cp
			left JOIN #EJECUCIONESTEMP ej on cp.Cod_Ciclo = ej.Cod_Ciclo 
			WHERE cp.ciclo >= (select min(ciclo) from #EJECUCIONESTEMP p where p.keyPiscina = cp.Key_Piscina) 
			AND REPLACE(Sector,' ','') = @SECTORFILTER and ej.ciclo is null AND cp.Key_Piscina = @PiscinaTemp

			SELECT 'FILTRO PISCIAN' FILTRO, * FROM #FILTERPISCINAKEYTEMP
	   --STEP 2: Query para creación de tabla de transferencia con homologaciones de piscinas con códigos de Insigne
		SELECT  DISTINCT
				'01' AS empresa,			'01' AS division,	  pu.codigoZona AS zona,		 pu.codigoCamaronera AS camaronera,			pu.codigoSector AS sector, 
				 pu.idPiscina,				 pu.codigoPiscina,  

				 CASE WHEN t.tipo = 'PRECRIADERO' THEN 'PRE01' WHEN t.tipo = 'PISCINA' THEN 'ENG01' WHEN t.tipo = 'REPRODUCTOR' THEN 'REP01' ELSE '' END AS ROL,  
				 REPLACE(Sector_Origen ,' ','')	 +   CONVERT(VARCHAR(200),Piscina_Origen)    AS keyOrigen, 

				 Cod_Ciclo_Origen,					   fecha_Transf,		pu.codigoZona AS Zona_Origen,   pu.codigoCamaronera as Camaronera_Origen,   pu.nombreSector,			 pu.codigoSector as Sector_Origen, 
				 Piscina_Origen,					   Ciclo_Origen,		t.Tipo,							Sub_Tipo,									Estatus_Origen, 
				 Hectarea_Origen,					   t.Fecha_Siembra,		t.Cantidad_Sembrada,			t.Densidad,									Peso_Siembra, 
				 Estatus_Transf,					   Cons_Balanc,		    Guia_Transf,					Forma_Transf,   

				 CASE WHEN t.linea = 'TANQUERO'         THEN '001' 	  WHEN t.linea = 'TUBERÍA' THEN '002' 
					  WHEN t.linea = 'TUBERÍA-TANQUERO' THEN '003'    WHEN t.linea = 'A PIE'   THEN '004' 
					  WHEN t.linea = 'DESCUELGUE'       THEN '006'    ELSE '001'			   END	 AS tipoTransferencia,

				REPLACE(Sector_Destino ,' ','') + CONVERT(VARCHAR(200),Piscina_Destino) AS keyDestino,	
				Cod_Ciclo_Destino,			          puD.codigoZona   AS Zona_Destino,			puD.codigoCamaronera AS  Camaronera_Destino,		puD.codigoSector AS  Sector_DestinoCOD,		puD.idPiscina AS idPiscinaDestino,
				Piscina_Destino,					  Ciclo_Destino,							Estatus_Destino,									Hectarea_Destino,							Cantidad_Transf, 
				Peso_Transf,						  Peso_Real,								Libras_Transf,										Conv,										Procedencia_Laboratorio, 
				Linea,								  Maduracion,								Superv,												Balanc,										Lib_Transf_C, 
				Anio,								  Estatus_Transf   AS TipoTransfTOTAL,		'APR' AS estado,									'AdminPsCam'     AS usuarioResponsable,
			   'adminPsCam' AS usuarioCreacion,		 ':TRANS' AS estacionCreacion,      GETDATE() AS fechaHoraCreacion, 
			   'adminPsCam' AS usuarioModificacion,  ':TRANS' AS estacionModificacion,  GETDATE() AS fechaHoraModificacion,							0 procesado,								pp.Fecha_DS
		INTO #TranferenciaTempPrev
		FROM TRANSFERENCIAS_PRODUCCION t   
			left join #EJECUCIONESTEMP pu  ON REPLACE(pu.keyPiscina ,' ','')  = REPLACE(t.keyPiscinaOrigen ,' ','')   
			LEFT join #EJECUCIONESTEMP puD ON REPLACE(puD.keyPiscina ,' ','') = REPLACE(t.keyPiscinaDestino ,' ','')
			left join PESCA_PRODUCCION pp ON REPLACE(pp.Cod_ciclo ,' ','') = REPLACE(t.Cod_Ciclo_Destino ,' ','')
		WHERE /*T.keyPiscinaOrigen IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) 
		AND  */T.keyPiscinaDestino IN (SELECT FTP.Key_Piscina FROM #FILTERPISCINAKEYTEMP FTP) --Sector_Origen = @SECTORFILTER
		ORDER BY 1
		
		--select 'REGULARIZAR' AS REGULARIZAR2, * from #TranferenciaTempPrev
		SELECT 	ROW_NUMBER ( ) OVER ( order by t.fecha_Transf, t.keyOrigen, t.keyDestino)  as rowKeySecuencia#,
				ROW_NUMBER ( ) OVER ( PARTITION BY keyOrigen order by  t.fecha_Transf, keyDestino ,Piscina_Origen, t.Cod_Ciclo_Origen)  as rowKey#, 
				ROW_NUMBER ( ) OVER ( PARTITION BY t.Cod_Ciclo_Origen order by  t.fecha_Transf, keyOrigen , t.Cod_Ciclo_Origen)  as rowCiclo#,
				case when t.Fecha_Transf =  
					(select max(Fecha_Transf) from #TranferenciaTempPrev  tp where tp.Cod_Ciclo_Destino = t.Cod_Ciclo_Destino and t.Fecha_DS is not null)
					then CAST(1 as bit)
					else CAST(0 as bit) end as Pesca,
				*
				INTO #TranferenciaTemp
				FROM #TranferenciaTempPrev t
				where t.keyDestino = @PiscinaTemp
				order by 1;


		with  cte as(
			select  idPiscina,				REPLACE(nombreSector,' ','') + nombrePiscina  KeyPiscina,		codigoPiscina,		nombreCamaronera, nombreZona,
					codigoSector sector,	nombreSector,												codigoCamaronera,	codigoZona
				from PiscinaUbicacion   rb )

		update ru
		set ru.idPiscina = rb.idPiscina,			ru.codigoPiscina = rb.codigoPiscina,			ru.sector = rb.sector,
			ru.camaronera = rb.codigoCamaronera,	ru.Camaronera_Origen = rb.codigoCamaronera,		ru.zona  = rb.codigoZona,
			ru.Zona_Origen = rb.codigoZona,			ru.Sector_Origen = rb.sector,					ru.nombreSector = rb.nombreSector
		from 
		#TranferenciaTemp ru 
		inner join cte rb on ru.keyOrigen = rb.KeyPiscina   and ru.idPiscina is null;

		with  cte2 as(
			select  idPiscina,				REPLACE(nombreSector,' ','')+nombrePiscina  KeyPiscina,		codigoPiscina,		nombreCamaronera, nombreZona,
					codigoSector sector,	nombreSector,												codigoCamaronera,	codigoZona
				from PiscinaUbicacion   rb -- where   idPiscina is not null
		)
		update ru
		set 
			ru.Zona_Destino = rbD.codigoZona,		ru.Camaronera_Destino = rbD.codigoCamaronera,	ru.Sector_DestinoCOD = rbD.sector,
			ru.idPiscinaDestino = rbD.idPiscina
		from 
		#TranferenciaTemp ru 
		inner join cte2 rbD on ru.keyDestino = rbD.KeyPiscina   and ru.idPiscinaDestino is null;
		
		select 'REGULARIZAR' AS REGULARIZAR, * from #TranferenciaTemp
		BEGIN TRY

			declare @EjecucionExistente bit = 1
			declare @EjecucionExistenteDESTINO bit = 1
			declare @estadoTransferencia varchar(10)
			declare @EXISTE_CICLO_INICIADO bit = 0
		
			declare @secuencialRowKeyTransferencia int = 0
			declare @secuencialTransferencia int = 0
			declare @secuencialTransferenciaDetalle int = 0
			declare @maxSecuencialRecepcion int = 0

			declare @cantidadTransferencia int = 0 
			declare @FechaCierre date 
	
			declare @secuencialMaeCiclo int = 0
			declare @secuencialPiscinaEjecucion int = 0
			declare @secuencialPiscinaEjecucionSiguiente int = null

			declare @secuencialMaeCicloDESTINO int = 0
			declare @secuencialPiscinaEjecucionDESTINO int = 0
			declare @secuencialPiscinaEjecucionSiguienteDESTINO int = null

			declare @secuencia int = 0
			declare @rowKeySecuencia int = 0
			declare @cicloTransferencia varchar(100)
			declare @cicloTransferenciaDestino varchar(100)
			declare @cicloTransferenciaDestinoVALIDACION varchar(100)
			declare @fechaRecep dateTime
			declare @fechaProceso dateTime = getdate()
			declare @usuarioAudit varchar(50) = 'AdminPsCam'
			DECLARE @MESAJEERROR VARCHAR(100)

			declare @idPiscina int
			declare @keyPiscina varchar(50)
			--Bloqueamos las tablas de secuenciales
			SELECT top 1 1 FROM proSecuencial WITH (TABLOCKX)
			SELECT top 1 1 FROM maeSecuencial WITH (TABLOCKX)
				declare @cpount int = 0
				WHILE exists (select procesado from #TranferenciaTemp where procesado = 0 )
				BEGIN
				select @cpount = @cpount+1
					--/***************INCIO VARIABLES INICIALES****************/--
					select top 1  @secuencia  = rowKeySecuencia#,	@cicloTransferencia = Cod_Ciclo_Origen, 
								  @fechaRecep = Fecha_Transf,		@rowKeySecuencia = rowKey#,				@cicloTransferenciaDestinoVALIDACION = Cod_Ciclo_Destino
						   from #TranferenciaTemp  where procesado = 0 order by rowKeySecuencia#;
					select @cpount as contadorDeVueltas

					set @idPiscina = 0
					set @keyPiscina = ''
					set @secuencialPiscinaEjecucion = 0

					set @idPiscina	= (SELECT TOP 1 idPiscina	 FROM  #EJECUCIONESTEMP	WHERE Cod_Ciclo = @cicloTransferencia)
					set @keyPiscina = (SELECT TOP 1  keyPiscina  FROM  #EJECUCIONESTEMP WHERE Cod_Ciclo = @cicloTransferencia)


					SELECT TOP 1 @idPiscina  = idPiscina, 
								 @keyPiscina = keyPiscina  
						   FROM  #EJECUCIONESTEMP 
						   WHERE Cod_Ciclo = @cicloTransferencia

					--SELECT TOP 1 * 
					--	   FROM  #EJECUCIONESTEMP 
					--	   WHERE Cod_Ciclo = @cicloTransferencia

					DROP TABLE IF EXISTS #InsertTransfTemp  

					--/*BUSCAMOS EL IDPISCINAEJECUCIÓN DE LA PISCINA DE ORIGEN*/--
					set @secuencialPiscinaEjecucion = (SELECT  idPiscinaEjecucion FROM EjecucionesPiscinaView WHERE cod_ciclo = @cicloTransferencia)

					if @secuencialPiscinaEjecucion is null OR @secuencialPiscinaEjecucion = 0
						BEGIN
							set @MESAJEERROR = 'NO SE ENCONTRÓ EL SECUENCIAL PISCINA EJECUCIÓN DE LA PISCINA ' + @cicloTransferencia
							RAISERROR(@MESAJEERROR, 16,1)
						END
					ELSE
						BEGIN
							IF not exists (SELECT top 1 1 FROM proPiscinaEjecucion WHERE idPiscinaEjecucion = @secuencialPiscinaEjecucion and idPiscina = @idPiscina)
							begin 
								set @MESAJEERROR = 'La ejecución de la piscina N° ' + @secuencialPiscinaEjecucion + ' no pertenece a la piscina ' + @cicloTransferencia
								RAISERROR(@MESAJEERROR, 16,1)
							end
						END


				if not exists ( select 1 from proTransferenciaEspecieDetalle  td
						INNER JOIN proTransferenciaEspecie t ON td.idTransferencia = t.idTransferencia 
						INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = td.idPiscinaEjecucion 
						INNER JOIN #TranferenciaTemp tt on  
						--DATEDIFF(day, t.fechaTransferencia, tt.Fecha_Transf) BETWEEN -2 AND 2 
						t.fechaTransferencia = tt.Fecha_Transf --VALIDACION ANTIGUA 
												and ej.cod_ciclo = tt.Cod_Ciclo_Destino 
												and td.cantidadTransferida = tt.Cantidad_Transf
						where ej.cod_ciclo = @cicloTransferenciaDestinoVALIDACION AND T.estado = 'APR'
						and rowKeySecuencia# = @secuencia)
						BEGIN
								--/*INICIO SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
									
									SELECT TOP 1 @secuencialTransferencia = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecie' 

									SELECT TOP 1 @secuencialTransferenciaDetalle = ultimaSecuencia 
									FROM	proSecuencial 
									WHERE	tabla = 'transferenciaEspecieDetalle' 

								--/*FIN SEPARACIÓN DE SECUENCIALES TRANSFERENCIA DE ESPECIES*/--
						
							SELECT top 1
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferencia		  AS idTransferencia,
								ROW_NUMBER() OVER(ORDER BY Cod_Ciclo_Origen) + @secuencialTransferenciaDetalle AS idTransferenciaDetalle,
								empresa,			                    fecha_Transf  AS fechaRegistro,		     fecha_Transf                AS fechaTransferencia,      ROL,
								Sector_Origen,							Cod_Ciclo_Origen,						 Ciclo_Origen,
								tipoTransferencia,				        idPiscina,								 1                            AS idEspecie,              0   AS guiaTransferencia,		
								Cantidad_Transf AS cantidadTransferida, Peso_Transf  AS pesoTransferidoGramos,   @secuencialPiscinaEjecucion  AS idPiscinaEjecucion,     0	AS esTotal,    
								Sector_DestinoCOD,                      null         AS cantidadRemanente,       densidad,												 0 as balanceado, 
								''             AS descripcion,          usuarioResponsable,						 estado,												 usuarioCreacion,
								estacionCreacion,						fechaHoraCreacion,                       usuarioModificacion,                                    estacionModificacion,
								Peso_Siembra,							Peso_Transf,							 Peso_Real,												 Lib_Transf_C, 
								Libras_Transf  AS librasDeclaradas,		Ciclo_Destino,						     fechaHoraModificacion, null as reprocesoContable,       Cod_Ciclo_Destino, 
								idPiscinaDestino,						TipoTransfTOTAL,						 procesado = 0,											 Fecha_DS,					
								keyDestino,								Pesca
							INTO #InsertTransfTemp
							FROM #TranferenciaTemp WHERE Cod_Ciclo_Origen = @cicloTransferencia and rowKeySecuencia# = @secuencia ;

							select Cod_Ciclo_Destino AS 'ESTO ES #InsertTransfTemp', * FROM #InsertTransfTemp WHERE Cod_Ciclo_Origen = @cicloTransferencia 
				 
							SELECT top 1 @cantidadTransferencia = SUM(cantidadTransferida) FROM #InsertTransfTemp
							SELECT top 1 @FechaCierre			= MAX(fechaTransferencia)  FROM #InsertTransfTemp
							IF exists (select 1 from #InsertTransfTemp)
								BEGIN
							
							select 'trans'
							
									INSERT INTO [dbo].[proTransferenciaEspecie] (
										idTransferencia,				empresa,						secuencia,				fechaRegistro,		    fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				guiaTransferencia,     
										cantidadTransferida,            pesoTransferidoGramos,			idPiscinaEjecucion,		esTotal,				
										cantidadRemanente,				densidad,						balanceado,				descripcion,
										usuarioResponsable,				estado,							usuarioCreacion,
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, reprocesoContable)
									SELECT
										idTransferencia,				empresa,						idTransferencia,		fechaRegistro,			fechaTransferencia,
										tipoTransferencia,				idPiscina,						idEspecie,				RIGHT('0000000000' + CAST(idTransferencia AS VARCHAR(9)),9)   AS guiaTransferencia, 
										cantidadTransferida,			pesoTransferidoGramos,			idPiscinaEjecucion,		CASE WHEN (ROW_NUMBER() OVER (PARTITION BY fechaTransferencia ORDER BY idTransferencia)) = 1 THEN 1 ELSE 0 END AS esTotal, 
										cantidadRemanente,				densidad,						balanceado,				descripcion, 
										usuarioResponsable,				estado,							usuarioCreacion, 
										estacionCreacion,				fechaHoraCreacion,				usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, reprocesoContable
									FROM #InsertTransfTemp;

									select @estadoTransferencia = TipoTransfTOTAL  from #InsertTransfTemp where TipoTransfTOTAL = 'TOTAL'

									if @estadoTransferencia = 'TOTAL'
										BEGIN
										
											SET  @secuencialPiscinaEjecucionSiguiente = (SELECT ultimaSecuencia + 1
											FROM	proSecuencial 
											WHERE	tabla = 'piscinaEjecucion' )
										
											SET @secuencialMaeCiclo = (SELECT ultimaSecuencia + 1
											FROM	maeSecuencial 
											WHERE	tabla = 'PiscinaCiclo' )
										
select max(idPiscinaEjecucion), @cpount CONTADORVUELTA from proPiscinaEjecucion
select * from proSecuencial
where tabla  = 'piscinaEjecucion'
											--/*ACTUALIZAMOS PISCINA EJECUCIÓN*/--
											INSERT INTO proPiscinaEjecucion (
													idPiscinaEjecucion,					 idPiscina,				      ciclo,			rolPiscina,			numEtapa,			lote,				fechaInicio, 
													fechaSiembra,						 fechaCierre,			      tipoCierre,		idEspecie,			cantidadEntrada,	cantidadAdicional,  cantidadSalida,				
													cantidadPerdida,					 idPiscinaEjecucionSiguiente, estado,			tieneRaleo,			tieneRepanio,		tieneCosecha,		activo,
													usuarioCreacion,					 estacionCreacion,			  fechaHoraCreacion, 
													usuarioModificacion,				 estacionModificacion,		  fechaHoraModificacion) 
											SELECT @secuencialPiscinaEjecucionSiguiente, idPiscina,						0,					'',					0,				Sector_Origen,		DATEADD(DAY, 1, min(@FechaCierre)), 
													NULL,								 NULL,							'',					0,					0,				0,					0, 
													0,									 NULL,						    'INI',				0,					0,				0,					1,
													@usuarioAudit,						':TRANS',							@fechaProceso,
													@usuarioAudit,						':TRANS',							@fechaProceso
											FROM #InsertTransfTemp 
											WHERE Cod_Ciclo_Origen = @cicloTransferencia -- and fechaRecepcion = @fechaRecep
											GROUP BY idPiscina, Ciclo_Origen, rol, Sector_Origen
				 
											INSERT INTO [dbo].[maePiscinaCiclo] (
												idPiscinaCiclo,						idPiscina,			    ciclo,		
												fecha,								origen,				    idOrigen, 
												idOrigenEquivalente,				rolCiclo,			    activo, 
												usuarioCreacion,					estacionCreacion,		fechaHoraCreacion, 
												usuarioModificacion,				estacionModificacion,   fechaHoraModificacion)
											SELECT 
												@secuencialMaeCiclo,			idPiscina,				0, 
												DATEADD(DAY, 1, min(@FechaCierre)), 'PRE',					@secuencialPiscinaEjecucionSiguiente, 
												null as idOrigenEquivalente,		ROL,					1, 
												@usuarioAudit,						':TRANS',					@fechaProceso, 
												@usuarioAudit,						':TRANS',					@fechaProceso
											FROM #InsertTransfTemp 
											WHERE	Cod_Ciclo_Origen = @cicloTransferencia 
											GROUP BY idPiscina, Ciclo_Origen, rol, Sector_Origen
											
											--ACTUALIZAMOS LA EJECUCIÓN PASADA
											UPDATE PE
												SET 
													tipoCierre					= 'TRA',
													cantidadSalida				= @cantidadTransferencia,
													cantidadPerdida				= (cantidadEntrada + cantidadAdicional) - @cantidadTransferencia,
													fechaCierre					= @FechaCierre,
													estado						= 'PRE',
													idPiscinaEjecucionSiguiente = @secuencialPiscinaEjecucionSiguiente
												FROM #InsertTransfTemp   PTE
												JOIN proPiscinaEjecucion PE ON PTE.idPiscinaEjecucion = PE.idPiscinaEjecucion;
								
											--OBTENEMOS LOS ID DE EJECUCIÓN DESTINO Y CICLOS DE DESTINO **OJO ASUMIENDO QUE NO EXISTE
											UPDATE proSecuencial 
											SET    ultimaSecuencia = @secuencialPiscinaEjecucionSiguiente  
											WHERE  tabla           = 'piscinaEjecucion' 
		
											UPDATE maeSecuencial 
											SET    ultimaSecuencia = @secuencialMaeCiclo
											WHERE  tabla           = 'PiscinaCiclo' 
											--declare @CicloSiguiente int, @KeyPiscinaCicloSiguiente varchar(50);
											--select  @CicloSiguiente = @secuencialMaeCiclo + 1
											--select  @KeyPiscinaCicloSiguiente = @keyPiscina + '.' + @CicloSiguiente
											--   EXEC InsertLogEjecucionesCiclosProduccion 
											--			@idPiscina,						 @secuencialPiscinaEjecucionSiguiente, 
											--			@CicloSiguiente,				 @keyPiscina, 
											--			@KeyPiscinaCicloSiguiente,	    'proTransferencia',
											--			'INI',							'proRecepcion - proTransferencia'

										END
										--UPDATE PICINA EJECUCION
								
									--/*TRANSFERENCIAS DESTINO*/--
								
									SET @EjecucionExistente = 0
									SET @EXISTE_CICLO_INICIADO = 0
									WHILE EXISTS (SELECT * FROM #InsertTransfTemp WHERE procesado = 0)
									BEGIN
											select top 1 @secuencialRowKeyTransferencia = idTransferenciaDetalle, @cicloTransferenciaDestino = Cod_Ciclo_Destino from #InsertTransfTemp;

											--VERIFICAR SI EXISTE CICLO DE DESTINO
											IF (select COUNT(1) from EjecucionesPiscinaView where cod_ciclo = @cicloTransferenciaDestino) >0
												BEGIN
												select 1 AS CONDICION, @cicloTransferenciaDestino AS CICLO
													select @secuencialPiscinaEjecucionDESTINO = idPiscinaEjecucion, 
													@secuencialPiscinaEjecucionSiguienteDESTINO = idPiscinaEjecucionSiguiente 
													from EjecucionesPiscinaView where cod_ciclo = @cicloTransferenciaDestino

													SET @EjecucionExistenteDESTINO = 1
													select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
												END
											ELSE IF EXISTS (SELECT 1 FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
													AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
													AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
												   WHERE CP.Cod_Ciclo = @cicloTransferenciaDestino)
												BEGIN
												
												select 2 AS CONDICION, @cicloTransferenciaDestino AS CICLO
													SELECT TOP 1  @secuencialPiscinaEjecucionDESTINO = E.idPiscinaEjecucion
														FROM CICLOS_PRODUCCION CP INNER JOIN EjecucionesPiscinaView E ON E.keyPiscina = CP.Key_Piscina
																AND CP.[Fecha_IniSec] >= DATEADD(DAY, -2, E.FechaInicio) --ej.FechaSiembra           
																AND CP.[Fecha_IniSec] <= DATEADD(DAY, 1,  E.FechaInicio)  AND estado= 'INI'
															   WHERE CP.Cod_Ciclo = @cicloTransferenciaDestino

														select @secuencialMaeCicloDESTINO = idPiscinaCiclo from maePiscinaCiclo where idOrigen = @secuencialPiscinaEjecucionDESTINO
													
														SELECT TOP 1 @secuencialPiscinaEjecucionSiguienteDESTINO = ultimaSecuencia + 1
														FROM	proSecuencial 
														WHERE	tabla = 'piscinaEjecucion' 
														SET @EjecucionExistente = 1
														SET @EXISTE_CICLO_INICIADO = 1
												END
											ELSE 
												BEGIN
													select 3 AS CONDICION, @cicloTransferenciaDestino AS CICLO

													SELECT TOP 1 @secuencialPiscinaEjecucionDESTINO = ultimaSecuencia + 1
													FROM	proSecuencial 
													WHERE	tabla = 'piscinaEjecucion' 

													SELECT TOP 1 @secuencialMaeCicloDESTINO = ultimaSecuencia + 1
													FROM	maeSecuencial 
													WHERE	tabla = 'PiscinaCiclo' 
													SET @EjecucionExistenteDESTINO = 0
												
													SET @secuencialPiscinaEjecucionSiguienteDESTINO = @secuencialPiscinaEjecucionDESTINO + 1;
													
select max(idPiscinaEjecucion), @cpount CONTADORVUELTAS from proPiscinaEjecucion
select * from proSecuencial
where tabla  = 'piscinaEjecucion'
													--***OJO CONSULTAR EXISTENTE***--
													INSERT INTO proPiscinaEjecucion (
														idPiscinaEjecucion,				idPiscina,					 ciclo,							rolPiscina,			 numEtapa,					lote,					fechaInicio, 
														fechaSiembra,					fechaCierre,				 tipoCierre,					idEspecie,			 cantidadEntrada,			cantidadAdicional,		cantidadSalida, 
														cantidadPerdida,				idPiscinaEjecucionSiguiente, estado,						tieneRaleo,			 tieneRepanio,				tieneCosecha,			activo, 
														usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,				usuarioModificacion, estacionModificacion,		fechaHoraModificacion)
													SELECT 
														@secuencialPiscinaEjecucionDESTINO,		idPiscinaDestino,			 Ciclo_Destino,					ROL,				 1,							Sector_DestinoCOD,		DATEADD(DAY, -1, MIN(fechaTransferencia)), 
														MIN(fechaTransferencia),		NULL,						 '',							1,					 SUM(cantidadTransferida),	 0,						0, 
														0,								NULL,						'EJE',							0,					 0,							 0,						1,
														@usuarioAudit,					':TRANS',						 @fechaProceso,					@usuarioAudit,		':TRANS',						 @fechaProceso
														FROM #InsertTransfTemp 
														GROUP BY idPiscinaDestino, Ciclo_Destino, rol, Sector_DestinoCOD
			
													INSERT INTO [dbo].[maePiscinaCiclo] (
														idPiscinaCiclo,								idPiscina,			    ciclo,		
														fecha,										origen,				    idOrigen, 
														idOrigenEquivalente,						rolCiclo,			    activo, 
														usuarioCreacion,							estacionCreacion,		fechaHoraCreacion, 
														usuarioModificacion,						estacionModificacion,   fechaHoraModificacion)
													SELECT 
														@secuencialMaeCicloDESTINO ,						idPiscinaDestino,		Ciclo_Destino, 
														DATEADD(DAY, -1, min(fechaTransferencia)), 'EJE',					@secuencialPiscinaEjecucionDESTINO, 
														null as idOrigenEquivalente,				ROL,					1, 
														@usuarioAudit,								':TRANS',					@fechaProceso, 
														@usuarioAudit,								':TRANS',					@fechaProceso
													FROM	 #InsertTransfTemp 
													GROUP BY idPiscinaDestino, Ciclo_Destino, 
															rol,			   Sector_DestinoCOD

													UPDATE proSecuencial 
													SET    ultimaSecuencia = @secuencialPiscinaEjecucionDESTINO  
													WHERE  tabla           = 'piscinaEjecucion' 
		
													UPDATE maeSecuencial 
													SET    ultimaSecuencia = @secuencialMaeCicloDESTINO
													WHERE  tabla           = 'PiscinaCiclo' 

												END
									
									
												INSERT INTO [dbo].[proTransferenciaEspecieDetalle] (
															idTransferenciaDetalle,			idTransferencia,			 orden,									idPiscina,				rolPiscina,				cantidadTransferida,
															pesoPromedioTransferencia,		biomasa,					 
															idPiscinaEjecucion,				tipoTransferencia,			 horaInicioTransferencia,				horaFinTransferencia, 
															observacion,					observacionParametro,		 observacionCaracteristica,				usuarioResponsable,		activo, 
															usuarioCreacion,				estacionCreacion,			 fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
															librasDeclaradas,				cantidadDeclarada,			 pesoDeclaradoTransferido,				numeroViajes)
												SELECT
															idTransferenciaDetalle,			idTransferencia,			 1,										idPiscinaDestino,		ROL as rolPiscina,		cantidadTransferida,
															pesoTransferidoGramos,			(cantidadTransferida * pesoTransferidoGramos) * 0.00220462 as biomasa, 
															@secuencialPiscinaEjecucionDESTINO,	tipoTransferencia,			'06:00:00' as horaInicioTransferencia, '06:00:00' as horaFinTransferencia, 
															'' as observacion,				null,						null,									usuarioResponsable,		1, 
															usuarioCreacion,				estacionCreacion,			fechaHoraCreacion,						usuarioModificacion,	estacionModificacion,	fechaHoraModificacion, 
															librasDeclaradas,				cantidadTransferida,		pesoTransferidoGramos,					null
												FROM		#InsertTransfTemp
												where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferenciaDestino;

								
												declare @sumaTransDetalle int = 0;

												--select @sumaTransDetalle = SUM(cantidadTransferida) FROM #InsertTransfTemp
												--where		idTransferenciaDetalle = @secuencialRowKeyTransferencia and Cod_Ciclo_Destino = @cicloTransferenciaDestino;
											
												select @sumaTransDetalle = SUM(TE.cantidadTransferida) FROM proTransferenciaEspecieDetalle TE
												INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
												WHERE TE.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO AND T.estado = 'APR'

												--select 'QUERY TRANS',* FROM proTransferenciaEspecieDetalle TE
												--INNER JOIN proTransferenciaEspecie T ON TE.idTransferencia = T.idTransferencia 
												--WHERE TE.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO AND T.estado = 'APR'

												--ACTUALIZAMOS EL CICLO INICIADO DEL DESTINO
												declare @cicloMax int,@fechaSiembraMin date;
												select 
														@fechaSiembraMin				= min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding)
												FROM   proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')
													
												select 
													@cicloMax = irt.Ciclo_Destino
												FROM   #InsertTransfTemp irt 
												WHERE  irt.Cod_Ciclo_Destino = @cicloTransferenciaDestino

												--SELECT 'OJO TRANSFERENCINA', * FROM proTransferenciaEspecieDetalle c  
												--		INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
												--		INNER JOIN proPiscinaEjecucion pe on pe.idPiscinaEjecucion = c.idPiscinaEjecucion and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
												--		WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
												--		AND t.estado NOT IN ('ANU','ING') AND pe.estado IN ('EJE', 'INI', 'PRE')

												UPDATE pe
													SET 
														ciclo						= @cicloMax , --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														rolPiscina					= 'ENG01',
														numEtapa					= 1,
														fechaSiembra				= @fechaSiembraMin, --min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding),
														tipoCierre					= '',
														idEspecie					= 1,
														--cantidadEntrada				= sum(c.cantidadTransferida),
														cantidadEntrada				= @sumaTransDetalle,
														cantidadAdicional			=  0,
														cantidadSalida				= 0,
														cantidadPerdida				= CASE WHEN cantidadSalida > 0 THEN (cantidadEntrada + cantidadAdicional) - cantidadSalida ELSE 0 END,
														estado						= 'EJE',
														usuarioModificacion			= @usuarioAudit,
														fechaHoraModificacion		= @fechaProceso
												--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
												--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
												--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
												FROM   proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscinaEjecucion = c.idPiscinaEjecucion and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate())  
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU','ING') AND pe.estado IN ('EJE', 'INI', 'PRE')
														
												--MAEPISCINA CICLO
												UPDATE pc
													SET 
														ciclo						= @cicloMax, --(max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1),
														origen						= 'EJE',
														rolCiclo					= 'ENG01',
														usuarioModificacion			= @usuarioAudit,
														fechaHoraModificacion		= @fechaProceso
												--SELECT c.idPiscinaEjecucion idEjecucionTransferencia,		pe.fechaInicio,		pe.fechaSiembra,		pe.fechaCierre,
												--	   c.fechaTransferencia,								c.idPiscina,		c.idTransferencia,		'ENG01',
												--	   pe.ciclo,		min(fechaTransferencia) over (order by c.idPiscina rows unbounded preceding), (max(pe.ciclo) over (order by c.idPiscina rows unbounded preceding) + 1)
												FROM  proTransferenciaEspecieDetalle c  
														INNER JOIN proTransferenciaEspecie t	  on c.idTransferencia = t.idTransferencia 
														INNER JOIN proPiscinaEjecucion pe on pe.idPiscina = c.idPiscina and t.fechaTransferencia BETWEEN pe.fechaInicio and isnull(pe.fechaCierre, getdate()) 
														INNER JOIN maePiscinaCiclo pc on pe.idPiscinaEjecucion = pc.idOrigen
														WHERE  pe.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
														AND t.estado NOT IN ('ANU') AND pe.estado IN ('EJE', 'INI', 'PRE')

											UPDATE #InsertTransfTemp 
											SET   procesado = 1 
											WHERE Cod_Ciclo_Destino = @cicloTransferenciaDestino and idTransferenciaDetalle = @secuencialRowKeyTransferencia --and fechaRecepcion = @fechaRecep
											
											SELECT 'HOLAAA', * FROM #InsertTransfTemp WHERE Pesca = 1 and Cod_Ciclo_Destino = @cicloTransferenciaDestino
										
											--/*INICIO ACTUALIZAMOS PISCINA EJECUCIÓN*/--
											IF exists (SELECT 1 FROM #InsertTransfTemp WHERE Pesca = 1 and Cod_Ciclo_Destino = @cicloTransferenciaDestino)
											BEGIN
												declare @keyPiscinaDestino varchar(50)
												declare @idPiscinaDestino int
												declare @fechaPesca date
												declare @cicloDestino int

												select top 1 @keyPiscinaDestino = keyDestino,				@idPiscinaDestino = idPiscinaDestino, 
															 @fechaPesca = Fecha_DS,						@cicloDestino = Ciclo_Destino 
															 from #InsertTransfTemp				where Cod_Ciclo_Destino = @cicloTransferenciaDestino
												SELECT 'COMSUNME PESCA' SANCOCHO, @keyPiscinaDestino, @secuencialPiscinaEjecucionDESTINO EJECUCION, @idPiscinaDestino PISCINA, @cicloTransferenciaDestino CICLO
												
												SELECT 'RESULTADO PESCA', * from  proPiscinaCosecha PC WHERE PC.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
													AND PC.idPiscina= @idPiscinaDestino AND tipoPesca = 'PES' AND liquidado = 1 

												IF NOT EXISTS (SELECT 1 from  proPiscinaCosecha PC WHERE PC.idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO
													AND PC.idPiscina= @idPiscinaDestino AND tipoPesca = 'PES' AND liquidado = 1 )
													BEGIN
															SELECT 1 
															exec PROCESS_CREATE_PESCA_CIERRE_HISTORIAL  @keyPiscina = @keyPiscinaDestino,		@idPiscinaEjecucion = @secuencialPiscinaEjecucionDESTINO,		@idPiscina = @idPiscinaDestino,
																										@Cod_Piscina = @cicloTransferenciaDestino,
																										@fechaCierre = @fechaPesca,				@fechaProceso = @fechaProceso,									@usuario = @usuarioAudit,            
																										@ciclo = @cicloDestino,					@displayContent = 0
															
													END
											END
										
											--/*FIN ACTUALIZAMOS PISCINA EJECUCIÓN*/--

									END
								
									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferencia) FROM #InsertTransfTemp)  
									WHERE  tabla		   = 'transferenciaEspecie' 

									UPDATE proSecuencial 
									SET    ultimaSecuencia = (SELECT MAX(idTransferenciaDetalle) FROM #InsertTransfTemp) 
									WHERE  tabla		   = 'transferenciaEspecieDetalle' 

								END
						END

						print 'secuencia ' + cast( @cicloTransferencia as varchar(50)) + ' ' + cast( @fechaRecep as varchar(10))
					
					select 'despues propiscinaejecucion', * from EjecucionesPiscinaView where keyPiscina = @PiscinaTemp and estado in ('INI','EJE', 'PRE') ORDER BY 4
					UPDATE #TranferenciaTemp 
					SET   procesado = 1 
					WHERE Cod_Ciclo_Origen = @cicloTransferencia and rowKeySecuencia# = @secuencia

				END
			-----CONFIRMACION DE LA TRANSACCION
			--SELECT * FROM proRecepcionEspecie WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proRecepcionEspecieDetalle WHERE idRecepcion = @secuencialRecepcion
			--SELECT * FROM proTransferenciaEspecieDetalle where  idPiscinaEjecucion = @secuencialPiscinaEjecucion
			--select * from  proPiscinaEjecucion where idPiscina = 2002
		
			select 'FINAL propiscinaejecucion',* from EjecucionesPiscinaView where keyPiscina = @PiscinaTemp and estado  in ('INI','EJE', 'PRE')  ORDER BY 4
		
			
		END TRY
		BEGIN CATCH
			-----REVERSA DE LA TRANSACCION
			SELECT  
				 ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  

				DECLARE @ErrorMessage  NVARCHAR(4000), 
						@ErrorSeverity INT, 
						@ErrorState INT;

				SELECT  @ErrorMessage  = ERROR_MESSAGE(), 
						@ErrorSeverity = ERROR_SEVERITY(), 
						@ErrorState    = ERROR_STATE();
			
				RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END CATCH
	END
GO
/****** Object:  StoredProcedure [dbo].[viewProcessCiclos]    Script Date: 20/06/2024 14:56:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--exec viewProcessCiclos 'PORTILLOPC1A', 1


CREATE    proc [dbo].[viewProcessCiclos]( @keyPiscina varchar(50), @mostrarUnaVez bit )
as begin

	--declare @keyPiscina varchar(50) = 'CAPULSA18'
			declare @idPiscina int = 0

			select top 1 @idPiscina = idPiscina from EjecucionesPiscinaView
			where keyPiscina = @keyPiscina 

			if @mostrarUnaVez = 1
			begin
				select Cod_Ciclo, Key_Piscina,Ciclo,  Fecha_IniSec, CAST(Fecha_Siembra AS DATE) AS Fecha_Siembra, 
				CAST(Fecha_Pesca AS DATE) AS Fecha_Pesca, Tipo, Cantidad_Sembrada, Zona, Camaronera, Piscina, 
				Sub_Tipo, Estatus, Hectarea, Tipo_Siembra, Fecha_Siemb_Fut, Fecha_Pesc_Fut, Densidad
				from CICLOS_PRODUCCION where Key_Piscina = @keyPiscina ORDER BY Ciclo DESC, Cod_Ciclo DESC
			end
			
			if @mostrarUnaVez = 1
			begin
				select cod_ciclo, keyPiscina, Ciclo, FechaInicio, FechaSiembra, FechaCierre, idPiscina, idPiscinaEjecucion,
				CantidadEntrada, CantidadSalida, CantidadPerdida, rolPiscina, tipoCierre, estado,idPiscinaEjecucionSiguiente, nombreSector 
				from EjecucionesPiscinaView where keyPiscina = @keyPiscina and estado in ('INI','EJE', 'PRE') ORDER BY Ciclo DESC, Cod_Ciclo DESC
			end

			select 'recepcionSis', r.fechaRecepcion,r.guiasRemision, ej.cod_ciclo, re.* from proRecepcionEspecieDetalle re
					inner join proRecepcionEspecie r on re.idRecepcion = r.idRecepcion
					inner join EjecucionesPiscinaView ej on re.idPiscinaEjecucion = ej.idPiscinaEjecucion
					where ej.idPiscina = @idPiscina and r.estado = 'APR'
			order by r.fechaRecepcion
		
			select 'recepcionAr', * from RECEPCIONES_PRODUCCION
					where KeyPiscina = @keyPiscina
			order by Fecha_Siembra
			   		
		
			select 'TransSis', ej.keyPiscina, ej.cod_ciclo, te.* from proTransferenciaEspecie te
			INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = te.idPiscinaEjecucion
			where te.idPiscina = @idPiscina and te.estado = 'APR'
			order by fechaTransferencia

			select 'TransArc', * from TRANSFERENCIAS_PRODUCCION
			where REPLACE(keyPiscinaOrigen ,' ','') = @keyPiscina
			order by Fecha_Transf

			select 'TransDetSis', TE.fechaTransferencia, ej.keyPiscina, ej.cod_ciclo, ted.* from proTransferenciaEspecieDetalle ted
			INNER JOIN proTransferenciaEspecie te on te.idTransferencia = ted.idTransferencia
			INNER JOIN EjecucionesPiscinaView ej on ej.idPiscinaEjecucion = ted.idPiscinaEjecucion
			where ted.idPiscina = @idPiscina and te.estado = 'APR'
			order by fechaTransferencia

			select 'TransDetArc', Fecha_Transf,	keyPiscinaDestino,	Cod_Ciclo_Destino, 	Cantidad_Transf, Cod_Ciclo_Origen, 	keyPiscinaOrigen,	Zona_Destino,	Sector_Destino,	Piscina_Destino,	Ciclo_Destino,	Estatus_Destino,
			Hectarea_Destino,		Peso_Transf,	Peso_Real,	Libras_Transf,	Conv,	Procedencia_Laboratorio, Linea,	Maduracion,	Superv,	Balanc,	Lib_Transf_C,	Anio,
			Zona_Origen,	Sector_Origen,	Piscina_Origen,	Ciclo_Origen,	Tipo,
			Sub_Tipo,	Estatus_Origen,	Hectarea_Origen,	Fecha_Siembra,	Cantidad_Sembrada,	Densidad,	Peso_Siembra,	Estatus_Transf,	Cons_Balanc,	Guia_Transf,	Forma_Transf
			from TRANSFERENCIAS_PRODUCCION
			where REPLACE(keyPiscinaDestino ,' ','') = @keyPiscina
			order by Fecha_Transf

			select ep.cod_ciclo, PC.tipoPesca, PC.liquidado, pc.estadoTrabajo, pc.* from proPiscinaCosecha pc
			INNER JOIN EjecucionesPiscinaView ep on pc.idPiscinaEjecucion = ep.idPiscinaEjecucion
			where pc.idPiscina = @idPiscina-- and pc.estado = 'APR'

			select  'PescaArc', * from PESCA_PRODUCCION
			where keyPiscina = @keyPiscina
end

GO
