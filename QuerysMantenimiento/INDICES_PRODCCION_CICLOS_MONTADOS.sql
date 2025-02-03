 
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_maePiscina_20240624_1]
ON [dbo].[maePiscina] ([activo])
INCLUDE ([zona],[camaronera],[sector],[codigo],[nombre])
GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaCosecha_20240624_1]
ON [dbo].[proPiscinaCosecha] ([tipoPesca],[estado])
INCLUDE ([idPiscinaEjecucion])
GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_CICLOS_PRODUCCION_20240624_1]
ON [dbo].[CICLOS_PRODUCCION] ([Key_Piscina])

GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPedidoBinDetalle_20240624_1]
ON [dbo].[proPedidoBinDetalle] ([idPiscina])

GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proHistograma_20240624_1]
ON [dbo].[proHistograma] ([idPiscina],[estado])

GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaControlPeso_20240624_1]
ON [dbo].[proPiscinaControlPeso] ([idPiscinaEjecucion],[fechaMuestreo])

GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaControlPoblacion_20240624_1]
ON [dbo].[proPiscinaControlPoblacion] ([idPiscinaEjecucion],[fechaMuestreo])

GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proControlParametro_20240624_1]
ON [dbo].[proControlParametro] ([estado])
INCLUDE ([fechaControl])
GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_TRANSFERENCIAS_PRODUCCION_20240624_1]
ON [dbo].[TRANSFERENCIAS_PRODUCCION] ([Cod_Ciclo_Origen])

GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaEjecucion_20240624_1]
ON [dbo].[proPiscinaEjecucion] ([activo],[estado])
INCLUDE ([idPiscina],[ciclo])
GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_maePiscina_20240624_2]
ON [dbo].[maePiscina] ([zona],[camaronera],[sector],[activo])
INCLUDE ([codigo],[nombre],[superficieValor],[superficieUnidad],[profundidadValor],[profundidadUnidad])
GO
*/
 

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaEjecucion_20240624_2]
ON [dbo].[proPiscinaEjecucion] ([activo],[estado])
INCLUDE ([idPiscina],[ciclo],[rolPiscina],[fechaInicio],[fechaSiembra],[fechaCierre],[tipoCierre],[cantidadEntrada],[cantidadSalida],[cantidadPerdida],[idPiscinaEjecucionSiguiente])
GO
*/


/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proPiscinaCosecha_20240624_2]
ON [dbo].[proPiscinaCosecha] ([idPiscina])

GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proPiscinaCosecha_20240624_3]
ON [dbo].[proPiscinaCosecha] ([tipoPesca],[liquidado])
INCLUDE ([idPiscinaEjecucion])
GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proPiscinaCosecha_20240624_4]
ON [dbo].[proPiscinaEjecucion] ([estado])
INCLUDE ([idPiscina],[ciclo],[rolPiscina],[fechaInicio],[fechaSiembra],[fechaCierre],[cantidadEntrada])
GO
*/
/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proPedidoBin_20240624_1]
ON [dbo].[proPedidoBin] ([estado])
INCLUDE ([fechaPedido])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proMuestreoPeso_20240624_1]
ON [dbo].[proMuestreoPeso] ([estado])
INCLUDE ([fechaMuestreo])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proMuestreoPoblacion_20240624_1]
ON [dbo].[proMuestreoPoblacion] ([estado])
INCLUDE ([fechaMuestreo])
GO
*/

 /*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [ix_proControlParametroDetalle_20240624_1]
ON [dbo].[proControlParametroDetalle] ([idPiscina])
INCLUDE ([idControlParametro],[idPiscinaEjecucion])
GO
*/


/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proRecepcionEspecie_20240624_1]
ON [dbo].[proRecepcionEspecie] ([estado])
INCLUDE ([fechaRecepcion])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proMuestreoPeso_20240624_2]
ON [dbo].[proMuestreoPeso] ([fechaMuestreo])
INCLUDE ([estado])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[proMuestreoPoblacion] ([fechaMuestreo])
INCLUDE ([estado])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[proMuestreoPeso] ([fechaMuestreo])
INCLUDE ([estado])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proTransferenciaEspecie_20240624_1]
ON [dbo].[proTransferenciaEspecie] ([estado])
INCLUDE ([fechaTransferencia])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPedidoBin_20240624_2]
ON [dbo].[proPedidoBin] ([fechaPedido])
INCLUDE ([estado])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaEjecucion_20240624_3]
ON [dbo].[proPiscinaEjecucion] ([rolPiscina],[estado])
INCLUDE ([idPiscina],[ciclo],[fechaInicio],[fechaSiembra],[fechaCierre],[cantidadEntrada])
GO
*/

/*
USE [IPSPCamaroneraProduccion]
GO
CREATE NONCLUSTERED INDEX [IX_proPiscinaCosecha_20240624_4]
ON [dbo].[proPiscinaCosecha] ([idPiscinaEjecucion],[tipoPesca],[liquidado])

GO
*/

 
