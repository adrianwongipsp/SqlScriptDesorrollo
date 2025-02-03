create table #MigracionEjecucion ( 
		keyPiscinaPosterior varchar(30),
		keyPiscinaAnterior varchar(30),
		ciclo				int
)

 
 
 insert into #MigracionEjecucion values  ('EGIPTO41','RUANDA41',37)
 insert into #MigracionEjecucion values  ('EGIPTO42','RUANDA42',37)
 insert into #MigracionEjecucion values  ('EGIPTO43','RUANDA43',38)
 insert into #MigracionEjecucion values  ('EGIPTO44','RUANDA44',36)
 insert into #MigracionEjecucion values  ('EGIPTO45','RUANDA45',38)
 insert into #MigracionEjecucion values  ('EGIPTO46','RUANDA46',37)
 insert into #MigracionEjecucion values  ('EGIPTO47','RUANDA47',36)
 insert into #MigracionEjecucion values  ('EGIPTO50','MARRUECOS50',37)
 insert into #MigracionEjecucion values  ('EGIPTO51','MARRUECOS51',37)
 insert into #MigracionEjecucion values  ('EGIPTO53','MARRUECOS53',36)
 insert into #MigracionEjecucion values  ('EGIPTO55','MARRUECOS55',38)
 insert into #MigracionEjecucion values  ('EGIPTOPC20','MARRUECOSPC20',38)
 insert into #MigracionEjecucion values  ('EGIPTOPC18','MARRUECOSPC18',75)
 insert into #MigracionEjecucion values  ('EGIPTOPC19','MARRUECOSPC19',71)
 insert into #MigracionEjecucion values  ('EGIPTOPC11','RUANDAPC11',79)
 insert into #MigracionEjecucion values  ('EGIPTOPC12','RUANDAPC12',87)
 insert into #MigracionEjecucion values  ('EGIPTOPC13','RUANDAPC13',80)
 insert into #MigracionEjecucion values  ('EGIPTOPC14','RUANDAPC14',73)
 insert into #MigracionEjecucion values  ('EGIPTOPC41R','RUANDAPC41R',46)
 insert into #MigracionEjecucion values  ('EGIPTOPC49A','RUANDAPC49A',20)
 insert into #MigracionEjecucion values  ('EGIPTOPC49B','RUANDAPC49B',20)

 insert into #MigracionEjecucion values  ('EGIPTO48','RUANDA48',38)
 insert into #MigracionEjecucion values  ('EGIPTO52','MARRUECOS52',37)
 
 insert into #MigracionEjecucion values  ('EGIPTOPC16','MARRUECOSPC16',81)
  insert into #MigracionEjecucion values  ('EGIPTOPC17','MARRUECOSPC17',67)
--UPDATE  #MigracionEjecucion SET CICLO = 110 WHERE keyPiscinaAnterior ='MARRUECOSPC15'
 --insert into MigracionEjecucion (cod_cicloAnterior,  idPiscinaAnterior,           idPiscinaEjecucionAnterior, 
 --                               FechaSiembraAnterior, cod_cicloPosterior,
	--							idPiscinaPosterior, idPiscinaEjecucionPosterior, FechaSiembraPosterior, activo)
 --select   CONCAT(keyPiscinaAnterior,'.', tme.ciclo) as cod_cicloAnterior,    
	--	ejv.idPiscina			as idPiscinaAnterior, 
	--	ejv.idPiscinaEjecucion  as idPiscinaEjecucionAnterior, 
	--	ejv.FechaSiembra		as FechaSiembraAnterior,
 --       CONCAT(keyPiscinaPosterior,'.', tme.ciclo)  as cod_cicloPosterior,
	--	ejv2.idPiscina			as idPiscinaPosterior,
	--	ejv2.idPiscinaEjecucion  as idPiscinaEjecucionPosterior, 
	--	ejv.FechaSiembra		as FechaSiembraPosterior,
	--	1 as activo
 --from #MigracionEjecucion tme 
 --  inner join EjecucionesPiscinaView ejv on tme.keyPiscinaAnterior = ejv.keyPiscina  and ejv.Ciclo = tme.ciclo    -- and ejv.estado='INI'
 --inner join EjecucionesPiscinaView ejv2 on tme.keyPiscinaPosterior = ejv2.keyPiscina --and ejv2.Ciclo= tme.ciclo -- and ejv2.estado='INI'
 -- WHERE keyPiscinaAnterior='MARRUECOSPC17'
 

 SELECT * FROM EjecucionesPiscinaView where keyPiscina='EGIPTOPC15'


 select m.*, pc.ciclo from MigracionEjecucion m inner join maePiscinaCiclo pc on pc.idPiscina = m.idPiscinaPosterior and pc.ciclo > 0