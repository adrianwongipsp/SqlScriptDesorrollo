use IPSPCamaroneraTesting
go
select * from invDespacho

select * from coreComponentControl
select * from coreSequential
select * from audit_coreComponentControl

delete from coreComponentControl
delete from coreSequential
delete from audit_coreComponentControl


use IPSP_Produccion_LightweightCore
go
select * from secDataInstance -- TESTING 2

select * from coreComponentControl
select * from coreSequential
select * from audit_coreComponentControl

delete from coreComponentControl
delete from coreSequential
delete from audit_coreComponentControl