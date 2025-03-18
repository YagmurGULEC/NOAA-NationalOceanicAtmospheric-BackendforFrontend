-- Updated geo.station_data table, directly referencing geo.datasets(name)
CREATE TABLE IF NOT EXISTS geo.station_data (
    id SERIAL PRIMARY KEY,
    dataset_name TEXT NOT NULL,  -- Foreign key to geo.datasets(name)
    station_id TEXT NOT NULL,  -- Foreign key to geo.stations(id)
    date TIMESTAMP NOT NULL,
    datatype TEXT NOT NULL,
    attributes TEXT,
    value NUMERIC,
    FOREIGN KEY (dataset_name) REFERENCES geo.datasets(name) ON DELETE CASCADE,
    FOREIGN KEY (station_id) REFERENCES geo.stations(id) ON DELETE CASCADE
);