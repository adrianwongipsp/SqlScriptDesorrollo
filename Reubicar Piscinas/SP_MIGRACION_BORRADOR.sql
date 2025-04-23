select * from PiscinaUbicacion where KeyPiscina='TAURAI92'
select * from PiscinaUbicacion where KeyPiscina='HOLANDA92'  
 
select * from PiscinaUbicacion where KeyPiscina='TAURAIIPC28'
select * from PiscinaUbicacion where KeyPiscina='TAURAIVPC28'  

SELECT TOP 3 * from migracion_piscina
--INSERT INTO migracion_piscina_tipo 
insert into 	  tempMigracionPiscina 
select  ROW_NUMBER() over(order by idPiscina) +7 idTempMigracionPiscina ,
	   nombreZona       ZONA_OLD,       idZona        IDZONA_OLD,       codigoZona as CODIGOZONA_OLD,
       nombreCamaronera CAMARONERA_OLD, idCamaronera  IDCAMARONERA_OLD, codigoCamaronera AS CODIGOCAMARONERA_OLD,
	   nombreSector		SECTOR_OLD,     idSector      IDSECTOR_OLD,     codigoSector     as CODIGOSECTOR_OLD,
	   codigoPiscina    CODIGOPISCINA, 	idPiscina     IDPISCINA,	    NOMBREPISCINA, 	 KEYPISCINA,  
	   'TAURAB'         ZONA_NEW,       29            IDZONA_NEW,       '29'             AS CODIGOZONA_NEW,
       'TAURAB'         CAMARONERA_NEW, 2             IDCAMARONERA_NEW, '00002'          AS CODIGOCAMARONERA_NEW,
	   'TAURAV'		SECTOR_NEW,     9             IDSECTOR_NEW,     '00009'          AS CODIGOSECTOR_NEW, 9 IDLOTE_NEW,
	    NULL	        CICLO,
		1 ACTIVO	,
		'Piscina' TIPO ,
		0  as PROCESADO ,
		'adminPsCam' USUARIO_PROCESO,
		GETDATE() FECHA_PROCESO
	  
