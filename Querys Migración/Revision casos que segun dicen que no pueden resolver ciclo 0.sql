select * from CICLOS_PRODUCCION where Key_Piscina='TAURAVPC4'
select * from  [192.168.1.160].[ProduccionBI].dbo.Vw_variables_reporte_insigne where Piscina like 'TAURAVII31%'
select * from EjecucionesPiscinaView where keyPiscina='TAURAVPC4'
select * from proPiscinaEjecucion where idPiscina = 264


select idPiscina, keyPiscina, SUM(ciclo) from EjecucionesPiscinaView where keyPiscina like 'TAURAIII31%'    group by keyPiscina, idPiscina having  SUM(ciclo) <= 0 order by 3


exec viewProcessCiclos 'TAURAVPC4', 1
/*
select * from proPiscinaEjecucion where idPiscinaEjecucion in (8984)
select * from maePiscinaCiclo where idOrigen in (8984)

select p.fechaControl, pd.idPiscinaEjecucion, pd.idPiscina from
proControlParametro p inner join
proControlParametroDetalle pd  on p.idControlParametro = pd.idParametroControl
where idPiscinaEjecucion in (10005,9963) order by 1
*