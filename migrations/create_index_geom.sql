CREATE INDEX IF NOT EXISTS stations_geom_idx
ON geo.stations
USING GIST (geom);
