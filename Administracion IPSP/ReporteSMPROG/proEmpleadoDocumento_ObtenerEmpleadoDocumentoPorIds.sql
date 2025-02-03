
	SELECT ed.IdArchivo, IdEmpleadoProveedor, IdDocumento, IdTipoDocumento, FechaEmision, FechaVencimiento, BitAntecedentes, IdEstado, FechaEstado, a.NombreArchivo, a.Extension, a.RutaPublica
    FROM proEmpleadoDocumento ed 
	inner join genArchivo a on ed.IdArchivo = ed.IdArchivo

    --WHERE IdEmpleadoProveedor IN (SELECT value FROM STRING_SPLIT(@CodigosParametros, ','));

