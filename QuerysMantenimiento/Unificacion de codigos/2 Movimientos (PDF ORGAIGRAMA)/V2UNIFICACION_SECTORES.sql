--SELECT * FROM parSector WHERE idCamaronera IN (1,2) ORDER BY idCamaronera
BEGIN TRAN

INSERT [dbo].[parSector] ([idSector], [idCamaronera], [codigo], [nombre], [descripcion], [codigoINP], [activo], [usuarioCreacion], [estacionCreacion], [fechaHoraCreacion], [usuarioModificacion], [estacionModificacion], [fechaHoraModificacion]) VALUES (77, 1, N'00007', N'GARITA', N'GARITA', N'00007', 1, N'adminPsCam', N'::1', CAST(N'2024-06-11T13:08:59.630' AS DateTime), N'adminPsCam', N'::1', CAST(N'2024-06-11T13:11:59.167' AS DateTime))
INSERT [dbo].[parSector] ([idSector], [idCamaronera], [codigo], [nombre], [descripcion], [codigoINP], [activo], [usuarioCreacion], [estacionCreacion], [fechaHoraCreacion], [usuarioModificacion], [estacionModificacion], [fechaHoraModificacion]) VALUES (78, 1, N'00008', N'TAURAIII', N'TAURAIII', N'00008', 1, N'adminPsCam', N'::1', CAST(N'2024-06-11T13:17:00.357' AS DateTime), N'adminPsCam', N'::1', CAST(N'2024-06-11T13:17:00.357' AS DateTime))
INSERT [dbo].[parSector] ([idSector], [idCamaronera], [codigo], [nombre], [descripcion], [codigoINP], [activo], [usuarioCreacion], [estacionCreacion], [fechaHoraCreacion], [usuarioModificacion], [estacionModificacion], [fechaHoraModificacion]) VALUES (79, 2, N'00005', N'HOLANDA', N'HOLANDA', N'00005', 1, N'adminPsCam', N'::1', CAST(N'2024-06-11T13:18:20.543' AS DateTime), N'adminPsCam', N'::1', CAST(N'2024-06-11T13:18:20.543' AS DateTime))
INSERT [dbo].[parSector] ([idSector], [idCamaronera], [codigo], [nombre], [descripcion], [codigoINP], [activo], [usuarioCreacion], [estacionCreacion], [fechaHoraCreacion], [usuarioModificacion], [estacionModificacion], [fechaHoraModificacion]) VALUES (80, 2, N'00006', N'TAURAV', N'TAURAV', N'00006', 1, N'adminPsCam', N'::1', CAST(N'2024-06-11T13:19:30.170' AS DateTime), N'adminPsCam', N'::1', CAST(N'2024-06-11T13:19:30.170' AS DateTime))
 
 DECLARE @DISPLAYCONTENT BIT
 SET	 @DISPLAYCONTENT = 0

 IF (@DISPLAYCONTENT = 1)
 BEGIN
	SELECT * FROM parSecuencial WHERE tabla = 'Sector'
 END

UPDATE parSecuencial SET ultimaSecuencia = 80 WHERE tabla = 'Sector'

IF (@DISPLAYCONTENT = 1)
 BEGIN
	SELECT * FROM parSecuencial WHERE tabla = 'Sector'
 END

 -- Drop the temporary table if it exists                      
 IF OBJECT_ID('tempdb..#TEMPORAL_ZONA_1') IS NOT NULL                      
	DROP TABLE #TEMPORAL_ZONA_1;          
 -- Drop the temporary table if it exists                      
 IF OBJECT_ID('tempdb..#TEMPORAL_ZONA_2') IS NOT NULL                      
	DROP TABLE #TEMPORAL_ZONA_2;          
 -- Drop the temporary table if it exists                      
 IF OBJECT_ID('tempdb..#zonficacionActualizarCodigo') IS NOT NULL                      
	DROP TABLE #zonficacionActualizarCodigo;          

select z.codigo as codigoZona,       z.nombre as nombreZona,      
       c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,      
       s.codigo as codigoSector    , s.nombre as nombreSector,  
       s.idSector   ,			     s.idCamaronera ,    
	   z.idZona  
  INTO #TEMPORAL_ZONA_1
