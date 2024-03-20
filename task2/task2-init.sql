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

CREATE TABLE BusWay (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOMETRY
);
GO

-- Tworzymy indeks przestrzenny dla tabeli BusStop
CREATE SPATIAL INDEX spatial_index_BusStop
    ON BusStop(geom)
    USING GEOMETRY_GRID
    WITH (BOUNDING_BOX = (51, 19, 52, 20));
GO

-- Tworzymy indeks przestrzenny dla tabeli BusLoop
CREATE SPATIAL INDEX spatial_index_BusLoop
    ON BusLoop(geom)
    USING GEOMETRY_GRID
    WITH (BOUNDING_BOX = (51, 19, 52, 20));
GO

-- Tworzymy indeks przestrzenny dla tabeli BusWay
CREATE SPATIAL INDEX spatial_index_BusWay
    ON BusWay(geom)
    USING GEOMETRY_GRID
    WITH (BOUNDING_BOX = (51, 19, 52, 20));
GO