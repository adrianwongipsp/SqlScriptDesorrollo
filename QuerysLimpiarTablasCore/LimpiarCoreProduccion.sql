use IPSPCamaroneraProduccion
go
select * from invDespacho

select * from coreComponentControl
select * from coreSequential
select * from audit_coreComponentControl

delete from coreComponentControl
delete from coreSequential
delete from audit_coreComponentControl


use [IPSPLightweightCore_Produccion] 
go
select * from secDataInstance -- PRODUCCION

select * from coreComponentControl
select * from coreSequential
select * from audit_coreComponentControl

delete from coreComponentControl
delete from coreSequential
delete from audit_coreComponentControl