from parZona z inner join parCamaronera c on c.idZona = z.idZona      
      inner join parSector     s on s.idCamaronera = c.idCamaronera          
where  z.activo = 1 and c.activo = 1 and s.activo =1  
AND z.nombre = 'TAURA'
AND c.nombre = 'TAURAB'
AND s.nombre IN ('GARITA','TAURAIII','HOLANDA','TAURAV')

select z.codigo as codigoZona,       z.nombre as nombreZona,      
       c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,      
       s.codigo as codigoSector    , s.nombre as nombreSector,  
       s.idSector   ,			     s.idCamaronera ,    
	   z.idZona  
   INTO #TEMPORAL_ZONA_2
from parZona z inner join parCamaronera c on c.idZona = z.idZona      
      inner join parSector     s on s.idCamaronera = c.idCamaronera          
where  z.activo = 1 and c.activo = 1 and s.activo =1  
AND z.nombre = 'TAURA'
AND c.nombre = 'TAURAA'
AND s.nombre IN ('GARITA','TAURAIII','HOLANDA','TAURAV')

SELECT  CHANGE.*
   INTO #zonficacionActualizarCodigo
FROM
	( SELECT 
		Z1.codigoZona AS codigoZona_Old,
		Z1.nombreZona AS nombreZona_Old,
		Z1.codigoCamaronera AS codigoCamaronera_Old,
		Z1.nombreCamaronera AS nombreCamaronera_Old,
		Z1.codigoSector AS codigoSector_Old,
		Z1.nombreSector AS nombreSector_Old,
		Z1.idSector AS idSector_Old,
		Z1.idCamaronera AS idCamaronera_Old,
		Z1.idZona AS idZona_Old,
		 '-CAMBIO Z1-' CAMBIO, 
		 Z2.codigoZona AS codigoZona_New,
		Z2.nombreZona AS nombreZona_New,
		Z2.codigoCamaronera AS codigoCamaronera_New,
		Z2.nombreCamaronera AS nombreCamaronera_New,
		Z2.codigoSector AS codigoSector_New,
		Z2.nombreSector AS nombreSector_New,
		Z2.idSector AS idSector_New,
		Z2.idCamaronera AS idCamaronera_New,
		Z2.idZona AS idZona_New 
	FROM #TEMPORAL_ZONA_1 Z1 INNER JOIN #TEMPORAL_ZONA_2 Z2 ON Z1.codigoZona = Z2.codigoZona AND Z1.nombreSector = Z2.nombreSector
	WHERE Z1.idSector < Z2.idSector
UNION
	SELECT 
		Z2.codigoZona AS codigoZona_Old,
		Z2.nombreZona AS nombreZona_Old,
		Z2.codigoCamaronera AS codigoCamaronera_Old,
		Z2.nombreCamaronera AS nombreCamaronera_Old,
		Z2.codigoSector AS codigoSector_Old,
		Z2.nombreSector AS nombreSector_Old,
		Z2.idSector AS idSector_Old,
		Z2.idCamaronera AS idCamaronera_Old,
		Z2.idZona AS idZona_Old, 
		'-CAMBIO Z2-' CAMBIO,
		Z1.codigoZona AS codigoZona_New,
		Z1.nombreZona AS nombreZona_New,
		Z1.codigoCamaronera AS codigoCamaronera_New,
		Z1.nombreCamaronera AS nombreCamaronera_New,
		Z1.codigoSector AS codigoSector_New,
		Z1.nombreSector AS nombreSector_New,
		Z1.idSector AS idSector_New,
		Z1.idCamaronera AS idCamaronera_New,
		Z1.idZona AS idZona_New
	FROM #TEMPORAL_ZONA_1 Z1 INNER JOIN #TEMPORAL_ZONA_2 Z2 ON Z1.codigoZona = Z2.codigoZona AND Z1.nombreSector = Z2.nombreSector
	WHERE Z1.idSector > Z2.idSector )  AS CHANGE
 
 SELECT  row_number()over (order by idZona_Old) idZonficacionActualizacion,
		codigoZona_Old,
		nombreZona_Old,
		codigoCamaronera_Old,
		nombreCamaronera_Old,
		codigoSector_Old,
		nombreSector_Old,
		idSector_Old,
		idCamaronera_Old,
		idZona_Old,
		codigoZona_New,
		nombreZona_New,
		codigoCamaronera_New,
		nombreCamaronera_New,
		codigoSector_New,
		nombreSector_New,
		idSector_New,
		idCamaronera_New,
		idZona_New,
		cast (1 as bit) activo,
		'adminPsCam' as usuarioCreacion,
		'::1' as estacionCreacion,
	     getdate() fechaCreacion, 
		'adminPsCam' as  usuarioModificacion,
		'::1' as estacionModificacion,
		getdate()  fechaModificacion 
	INTO parZonficacionActualizacion
 FROM #zonficacionActualizarCodigo
 
   SELECT 'parZonficacionActualizarCodigo' tabla, * FROM parZonficacionActualizacion


 IF (@DISPLAYCONTENT = 1)
 BEGIN
	SELECT 'ANTES REGULARIZACION SECTORES' AS periodo,* FROM #zonficacionActualizarCodigo
 END

 ------------------------------------------INVENTARIO-------------------------------------------------------------------------------------
