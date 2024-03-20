USE SpatialDatabase;


-- Dodanie trasy

DECLARE @roadGeometry1 GEOGRAPHY;
SET @roadGeometry1 = geography::STLineFromText('LINESTRING(51.75814656346606 19.449168774079943, 51.75584979687422 19.43253509209079, 51.75257680272246 19.425371845051, 51.74983119554832 19.423309566714764, 51.74748933433701 19.41791407607441, 51.74761789965939 19.413370784677067, 51.74808447618714 19.404966689640226, 51.746400187644845 19.39882325024777, 51.74451952698091 19.392189691337567, 51.742146944442815 19.38449458219283)', 4326);
SET @roadGeometry1 = @roadGeometry1.MakeValid();

INSERT INTO BusWay (name, geom) VALUES ('Trasa Mickiewicza - Żeromskiego do petla retkinia', @roadGeometry1);

DECLARE @roadGeometry2 GEOGRAPHY;
SET @roadGeometry2 = geography::STLineFromText('LINESTRING(51.742146944442815 19.38449458219283, 51.74451952698091 19.392189691337567, 51.746400187644845 19.39882325024777, 51.74808447618714 19.404966689640226, 51.74761789965939 19.413370784677067, 51.74748933433701 19.41791407607441, 51.74983119554832 19.423309566714764, 51.75257680272246 19.425371845051, 51.75584979687422 19.43253509209079, 51.75814656346606 19.449168774079943)', 4326);
SET @roadGeometry2 = @roadGeometry2.MakeValid();

INSERT INTO BusWay (name, geom) VALUES ('Trasa petla retkinia do Mickiewicza - Żeromskiego', @roadGeometry2);

DECLARE @roadGeometry3 GEOGRAPHY;
SET @roadGeometry3 = geography::STLineFromText('LINESTRING(51.75814656346606 19.449168774079943, 51.75829557347975 19.433621136091748, 51.76835419405131 19.426154913953784)', 4326);
SET @roadGeometry3 = @roadGeometry3.MakeValid();

INSERT INTO BusWay (name, geom) VALUES ('Trasa Mickiewicza - Żeromskiego do Włókniarzy - Legionów', @roadGeometry3);

DECLARE @roadGeometry4 GEOGRAPHY;
SET @roadGeometry4 = geography::STLineFromText('LINESTRING(51.76835419405131 19.426154913953784, 51.75829557347975 19.433621136091748, 51.75814656346606 19.449168774079943)', 4326);
SET @roadGeometry4 = @roadGeometry4.MakeValid();

INSERT INTO BusWay (name, geom) VALUES ('Trasa Włókniarzy - Legionów do Mickiewicza - Żeromskiego', @roadGeometry4);


-- Dodanie przystanków

DECLARE @pointGeometry13 GEOGRAPHY;
SET @pointGeometry13 = geography::STPointFromText('POINT(51.76835419405131 19.426154913953784)', 4326);
SET @pointGeometry13 = @pointGeometry13.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Włókniarzy - Legionów (1302)', @pointGeometry13);

DECLARE @pointGeometry12 GEOGRAPHY;
SET @pointGeometry12 = geography::STPointFromText('POINT(51.75829557347975 19.433621136091748)', 4326);
SET @pointGeometry12 = @pointGeometry12.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Włókniarzy - Karolewska (Dw. Ł. Kaliska) (1297)', @pointGeometry12);

DECLARE @pointGeometry11 GEOGRAPHY;
SET @pointGeometry11 = geography::STPointFromText('POINT(51.75814656346606 19.449168774079943)', 4326);
SET @pointGeometry11 = @pointGeometry11.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Mickiewicza - Żeromskiego (0577)', @pointGeometry11);

DECLARE @pointGeometry10 GEOGRAPHY;
SET @pointGeometry10 = geography::STPointFromText('POINT(51.75584979687422 19.43253509209079)', 4326);
SET @pointGeometry10 = @pointGeometry10.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Bandurskiego - Dw. Łódź Kaliska', @pointGeometry10);

