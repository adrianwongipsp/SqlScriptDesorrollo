
CREATE or alter PROCEDURE USP_CONSULTARCOMPRASPORSEMANA(@FechaInicio DATETIME,@FechaFin	 DATETIME)
AS BEGIN
	SELECT 
		 ca.cod_compra,			ca.cod_proveedor,			ca.Comprador,			ca.Autorizado,			ca.Solicitado,
		 ca.fecha_emision,		ca.fecha_anulacion,			ca.fecha_cierre,		ca.estado,				ca.observacion
		,REPLACE(CAST(ROUND(ca.subtotal,6,1) AS CHAR),'.',',')  as subtotal
		,REPLACE(CAST(ROUND(ca.iva,6,1) AS CHAR),'.',',')		as iva
		, ca.f_creacion,		ca.f_modificacion,			ca.f_eliminacion,		ca.u_creacion,			ca.u_modificacion
		,ca.u_eliminacion,		ca.cod_bodega,				ca.son_en_letras,		ca.mail_enviado,		ca.u_anulacion, 
		ca.Motivo_Anula,		ca.COD_EMPRESA,				ca.ANULADO,				ca.COD_COTIZACION,		ca.COD_USR_ELABORA,  
		ca.COD_USR_AUTORIZA,	ca.TIPO_OC,					ca.COD_EQUIPO,			ca.NOM_EQUIPO,			ca.COD_AREA, 
		ca.NOM_AREA,			ca.COD_GRUPO,				ca.NOM_GRUPO,			ca.COD_SUBGRUPO,		ca.NOM_SUBGRUPO,
		ca.NOM_MARCA,			ca.NOM_MODELO,				ca.NUM_ACTIVO_FIJO,		ca.SERIE,				ca.USA_MEDIDOR,
		ca.VAL_MEDIDOR_ACTUAL,	ca.VAL_MEDIDOR_ACUMULADO,	ca.NOM_TIPO_EQUIPO,		ca.NOM_PROVEEDOR,		de.cod_pedido, 
		de.cod_requisicion,		de.item,					de.cod_repuesto,		de.cod_inventario,		de.cantidad,
		REPLACE(CAST(ROUND(de.precio,6,1) AS CHAR),'.',',')	as precio,
		REPLACE(CAST(ROUND(de.descuento,6,1) AS CHAR),'.',',') as descuento,
		de.cant_compra,			de.prec_compra,				de.desc_compra,			de.estado,				de.f_creacion,
		de.f_modificacion,		de.f_eliminacion,			de.u_creacion,			de.u_modificacion,		de.u_eliminacion, 
		de.cod_bodega,			de.tipo_pedido,				de.cod_unidad,			de.u_anulacion,			de.Motivo_Anula, 
		de.fecha_anulacion,		de.cod_actividad,			de.cant_anulada,		de.usa_iva,
		REPLACE(CAST(ROUND(de.DSCTO_VALOR,6,1) AS CHAR),'.',',') as DSCTO_VALOR,
		REPLACE(CAST(ROUND(de.IVA_VALOR,6,1) AS CHAR),'.',',') as IVA_VALOR,
		de.COD_BODEGA_SOTC,		de.IVA_PORCENTAJE,			de.COD_EMPRESA,			de.CANT_FACTURADA,		de.NOM_BODEGA, 
		de.BOD_DESCRIPCION,		de.NOM_REPUESTO,			de.NUM_PARTE,			de.UNIDAD,				de.CANT_TRANSITO, 
		de.COD_COTIZACION,		de.COD_REPUESTO_SOC,		de.STOCK_ANTERIOR_OC,	de.COD_MARCA,			de.NOM_MARCA, 
		de.CENTRO_COSTO_BODEGA,	cf.NUM_FACTURA,				p.ruc,					p.NOM_PROVEEDOR,		cf.NUM_NOTA_RECEPCION,
		cf.ELABORADO_POR,		
		REPLACE(CAST(ROUND(cf.SUBTOTAL,6,1) AS CHAR),'.',',') as SUBTOTAL,
		REPLACE(CAST(ROUND(cf.IVA_VALOR,6,1) AS CHAR),'.',',') as IVA_VALOR,		
		REPLACE(CAST(ROUND(cf.TOTAL,6,1) AS CHAR),'.',',') as TOTAL,
		COD_OT = CASE 
					WHEN ca.TIPO_OC = 'S' THEN (SELECT x.COD_OT FROM SMPROG.dbo.TSM_REQ_SERVICIO_CAB x (NOLOCK) 
												WHERE x.COD_REQUISICION=de.cod_requisicion ) 
					ELSE 0 END
	FROM		SMPROG.dbo.BOD_ORDEN_COMPRA		ca 
	INNER JOIN	SMPROG.dbo.BOD_DETALLE_COMPRA	de	ON ca.cod_compra = de.cod_compra
	LEFT JOIN	SMPROG.dbo.BOD_CAB_FACT_INGRESO cf	ON cf.COD_COMPRA = de.cod_compra 
	LEFT JOIN	SMPROG.dbo.TSM_PROVEEDOR		p	ON cf.COD_PROVEEDOR = p.COD_PROVEEDOR
	WHERE CONVERT(DATE, ca.f_creacion) between @FechaInicio and @FechaFin  
	ORDER BY ca.f_creacion

END
go


Insert into genParametros values ('CORREOSMPRGOREPORT', 'Lista de correo para envio de reporte SMPROG',null,'erick.valverde@ipsp-produccion.com;lenin.barrera@ipsp-produccion.com;jordan.avellan@ipsp-produccion.com,',null,null,1,GETDATE(),'erick.valverde',null,null,4);
go

CREATE FUNCTION dbo.SplitString
(
    @string NVARCHAR(MAX),
    @delimiter CHAR(1)
)
RETURNS @output TABLE(value NVARCHAR(MAX))
BEGIN
    DECLARE @start INT, @end INT
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string)
    WHILE @start < LEN(@string) + 1 BEGIN
        IF @end = 0  
            SET @end = LEN(@string) + 1
        INSERT INTO @output (value) 
        VALUES(SUBSTRING(@string, @start, @end - @start))
        SET @start = @end + 1
        SET @end = CHARINDEX(@delimiter, @string, @start)
    END
    RETURN
END
go

CREATE PROCEDURE USP_CONSULTAR_PARAMETROS_POR_CODIGO
    @CodigosParametros VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdParametro, Descripcion, ValorInt, ValorVarchar, ValorDecimal, ValorDatetime, Activo, FechaRegistro, UsuarioRegistro, FechaModificacion, UsuarioModificacion, IdModulo
    FROM genParametros 
    WHERE IdParametro IN (SELECT value FROM STRING_SPLIT(@CodigosParametros, ','));
END