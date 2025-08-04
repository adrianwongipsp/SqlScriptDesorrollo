
--select * from parSector where nombre='CANCUN'
SELECT * FROM SectorUbicacion WHERE nombreZona IN('CHANDUY','PAÑAMAOA','PAÑAMAOB')
SELECT * FROM SectorUbicacion WHERE nombreZona IN('KOREA','PLAYAS','SABANA')
SELECT * FROM SectorUbicacion WHERE nombreZona IN('BAJENA','BAJENB','CORVINEROA','CORVINEROB','DAULAR','AFRICA','ASIA')--ESPAÑA && KANSAS--DE BAJENB A BAJENA
SELECT * FROM SectorUbicacion WHERE nombreZona IN('GOLFOA','GOLFOB') --pasa a ser solo GOLFO
SELECT * FROM SectorUbicacion WHERE nombreMegaZona IN('TAURA')
SELECT * FROM SectorUbicacion WHERE nombreMegaZona IN('CALIFORNIA')

SELECT * FROM parMegaZona WHERE nombre='GOLFO' 
SELECT * FROM parZona WHERE nombre='GOLFO' 
SELECT * FROM parCamaronera WHERE nombre='GOLFO' --crear camaronera ya asignar los sectores de golfo a y b
SELECT * FROM parSector WHERE idCamaronera IN(SELECT idCamaronera FROM parCamaronera WHERE nombre IN('GOLFOA','GOLFOB'))

SELECT * FROM tempMigracionPiscina 

--UPDATE x SET x.ACTIVO=0  FROM tempMigracionPiscina x

