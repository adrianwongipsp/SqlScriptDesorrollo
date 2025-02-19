
USE IPSPCamaroneraPre
GO

begin tran
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
		 FROM  proMapperMallas pmm inner join parMegaUbicaciones MP on pmm.sectorKey = mp.SECTOR
 
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
			 R.zona       = mp.COD_ZONA,
			 R.camaronera = mp.COD_CAMARONERA,
			 R.sector     = mp.COD_SECTOR  
		FROM		
			parMegaUbicaciones MP 
			INNER JOIN parGrupoWhatsappDetalle R
		    ON    R.ZONA       = MP.COD_ZONA_OLD
		    AND   R.camaronera = MP.COD_CAMARONERA_OLD
		    AND   R.sector     = MP.COD_SECTOR_OLD 

		  		 
----TABLA: HORARIO
		IF NOT OBJECT_ID('tempdb..#tem_Horarios') IS NULL  DROP TABLE #tem_Horarios;
		
		 
        SELECT DISTINCT
			Z.nombre AS NombreZonaOld,
			R.idZona AS id_Zona_Horario,
			Z.idZona AS id_Zona_Old,
			MP.ID_ZONA,
			MP.COD_ZONA,
			MP.COD_ZONA_OLD,
			MP.ZONA,
			tipo, 
			horaInicio,
			horaFin,
			valorDiasPrevio,
			valorDiasSemana,
			valorMes,
			valorDiaMes,
			horaFinDia
		 	into #tem_Horarios
		FROM		
			parMegaUbicaciones MP 
			INNER JOIN parZona Z 
		ON MP.COD_ZONA_OLD=Z.codigo
			INNER JOIN parHorario R
		ON  Z.idZona=R.idZona
	    WHERE MP.COD_ZONA <>  Z.codigo
		 

		DECLARE @ids INT 
		DECLARE @idMaxs INT 
		SET @ids = 0
		IF EXISTS(SELECT  TOP 1 1 FROM parSecuencial WITH(NOLOCK) WHERE tabla='Horario')
		BEGIN
		SELECT TOP 1 @ids = ultimaSecuencia
			FROM parSecuencial WITH(NOLOCK) WHERE tabla='Horario'
		END 

		  INSERT INTO parHorario(idHorario, codigo, nombre, idZona, tipo, horaInicio, horaFin, valorDiasPrevio, valorDiasSemana, valorMes, valorDiaMes, horaFinDia, activo, fechaHoraCreacion, usuarioCreacion, estacionCreacion, fechaHoraModificacion, usuarioModificacion, estacionModificacion)
		  SELECT DISTINCT
		   @ids + ROW_NUMBER() OVER (ORDER BY Zona)
		  ,FORMAT(@ids + ROW_NUMBER() OVER (ORDER BY Zona), '000')
		  ,ZONA
		  ,ID_ZONA
		  ,tipo 
		  ,horaInicio
		  ,horaFin
		  ,valorDiasPrevio
		  ,valorDiasSemana
		  ,valorMes
		  ,valorDiaMes
		  ,horaFinDia
		  ,1
		  ,GETDATE()
		  ,'adminPsCam'
		  ,''
		  ,GETDATE()
		  ,'adminPsCam'
		  ,''
		  FROM #tem_Horarios
		  WHERE NOT EXISTS (SELECT * FROM parHorario x WITH(NOLOCK) WHERE x.idZona= id_Zona AND activo=1)
		  GROUP BY Zona, ID_ZONA, tipo 
		  ,horaInicio
		  ,horaFin
		  ,valorDiasPrevio
		  ,valorDiasSemana
		  ,valorMes
		  ,valorDiaMes
		  ,horaFinDia

		  SELECT @idMaxs = MAX(idHorario) FROM parHorario WITH(NOLOCK)
		  IF(@ids =0)
		  BEGIN
		    INSERT INTO parSecuencial VALUES ('Horario',  @idMaxs)  
		  END 
		  ELSE
		  BEGIN
			 UPDATE parSecuencial SET ultimaSecuencia = @idMaxs WHERE tabla ='Horario'
		  END

		  
		  UPDATE x 
		  SET x.activo= 0,
		      x.fechaHoraModificacion=GETDATE(),
			  x.usuarioModificacion='adminPsCam'
		  FROM  parHorario x WITH(NOLOCK)
		  INNER JOIN #tem_Horarios tam ON x.idZona = tam.id_Zona_Horario
		  WHERE x.activo = 1;
		   

		  ----TABLA: maeTablaEquivalenciaLongitudPeso---
		  UPDATE x 
		  SET x.zona= tam.COD_ZONA,
		      x.fechaHoraModificacion=GETDATE(),
			  x.usuarioModificacion='adminPsCam'
		  FROM  maeTablaEquivalenciaLongitudPeso x WITH(NOLOCK)
		  INNER JOIN #tem_Horarios tam ON x.zona = tam.COD_ZONA_OLD

		DECLARE @ids1 INT 
		DECLARE @idMaxs1 INT 
		SET @ids1 = 0
		IF EXISTS(SELECT  TOP 1 1 FROM maeSecuencial WITH(NOLOCK) WHERE tabla='TablaEquivalenciaLongitudPeso')
		BEGIN
		SELECT TOP 1 @ids1 = ultimaSecuencia
			FROM maeSecuencial WITH(NOLOCK) WHERE tabla='TablaEquivalenciaLongitudPeso'
		END 

	    INSERT INTO maeTablaEquivalenciaLongitudPeso
		 SELECT 
		 @ids1 + ROW_NUMBER() OVER (ORDER BY z.codigo) idTablaEquivalenciaLongitudPeso,  
		'01' as empresa	, '01' as division, z.codigo as zona, 
		 45.000000 as longitudInicio, 300.000000 as longitudFinal, 1 as idFormula, 'MMETRO' as	medidaLongitud, 0 as	bloqueado ,
		'adminPsCam'   ,'', GETDATE(),
		'adminPsCam'   ,'', GETDATE()
		FROM parZona z left join maeTablaEquivalenciaLongitudPeso l on l.zona = z.codigo
		WHERE l.zona is null and z.activo  = 1

          SELECT @idMaxs1 = MAX(idHorario) FROM parHorario WITH(NOLOCK)
		  IF(@ids1 =0)
		  BEGIN
		    INSERT INTO maeSecuencial  VALUES ('TablaEquivalenciaLongitudPeso',  @idMaxs1)  
		  END 
		  ELSE
		  BEGIN
			 UPDATE maeSecuencial  SET ultimaSecuencia = @idMaxs1 WHERE tabla ='TablaEquivalenciaLongitudPeso'
		  END


		 DROP TABLE parMegaUbicaciones
		 DROP TABLE #tem_Horarios 

		 select  codigoZona, nombreZona, codigoCamaronera	, nombreCamaronera,	codigoSector	,nombreSector, count(idPiscina) as cantidadPiscina
		from PiscinaUbicacion 
		group by  codigoZona, nombreZona, codigoCamaronera	, nombreCamaronera,	codigoSector	,nombreSector
		order by nombreSector

		 select  codigoZona, nombreZona, codigoCamaronera	, nombreCamaronera,	codigoSector	,nombreSector,  nombrePiscina, idPiscina, KeyPiscina
		from PiscinaUbicacion 
		WHERE nombreSector='RUANDA'
		 COMMIT tran