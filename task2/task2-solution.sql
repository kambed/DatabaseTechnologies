USE SpatialDatabase;


------------------------------------- 3 -------------------------------------

-- Procedure to display data
CREATE PROCEDURE DisplayBusStop
AS
BEGIN
    SELECT
        id,
        name,
        geom.ToString() AS geometry_string
    FROM
        BusStop;
END;

CREATE PROCEDURE DisplayBusLoop
AS
BEGIN
    SELECT
        id,
        name,
        geom.ToString() AS geometry_string
    FROM
        BusLoop;
END;

CREATE OR ALTER PROCEDURE DisplayBusWay
AS
BEGIN
    SELECT
        id,
        name,
        geom.ToString() AS geometry_string
    FROM
        BusWay;
END;

EXEC DisplayBusStop;
EXEC DisplayBusLoop;
EXEC DisplayBusWay;

-- Procedure to load data

CREATE PROCEDURE LoadSpatialData
    @name NVARCHAR(100),
    @geometryData NVARCHAR(MAX),
    @geometryType NVARCHAR(50)
AS
BEGIN
    DECLARE @geometry GEOMETRY;

    SET @geometry = geometry::STGeomFromText(@geometryData, 4326);

    IF @geometryType = 'point'
    BEGIN
        INSERT INTO BusStop (name, geom) VALUES (@name, @geometry);
    END
    ELSE IF @geometryType = 'linestring'
    BEGIN
        INSERT INTO BusWay (name, geom) VALUES (@name, @geometry);
    END
    ELSE IF @geometryType = 'polygon'
    BEGIN
        INSERT INTO BusLoop (name, geom) VALUES (@name, @geometry);
    END
END;

EXEC LoadSpatialData 'BusStop1', 'POINT(1 1)', 'point';


------------------------------------- 4 -------------------------------------






------------------------------------- 5 -------------------------------------