from PiscinaUbicacion  where KeyPiscina in ('TAURAIIPC44')
 
 select * from #tem_migracion

 begin tran 

  ------------------------------------------INVENTARIO------------------------------------------------------------- 

		  
		  DECLARE @IdCabecera INT; 
		  DECLARE @IdDetalle  INT; 
		  DECLARE @IdPiscina  INT; 
		  DECLARE @ContarDetalle INT;  

		  SELECT  ap.idAplicacionItem, ap.idAplicacionItemDetalle, ap.idPiscina , 0 procesado
				into #idsAplicacionItem FROM invAplicacionItemDetalle ap inner join tempMigracionPiscina mp on ap.idPiscina = mp.IDPISCINA  
				where ap.activo= GETDATE() 

		  while exists(select top 1 1 from #idsAplicacionItem where procesado = 0)
		  begin
				SELECT TOP 1 @IdCabecera =  idAplicacionItem, 
							 @IdDetalle   = idAplicacionItemDetalle,
							 @IdPiscina   = idPiscina 
					    FROM #idsAplicacionItem  WHERE procesado = 0 

			    SELECT @ContarDetalle    =   COUNT(distinct idPiscina) FROM  invAplicacionItemDetalle ap WHERE idAplicacionItem = @IdCabecera --and activo = 1 

				IF(@ContarDetalle = 1)--si la transaccion es un solo detalle con una sola piscina distinta , basta con actualizar la cabecera
				  begin
				   UPDATE A SET    
					  A.codigoZONA       = mp.CODIGOZONA_NEW,
					  A.codigocamaronera = mp.CODIGOCAMARONERA_NEW,
					  A.codigosector     = mp.CODIGOSECTOR_NEW  
					 FROM 
							tempMigracionPiscina MP INNER JOIN invAplicacionItem A
					   ON   A.codigoZONA       = MP.CODIGOZONA_OLD
					  AND   A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
					  AND   A.codigosector     = MP.CODIGOSECTOR_OLD
				  end
				   IF(@ContarDetalle > 1)--si la transaccion es mas detalle , crear la cabecera con los nuevos campos , crear el detalle con el item a migrar y en el antiguo detalle los desactivamos
				   begin
						 --separamaos los secuenciles para la creacion
					    declare @ultimaSecuenciaCabecera int
						declare @ultimaSecuenciaDetalle int
						declare @ultimaSecuenciaNueva int
						update parSecuencial set ultimaSecuencia = ultimaSecuencia + 1 WHERE tabla = 'aplicacionItem'
						select top 1 @ultimaSecuenciaCabecera = ultimaSecuencia  from parSecuencial WHERE tabla = 'aplicacionItem'  

						DECLARE @IdsNecesarios INT = (SELECT COUNT(*) FROM invAplicacionItemDetalle WHERE idAplicacionItem = @IdCabecera AND idPiscina = @IdPiscina)

						UPDATE parSecuencial 
						SET @ultimaSecuenciaDetalle = ultimaSecuencia,
							ultimaSecuencia = ultimaSecuencia + @IdsNecesarios  -- Valor arbitrario pero seguro
						WHERE tabla = 'aplicacionItemDetalle'

						--crear la cabecera con los nuevos campos 
						INSERT INTO invAplicacionItem ( idAplicacionItem
														,codigo
														,codigoEmpresa
														,codigoDivision
														,codigoZona
														,codigoCamaronera
														,codigoSector
														,fechaConsumo
														,linea
														,usuarioResponsable
														,estado
														,activo
														,usuarioCreacion
														,estacionCreacion
														,fechaHoraCreacion
														,usuarioModificacion
														,estacionModificacion
														,fechaHoraModificacion
														,responsable)
					    select                          @ultimaSecuenciaCabecera idAplicacionItem
														,codigo
														,codigoEmpresa
														,codigoDivision
														,CODIGOZONA_NEW codigoZona
														,CODIGOCAMARONERA_NEW codigoCamaronera
														,CODIGOSECTOR_NEW codigoSector
														,fechaConsumo
														,linea
														,usuarioResponsable
														,estado
														,a.activo
														,usuarioCreacion
														,estacionCreacion
														,fechaHoraCreacion
														,usuarioModificacion
														,estacionModificacion
														,fechaHoraModificacion
														,responsable 
						from 		tempMigracionPiscina MP INNER JOIN invAplicacionItem A
								   ON   A.codigoZONA       = MP.CODIGOZONA_OLD
								  AND   A.codigocamaronera = MP.CODIGOCAMARONERA_OLD
								  AND   A.codigosector     = MP.CODIGOSECTOR_OLD
								 where A.idAplicacionItem = @IdCabecera

					  --crear los detalles por piscina con los nuevos campos 
						INSERT INTO invAplicacionItemDetalle(        idAplicacionItemDetalle
																	,idAplicacionItem
																	,idPiscina
																	,idPiscinaEjecucion
																	,idItem
																	,idRecepcionItems
																	,idUsoItem
																	,tipoOrigen
																	,idMovimientoDetalle
																	,cantidadDisponible
																	,cantidadConsumida
																	,cantidadSobrante
																	,idPiscinaDestino
																	,idPiscinaEjecucionDestino
																	,activo
																	,usuarioCreacion
																	,estacionCreacion
																	,fechaHoraCreacion
																	,usuarioModificacion
																	,estacionModificacion
																	,fechaHoraModificacion
																	,idBodegaDestino
																	,numeroLote)

					    select                                       (row_number() over(order by idAplicacionItemDetalle)  + @ultimaSecuenciaDetalle) as idAplicacionItemDetalle
																	,@ultimaSecuenciaCabecera idAplicacionItem
																	,idPiscina
																	,idPiscinaEjecucion
																	,idItem
																	,idRecepcionItems
																	,idUsoItem
																	,tipoOrigen
																	,idMovimientoDetalle
																	,cantidadDisponible
																	,cantidadConsumida
																	,cantidadSobrante
																	,idPiscinaDestino
																	,idPiscinaEjecucionDestino
																	,activo
																	,usuarioCreacion
																	,estacionCreacion
																	,fechaHoraCreacion
																	,usuarioModificacion
																	,estacionModificacion
																	,fechaHoraModificacion
																	,idBodegaDestino
																	,numeroLote
						from 		  invAplicacionItemDetalle where idPiscina = @IdPiscina  

					--actualizo los SECUENCIALES DE DETALLE 
					select @ultimaSecuenciaNueva = max(idAplicacionItemDetalle) from invAplicacionItemDetalle where idAplicacionItem= @ultimaSecuenciaCabecera
					update parSecuencial set ultimaSecuencia = @ultimaSecuenciaNueva  WHERE tabla = 'aplicacionItemDetalle'--ahora si se cuantos ids utilizare 

					--inactivo los detalle antiguo migrado a la nueva transaccion
					update  d	set activo = 0	from  invAplicacionItemDetalle d where idPiscina = @IdPiscina  
				   end


				update #idsAplicacionItem set procesado = 1   where procesado = 0 and idAplicacionItem = @IdCabecera and idAplicacionItemDetalle = @IdDetalle and idPiscina = @IdPiscina
		  end

	
	
 rollback tran