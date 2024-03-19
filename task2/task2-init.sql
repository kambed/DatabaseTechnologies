-- Tworzymy bazę danych, jeśli nie istnieje
CREATE DATABASE SpatialDatabase;
GO
USE SpatialDatabase;
GO

-- Włączamy obsługę danych przestrzennych
EXEC sys.sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
EXEC sys.sp_configure 'clr enabled', 1;
RECONFIGURE;
GO

-- Tworzymy tabelę do przechowywania przystanków
CREATE TABLE BusStop (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOMETRY
);
GO

CREATE TABLE BusLoop (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOMETRY
);
GO

-- Tworzymy tabelę do przechowywania przystanków
CREATE TABLE BusWay (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOMETRY
);
GO