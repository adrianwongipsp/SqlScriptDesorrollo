/*
select * from parCamaronera where idCamaronera in (1,2) --TAURA A Y B
select * from parSector WHERE idCamaronera IN (1,2)    --TAURA a y b
select * from parSector WHERE idSector IN (2,3,4,5,7,8) --TAURA A (1)
select * from parSector WHERE idSector IN (9,6,10,1)    --TAURA B (2)
*/
 

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
 where idZona in (1) and idCamaronera in (1,2)
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
	codigoCamaronera as codigoCamaroneraNew,
	nombreCamaronera as nombreCamaroneraNew,
	codigoSector     as codigoSectorNew,
	nombreSector     as nombreSectorNew
   into #zonficacionActualizarCodigo
 from 
  BaseCTE

   update za
   set za.idCamaronera = 1,
	   za.codigoCamaroneraNew = '00001'
   from  #zonficacionActualizarCodigo za   
   WHERE za.idSector IN (2,3,4,5,7,8)

      update za
   set za.idCamaronera = 2,
	   za.codigoCamaroneraNew = '00002'
   from  #zonficacionActualizarCodigo za   
   WHERE za.idSector IN (9,6,10,1) 
   select * from #zonficacionActualizarCodigo
   select distinct codigoZona,	nombreZona,	codigoCamaronera	,nombreCamaronera,	codigoSector	,nombreSector, idSector,	idCamaronera,	idZona
   from PiscinaUbicacion  where codigoZona='01' and codigoCamaronera in ('00001','00002') order by codigoCamaronera, codigoSector
 
    BEGIN TRAN
 ------------------------------------------INVENTARIO-------------------------------------------------------------
		 ----TABLA: BODEGAS
		 UPDATE B SET  
				B.zona       = MP.codigozonaNew,
				B.camaronera = MP.codigocamaroneraNew,
				B.sector     = MP.codigosectorNew   
		 FROM  
				#zonficacionActualizarCodigo MP INNER JOIN invBodega B 
		  ON     B.zona       = MP.codigozonaOld
		  AND    B.camaronera = MP.codigocamaroneraOld
		  AND    B.sector     = MP.codigosectorOld

		----TABLA: APLICACIONITEM 
		 UPDATE A SET  
			  A.codigoZONA       = mp.codigozonaNew,
			  A.codigocamaronera = mp.codigocamaroneraNew,
			  A.codigosector     = mp.codigosectorNew  
		 FROM 
				#zonficacionActualizarCodigo MP INNER JOIN invAplicacionItem A
		   ON   A.codigoZONA       = MP.codigozonaOld
		  AND   A.codigocamaronera = MP.codigocamaroneraOld
		  AND   A.codigosector     = MP.codigosectorOld

		----TABLA: PEDIDO 
		 UPDATE P SET  
			  P.codigoZONA       = mp.codigozonaNew,
			  P.codigocamaronera = mp.codigocamaroneraNew,
			  P.codigosector     = mp.codigosectorNew  
		   FROM 
				#zonficacionActualizarCodigo MP  INNER JOIN invPedido P 
		 ON     P.codigoZONA       = MP.codigozonaOld
		  AND   P.codigocamaronera = MP.codigocamaroneraOld
		  AND   P.codigosector     = MP.codigosectorOld

		----TABLA: RECEPCIONITEMSCABECERA 
		 UPDATE RC SET  
			  RC.codigoZONA       = mp.codigozonaNew,
			  RC.codigocamaronera = mp.codigocamaroneraNew,
			  RC.codigosector     = mp.codigosectorNew  
		   FROM 
				#zonficacionActualizarCodigo MP  INNER JOIN invRecepcionItemsCabecera RC 
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
				#zonficacionActualizarCodigo MP INNER JOIN maePiscina P 
		 ON     P.zona       = MP.codigozonaOld
		  AND   P.camaronera = MP.codigocamaroneraOld
		  AND   P.sector     = MP.codigosectorOld 

		----TABLA: CAMARONERA
		 -- UPDATE C SET 
			--	 C.codigo = MP.codigocamaroneraNew  
		 -- FROM 
			--	#zonficacionActualizarCodigo MP INNER JOIN parCamaronera C 
			--ON  C.idCamaronera  = MP.idCamaronera
			--AND C.idZona        = MP.idZona 

		----TABLA: SECTOR	  
			-- UPDATE S SET
			--	 S.codigo = MP.codigosectorNew  
		 -- FROM #zonficacionActualizarCodigo MP INNER JOIN parSector S 
			--ON S.idSector     = MP.idSector
		 --  AND S.idCamaronera = MP.idCamaronera

		----TABLA: LOTE
		/* UPDATE pl  SET 
			pl.codigo = mp.codigosectorNew
		 FROM  parLote pl inner join #zonficacionActualizarCodigo MP on  pl.idsector = mp.idsector*/

		----TABLA: MAPPERMALLAS
		  UPDATE pmm set
			pmm.zona        = mp.codigozonaNew,
			pmm.camaronera  = mp.codigocamaroneraNew,
			pmm.sector      = mp.codigoSectorNew
		 FROM  proMapperMallas pmm inner join #zonficacionActualizarCodigo MP on pmm.sectorKey = mp.nombreSectorOld
 
		----TABLA: PARAMETROCONTROLDETALLE
		UPDATE PCD SET 
			 PCD.zona        = mp.codigozonaNew,
			 PCD.camaronera  = mp.codigocamaroneraNew,
			 PCD.sector      = mp.codigosectorNew   
		 FROM  
			 #zonficacionActualizarCodigo MP INNER JOIN maeParametroControlDetalle PCD
		 ON     PCD.ZONA       = MP.codigozonaOld
		  AND   PCD.camaronera = MP.codigocamaroneraOld
		  AND   PCD.sector     = MP.codigosectorOld  

		----TABLA: CONTROLPARAMETRO
		UPDATE PCP SET 
			 PCP.zona       = mp.codigozonaNew,
			 PCP.camaronera = mp.codigocamaroneraNew,
			 PCP.sector     = mp.codigosectorNew   
		 FROM  
			 #zonficacionActualizarCodigo MP INNER JOIN proControlParametro PCP
		 ON     PCP.zona       = MP.codigozonaOld
		  AND   PCP.camaronera = MP.codigocamaroneraOld
		  AND   PCP.sector     = MP.codigosectorOld 

		----TABLA: MUESTREOPESO
		UPDATE PMP SET 
			 PMP.zona       = mp.codigozonaNew,
			 PMP.camaronera = mp.codigocamaroneraNew,
			 PMP.sector     = mp.codigosectorNew   
		 FROM		
			#zonficacionActualizarCodigo MP INNER JOIN proMuestreoPeso PMP
		 ON     PMP.ZONA       = MP.codigozonaOld
		  AND   PMP.camaronera = MP.codigocamaroneraOld
		  AND   PMP.sector     = MP.codigosectorOld 
 
		----TABLA: MUESTREOPOBLACION
		UPDATE PMPB SET  
			 PMPB.zona		 = mp.codigozonaNew,
			 PMPB.camaronera = mp.codigocamaroneraNew,
			 PMPB.sector     = mp.codigosectorNew   
		 FROM
				#zonficacionActualizarCodigo MP INNER JOIN proMuestreoPoblacion PMPB
		 ON     PMPB.ZONA       = MP.codigozonaOld
		  AND   PMPB.camaronera = MP.codigocamaroneraOld
		  AND   PMPB.sector     = MP.codigosectorOld 

		----TABLA: RECEPCIONESPECIE
		UPDATE R SET  
			 R.zona = mp.codigozonaNew,
			 R.camaronera = mp.codigocamaroneraNew,
			 R.sector = mp.codigosectorNew  
		FROM		
			#zonficacionActualizarCodigo MP INNER JOIN proRecepcionEspecie R
		 ON     R.ZONA       = MP.CODIGOZONAOLD
		  AND   R.camaronera = MP.CODIGOCAMARONERAOLD
		  AND   R.sector     = MP.CODIGOSECTOROLD 
		    
			   update za
   set za.idCamaronera = 1
   from  parSector za   
   WHERE za.idSector IN (2,3,4,5,7,8)

  	 update za
   set za.idCamaronera = 2
   from  parSector za    
   WHERE za.idSector IN (9,6,10,1) 
commit tran
   
 


 