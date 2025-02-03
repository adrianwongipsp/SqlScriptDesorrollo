

--Testing Log_5999A53F4AD048F4_F8F7835D6AAE4132_20240723
--Produccio Log_5999A53F4AD048F4_D6EDD50649ED4B42_20240723


select lo.logId, usr.[description], lo.userLogin, lo.clientHostName, lo.gatewayHostName, lo.serverHostName, 
lo.startDateTime, lo.typeName, lo.success, lo.errorDetails 
from Log_5999A53F4AD048F4_D6EDD50649ED4B42_20240807 lo
inner join IPSP_Produccion_LightweightCore.dbo.secUser usr on lo.userLogin = usr.userLogin
--where lo.[action] = 'GetTransactionsView'
where lo.success = 0
--order by lo.startDateTime, lo.clientHostName, usr.description


--select * from IPSPLightweightCore_Produccion.dbo.secUser

select *
from LogDetail_5999A53F4AD048F4_D6EDD50649ED4B42_20240807 lo
where lo.success = 0 and  logId in (536,543,544,500,502,530,531,533)