-------------******************************TABLA: BODEGAS************************---------------------------------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'ANTES invBodega' AS Periodo,
			        B.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invBodega B 
					  ON     B.zona       = MP.codigozona_Old
					  AND    B.camaronera = MP.codigocamaronera_Old
					  AND    B.sector     = MP.codigosector_Old
		 END

		 print 'invBodega'
		 UPDATE B SET  
				B.zona       = MP.codigoZona_New,
				B.camaronera = MP.codigocamaronera_New,
				B.sector     = MP.codigosector_New   
		 FROM  
				#zonficacionActualizarCodigo MP INNER JOIN invBodega B 
		  ON     B.zona       = MP.codigozona_Old
		  AND    B.camaronera = MP.codigocamaronera_Old
		  AND    B.sector     = MP.codigosector_Old

		 print 'invBodega: idSector_Old'
		 UPDATE B SET  
				B.idSector       = MP.idSector_New --,
				--B.codigo         =  'Sector' + CAST(MP.idSector_New as varchar(3))
		 FROM  
				#zonficacionActualizarCodigo MP INNER JOIN invBodega B 
		  ON     B.idSector       = MP.idSector_Old 
		 
		 
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'DESPUES invBodega' AS Periodo,
			        B.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invBodega B 
					  ON     B.zona       = MP.codigozona_Old
					  AND    B.camaronera = MP.codigocamaronera_Old
					  AND    B.sector     = MP.codigosector_Old

			SELECT 'DESPUES invBodega' AS Periodo,
			        B.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invBodega B 
					  ON     B.zona       = MP.codigoZona_New
					  AND    B.camaronera = MP.codigocamaronera_New
					  AND    B.sector     = MP.codigosector_New
		 END
-------------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: APLICACIONITEM************************---------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'ANTES invAplicacionItem' AS Periodo,
			        A.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invAplicacionItem A
				   ON   A.codigoZONA       = MP.codigozona_Old
				  AND   A.codigocamaronera = MP.codigocamaronera_Old
				  AND   A.codigosector     = MP.codigosector_Old
		 END
		 print 'invAplicacionItem'
		 UPDATE A SET  
			  A.codigoZONA       = mp.codigozona_New,
			  A.codigocamaronera = mp.codigocamaronera_New,
			  A.codigosector     = mp.codigosector_New  
		 FROM 
				#zonficacionActualizarCodigo MP INNER JOIN invAplicacionItem A
		   ON   A.codigoZONA       = MP.codigozona_Old
		  AND   A.codigocamaronera = MP.codigocamaronera_Old
		  AND   A.codigosector     = MP.codigosector_Old

		  ---NOTA: Revisar Bodega Destino: invAplicacionItemDetalle
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'DESPUES invAplicacionItem' AS Periodo,
			        A.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invAplicacionItem A
				   ON   A.codigoZONA       = MP.codigozona_Old
				  AND   A.codigocamaronera = MP.codigocamaronera_Old
				  AND   A.codigosector     = MP.codigosector_Old

			SELECT 'DESPUES invAplicacionItem' AS Periodo,
			        A.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invAplicacionItem A
				   ON   A.codigoZONA       = MP.codigoZona_New
				  AND   A.codigocamaronera = MP.codigocamaronera_New
				  AND   A.codigosector     = MP.codigosector_New
		 END

