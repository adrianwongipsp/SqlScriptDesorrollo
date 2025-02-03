--SELECT * FROM parSector WHERE nombre LIKE '%HOLANDA%'
--select * from invBodega where codigo='SECTOR1'
--SELECT* FROM invBodega WHERE codigo ='SECTOR5'

SELECT 
codigo, 'Sector' + CAST(idSector as varchar(10)) as codigo 
 --Update b set codigo = 'Sector' + CAST(idSector as varchar(10))
FROM invBodega b WHERE tipoBodega = '00005' and idSector is not null
and codigo <> 'Sector' + CAST(idSector as varchar(10))

--Update invBodega set activo = 1 where activo = 0  and  tipoBodega ='00005'


SELECT * FROM invBodega WHERE codigo = 'Sector1'
SELECT * FROM invBodega WHERE activo  = 0