DECLARE @pointGeometry9 GEOGRAPHY;
SET @pointGeometry9 = geography::STPointFromText('POINT(51.75257680272246 19.425371845051)', 4326);
SET @pointGeometry9 = @pointGeometry9.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Karolewska - Wileńska (0257)', @pointGeometry9);

DECLARE @pointGeometry8 GEOGRAPHY;
SET @pointGeometry8 = geography::STPointFromText('POINT(51.74983119554832 19.423309566714764)', 4326);
SET @pointGeometry8 = @pointGeometry8.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Bratysławska - Wróblewskiego (0045)', @pointGeometry8);

DECLARE @pointGeometry7 GEOGRAPHY;
SET @pointGeometry7 = geography::STPointFromText('POINT(51.747874986889556 19.42111297501415)', 4326);
SET @pointGeometry7 = @pointGeometry7.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Karolew (2301)', @pointGeometry7);

DECLARE @pointGeometry6 GEOGRAPHY;
SET @pointGeometry6 = geography::STPointFromText('POINT(51.74748933433701 19.41791407607441)', 4326);
SET @pointGeometry6 = @pointGeometry6.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Wyszyńskiego - Waltera-Janke (1378)', @pointGeometry6);

DECLARE @pointGeometry5 GEOGRAPHY;
SET @pointGeometry5 = geography::STPointFromText('POINT(51.74761789965939 19.413370784677067)', 4326);
SET @pointGeometry5 = @pointGeometry5.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Wyszyńskiego - os. Piaski (1376)', @pointGeometry5);

DECLARE @pointGeometry4 GEOGRAPHY;
SET @pointGeometry4 = geography::STPointFromText('POINT(51.74808447618714 19.404966689640226)', 4326);
SET @pointGeometry4 = @pointGeometry4.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Wyszynskiego - Retkinska (1384)', @pointGeometry4);

DECLARE @pointGeometry3 GEOGRAPHY;
SET @pointGeometry3 = geography::STPointFromText('POINT(51.746400187644845 19.39882325024777)', 4326);
SET @pointGeometry3 = @pointGeometry3.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Wyszynskiego - Armii Krajowej (1386)', @pointGeometry3);

DECLARE @pointGeometry2 GEOGRAPHY;
SET @pointGeometry2 = geography::STPointFromText('POINT(51.74451952698091 19.392189691337567)', 4326);
SET @pointGeometry2 = @pointGeometry2.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Blok 270 (1386)', @pointGeometry2);

DECLARE @pointGeometry1 GEOGRAPHY;
SET @pointGeometry1 = geography::STPointFromText('POINT(51.742146944442815 19.38449458219283)', 4326);
SET @pointGeometry1 = @pointGeometry1.MakeValid();

INSERT INTO BusStop (name, geom) VALUES ('Retkinia (1370)', @pointGeometry1);


-- Dodanie petli autobusowej

DECLARE @rectangleGeometry GEOGRAPHY;
SET @rectangleGeometry = geography::STGeomFromText('POLYGON((51.742146944442815 19.38449458219283, 51.742349 19.383290, 51.741925 19.383617, 51.742195 19.384225, 51.742146944442815 19.38449458219283))', 4326);
SET @rectangleGeometry = @rectangleGeometry.MakeValid();

INSERT INTO BusLoop (name, geom) VALUES ('Petla retkinia', @rectangleGeometry);

DECLARE @rectangleGeometry2 GEOGRAPHY;
SET @rectangleGeometry2 = geography::STGeomFromText('POLYGON((51.747874986889556 19.42111297501415, 51.74682048207058 19.421129871884144, 51.746659375000455 19.4205013087381, 51.74763228557784 19.419700397632656, 51.747874986889556 19.42111297501415))', 4326);
SET @rectangleGeometry2 = @rectangleGeometry2.MakeValid();

INSERT INTO BusLoop (name, geom) VALUES ('Petla Karolew', @rectangleGeometry2);