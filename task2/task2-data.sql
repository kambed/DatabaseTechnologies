USE SpatialDatabase;


-- Dodanie trasy

DECLARE @roadGeometry1 GEOMETRY;
SET @roadGeometry1 = geometry::STLineFromText('LINESTRING(19.404867 51.748058, 19.403602 51.747741, 19.398779 51.746349, 19.392097 51.744458, 19.384769 51.742422)', 4326);

INSERT INTO BusWay (name, geom) VALUES ('Trasa wyszynskiego-retkinia do petla retkinia', @roadGeometry1);

DECLARE @roadGeometry2 GEOMETRY;
SET @roadGeometry2 = geometry::STLineFromText('LINESTRING(19.384907 51.742370, 19.384769 51.742422, 19.392275 51.744450, 19.399333 51.746468, 19.404750 51.748004)', 4326);

INSERT INTO BusWay (name, geom) VALUES ('Trasa petla retkinia do wyszynskiego-retkinia', @roadGeometry2);


-- Dodanie przystanków

DECLARE @pointGeometry1 GEOMETRY;
SET @pointGeometry1 = geometry::STPointFromText('POINT(19.404893 51.748068)', 4326);

INSERT INTO BusStop (name, geom) VALUES ('Wyszynskiego - Retkinska (1384)', @pointGeometry1);

DECLARE @pointGeometry2 GEOMETRY;
SET @pointGeometry2 = geometry::STPointFromText('POINT(51.746460 19.399165)', 4326);

INSERT INTO BusStop (name, geom) VALUES ('Wyszynskiego - Armii Krajowej (1386)', @pointGeometry2);

DECLARE @pointGeometry3 GEOMETRY;
SET @pointGeometry3 = geometry::STPointFromText('POINT(51.744457 19.392113)', 4326);

INSERT INTO BusStop (name, geom) VALUES ('Blok 270 (1386)', @pointGeometry3);

DECLARE @pointGeometry4 GEOMETRY;
SET @pointGeometry4 = geometry::STPointFromText('POINT(51.742002 19.384003)', 4326);

INSERT INTO BusStop (name, geom) VALUES ('Retkinia (1370)', @pointGeometry4);


-- Dodanie petli autobusowej

DECLARE @rectangleGeometry GEOMETRY;
SET @rectangleGeometry = geometry::STGeomFromText('POLYGON((19.384163 51.742357, 19.383290 51.742349, 19.383617 51.741925, 19.384225 51.742195, 19.384163 51.742357))', 4326);

INSERT INTO BusLoop (name, geom) VALUES ('Petla retkinia', @rectangleGeometry);

select * from BusLoop;