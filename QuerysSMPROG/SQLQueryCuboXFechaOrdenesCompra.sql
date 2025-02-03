use SMPROG
go

DECLARE @FechaInicio DATETIME = '2024-05-01' ;
DECLARE @FechaFin	 DATETIME = '2024-05-30' ;

--EXEC USP_CONSULTARCOMPRASPORSEMANA @FechaInicio, @FechaFin

select 
	 ca.cod_compra, ca.cod_proveedor, ca.Comprador, ca.Autorizado, ca.Solicitado, ca.observacion,
	 ca.fecha_emision, ca.fecha_anulacion, ca.fecha_cierre
	, ca.estado, ca.f_creacion, ca.f_modificacion, ca.f_eliminacion, ca.u_creacion, ca.u_modificacion
	,ca.u_eliminacion,ca.cod_bodega, ca.son_en_letras, ca.mail_enviado, ca.u_anulacion, ca.Motivo_Anula
	,ca.COD_EMPRESA, ca.ANULADO, ca.COD_COTIZACION, ca.COD_USR_ELABORA,  ca.COD_USR_AUTORIZA, ca.TIPO_OC
	,ca.COD_EQUIPO, ca.NOM_EQUIPO, ca.COD_AREA, ca.NOM_AREA, ca.COD_GRUPO, ca.NOM_GRUPO,ca.COD_SUBGRUPO 
	,ca.NOM_SUBGRUPO,ca.NOM_MARCA, ca.NOM_MODELO, ca.NUM_ACTIVO_FIJO,ca.SERIE, ca.USA_MEDIDOR 
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
	,de.u_anulacion,de.Motivo_Anula, de.fecha_anulacion, de.cod_actividad, de.cant_anulada, de.usa_iva
	,REPLACE(CAST(ROUND(de.DSCTO_VALOR,6,1) AS CHAR),'.',',') as DSCTO_VALOR
	,REPLACE(CAST(ROUND(de.IVA_VALOR,6,1) AS CHAR),'.',',') as IVA_VALOR
	,de.COD_BODEGA_SOTC, de.IVA_PORCENTAJE, de.COD_EMPRESA, de.CANT_FACTURADA, de.NOM_BODEGA, de.BOD_DESCRIPCION
	,de.NOM_REPUESTO, de.NUM_PARTE, de.UNIDAD, de.CANT_TRANSITO, de.COD_COTIZACION,de.COD_REPUESTO_SOC, de.STOCK_ANTERIOR_OC
	,de.COD_MARCA, de.NOM_MARCA, de.CENTRO_COSTO_BODEGA 
	,cf.NUM_FACTURA
	,p.ruc
	,p.NOM_PROVEEDOR
	,cf.NUM_NOTA_RECEPCION
	,cf.ELABORADO_POR
	,COD_OT= case when ca.TIPO_OC='S' THEN (Select x.COD_OT
	      from  TSM_REQ_SERVICIO_CAB x (nolock) 
	      where x.COD_REQUISICION=de.cod_requisicion ) else 0 end,
	de.cantidad 
from BOD_ORDEN_COMPRA ca 
INNER JOIN BOD_DETALLE_COMPRA de on ca.cod_compra = de.cod_compra
LEFT JOIN BOD_CAB_FACT_INGRESO cf on cf.COD_COMPRA = de.cod_compra 
LEFT JOIN TSM_PROVEEDOR p ON cf.COD_PROVEEDOR = p.COD_PROVEEDOR
WHERE CONVERT(DATE, ca.f_creacion) between @FechaInicio and @FechaFin and ca.COD_COMPRA = '0010379'
order by ca.f_creacion

--select  * from BOD_CAB_FACT_INGRESO where COD_COMPRA = '0010379'


--select precio, descuento, precio - (precio*descuento)/100 DescuentoValor, (precio - (precio*descuento)/100) * cantidad,
--* from BOD_DETALLE_COMPRA where COD_COMPRA = '0010379'

--select 606.536198 + 808.714931

--and ca.cod_compra = '0004803'--'0006599'

--select * from TSM_REQUISICION_CAB
--where COD_REQUISICION=97026

--select * from TSM_REQUISICION_DET
--where  COD_REPUESTO in (2022,2030,2036,4601)

--select * from[dbo].[TSM_REQ_SERVICIO_CAB] 
--where COD_REQUISICION=97026

--select * from [dbo].[TSM_REQ_SERVICIO_DET]
--where COD_REQUISICION=97026

--select top 10 * from BOD_DET_ORDEN_PEDIDO
--where COD_REQUISICION=97026

--select * from [dbo].[BOD_DETALLE_COMPRA]
--where cod_compra='0004803'

--select * from [dbo].[TSM_OT_DET_REP]
--where COD_REQUISICION=97026

--select * from BOD_ORDEN_COMPRA
--where cod_compra = '0004803'
--select  * from TSM_COTIZACION_MOV_APROBACION_DET
--where COD_COTIZACION=17219  
--order by COD_MOV_APROBACION_DET desc 
--select SUBSTRING('C-0002601',3,LEN('C-0002601'))

--select * from TSM_REQ_SERVICIO_CAB x
--where CAST(x.COD_REQUISICION as varchar)='0002601'


--select * from BOD_ORDEN_COMPRA
--where cod_compra = '0006390'
--select * from BOD_DETALLE_COMPRA
--where cod_compra = '0006390'
--select  * from TSM_COTIZACION_MOV_APROBACION_DET
--where COD_COTIZACION=20775  
--select  * from TSM_REQ_SERVICIO_CAB
--where COD_REQUISICION=2729

--select  * from  [dbo].[TSM_OT_DET]
--where COD_OT=61230