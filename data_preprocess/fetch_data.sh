#!/bin/bash

BASE_URL="https://www.ncei.noaa.gov/cdo-web/api/v2"

END_DATE=$(date +"%Y-%m-%d")
# END_DATE="2023-03-14"
START_DATE=$(date -d "$END_DATE -1 year" +"%Y-%m-%d")
START_OFFSET=1000
LIMIT=1000
TOTAL_COUNT=1989972
OUTPUT_DIR="./data"
DATATYPE=("TAVG")
# mapfile -t DATATYPE < <(jq -r 'keys[:1][]' datatypes_merged.json)

mapfile -t DATASET_ID < <(jq -r 'keys[:1][]' datasets_merged.json)

for ds in "${DATASET_ID[@]}"; do
    echo "Dataset ID: $ds"
done


# # ✅ Export variables for parallel execution 
export  BASE_URL OUTPUT_DIR LIMIT START_OFFSET START_DATE END_DATE
mkdir -p "${OUTPUT_DIR}"

for dt in "${DATATYPE_ID[@]}"; do
    echo "Dataset ID: $dt"
   
done
fetch_page() {
  
    local offset="$1"
    local dataset_id="$2"
    local datatype_id="$3"
    local max_retries=5
    local retry_delay=2
    local attempt=1 
    
    mkdir -p "${OUTPUT_DIR}/${dataset_id}/${datatype_id}/${START_DATE}_${END_DATE}"
    FILE_NAME="${OUTPUT_DIR}/${dataset_id}/${datatype_id}/${START_DATE}_${END_DATE}/${offset}"
    echo $FILE_NAME
    while [ "$attempt" -le "$max_retries" ]; do
        echo "🆔 Running PID $$ for offset=$offset on endpoint=$endpoint (Attempt $attempt)"
        # URL="$BASE_URL/data?datasetid=$dataset_id&offset=$offset&limit=$LIMIT&startdate=$START_DATE&enddate=$END_DATE"
        URL="$BASE_URL/data?datasetid=$dataset_id&datatypeid=$datatype_id&offset=$offset&limit=$LIMIT&startdate=$START_DATE&enddate=$END_DATE"
        echo "Requesting: $URL"
        echo "$URL"
        RESPONSE=$(curl -s -X GET "$URL" -H "Token: $NOAA_API_KEY")

        # ✅ Check if response is valid JSON
        if ! echo "$RESPONSE" | jq empty 2>/dev/null; then
            echo "🚨 ERROR: Invalid JSON received (Attempt $attempt). Retrying in $retry_delay seconds..."
            echo "$RESPONSE" > "$FILENAME.txt"
            sleep "$retry_delay"
            ((attempt++))
            continue
        fi

        # ✅ Check if "results" exists and is not empty
        if ! echo "$RESPONSE" | jq 'has("results") and (.results | length > 0)' 2>/dev/null | grep -q true; then
            echo "🚨 ERROR: 'results' is missing or empty (Attempt $attempt). Retrying in $retry_delay seconds..."
            echo "$RESPONSE" > "$FILE_NAME.txt"
            sleep "$retry_delay"
            ((attempt++))
            continue
        fi

        # ✅ If everything is fine, save the response
        echo "$RESPONSE" | jq . > "$FILE_NAME.json"
        echo "✅ Saved: $FILE_NAME.json"
        return 0
    done

    echo "❌ Failed after $max_retries attempts for offset=$offset. Skipping..."
}


export -f fetch_page


OFFSETS=$(seq "$START_OFFSET" "$LIMIT" "$TOTAL_COUNT")
# # ✅ Run parallel for dataset_id and datatype_id
parallel --delay 0.2 -j5 fetch_page ::: "${OFFSETS[@]}" ::: "${DATASET_ID[@]}" ::: "${DATATYPE[@]}"&

# # ✅ Wait for parallel execution to finish
wait $!



