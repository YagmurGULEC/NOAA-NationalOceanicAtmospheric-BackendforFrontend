COPY geo.station_data (dataset_name, station_id, date, datatype, attributes, value)
FROM '/docker-entrypoint-initdb.d/all_tavg_gsom.csv'
DELIMITER ','
CSV HEADER;