-------------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: PEDIDO************************-----------------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'ANTES invPedido' AS Periodo,
			        P.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invPedido P 
			 ON     P.codigoZONA       = MP.codigozona_Old
			  AND   P.codigocamaronera = MP.codigocamaronera_Old
			  AND   P.codigosector     = MP.codigosector_Old
		 END
		 print 'invPedido'
		 UPDATE P SET  
			  P.codigoZONA       = mp.codigozona_New,
			  P.codigocamaronera = mp.codigocamaronera_New,
			  P.codigosector     = mp.codigosector_New  
		   FROM 
				#zonficacionActualizarCodigo MP  INNER JOIN invPedido P 
		 ON     P.codigoZONA       = MP.codigozona_Old
		  AND   P.codigocamaronera = MP.codigocamaronera_Old
		  AND   P.codigosector     = MP.codigosector_Old
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'DESPUES invPedido' AS Periodo,
			        P.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invPedido P 
			 ON     P.codigoZONA       = MP.codigozona_Old
			  AND   P.codigocamaronera = MP.codigocamaronera_Old
			  AND   P.codigosector     = MP.codigosector_Old

			SELECT 'DESPUES invPedido' AS Periodo,
			        P.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN invPedido P 
			 ON     P.codigoZONA       = MP.codigoZona_New
			  AND   P.codigocamaronera = MP.codigocamaronera_New
			  AND   P.codigosector     = MP.codigosector_New
		 END
		----TABLA: RECEPCIONITEMSCABECERA 
-------------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: RECEPCION ************************-------------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'ANTES invRecepcionItemsCabecera' AS Periodo,
			        RC.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN  invRecepcionItemsCabecera RC 
			 ON     RC .codigoZONA       = MP.codigozona_Old
			  AND   RC.codigocamaronera  = MP.codigocamaronera_Old
			  AND   RC.codigosector      = MP.codigosector_Old
		 END
		 print 'invRecepcionItemsCabecera'
		 UPDATE RC SET  
			  RC.codigoZONA       = mp.codigozona_New,
			  RC.codigocamaronera = mp.codigocamaronera_New,
			  RC.codigosector     = mp.codigosector_New  
		   FROM 
				#zonficacionActualizarCodigo MP  INNER JOIN invRecepcionItemsCabecera RC 
		 ON     RC .codigoZONA       = MP.codigozona_Old
		  AND   RC.codigocamaronera  = MP.codigocamaronera_Old
		  AND   RC.codigosector      = MP.codigosector_Old
 		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			SELECT 'DESPUES invRecepcionItemsCabecera' AS Periodo,
			        RC.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN  invRecepcionItemsCabecera RC 
			 ON     RC .codigoZONA       = MP.codigozona_Old
			  AND   RC.codigocamaronera  = MP.codigocamaronera_Old
			  AND   RC.codigosector      = MP.codigosector_Old

			 SELECT 'DESPUES invRecepcionItemsCabecera' AS Periodo,
			        RC.* 
			FROM  #zonficacionActualizarCodigo MP INNER JOIN  invRecepcionItemsCabecera RC 
			 ON     RC .codigoZONA       = MP.codigozona_New
			  AND   RC.codigocamaronera  = MP.codigocamaronera_New
			  AND   RC.codigosector      = MP.codigosector_New
		 END  
