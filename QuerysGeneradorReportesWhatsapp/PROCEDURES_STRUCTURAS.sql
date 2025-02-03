GO
 --EXEC  ReporteGenerator_ObtenerDatosIniciales 'reporteParametrosAmbientalesDiaHora' ,20240405
  CREATE or ALTER PROCEDURE  ReporteGenerator_ObtenerDatosIniciales
 	   @tipoTransaccion varchar(50),
	   @idImpresion     int
 AS
 BEGIN 
	 --declare @tipoTransaccion varchar(15)
	 --declare @idImpresion     int 
	 --set @tipoTransaccion = 'controlParametro'
	 --set @idImpresion = 2290

	 declare     @idActual     int 
	 select top 1 @idActual = ultimaSecuencia from proSecuencial where tabla = @tipoTransaccion
	  
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
			select empresa,	    division,			zona,	camaronera, sector, fechaControl, 
				   horaControl, idControlParametro
				into #tmp_r_proControlParametro
			from proControlParametro where fechaControl = @fechaActual and estado = 'APR' ;

			select   e.codigo, 
			         e.descripcion 
					 into #horas
				from parCatalogo c inner join parElementoCatalogo e on c.idCatalogo = e.idCatalogo
				where c.codigo ='maeHorasControl';

			WITH tmpw_r_proControlParametro AS (
				SELECT empresa, division, zona, camaronera, sector, fechaControl, horaControl, idControlParametro,
					   ROW_NUMBER() OVER (PARTITION BY empresa, division, zona, camaronera, sector, fechaControl ORDER BY horaControl DESC) AS rn
				FROM #tmp_r_proControlParametro
			)
			SELECT @tipoTransaccion tipoTransaccion, empresa, division, zona, camaronera, sector, h.descripcion as horaControl, @idActual as id,  '' as adicional --idControlParametro as id
			FROM tmpw_r_proControlParametro cp inner join #horas h on h.codigo = cp.horaControl 
			WHERE rn = 1
			ORDER BY empresa, division,zona,camaronera, sector;
	   end 
	 end
 END 
 GO
 --exec  ReporteGenerator_ObtenerVistas  'muestreoPoblacion'
  CREATE or ALTER PROCEDURE ReporteGenerator_ObtenerVistas
	 @tipoTransaccion varchar(50)
 AS
 BEGIN
	 IF(@tipoTransaccion = 'histograma')
	 BEGIN
	   SELECT '/Procesos/histograma/reportPDF?empresa=@empresa&numeroHistograma=@id&usuario=@usuario&reportCommand=@reportCommand' as ViewWebUrl
	 END 
	 IF(@tipoTransaccion = 'histogramaLongitud')
	 BEGIN
	   SELECT '/Procesos/histogramaLongitud/reportPDF?empresa=@empresa&numeroHistograma=@id&usuario=@usuario&reportCommand=@reportCommand' as ViewWebUrl
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
 CREATE or ALTER PROCEDURE UbicacionGenerator_ObtenerDatosConsulta
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
  
  CREATE or ALTER PROCEDURE SecuencialGenerator_ObtenerIdActual
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
   CREATE or ALTER PROCEDURE CatalogoTipoTransaccionGenerator_ObtenerCatalogoDisponible
 AS
 BEGIN
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
			 --	 UNION  

				--SELECT  TESM.esquema, TESM.tipoTransaccion,  TESM.formatoGeneracion,   TESM.tiempoEspera, TLEM.tiempoEliminacion 
				--FROM (
				--	SELECT TOP 1 'pro' AS esquema, 'muestreoPoblacion' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEspera
				--	FROM parParametro
				--	WHERE codigo = 'TESMMPOB'
				--) AS TESM
				--JOIN (
				--	SELECT TOP 1 'pro' AS esquema, 'muestreoPoblacion' AS tipoTransaccion, 'png' AS formatoGeneracion, valorEntero AS tiempoEliminacion
				--	FROM parParametro
				--	WHERE codigo = 'TLEMMPOB'
				--) AS TLEM
				--ON TESM.esquema = TLEM.esquema
				--AND TESM.tipoTransaccion = TLEM.tipoTransaccion
				--AND TESM.formatoGeneracion = TLEM.formatoGeneracion
				 
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
   CREATE or ALTER PROCEDURE CatalogoTipoTransaccionGenerator_ObtenerCatalogoAEliminar
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

 