USE SpatialDatabase;


------------------------------------- 3 -------------------------------------

-- Procedure to display data
CREATE PROCEDURE DisplayBusStop
AS
BEGIN
    SELECT
        id,
        name,
        geom.ToString() AS geography_string
    FROM
        BusStop;
END;

CREATE PROCEDURE DisplayBusLoop
AS
BEGIN
    SELECT
        id,
        name,
        geom.ToString() AS geography_string
    FROM
        BusLoop;
END;

CREATE OR ALTER PROCEDURE DisplayBusWay
AS
BEGIN
    SELECT
        id,
        name,
        geom.ToString() AS geography_string
    FROM
        BusWay;
END;

EXEC DisplayBusStop;
EXEC DisplayBusLoop;
EXEC DisplayBusWay;

-- Procedure to load data

CREATE PROCEDURE LoadSpatialData
    @name NVARCHAR(100),
    @geographyData NVARCHAR(MAX),
    @geographyType NVARCHAR(50)
AS
BEGIN
    DECLARE @geography GEOGRAPHY;

    SET @geography = geography::STGeomFromText(@geographyData, 4326);

    IF @geographyType = 'point'
    BEGIN
        INSERT INTO BusStop (name, geom) VALUES (@name, @geography);
    END
    ELSE IF @geographyType = 'linestring'
    BEGIN
        INSERT INTO BusWay (name, geom) VALUES (@name, @geography);
    END
    ELSE IF @geographyType = 'polygon'
    BEGIN
        INSERT INTO BusLoop (name, geom) VALUES (@name, @geography);
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
    @geography GEOGRAPHY,
    @targetSRID INT
AS
BEGIN
    DECLARE @projectedGeography GEOGRAPHY;
    SET @projectedGeography = @geography.STAsText();
    SET @projectedGeography = geography::STGeomFromText(@projectedGeography.ToString(), @targetSRID);

    SELECT @projectedGeography AS ProjectedGeometry;
END;

DECLARE @inputGeography GEOGRAPHY;
DECLARE @targetSRID INT;
SET @inputGeography = (SELECT TOP 1 geom FROM BusLoop);
SET @targetSRID = 4267;

EXEC ProjectGeometryToDifferentSRID @geography = @inputGeography, @targetSRID = @targetSRID;

------------------------------------- 5 -------------------------------------

-- designation area

CREATE OR ALTER PROCEDURE Spatial_Area_Analysis
    @Geography GEOGRAPHY
AS
BEGIN
    DECLARE @Area FLOAT;
    SET @Area = @Geography.STArea();

    DECLARE @Length FLOAT;
    SET @Length = @Geography.STLength();

    SELECT @Area AS Area, @Length AS Circuit;
END;

DECLARE @inputGeometry GEOGRAPHY;
SET @inputGeometry = (SELECT TOP 1 geom FROM BusLoop);

EXEC Spatial_Area_Analysis @Geography = @inputGeometry;

-- validate area

CREATE PROCEDURE Validate_Geography
    @Geography GEOGRAPHY
AS
BEGIN
    DECLARE @IsValid BIT;
    SET @IsValid = CASE WHEN @Geography.STIsValid() = 1 THEN 1 ELSE 0 END;

    DECLARE @IsClosed BIT;
    SET @IsClosed = CASE WHEN @Geography.STIsClosed() = 1 THEN 1 ELSE 0 END;

    DECLARE @IsEmpty BIT;
    SET @IsEmpty = CASE WHEN @Geography.STIsEmpty() = 1 THEN 1 ELSE 0 END;

    SELECT @IsValid AS IsValid, @IsClosed AS IsClosed, @IsEmpty AS IsEmpty;
END;

DECLARE @inputGeography GEOGRAPHY;
SET @inputGeography = (SELECT TOP 1 geom FROM BusLoop);

EXEC Validate_Geography @Geography = @inputGeography;

-- Calculating the distance between geometries

CREATE PROCEDURE Spatial_Areas_Analysis
    @Geography1 GEOGRAPHY,
    @Geography2 GEOGRAPHY
AS
BEGIN
    DECLARE @Distance FLOAT;
    SET @Distance = @Geography1.STDistance(@Geography2);

    DECLARE @Intersects BIT;
    SET @Intersects = IIF(@Geography1.STIntersects(@Geography2) = 1, 1, 0);

    SELECT @Distance AS Distance, @Intersects AS Intersects;
END;

DECLARE @inputGeo1 GEOGRAPHY;
DECLARE @inputGeo2 GEOGRAPHY;

SELECT TOP 1 @inputGeo1 = geom FROM BusStop ORDER BY NEWID();
SELECT TOP 2 @inputGeo2 = geom FROM BusStop ORDER BY NEWID();

EXEC Spatial_Areas_Analysis @Geography1 = @inputGeo1, @Geography2 = @inputGeo2;

-- determining the location in the given range

CREATE PROCEDURE Find_Location_In_Range
    @SearchGeo GEOGRAPHY,
    @Range FLOAT,
    @Location GEOGRAPHY
AS
BEGIN
    -- Wyszukiwanie lokalizacji w podanym zakresie
    DECLARE @WithinRange BIT;
    SET @WithinRange = CASE WHEN @SearchGeo.STDistance(@Location) <= @Range THEN 1 ELSE 0 END;

    -- Zwracanie wyników
    SELECT @WithinRange AS WithinRange;
END;

DECLARE @inputGeo1 GEOGRAPHY;
DECLARE @inputGeo2 GEOGRAPHY;
DECLARE @range FLOAT;

SELECT TOP 1 @inputGeo1 = geom FROM BusStop ORDER BY NEWID();
SELECT TOP 1 @inputGeo2 = geom FROM BusStop ORDER BY NEWID();
SET @range = 100;

EXEC Find_Location_In_Range @SearchGeo = @inputGeo1, @Range = @range, @Location = @inputGeo2;


-- find nearest bus stop

CREATE PROCEDURE FindNearestBusStopWithName
    @Latitude FLOAT,
    @Longitude FLOAT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Point GEOGRAPHY;
    SET @Point = GEOGRAPHY::Point(@Latitude, @Longitude, 4326);

    DECLARE @NearestBusStop GEOGRAPHY;
    DECLARE @NearestBusStopName NVARCHAR(100);

    SELECT TOP 1 @NearestBusStop = geom, @NearestBusStopName = Name
    FROM BusStop
    ORDER BY @Point.STDistance(geom);

    SELECT @NearestBusStopName AS NearestBusStopName, @NearestBusStop.STAsText() AS NearestBusStopLocation;
END;

EXEC FindNearestBusStopWithName 51.75257680272248, 19.425371845051;