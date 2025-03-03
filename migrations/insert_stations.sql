CREATE TEMP TABLE temp_stations (
    id TEXT,
    name TEXT,
    geom_text TEXT
);

COPY temp_stations(id, name, geom_text)
FROM '/docker-entrypoint-initdb.d/stations.csv'
DELIMITER ',' CSV HEADER;

INSERT INTO geo.stations (id, name, geom)
SELECT id, name, ST_GeomFromEWKT(geom_text)
FROM temp_stations;