
 ------------------------------------------INVENTARIO-------------------------------------------------------------
		 ----TABLA: BODEGAS
		 UPDATE B SET  
				B.zona       = MP.COD_ZONA,
				B.camaronera = MP.COD_CAMARONERA,
				B.sector     = MP.COD_SECTOR   
		 FROM  
				 parMegaUbicaciones MP INNER JOIN invBodega B 
		  ON     B.zona       = MP.COD_ZONA_OLD
		  AND    B.camaronera = MP.COD_CAMARONERA_OLD
		  AND    B.sector     = MP.COD_SECTOR_OLD

		----TABLA: APLICACIONITEM 
		 UPDATE A SET  
			  A.codigoZONA       = mp.COD_ZONA,
			  A.codigocamaronera = mp.COD_CAMARONERA,
			  A.codigosector     = mp.COD_SECTOR  
		 FROM 
				parMegaUbicaciones MP INNER JOIN invAplicacionItem A
		   ON   A.codigoZONA       = MP.COD_ZONA_OLD
		  AND   A.codigocamaronera = MP.COD_CAMARONERA_OLD
		  AND   A.codigosector     = MP.COD_SECTOR_OLD

		----TABLA: PEDIDO 
		 UPDATE P SET  
			  P.codigoZONA       = mp.COD_ZONA,
			  P.codigocamaronera = mp.COD_CAMARONERA,
			  P.codigosector     = mp.COD_SECTOR  
		   FROM 
				parMegaUbicaciones MP  INNER JOIN invPedido P 
		 ON     P.codigoZONA       = MP.COD_ZONA_OLD
		  AND   P.codigocamaronera = MP.COD_CAMARONERA_OLD
		  AND   P.codigosector     = MP.COD_SECTOR_OLD

		----TABLA: RECEPCIONITEMSCABECERA 
		 UPDATE RC SET  
			  RC.codigoZONA       = mp.COD_ZONA,
			  RC.codigocamaronera = mp.COD_CAMARONERA,
			  RC.codigosector     = mp.COD_SECTOR  
		   FROM 
				parMegaUbicaciones MP  INNER JOIN invRecepcionItemsCabecera RC 
		 ON     RC .codigoZONA       = MP.COD_ZONA_OLD
		  AND   RC.codigocamaronera  = MP.COD_CAMARONERA_OLD
		  AND   RC.codigosector      = MP.COD_SECTOR_OLD
   
------------------------------------------JERARQUIAS------------------------------------------------------------------
		----TABLA: PISCINA
		   UPDATE P SET  
			 P.zona       = mp.COD_ZONA,
			 P.camaronera = mp.COD_CAMARONERA,
			 P.sector     = mp.COD_SECTOR
		--  ,P.Lote       = mp.COD_SECTOR   
		 FROM  
				parMegaUbicaciones MP INNER JOIN maePiscina P 
		 ON     P.zona       = MP.COD_ZONA_OLD
		  AND   P.camaronera = MP.COD_CAMARONERA_OLD
		  AND   P.sector     = MP.COD_SECTOR_OLD 

		----TABLA: MAPPERMALLAS
		  UPDATE pmm set
			pmm.zona        = mp.COD_ZONA,
			pmm.camaronera  = mp.COD_CAMARONERA,
			pmm.sector      = mp.COD_SECTOR
		 FROM  proMapperMallas pmm inner join parMegaUbicaciones MP on pmm.sectorKey = mp.nombreSectorOld
 
		----TABLA: PARAMETROCONTROLDETALLE
		UPDATE PCD SET 
			 PCD.zona        = mp.COD_ZONA,
			 PCD.camaronera  = mp.COD_CAMARONERA,
			 PCD.sector      = mp.COD_SECTOR   
		 FROM  
			 parMegaUbicaciones MP INNER JOIN maeParametroControlDetalle PCD
		 ON     PCD.ZONA       = MP.COD_ZONA_OLD
		  AND   PCD.camaronera = MP.COD_CAMARONERA_OLD
		  AND   PCD.sector     = MP.COD_SECTOR_OLD  

		----TABLA: CONTROLPARAMETRO
		UPDATE PCP SET 
			 PCP.zona       = mp.COD_ZONA,
			 PCP.camaronera = mp.COD_CAMARONERA,
			 PCP.sector     = mp.COD_SECTOR   
		 FROM  
			 parMegaUbicaciones MP INNER JOIN proControlParametro PCP
		 ON     PCP.zona       = MP.COD_ZONA_OLD
		  AND   PCP.camaronera = MP.COD_CAMARONERA_OLD
		  AND   PCP.sector     = MP.COD_SECTOR_OLD 


		----TABLA: MUESTREOPESO
		UPDATE PMP SET 
			 PMP.zona       = mp.COD_ZONA,
			 PMP.camaronera = mp.COD_CAMARONERA,
			 PMP.sector     = mp.COD_SECTOR   
		 FROM		
			parMegaUbicaciones MP INNER JOIN proMuestreoPeso PMP
		 ON     PMP.ZONA       = MP.COD_ZONA_OLD
		  AND   PMP.camaronera = MP.COD_CAMARONERA_OLD
		  AND   PMP.sector     = MP.COD_SECTOR_OLD 
 
		----TABLA: MUESTREOPOBLACION
		UPDATE PMPB SET  
			 PMPB.zona		 = mp.COD_ZONA,
			 PMPB.camaronera = mp.COD_CAMARONERA,
			 PMPB.sector     = mp.COD_SECTOR   
		 FROM
				parMegaUbicaciones MP INNER JOIN proMuestreoPoblacion PMPB
		 ON     PMPB.ZONA       = MP.COD_ZONA_OLD
		  AND   PMPB.camaronera = MP.COD_CAMARONERA_OLD
		  AND   PMPB.sector     = MP.COD_SECTOR_OLD 

		----TABLA: RECEPCIONESPECIE
		UPDATE R SET  
			 R.zona = mp.COD_ZONA,
			 R.camaronera = mp.COD_CAMARONERA,
			 R.sector = mp.COD_SECTOR  
		FROM		
			parMegaUbicaciones MP INNER JOIN proRecepcionEspecie R
		 ON     R.ZONA       = MP.COD_ZONA_OLD
		  AND   R.camaronera = MP.COD_CAMARONERA_OLD
		  AND   R.sector     = MP.COD_SECTOR_OLD 
		    
			
		----TABLA: DARBOT CHAT
		UPDATE R SET  
			 R.zona = mp.COD_ZONA,
			 R.camaronera = mp.COD_CAMARONERA,
			 R.sector = mp.COD_SECTOR  
		FROM		
			parMegaUbicaciones MP INNER JOIN parGrupoWhatsappDetalle R
		 ON     R.ZONA       = MP.COD_ZONA_OLD
		  AND   R.camaronera = MP.COD_CAMARONERA_OLD
		  AND   R.sector     = MP.COD_SECTOR_OLD 

		  DROP TABLE parMegaUbicaciones