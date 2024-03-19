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

-- build geometric area

SELECT DISTINCT
    bs.id AS BusStopID,
    bs.name AS BusStopName,
    bl.id AS BusLoopID,
    bl.name AS BusLoopName,
    bw.id AS BusWayID,
    bw.name AS BusWayName
FROM
    BusStop bs
LEFT JOIN
    BusLoop bl
ON
    bs.geom.STIntersects(bl.geom) = 1
LEFT JOIN
    BusWay bw
ON
    bs.geom.STIntersects(bw.geom) = 1;

-- connect geometric area with coordinate system

CREATE OR ALTER PROCEDURE ProjectGeometryToDifferentSRID
    @geometry GEOMETRY,
    @targetSRID INT
AS
BEGIN
    DECLARE @projectedGeometry GEOMETRY;
    SET @projectedGeometry = @geometry.STAsText();
    SET @projectedGeometry = geometry::STGeomFromText(@projectedGeometry.ToString(), @targetSRID);

    SELECT @projectedGeometry AS ProjectedGeometry;
END;

DECLARE @inputGeometry GEOMETRY;
DECLARE @targetSRID INT;
SET @inputGeometry = (SELECT TOP 1 geom FROM BusLoop);
SET @targetSRID = 4326;

EXEC ProjectGeometryToDifferentSRID @geometry = @inputGeometry, @targetSRID = @targetSRID;
------------------------------------- 5 -------------------------------------