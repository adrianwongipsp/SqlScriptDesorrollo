ALTER PROCEDURE usp_proObtenerTransporte(
    @IdProveedor INT = NULL,
    @todos VARCHAR(1) = NULL
)
AS 
--declare @IdProveedor int=159
--,@todos varchar(1)=null;
BEGIN
    --obtener los archivos por transporte
    WITH TransporteArchivos AS (
        SELECT
            t.IdTransporte,
            ar.IdArchivo,
            ar.NombreArchivo,
            ar.RutaPrivada,
            tpd.Nombre AS TipoDocumento,
            doc.Nombre AS Documento,
            tpd.IdTipoDocumento,
            doc.IdDocumento,
            ROW_NUMBER() OVER(PARTITION BY t.IdTransporte ORDER BY tpd.IdTipoDocumento) AS RowNum
        FROM proTransporte t
        INNER JOIN proTransporteDocumento td ON td.IdTransporte = t.IdTransporte
        INNER JOIN genArchivo ar ON ar.IdArchivo = td.IdArchivo
        INNER JOIN genTipoDocumento tpd ON tpd.IdTipoDocumento = td.IdTipoDocumento
        INNER JOIN genDocumento doc ON doc.IdDocumento = td.IdDocumento
    )
    SELECT 
        t.IdTransporte,
        t.IdSubTipoTransporte,
        t.IdTipoPropiedadTransporte,
        t.IdFormaTransporte,
        t.IdMarcaTransporte,
        t.IdModeloTransporte,
        t.IdProveedor,
        t.Identificacion,
        t.Placa,
        t.Serie,
        t.Descripcion,
        t.CapacidadMaximaPersonas,
        t.Horometro,
        t.AplicaDescuento,
        st.Nombre AS SubTipoTransporte,
        tp.IdTipoTransporte,
        tp.Nombre AS TipoTransporte,
        md.IdMedioTransporte,
        md.Nombre AS MedioTransporte,
        tpt.Nombre AS TipoPropiedad,
        ft.Nombre AS FormaTransporte,
        mc.Nombre AS MarcaTransporte,
        mdt.Nombre AS ModeloTransporte,
        prov.Nombre AS Proveedor,
        t.Activo,
		t.FechaRegistro,
		t.UsuarioRegistro,
        CASE 
            WHEN t.Activo = 1 THEN 'ACTIVO' 
            WHEN t.Activo = 0 THEN 'INACTIVO' 
        END AS Estado,
        MAX(CASE WHEN ta.RowNum = 1 THEN ta.IdArchivo ELSE NULL END) AS IdArchivoMatricula,
        MAX(CASE WHEN ta.RowNum = 1 THEN ta.NombreArchivo ELSE NULL END) AS NombreArchivoMatricula,
        --MAX(CASE WHEN ta.RowNum = 1 THEN ta.RutaPrivada ELSE NULL END) AS RutaPrivadaMatricula,
        MAX(CASE WHEN ta.RowNum = 2 THEN ta.IdArchivo ELSE NULL END) AS IdArchivoFoto,
        MAX(CASE WHEN ta.RowNum = 2 THEN ta.NombreArchivo ELSE NULL END) AS NombreArchivoFoto,
        --MAX(CASE WHEN ta.RowNum = 2 THEN ta.RutaPrivada ELSE NULL END) AS RutaPrivadaFoto,
		MAX(CASE WHEN ta.RowNum = 1 THEN ta.IdTipoDocumento ELSE NULL END) AS IdTipoDocumento1,
        MAX(CASE WHEN ta.RowNum = 1 THEN ta.TipoDocumento ELSE NULL END) AS TipoDocumento1,
		MAX(CASE WHEN ta.RowNum = 1 THEN ta.IdDocumento ELSE NULL END) AS IdDocumento1,
        MAX(CASE WHEN ta.RowNum = 1 THEN ta.Documento ELSE NULL END) AS Documento1,
        MAX(CASE WHEN ta.RowNum = 2 THEN ta.TipoDocumento ELSE NULL END) AS TipoDocumento2,
        MAX(CASE WHEN ta.RowNum = 2 THEN ta.Documento ELSE NULL END) AS Documento2
    FROM proTransporte t
    INNER JOIN proSubTipoTransporte st ON st.IdSubTipoTransporte = t.IdSubTipoTransporte
    INNER JOIN proTipoTransporte tp ON tp.IdTipoTransporte = st.IdTipoTransporte
    INNER JOIN proMedioTransporte md ON md.IdMedioTransporte = tp.IdMedioTransporte
    INNER JOIN proTipoPropiedadTransporte tpt ON tpt.IdTipoPropiedadTransporte = t.IdTipoPropiedadTransporte
    INNER JOIN proFormaTransporte ft ON ft.IdFormaTransporte = t.IdFormaTransporte
    INNER JOIN proMarcaTransporte mc ON mc.IdMarcaTransporte = t.IdMarcaTransporte
    INNER JOIN proModeloTransporte mdt ON mdt.IdModeloTransporte = t.IdModeloTransporte
    INNER JOIN proProveedor prov ON prov.IdProveedor = t.IdProveedor
    LEFT JOIN TransporteArchivos ta ON ta.IdTransporte = t.IdTransporte
    WHERE t.IdProveedor = COALESCE(@IdProveedor, t.IdProveedor)
    AND t.Activo = COALESCE(@todos, t.Activo)
    GROUP BY 
        t.IdTransporte,
        t.IdSubTipoTransporte,
        t.IdTipoPropiedadTransporte,
        t.IdFormaTransporte,
        t.IdMarcaTransporte,
        t.IdModeloTransporte,
        t.IdProveedor,
        t.Identificacion,
        t.Placa,
        t.Serie,
        t.Descripcion,
        t.CapacidadMaximaPersonas,
        t.Horometro,
        t.AplicaDescuento,
        st.Nombre,
        tp.IdTipoTransporte,
        tp.Nombre,
        md.IdMedioTransporte,
        md.Nombre,
        tpt.Nombre,
        ft.Nombre,
        mc.Nombre,
        mdt.Nombre,
        prov.Nombre,
        t.Activo,
		t.FechaRegistro,
		t.UsuarioRegistro
END
