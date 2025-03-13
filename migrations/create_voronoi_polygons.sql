CREATE TABLE IF NOT EXISTS geo.voronoi_polygons (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY(Polygon, 4326)
);

INSERT INTO geo.voronoi_polygons (geom)
WITH voronoi AS (
    SELECT ST_Dump(ST_VoronoiPolygons(ST_Collect(geom))) AS geom
    FROM geo.stations
)
SELECT (geom).geom FROM voronoi;