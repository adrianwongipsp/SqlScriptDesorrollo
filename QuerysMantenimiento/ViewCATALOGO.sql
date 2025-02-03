
alter view CATALOGO_ELEMENTS as
select ca.idCatalogo, ca.codigo as codigoCatalogo, ca.nombre as nombreCatalogo, ec.codigo as codigoElemento, ec.nombre as nombreElemento  from parElementoCatalogo ec
inner join parCatalogo ca on ec.idCatalogo = ca.idCatalogo
where ca.activo = 1 and ec.activo = 1
