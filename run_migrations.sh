#!/bin/bash

set -e  # Stop the script on any error

DB_NAME="noaa_database"
CONTAINER_NAME="postgis-database"
POSTGRES_USER="noaa_user"
DESTINATION="docker-entrypoint-initdb.d"

# Function to check if the database exists
check_db_exists() {
    DB_EXIST=$(docker exec -it "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d postgres -tA -c "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")
    if [ -z "$DB_EXIST" ]; then
        echo "❌ Database does not exist."
        exit 1
    else
        echo "✅ Database '$DB_NAME' already exists."
    fi
}

# Function to check if the table exists
check_table_exists() {
    TABLE_EXIST=$(docker exec -it "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d "$DB_NAME" -tA -c "SELECT 1 FROM information_schema.tables WHERE table_schema='geo' AND table_name='stations';")
    if [ -z "$TABLE_EXIST" ]; then
        echo "❌ Table does not exist."
        exit 1
    else
        echo "✅ Table 'geo.stations' already exists."
    fi
}

copy_csv_to_container() {
    files=$(ls migrations/*.csv)
    # shellcheck disable=SC2034
    for file in $files; do
      echo "🚀 Copying CSV file: $file"
      docker cp "$file" "$CONTAINER_NAME":"$DESTINATION"/.
    done

    echo "✅ CSV file copied: $CSV_FILE"
}

# Function to apply a migration SQL file
apply_migration() {
    MIGRATION_FILE="$1"

    if [ ! -f "./migrations/$MIGRATION_FILE" ]; then
        echo "❌ Migration file '$MIGRATION_FILE' not found."
        exit 1
    fi

    echo "🚀 Applying migration: $MIGRATION_FILE"

    docker cp "./migrations/$MIGRATION_FILE" "$CONTAINER_NAME":"$DESTINATION"/.
    docker exec -it "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d "$DB_NAME" -f "$DESTINATION/$MIGRATION_FILE"

    echo "✅ Migration applied: $MIGRATION_FILE"
}

# 1️⃣ Check if database and table exist
check_db_exists
check_table_exists

if [ "$#" -eq 0 ]; then
    echo "❌ No migration specified. Use 'all' to apply all migrations or specify a file."
    exit 1
fi

if [ "$1" == "all" ]; then
    copy_csv_to_container
    echo "🔄 Applying all migrations..."
    for file in migrations/*.sql; do
        apply_migration "$(basename "$file")"
    done
elif [ "$1" == "create_geojson" ]; then
    echo "🔄 Generating Separate GeoJSON Files for Voronoi Polygons & Station Points"

    HOST_VORONOI="./voronoi.json"  # On the host
    HOST_STATIONS="./stations.json"

    # Bounding box coordinates (modify as needed)
    MIN_LON="-73.99"
    MIN_LAT="40.70"
    MAX_LON="-73.97"
    MAX_LAT="40.72"

    # Query Voronoi Polygons
    docker exec -i "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d "$DB_NAME" -t -A -c "
        
           SELECT json_build_object(
            'type', 'FeatureCollection',
            'features', json_agg(
                json_build_object(
                    'type', 'Feature',
                    'geometry', ST_AsGeoJSON(v.geom)::jsonb,
                    'properties', jsonb_build_object(
                        'id', v.id,
                        'station_id', v.station_id
                    )
                )
            )
        )
        FROM geo.voronoi_polygons v
        WHERE v.geom && ST_MakeEnvelope($MIN_LON, $MIN_LAT, $MAX_LON, $MAX_LAT, 4326);
       
    "| jq . | tee "$HOST_VORONOI" > /dev/null

elif [ "$1" == "insert_station_data" ]; then
    echo "🔄 Inserting station data"
    echo "$CONTAINER_NAME":"$DESTINATION"/.
    docker cp ./migrations/all_tavg_gsom.csv "$CONTAINER_NAME":"$DESTINATION"/.
    cat ./migrations/insert_stations_data.sql | docker exec -i "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d "$DB_NAME"

elif [ "$1" == "get_schema" ]; then
    echo "🔄sGetting schema"
    cat ./migrations/query.sql | docker exec -i "$CONTAINER_NAME" psql -U "$POSTGRES_USER" -d "$DB_NAME"
else
    apply_migration "$1"

fi
