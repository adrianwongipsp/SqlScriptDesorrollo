  with BaseCTE as (
 select distinct
	codigoZona,
	nombreZona,
	codigoCamaronera,
	nombreCamaronera,
	codigoSector,
	nombreSector,
	idZona,
	idSector,
	idCamaronera 
 from PiscinaUbicacion
 )
 select	
    codigoZona as codigoZonaOld,
	nombreZona as nombreZonaOld,
	codigoCamaronera as codigoCamaroneraOld,
	nombreCamaronera as nombreCamaroneraOld,
	codigoSector as codigoSectorOld,
	nombreSector as nombreSectorOld,
	idZona,
	idSector,
	idCamaronera  ,
	codigoZona as codigoZonaNew,
	nombreZona as nombreZonaNew,
	--FORMAT(DENSE_RANK() OVER ( ORDER BY codigoZona, codigoCamaronera), '00000') as codigoCamaroneraNew,
    RIGHT('00000' + cast(idCamaronera  as varchar(5)),5) as codigoCamaroneraNew,
	nombreCamaronera as nombreCamaroneraNew,
	--FORMAT(ROW_NUMBER() OVER (ORDER BY codigoZona), '00000') as idSector,
	RIGHT('00000' + cast(idSector  as varchar(5)),5) as idSector,
	nombreSector as nombreSectorNew
 ---  into #zonficacionHomologarCodigo
 from 
  BaseCTE
  



 
 BEGIN TRAN
 ------------------------------------------INVENTARIO-------------------------------------------------------------
		 ----TABLA: BODEGAS
		 UPDATE B SET  
				B.zona       = MP.codigozonaNew,
				B.camaronera = MP.codigocamaroneraNew,
				B.sector     = MP.codigosectorNew   
		 FROM  
				#zonficacionHomologarCodigo MP INNER JOIN invBodega B 
		  ON     B.zona       = MP.codigozonaOld
		  AND    B.camaronera = MP.codigocamaroneraOld
		  AND    B.sector     = MP.codigosectorOld

		----TABLA: APLICACIONITEM 
		 UPDATE A SET  
			  A.codigoZONA       = mp.codigozonaNew,
			  A.codigocamaronera = mp.codigocamaroneraNew,
			  A.codigosector     = mp.codigosectorNew  
		 FROM 
				#zonficacionHomologarCodigo MP INNER JOIN invAplicacionItem A
		   ON   A.codigoZONA       = MP.codigozonaOld
		  AND   A.codigocamaronera = MP.codigocamaroneraOld
		  AND   A.codigosector     = MP.codigosectorOld

		----TABLA: PEDIDO 
		 UPDATE P SET  
			  P.codigoZONA       = mp.codigozonaNew,
			  P.codigocamaronera = mp.codigocamaroneraNew,
			  P.codigosector     = mp.codigosectorNew  
		   FROM 
				#zonficacionHomologarCodigo MP  INNER JOIN invPedido P 
		 ON     P.codigoZONA       = MP.codigozonaOld
		  AND   P.codigocamaronera = MP.codigocamaroneraOld
		  AND   P.codigosector     = MP.codigosectorOld

		----TABLA: RECEPCIONITEMSCABECERA 
		 UPDATE RC SET  
			  RC.codigoZONA       = mp.codigozonaNew,
			  RC.codigocamaronera = mp.codigocamaroneraNew,
			  RC.codigosector     = mp.codigosectorNew  
		   FROM 
				#zonficacionHomologarCodigo MP  INNER JOIN invRecepcionItemsCabecera RC 
		 ON     RC .codigoZONA       = MP.codigozonaOld
		  AND   RC.codigocamaronera  = MP.codigocamaroneraOld
		  AND   RC.codigosector      = MP.codigosectorOld
   