-----------------------------------------------------------------------------------------------------------------------
------------------------------------------JERARQUIAS------------------------------------------------------------------
-------------******************************TABLA: PISCINA ************************-------------------------------------
 		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES  CATALOGO PISCINA' as Periodo ,P.*
			 FROM  
					#zonficacionActualizarCodigo MP INNER JOIN PiscinaUbicacion P 
			 ON     P.codigoZona       = MP.codigozona_Old
			  AND   P.codigoCamaronera = MP.codigocamaronera_Old
			  AND   P.codigosector     = MP.codigosector_Old 
		 END
		   print 'maePiscina'
		   UPDATE P SET  
			 P.zona       = mp.codigozona_New,
			 P.camaronera = mp.codigocamaronera_New,
			 P.sector     = mp.codigosector_New
		    ,P.Lote       = mp.codigosector_New   
		 FROM  
				#zonficacionActualizarCodigo MP INNER JOIN maePiscina P 
		 ON     P.zona       = MP.codigozona_Old
		  AND   P.camaronera = MP.codigocamaronera_Old
		  AND   P.sector     = MP.codigosector_Old 

		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES CATALOGO PISCINA' as Periodo, P.*
			 FROM  
					#zonficacionActualizarCodigo MP INNER JOIN PiscinaUbicacion P 
			 ON     P.codigoZona       = MP.codigozona_Old
			  AND   P.codigoCamaronera = MP.codigocamaronera_Old
			  AND   P.codigosector     = MP.codigosector_Old 

			 SELECT 'DESPUES CATALOGO PISCINA' as Periodo, P.*
			 FROM  
					#zonficacionActualizarCodigo MP INNER JOIN PiscinaUbicacion P 
			 ON     P.codigoZona       = MP.codigoZona_New
			  AND   P.codigoCamaronera = MP.codigocamaronera_New
			  AND   P.codigosector     = MP.codigosector_New
		END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: SECTOR ************************-------------------------------------  
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES CATALOGO SECTOR (ACTIVO)' as Periodo,S.activo, S.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parSector S 
				ON S.idSector     = MP.idSector_OLD
			   AND S.idCamaronera = MP.idCamaronera_Old
		 END
		  print 'parSector'
		   UPDATE S SET
				 S.activo = 0
		  FROM #zonficacionActualizarCodigo MP INNER JOIN parSector S 
			ON S.idSector     = MP.idSector_OLD
		   AND S.idCamaronera = MP.idCamaronera_Old
		
		IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES CATALOGO SECTOR (INACTIVO)' as Periodo,S.activo, S.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parSector S 
				ON S.idSector     = MP.idSector_OLD
			   AND S.idCamaronera = MP.idCamaronera_Old

		    SELECT 'DESPUES CATALOGO SECTOR (ACTIVO)' as Periodo,S.activo, S.*
			FROM #zonficacionActualizarCodigo MP INNER JOIN parSector S 
				ON S.idSector     = MP.idSector_New
			   AND S.idCamaronera = MP.idCamaronera_New
		 END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: LOTE ************************---------------------------------------		   
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES LOTE' as Periodo, PL.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parLote PL 
			  ON  PL.idsector = mp.idSector_Old 
		 END
		  print 'parLote'
		  UPDATE PL  SET 
			PL.codigo   =   MP.codigosector_New,
			PL.idSector =   MP.idSector_New
		  FROM   #zonficacionActualizarCodigo MP INNER JOIN parLote PL 
			ON  PL.idsector = mp.idSector_Old 

         IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES LOTE' as Periodo, PL.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parLote PL 
			  ON  PL.idsector = mp.idSector_Old 

             SELECT 'DESPUES LOTE' as Periodo, PL.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parLote PL 
			  ON  PL.idsector = mp.idSector_New 
		 END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: MapperMallas ************************-------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES MAPPERMALLAS' as Periodo, pmm.*
			 FROM #zonficacionActualizarCodigo MP Inner join proMapperMallas pmm on
					pmm.zona       = MP.codigozona_Old
			  AND   pmm.camaronera = MP.codigocamaronera_Old
			  AND   pmm.sector     = MP.codigosector_Old 
		 END
		 print 'proMapperMallas'
		  UPDATE pmm set
			pmm.zona        = mp.codigozona_New,
			pmm.camaronera  = mp.codigocamaronera_New,
			pmm.sector      = mp.codigoSector_New
		 FROM  #zonficacionActualizarCodigo MP inner join proMapperMallas pmm on
				pmm.zona       = MP.codigozona_Old
		  AND   pmm.camaronera = MP.codigocamaronera_Old
		  AND   pmm.sector     = MP.codigosector_Old 
 
	     IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES MAPPERMALLAS' as Periodo, pmm.*
			 FROM #zonficacionActualizarCodigo MP Inner join proMapperMallas pmm on
					pmm.zona       = MP.codigozona_Old
			  AND   pmm.camaronera = MP.codigocamaronera_Old
			  AND   pmm.sector     = MP.codigosector_Old 

			 SELECT 'DESPUES MAPPERMALLAS' as Periodo, pmm.*
			 FROM #zonficacionActualizarCodigo MP Inner join proMapperMallas pmm on
					pmm.zona       = MP.codigoZona_New
			  AND   pmm.camaronera = MP.codigocamaronera_New
			  AND   pmm.sector     = MP.codigosector_New
		 END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: PARAMETROCONTROLDETALLE (CONFIGURACION) ************************----
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES PARAMETROCONTROLDETALLE' as Periodo, PCD.*
			 FROM #zonficacionActualizarCodigo MP Inner join maeParametroControlDetalle PCD on
					PCD.zona       = MP.codigozona_Old
			  AND   PCD.camaronera = MP.codigocamaronera_Old
			  AND   PCD.sector     = MP.codigosector_Old 
		 END
		 
		print 'maeParametroControlDetalle'
		UPDATE	PCD SET 
				PCD.zona        = mp.codigozona_New,
				PCD.camaronera  = mp.codigocamaronera_New,
				PCD.sector      = mp.codigoSector_New 
		 FROM  
			 #zonficacionActualizarCodigo MP INNER JOIN maeParametroControlDetalle PCD on
				PCD.zona       = MP.codigozona_Old
		  AND   PCD.camaronera = MP.codigocamaronera_Old
		  AND   PCD.sector     = MP.codigosector_Old 

		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES PARAMETROCONTROLDETALLE' as Periodo, PCD.*
			 FROM #zonficacionActualizarCodigo MP Inner join maeParametroControlDetalle PCD on
					PCD.zona       = MP.codigozona_Old
			  AND   PCD.camaronera = MP.codigocamaronera_Old
			  AND   PCD.sector     = MP.codigosector_Old 

			 SELECT 'DESPUES PARAMETROCONTROLDETALLE' as Periodo, PCD.*
			 FROM #zonficacionActualizarCodigo MP Inner join maeParametroControlDetalle PCD on
					PCD.zona       = MP.codigozona_New 
			  AND   PCD.camaronera = MP.codigocamaronera_New 
			  AND   PCD.sector     = MP.codigosector_New 
		 END

