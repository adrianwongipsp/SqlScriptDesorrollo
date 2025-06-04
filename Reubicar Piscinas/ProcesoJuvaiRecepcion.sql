

 --primer (primero insigne y luego juvai solo  [192.168.8.60].[JUVAI_TEST].dbo.Vw_BasePesoMuestra con estos nbIdPiscinaEjecucion
 --nbNumeroCiclo porque trae valores)
 select * from [192.168.8.60].[JUVAI_TEST].dbo.Vw_BasePesoMuestra
  where  txtIdPiscina= 'U0445' and nbidtipomuestra = 1 and cast( dtFechaRegistro as date)='2025-05-15'

 select plGramoCam as plGramoCamInsigne, 5.555 as plGramoCamJuvai --hay convertit plgr cam
 ,
 r.fechaRecepcion, *
 from proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
 where idPiscina=574 and r.estado='apr' and rd.idPiscinaEjecucion = 17064 --afinar

 --segundo (primero juvai y luego insigne solo  [192.168.8.60].[JUVAI_TEST].dbo.Vw_BasePesoMuestra no puedos estos nbIdPiscinaEjecucion
 --nbNumeroCiclo porque no trae valores)

 select * from [192.168.8.60].[JUVAI_TEST].dbo.Vw_BasePesoMuestra
  where  txtIdPiscina= 'U0445' and nbidtipomuestra = 1 and cast( dtFechaRegistro as date)='2025-05-15'

select * from [192.168.1.160].[ProduccionBI].[dbo].[Vw_catalogo_actual_psc_IPSP] 
 where id_unid= 'U0445'

 select * from PiscinaUbicacion where KeyPiscina='SANDIEGOPC26'

 --2 dias
 select plGramoCam as plGramoCamInsigne, 5.555 as plGramoCamJuvai --hay convertit plgr cam
 ,
 r.fechaRecepcion, *
 from proRecepcionEspecieDetalle rd inner join proRecepcionEspecie r on r.idRecepcion = rd.idRecepcion
 where idPiscina=574 and r.estado='apr' and r.fechaRecepcion between '2025-05-13' and '2025-05-15' --afinar
 --origenPlGramo='juv' and isnull(rd.plGramoCam,0) <= 0
