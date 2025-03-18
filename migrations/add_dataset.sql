
CREATE TABLE IF NOT EXISTS geo.datasets (
    name TEXT PRIMARY KEY,  -- Name of the dataset (e.g., "Temperature Data April 2023")
    description TEXT NOT NULL  -- Description of the dataset (e.g., "Temperature data for April 2023")
);

INSERT INTO geo.datasets (name, description) VALUES ('GSOM', 'Global Surface Summary of the Month');
