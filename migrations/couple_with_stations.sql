ALTER TABLE geo.voronoi_polygons ADD COLUMN station_id TEXT;

UPDATE geo.voronoi_polygons v
SET station_id = s.id
FROM geo.stations s
WHERE ST_Contains(v.geom, s.geom);