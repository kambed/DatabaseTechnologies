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
    bs.geom.STDistance(bl.geom) < 0.000001
LEFT JOIN
    BusWay bw
ON
    bs.geom.STIntersects(bw.geom) = 1
ORDER BY bw.id;
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
SET @targetSRID = 2180;

EXEC ProjectGeometryToDifferentSRID @geometry = @inputGeometry, @targetSRID = @targetSRID;

------------------------------------- 5 -------------------------------------

-- designation area

CREATE OR ALTER PROCEDURE Spatial_Area_Analysis
    @Geometry GEOMETRY
AS
BEGIN
    DECLARE @Area FLOAT;
    SET @Area = @Geometry.STArea();

    DECLARE @Length FLOAT;
    SET @Length = @Geometry.STLength();

    SELECT @Area AS Area, @Length AS Circuit;
END;

DECLARE @inputGeometry GEOMETRY;
SET @inputGeometry = (SELECT TOP 1 geom FROM BusLoop);

EXEC Spatial_Area_Analysis @Geometry = @inputGeometry;

-- validate area

CREATE PROCEDURE Validate_Geometry
    @Geometry GEOMETRY
AS
BEGIN
    DECLARE @IsValid BIT;
    SET @IsValid = CASE WHEN @Geometry.STIsValid() = 1 THEN 1 ELSE 0 END;

    DECLARE @IsClosed BIT;
    SET @IsClosed = CASE WHEN @Geometry.STIsClosed() = 1 THEN 1 ELSE 0 END;

    DECLARE @IsEmpty BIT;
    SET @IsEmpty = CASE WHEN @Geometry.STIsEmpty() = 1 THEN 1 ELSE 0 END;

    SELECT @IsValid AS IsValid, @IsClosed AS IsClosed, @IsEmpty AS IsEmpty;
END;

DECLARE @inputGeometry GEOMETRY;
SET @inputGeometry = (SELECT TOP 1 geom FROM BusLoop);

EXEC Validate_Geometry @Geometry = @inputGeometry;

-- Calculating the distance between geometries

CREATE PROCEDURE Spatial_Areas_Analysis
    @Geometry1 GEOMETRY,
    @Geometry2 GEOMETRY
AS
BEGIN
    DECLARE @Distance FLOAT;
    SET @Distance = @Geometry1.STDistance(@Geometry2);

    DECLARE @Intersects BIT;
    SET @Intersects = IIF(@Geometry1.STIntersects(@Geometry2) = 1, 1, 0);

    SELECT @Distance AS Distance, @Intersects AS Intersects;
END;

DECLARE @inputGeometry1 GEOMETRY;
DECLARE @inputGeometry2 GEOMETRY;

SELECT TOP 1 @inputGeometry1 = geom FROM BusStop ORDER BY NEWID();
SELECT TOP 2 @inputGeometry2 = geom FROM BusStop ORDER BY NEWID();

EXEC Spatial_Areas_Analysis @Geometry1 = @inputGeometry1, @Geometry2 = @inputGeometry2;

-- determining the location in the given range

CREATE PROCEDURE Find_Location_In_Range
    @SearchGeometry GEOMETRY,
    @Range FLOAT,
    @Location GEOMETRY
AS
BEGIN
    -- Wyszukiwanie lokalizacji w podanym zakresie
    DECLARE @WithinRange BIT;
    SET @WithinRange = CASE WHEN @SearchGeometry.STDistance(@Location) <= @Range THEN 1 ELSE 0 END;

    -- Zwracanie wyników
    SELECT @WithinRange AS WithinRange;
END;

DECLARE @inputGeometry1 GEOMETRY;
DECLARE @inputGeometry2 GEOMETRY;
DECLARE @range FLOAT;

SELECT TOP 1 @inputGeometry1 = geom FROM BusStop ORDER BY NEWID();
SELECT TOP 1 @inputGeometry2 = geom FROM BusStop ORDER BY NEWID();
SET @range = 100;

EXEC Find_Location_In_Range @SearchGeometry = @inputGeometry1, @Range = @range, @Location = @inputGeometry2;


-- find nearest bus stop

CREATE PROCEDURE FindNearestBusStopWithName
    @Latitude FLOAT,
    @Longitude FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Point GEOMETRY;
    SET @Point = GEOMETRY::Point(@Latitude, @Longitude, 4326);

    DECLARE @NearestBusStop GEOMETRY;
    DECLARE @NearestBusStopName NVARCHAR(100);

    SELECT TOP 1 @NearestBusStop = geom, @NearestBusStopName = Name
    FROM BusStop
    ORDER BY @Point.STDistance(geom);

    SELECT @NearestBusStopName AS NearestBusStopName, @NearestBusStop.STAsText() AS NearestBusStopLocation;
END;

EXEC FindNearestBusStopWithName 51.75257680272248, 19.425371845051;