------------------------------------------JERARQUIAS------------------------------------------------------------------
		----TABLA: PISCINA
		   UPDATE P SET  
			 P.zona       = mp.codigozonaNew,
			 P.camaronera = mp.codigocamaroneraNew,
			 P.sector     = mp.codigosectorNew
		--  ,P.Lote       = mp.codigosectorNew   
		 FROM  
				#zonficacionHomologarCodigo MP INNER JOIN maePiscina P 
		 ON     P.zona       = MP.codigozonaOld
		  AND   P.camaronera = MP.codigocamaroneraOld
		  AND   P.sector     = MP.codigosectorOld 

		----TABLA: CAMARONERA
		  UPDATE C SET 
				 C.codigo = MP.codigocamaroneraNew  
		  FROM 
				#zonficacionHomologarCodigo MP INNER JOIN parCamaronera C 
			ON  C.idCamaronera  = MP.idCamaronera
			AND C.idZona        = MP.idZona 

		----TABLA: SECTOR	  
			 UPDATE S SET
				 S.codigo = MP.codigosectorNew  
		  FROM #zonficacionHomologarCodigo MP INNER JOIN parSector S 
			ON S.idSector     = MP.idSector
		   AND S.idCamaronera = MP.idCamaronera

		----TABLA: LOTE
		/* UPDATE pl  SET 
			pl.codigo = mp.codigosectorNew
		 FROM  parLote pl inner join #zonficacionHomologarCodigo MP on  pl.idsector = mp.idsector*/

		----TABLA: MAPPERMALLAS
		  UPDATE pmm set
			pmm.zona        = mp.codigozonaNew,
			pmm.camaronera  = mp.codigocamaroneraNew,
			pmm.sector      = mp.codigoSectorNew
		 FROM  proMapperMallas pmm inner join #zonficacionHomologarCodigo MP on pmm.sectorKey = mp.nombreSectorOld
 
		----TABLA: PARAMETROCONTROLDETALLE
		UPDATE PCD SET 
			 PCD.zona        = mp.codigozonaNew,
			 PCD.camaronera  = mp.codigocamaroneraNew,
			 PCD.sector      = mp.codigosectorNew   
		 FROM  
			 #zonficacionHomologarCodigo MP INNER JOIN maeParametroControlDetalle PCD
		 ON     PCD.ZONA       = MP.codigozonaOld
		  AND   PCD.camaronera = MP.codigocamaroneraOld
		  AND   PCD.sector     = MP.codigosectorOld  

		----TABLA: CONTROLPARAMETRO
		UPDATE PCP SET 
			 PCP.zona       = mp.codigozonaNew,
			 PCP.camaronera = mp.codigocamaroneraNew,
			 PCP.sector     = mp.codigosectorNew   
		 FROM  
			 #zonficacionHomologarCodigo MP INNER JOIN proControlParametro PCP
		 ON     PCP.zona       = MP.codigozonaOld
		  AND   PCP.camaronera = MP.codigocamaroneraOld
		  AND   PCP.sector     = MP.codigosectorOld 

		----TABLA: MUESTREOPESO
		UPDATE PMP SET 
			 PMP.zona       = mp.codigozonaNew,
			 PMP.camaronera = mp.codigocamaroneraNew,
			 PMP.sector     = mp.codigosectorNew   
		 FROM		
			#zonficacionHomologarCodigo MP INNER JOIN proMuestreoPeso PMP
		 ON     PMP.ZONA       = MP.codigozonaOld
		  AND   PMP.camaronera = MP.codigocamaroneraOld
		  AND   PMP.sector     = MP.codigosectorOld 
 
		----TABLA: MUESTREOPOBLACION
		UPDATE PMPB SET  
			 PMPB.zona		 = mp.codigozonaNew,
			 PMPB.camaronera = mp.codigocamaroneraNew,
			 PMPB.sector     = mp.codigosectorNew   
		 FROM
				#zonficacionHomologarCodigo MP INNER JOIN proMuestreoPoblacion PMPB
		 ON     PMPB.ZONA       = MP.codigozonaOld
		  AND   PMPB.camaronera = MP.codigocamaroneraOld
		  AND   PMPB.sector     = MP.codigosectorOld 

		----TABLA: RECEPCIONESPECIE
		UPDATE R SET  
			 R.zona = mp.codigozonaNew,
			 R.camaronera = mp.codigocamaroneraNew,
			 R.sector = mp.codigosectorNew  
		FROM		
			#zonficacionHomologarCodigo MP INNER JOIN proRecepcionEspecie R
		 ON     R.ZONA       = MP.CODIGOZONAOLD
		  AND   R.camaronera = MP.CODIGOCAMARONERAOLD
		  AND   R.sector     = MP.CODIGOSECTOROLD 
		    
			
		----TABLA: DARBOT CHAT
		UPDATE R SET  
			 R.zona = mp.codigozonaNew,
			 R.camaronera = mp.codigocamaroneraNew,
			 R.sector = mp.codigosectorNew  
		FROM		
			#zonficacionHomologarCodigo MP INNER JOIN parGrupoWhatsappDetalle R
		 ON     R.ZONA       = MP.CODIGOZONAOLD
		  AND   R.camaronera = MP.CODIGOCAMARONERAOLD
		  AND   R.sector     = MP.CODIGOSECTOROLD 
			
 -- TRAN
   