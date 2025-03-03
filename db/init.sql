-- Enable PostGIS Extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create schema
CREATE SCHEMA IF NOT EXISTS geo;

-- Create table in the schema
CREATE TABLE IF NOT EXISTS geo.stations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    geom GEOMETRY(Point, 4326)
);

