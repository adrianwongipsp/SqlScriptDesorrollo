--respaldo zona
select * 
into hisZona
from parZona

--respaldo camaronera
select * 
into hisCamaronera
from parCamaronera

--respaldo sector
select * 
into hisSector
from parSector

--respaldo piscina
select * 
into hisPiscina
from maePiscina

CREATE view  [dbo].[HisPiscinaUbicacion] as         
	select  z.codigo as codigoZona, z.nombre as nombreZona,        
			c.codigo as codigoCamaronera, c.nombre as nombreCamaronera,        
			s.codigo as codigoSector    , s.nombre as nombreSector,        
			p.codigo as codigoPiscina   , p.nombre as nombrePiscina,        
			p.superficieValor,       
			p.superficieUnidad,       
			p.idPiscina  ,      
			s.idSector   ,      
			s.idCamaronera ,      
			z.idZona   ,    
			replace(s.nombre +  p.nombre, ' ', '')  KeyPiscina  ,  
			p.profundidadValor,       
			p.profundidadUnidad  
	from  hisZona z inner join hisCamaronera c on c.idZona = z.idZona        
		  inner join hisSector     s on s.idCamaronera = c.idCamaronera         
		  inner join hisPiscina    p on p.zona = z.codigo and p.camaronera = c.codigo and p.sector = s.codigo        
	where  z.activo = 1 and c.activo = 1 and s.activo =1 and p.activo = 1  
 