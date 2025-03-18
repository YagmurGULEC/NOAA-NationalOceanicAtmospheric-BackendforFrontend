SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'geo';

SELECT * FROM geo.station_data JOIN geo.stations ON station_data.station_id = stations.id 
JOIN geo.datasets ON station_data.dataset_name = datasets.name 
WHERE station_data.dataset_name='GSOM' AND station_data.datatype='TAVG' ORDER BY station_data.date DESC LIMIT 10;

