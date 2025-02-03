alter procedure usp_RptMarcacionesMonitoreo(@fechaini date,@fechafin date,@IdTurno int=null, @IdDescanso int)
as
begin 
DECLARE @horaini VARCHAR(20), 
        @horafin VARCHAR(20), 
        @tiempoPermitido INT = 0;
DECLARE @horas INT, 
        @minutos INT, 
        @segundos INT = 0, 
        @hhmmss VARCHAR(8);

-- Obtener los valores desde la tabla Descanso
SET @horaini = (SELECT HoraInicio FROM Descanso WHERE IdDescanso = @IdDescanso);
SET @horafin = (SELECT HoraFin FROM Descanso WHERE IdDescanso = @IdDescanso);
SET @tiempoPermitido = (SELECT ValorMinutos FROM Descanso WHERE IdDescanso = @IdDescanso);

-- Convertir minutos a formato hh:mm:ss
SET @horas = @tiempoPermitido / 60;
SET @minutos = @tiempoPermitido % 60;

-- Formatear como hh:mm:ss
SET @hhmmss = RIGHT('00' + CAST(@horas AS VARCHAR(2)), 2) + ':' 
             + RIGHT('00' + CAST(@minutos AS VARCHAR(2)), 2) + ':' 
             + RIGHT('00' + CAST(@segundos AS VARCHAR(2)), 2);

-- Consultas para obtener datos y calcular la diferencia
WITH GENERAL AS (
    SELECT
        us.IdUsuario,
        us.Apellidos + ' ' + us.Nombres AS NombreCompleto,
        dep.Nombre AS Departamento,
        b.Alias AS Biometrico,
        lf.Nombre AS LugarFisico,
        ev.Nombre AS Evento,
        FORMAT(uxm.Fecha,'yyyy-MM-dd') AS FechaMarcacion,
        uxm.Hora AS HoraMarcacion
    FROM UsuarioXMarcacion uxm
    INNER JOIN Usuario us ON us.IdUsuario = uxm.IdUsuario
    INNER JOIN DepartamentoXBiometrico dxb ON dxb.IdBiometrico = uxm.IdBiometrico 
        AND dxb.IdDepartamento = uxm.IdDepartamento
        AND dxb.IdLugar = uxm.IdLugar 
        AND dxb.IdEvento = uxm.IdEvento
    INNER JOIN Biometrico b ON b.IdBiometrico = dxb.IdBiometrico
    INNER JOIN Departamento dep ON dep.IdDepartamento = dxb.IdDepartamento
    INNER JOIN LugarFisico lf ON lf.IdLugar = dxb.IdLugar
    INNER JOIN Evento ev ON ev.IdEvento = dxb.IdEvento
    WHERE 
        CAST(uxm.Fecha AS DATE) BETWEEN @fechaini AND @fechafin
        AND uxm.Hora BETWEEN @horaini AND @horafin
        AND b.IdBiometrico = 9
        AND dep.Nombre = 'MONITOREO'
),
Pivoted AS (
    SELECT 
        IdUsuario,
        NombreCompleto,
        Departamento,
        Biometrico,
        LugarFisico,
        FechaMarcacion,
        MIN(CASE WHEN Evento = 'Salida' THEN HoraMarcacion END) AS HoraSalida,
        MAX(CASE WHEN Evento = 'Entrada' THEN HoraMarcacion END) AS HoraEntrada
    FROM GENERAL
    GROUP BY 
        IdUsuario,
        NombreCompleto,
        Departamento,
        Biometrico,
        LugarFisico,
        FechaMarcacion
)
SELECT 
    IdUsuario,
    NombreCompleto,
    Departamento,
    Biometrico,
    LugarFisico,
    FechaMarcacion,
    HoraSalida,
    HoraEntrada,
    CASE 
        WHEN HoraEntrada IS NOT NULL AND HoraSalida IS NOT NULL 
        THEN RIGHT('0' + CAST(DATEDIFF(SECOND, HoraSalida, HoraEntrada) / 3600 AS VARCHAR), 2) + ':' +
             RIGHT('0' + CAST((DATEDIFF(SECOND, HoraSalida, HoraEntrada) % 3600) / 60 AS VARCHAR), 2) + ':' +
             RIGHT('0' + CAST(DATEDIFF(SECOND, HoraSalida, HoraEntrada) % 60 AS VARCHAR), 2)
        ELSE NULL 
    END AS Diferencia,
    CASE
        WHEN DATEDIFF(SECOND, HoraSalida, HoraEntrada) > @tiempoPermitido * 60
        THEN RIGHT('0' + CAST((DATEDIFF(SECOND, HoraSalida, HoraEntrada) - @tiempoPermitido * 60) / 3600 AS VARCHAR), 2) + ':' +
             RIGHT('0' + CAST(((DATEDIFF(SECOND, HoraSalida, HoraEntrada) - @tiempoPermitido * 60) % 3600) / 60 AS VARCHAR), 2) + ':' +
             RIGHT('0' + CAST((DATEDIFF(SECOND, HoraSalida, HoraEntrada) - @tiempoPermitido * 60) % 60 AS VARCHAR), 2)
        ELSE NULL
    END AS TiempoExcedido,
	
    CASE
        WHEN DATEDIFF(MINUTE, HoraSalida, HoraEntrada) > @tiempoPermitido
        THEN 1
        ELSE 0
    END AS Alerta
FROM Pivoted
WHERE HoraEntrada IS NOT NULL AND HoraSalida IS NOT NULL
ORDER BY NombreCompleto, HoraEntrada;

end