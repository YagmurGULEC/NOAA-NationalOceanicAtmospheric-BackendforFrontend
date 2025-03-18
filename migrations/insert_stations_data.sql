COPY geo.station_data (dataset_name, station_id, date, datatype, attributes, value)
FROM '/docker-entrypoint-initdb.d/examples.csv'
DELIMITER ','
CSV HEADER;