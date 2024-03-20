CREATE DATABASE SpatialDatabase;
GO
USE SpatialDatabase;
GO

CREATE TABLE BusStop (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOGRAPHY
);
GO

CREATE TABLE BusLoop (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOGRAPHY
);
GO

CREATE TABLE BusWay (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100),
    geom GEOGRAPHY
);
GO

-- Tworzymy indeks przestrzenny dla tabeli BusStop
CREATE SPATIAL INDEX spatial_index_BusStop
    ON BusStop(geom)
    USING GEOGRAPHY_GRID
    WITH (
        GRIDS = (LOW, LOW, MEDIUM, HIGH)
    );
GO

-- Tworzymy indeks przestrzenny dla tabeli BusLoop
CREATE SPATIAL INDEX spatial_index_BusLoop
    ON BusLoop(geom)
    USING GEOGRAPHY_GRID
    WITH (
        GRIDS = (LOW, LOW, MEDIUM, HIGH)
    );
GO

-- Tworzymy indeks przestrzenny dla tabeli BusWay
CREATE SPATIAL INDEX spatial_index_BusWay
    ON BusWay(geom)
    USING GEOGRAPHY_GRID
    WITH (
        GRIDS = (LOW, LOW, MEDIUM, HIGH)
    );
GO