----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: CONTROLPARAMETRO ************************---------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES CONTROLPARAMETRO' as Periodo, PCP.*
			 FROM #zonficacionActualizarCodigo MP Inner join  proControlParametro PCP
			 ON     PCP.zona       = MP.codigozona_Old
			  AND   PCP.camaronera = MP.codigocamaronera_Old
			  AND   PCP.sector     = MP.codigosector_Old 
		 END
		
		print 'proControlParametro'
		UPDATE PCP SET 
			 PCP.zona       = mp.codigozona_New,
			 PCP.camaronera = mp.codigocamaronera_New,
			 PCP.sector     = mp.codigosector_New   
		 FROM  
			 #zonficacionActualizarCodigo MP INNER JOIN proControlParametro PCP
		 ON     PCP.zona       = MP.codigozona_Old
		  AND   PCP.camaronera = MP.codigocamaronera_Old
		  AND   PCP.sector     = MP.codigosector_Old 

		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES CONTROLPARAMETRO' as Periodo, PCP.*
			 FROM #zonficacionActualizarCodigo MP Inner join  proControlParametro PCP
			 ON     PCP.zona       = MP.codigozona_Old
			  AND   PCP.camaronera = MP.codigocamaronera_Old
			  AND   PCP.sector     = MP.codigosector_Old 

			SELECT 'DESPUES CONTROLPARAMETRO' as Periodo, PCP.*
			 FROM #zonficacionActualizarCodigo MP Inner join  proControlParametro PCP
			 ON     PCP.zona       = MP.codigoZona_New
			  AND   PCP.camaronera = MP.codigocamaronera_New
			  AND   PCP.sector     = MP.codigosector_New
		 END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: MUESTREOPESO ************************-------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES MUESTREOPESO' as Periodo, PMP.*
			 FROM #zonficacionActualizarCodigo MP Inner join  proMuestreoPeso PMP
			 ON     PMP.ZONA       = MP.codigozona_Old
			  AND   PMP.camaronera = MP.codigocamaronera_Old
			  AND   PMP.sector     = MP.codigosector_Old 
		 END
		
		print 'proMuestreoPeso'
		UPDATE PMP SET 
			 PMP.zona       = mp.codigozona_New,
			 PMP.camaronera = mp.codigocamaronera_New,
			 PMP.sector     = mp.codigosector_New   
		 FROM		
			#zonficacionActualizarCodigo MP INNER JOIN proMuestreoPeso PMP
		 ON     PMP.ZONA       = MP.codigozona_Old
		  AND   PMP.camaronera = MP.codigocamaronera_Old
		  AND   PMP.sector     = MP.codigosector_Old 
 
 		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES MUESTREOPESO' as Periodo, PMP.*
			 FROM #zonficacionActualizarCodigo MP Inner join  proMuestreoPeso PMP
			 ON     PMP.ZONA       = MP.codigozona_Old
			  AND   PMP.camaronera = MP.codigocamaronera_Old
			  AND   PMP.sector     = MP.codigosector_Old 

			SELECT 'DESPUES MUESTREOPESO' as Periodo, PMP.*
			 FROM #zonficacionActualizarCodigo MP Inner join  proMuestreoPeso PMP
			 ON     PMP.ZONA       = MP.codigoZona_New
			  AND   PMP.camaronera = MP.codigocamaronera_New
			  AND   PMP.sector     = MP.codigosector_New
		 END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: MUESTREOPOBLACION ************************--------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES MUESTREOPOBLACION' as Periodo, PMPB.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN proMuestreoPoblacion PMPB
			 ON     PMPB.ZONA       = MP.codigozona_Old
			  AND   PMPB.camaronera = MP.codigocamaronera_Old
			  AND   PMPB.sector     = MP.codigosector_Old 
		 END

        print 'proMuestreoPoblacion'
		UPDATE PMPB SET  
			 PMPB.zona		 = mp.codigozona_New,
			 PMPB.camaronera = mp.codigoCamaronera_New,
			 PMPB.sector     = mp.codigosector_New   
		 FROM
				#zonficacionActualizarCodigo MP INNER JOIN proMuestreoPoblacion PMPB
		 ON     PMPB.ZONA       = MP.codigozona_Old
		  AND   PMPB.camaronera = MP.codigocamaronera_Old
		  AND   PMPB.sector     = MP.codigosector_Old 

		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES MUESTREOPOBLACION' as Periodo, PMPB.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN proMuestreoPoblacion PMPB
			 ON     PMPB.ZONA       = MP.codigozona_Old
			  AND   PMPB.camaronera = MP.codigocamaronera_Old
			  AND   PMPB.sector     = MP.codigosector_Old 

			SELECT 'DESPUES MUESTREOPOBLACION' as Periodo, PMPB.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN proMuestreoPoblacion PMPB
			 ON     PMPB.ZONA       = MP.codigoZona_New
			  AND   PMPB.camaronera = MP.codigocamaronera_New
			  AND   PMPB.sector     = MP.codigosector_New 
		 END
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: RECEPCIONESPECIE ************************---------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES RECEPCIONESPECIE' as Periodo, R.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN proRecepcionEspecie R
		 ON      R.ZONA       = MP.CODIGOZONA_OLD
		   AND   R.camaronera = MP.CODIGOCAMARONERA_OLD
		   AND   R.sector     = MP.CODIGOSECTOR_OLD 
		 END

		print 'proRecepcionEspecie'
		UPDATE R SET  
			 R.zona       = mp.codigozona_New,
			 R.camaronera = mp.codigocamaronera_New,
			 R.sector     = mp.codigosector_New  
		FROM		
			#zonficacionActualizarCodigo MP INNER JOIN proRecepcionEspecie R
		 ON      R.ZONA       = MP.CODIGOZONA_OLD
		   AND   R.camaronera = MP.CODIGOCAMARONERA_OLD
		   AND   R.sector     = MP.CODIGOSECTOR_OLD 

		IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES RECEPCIONESPECIE' as Periodo, R.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN proRecepcionEspecie R
			 ON      R.ZONA       = MP.CODIGOZONA_OLD
			   AND   R.camaronera = MP.CODIGOCAMARONERA_OLD
			   AND   R.sector     = MP.CODIGOSECTOR_OLD 

			SELECT 'DESPUES RECEPCIONESPECIE' as Periodo, R.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN proRecepcionEspecie R
			 ON      R.ZONA       = MP.codigoZona_New
			   AND   R.camaronera = MP.CODIGOCAMARONERA_New
			   AND   R.sector     = MP.CODIGOSECTOR_New
		 END 
