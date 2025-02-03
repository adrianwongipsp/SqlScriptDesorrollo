use IPSPAdministracion
go

--DECLARE @FechaInicio DATETIME = '2024-05-01' ;
--DECLARE @FechaFin	 DATETIME = '2024-05-30' ;

--EXEC USP_CONSULTARCOMPRASPORSEMANA @FechaInicio, @FechaFin

go 

CREATE or alter PROCEDURE USP_CONSULTARCOMPRASPORSEMANA (@FechaInicio DATETIME,@FechaFin	 DATETIME)
AS BEGIN

SELECT 
	 ca.cod_compra, ca.cod_proveedor, ca.Comprador, ca.Autorizado, ca.Solicitado, ca.observacion,
	 ca.fecha_emision, ca.fecha_anulacion, ca.fecha_cierre
	, ca.estado, ca.f_creacion, ca.f_modificacion, ca.f_eliminacion, ca.u_creacion, ca.u_modificacion
	,ca.u_eliminacion,ca.cod_bodega, ca.son_en_letras, ca.mail_enviado, ca.u_anulacion, ca.Motivo_Anula
	,ca.COD_EMPRESA, ca.ANULADO, ca.COD_COTIZACION, ca.COD_USR_ELABORA,  ca.COD_USR_AUTORIZA, ca.TIPO_OC
	,ca.COD_EQUIPO, ca.NOM_EQUIPO, ca.COD_AREA, ca.NOM_AREA, ca.COD_GRUPO, ca.NOM_GRUPO,ca.COD_SUBGRUPO 
	,ca.NOM_SUBGRUPO,ca.NOM_MARCA, ca.NOM_MODELO, ca.NUM_ACTIVO_FIJO,ca.SERIE, 
	(CASE WHEN ca.USA_MEDIDOR is null then 'NO' when ca.USA_MEDIDOR='N' then 'NO' when ca.USA_MEDIDOR='S' then 'SI' end) USA_MEDIDOR
	,ca.VAL_MEDIDOR_ACTUAL, ca.VAL_MEDIDOR_ACUMULADO, ca.NOM_TIPO_EQUIPO, ca.NOM_PROVEEDOR
	, de.cod_pedido, de.cod_requisicion, de.item, de.cod_repuesto, de.cod_inventario, de.cantidad
	,REPLACE(CAST(ROUND(de.precio,6,1) AS CHAR),'.',',') as precio
	,REPLACE(CAST(ROUND(de.descuento,6,1) AS CHAR),'.',',') as descuento
	,(de.precio - (de.precio*de.descuento)/100) * de.cantidad subtotalDetalle
	,REPLACE(CAST(ROUND(ca.subtotal,6,1) AS CHAR),'.',',') as subtotalCabecera
	--,REPLACE(CAST(ROUND(ca.iva,6,1) AS CHAR),'.',',') as iva
	,REPLACE(CAST(ROUND(cf.IVA_VALOR,6,1) AS CHAR),'.',',') as IVA_VALOR
	,REPLACE(CAST(ROUND(cf.TOTAL,6,1) AS CHAR),'.',',') as TOTALCABECERA
	,de.cant_compra, de.prec_compra, de.desc_compra, de.estado
	,de.f_creacion
	,de.f_modificacion
	,de.f_eliminacion
	,de.u_creacion,de.u_modificacion, de.u_eliminacion, de.cod_bodega, de.tipo_pedido, de.cod_unidad
	,de.u_anulacion,de.Motivo_Anula, de.fecha_anulacion, de.cod_actividad, de.cant_anulada,
	(CASE WHEN usa_iva is null then 'NO' when usa_iva='N' then 'NO' when usa_iva='S' then 'SI' end) usa_iva
	,REPLACE(CAST(ROUND(de.DSCTO_VALOR,6,1) AS CHAR),'.',',') as DSCTO_VALOR
	,REPLACE(CAST(ROUND(de.IVA_VALOR,6,1) AS CHAR),'.',',') as IVA_VALOR_DET
	,de.COD_BODEGA_SOTC, de.IVA_PORCENTAJE, de.COD_EMPRESA, de.CANT_FACTURADA, de.NOM_BODEGA, de.BOD_DESCRIPCION
	,de.NOM_REPUESTO, de.NUM_PARTE, de.UNIDAD, de.CANT_TRANSITO, de.COD_COTIZACION,de.COD_REPUESTO_SOC, de.STOCK_ANTERIOR_OC
	,de.COD_MARCA, de.NOM_MARCA, de.CENTRO_COSTO_BODEGA 
	,cf.NUM_FACTURA
	,p.ruc
	,p.NOM_PROVEEDOR
	,cf.NUM_NOTA_RECEPCION
	,cf.ELABORADO_POR
	,COD_OT= case when ca.TIPO_OC='S' THEN (Select x.COD_OT
	      from  SMPROG.dbo.TSM_REQ_SERVICIO_CAB x (nolock) 
	      where x.COD_REQUISICION=de.cod_requisicion ) else 0 end,
	de.cantidad 
	FROM		SMPROG.dbo.BOD_ORDEN_COMPRA		ca 
	INNER JOIN	SMPROG.dbo.BOD_DETALLE_COMPRA	de	ON ca.cod_compra = de.cod_compra
	LEFT JOIN	SMPROG.dbo.BOD_CAB_FACT_INGRESO cf	ON cf.COD_COMPRA = de.cod_compra 
	LEFT JOIN	SMPROG.dbo.TSM_PROVEEDOR		p	ON cf.COD_PROVEEDOR = p.COD_PROVEEDOR
WHERE CONVERT(DATE, ca.f_creacion) between @FechaInicio and @FechaFin --and ca.COD_COMPRA = '0010379'
order by ca.f_creacion

END