----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: ATARRAYA ************************-----------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES ATARRAYA' as Periodo, MAY.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN maeAtarraya may 
				ON may.idSector = MP.idSector_Old
		 END

		  print 'maeAtarraya'
		  UPDATE may SET
				 may.idSector = MP.idSector_New
		  FROM #zonficacionActualizarCodigo MP INNER JOIN maeAtarraya may 
		  ON may.idSector = MP.idSector_Old

		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES ATARRAYA' as Periodo, MAY.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN maeAtarraya may 
				ON may.idSector = MP.idSector_Old

			SELECT 'DESPUES ATARRAYA' as Periodo, MAY.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN maeAtarraya may 
				ON may.idSector = MP.idSector_New
		 END

----------------------------------------------------------------------------------------------------------------------
-------------******************************TABLA: SECTORUSUARIO ************************------------------------------
		 IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'ANTES SECTORUSUARIO' as Periodo, psu.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parSectorUsuario psu 
				ON psu.idSector = MP.idSector_Old
		 END

		 print 'parSectorUsuario'
		 UPDATE  psu SET
				 psu.idSector = MP.idSector_New
		  FROM #zonficacionActualizarCodigo MP INNER JOIN parSectorUsuario psu 
		  ON psu.idSector = MP.idSector_Old

		IF (@DISPLAYCONTENT = 1)
		 BEGIN
			 SELECT 'DESPUES SECTORUSUARIO' as Periodo, psu.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parSectorUsuario psu 
				ON psu.idSector = MP.idSector_Old

			 SELECT 'DESPUES SECTORUSUARIO' as Periodo, psu.*
			 FROM #zonficacionActualizarCodigo MP INNER JOIN parSectorUsuario psu 
				ON psu.idSector = MP.idSector_New
		 END
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
select 'DESPUES' as Periodo ,   New.* from 
	(select s.activo,
		    z.codigo as codigoZona,       z.nombre as nombreZona,      
		    c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,      
		    s.codigo as codigoSector    , s.nombre as nombreSector,  
		    s.idSector   ,			      s.idCamaronera ,    
		    z.idZona   
	from parZona z inner join parCamaronera c on c.idZona = z.idZona      
		  inner join parSector     s on s.idCamaronera = c.idCamaronera          
	where  z.activo = 1 and c.activo = 1 --and s.activo =1  
	AND z.nombre = 'TAURA'
	AND c.nombre = 'TAURAB'
	AND s.nombre IN ('GARITA','TAURAIII','HOLANDA','TAURAV')

	union all

	select s.activo,
		   z.codigo as codigoZona,       z.nombre as nombreZona,      
		   c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,      
		   s.codigo as codigoSector    , s.nombre as nombreSector,  
		   s.idSector   ,			     s.idCamaronera ,    
		   z.idZona   
	from parZona z inner join parCamaronera c on c.idZona = z.idZona      
		  inner join parSector     s on s.idCamaronera = c.idCamaronera          
	where  z.activo = 1 and c.activo = 1 --and s.activo =1  
	AND z.nombre = 'TAURA'
	AND c.nombre = 'TAURAA'
	AND s.nombre IN ('GARITA','TAURAIII','HOLANDA','TAURAV')) as New

ROLLBACK TRAN
--COMMIT TRAN
   
 