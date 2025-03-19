#!/bin/bash

# Default values (if arguments are not provided)
DEFAULT_OUTPUT_DIR="api_responses"
DEFAULT_TOTAL_COUNT=100
DEFAULT_LIMIT=100
DEFAULT_START_OFFSET=0
DEFAULT_ENDPOINTS=("stations")


API_KEY="fYtUjDsUnAwZJHAUEwNpZMoktpvwRUIZ"
BASE_URL="https://www.ncei.noaa.gov/cdo-web/api/v2"


START_OFFSET="${1:-$DEFAULT_START_OFFSET}"
LIMIT="${2:-$DEFAULT_LIMIT}"
TOTAL_COUNT="${3:-$DEFAULT_TOTAL_COUNT}"
OUTPUT_DIR="${4:-$DEFAULT_OUTPUT_DIR}"
shift 4  # ✅ Shift arguments correctly
ENDPOINTS=("$@")  # ✅ Store remaining arguments as endpoints


# ✅ Fix: If no endpoints are provided, use the default
if [ ${#ENDPOINTS[@]} -eq 0 ]; then
    ENDPOINTS=("${DEFAULT_ENDPOINTS[@]}")
fi

# ✅ Fix: Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# ✅ Export variables for parallel execution
export API_KEY BASE_URL OUTPUT_DIR LIMIT
export LIMIT TOTAL_COUNT START_OFFSET ENDPOINTS




fetch_page() {
    local endpoint="$1"
    local offset="$2"

    local max_retries=5
    local retry_delay=2
    local attempt=1 
    echo "$endpoint"
    mkdir -p "$OUTPUT_DIR/$endpoint"
    while [ "$attempt" -le "$max_retries" ]; do
        echo "🆔 Running PID $$ for offset=$offset on endpoint=$endpoint (Attempt $attempt)"
        URL="$BASE_URL/$endpoint?offset=$offset&limit=$LIMIT"
        echo "Requesting: $URL"

        RESPONSE=$(curl -s -X GET "$URL" -H "Token: $API_KEY")

        # ✅ Check if response is valid JSON
        if ! echo "$RESPONSE" | jq empty 2>/dev/null; then
            echo "🚨 ERROR: Invalid JSON received (Attempt $attempt). Retrying in $retry_delay seconds..."
            echo "$RESPONSE" > "${OUTPUT_DIR}/${endpoint}/${endpoint}_offset_${offset}_error.txt"
            sleep "$retry_delay"
            ((attempt++))
            continue
        fi

        # ✅ Check if "results" exists and is not empty
        if ! echo "$RESPONSE" | jq 'has("results") and (.results | length > 0)' 2>/dev/null | grep -q true; then
            echo "🚨 ERROR: 'results' is missing or empty (Attempt $attempt). Retrying in $retry_delay seconds..."
            echo "$RESPONSE" > "${OUTPUT_DIR}/${endpoint}/${endpoint}_offset_${offset}_error.txt"
            sleep "$retry_delay"
            ((attempt++))
            continue
        fi

        # ✅ If everything is fine, save the response
        echo "$RESPONSE" | jq . > "${OUTPUT_DIR}/${endpoint}/${endpoint}_offset_${offset}.json"
        echo "✅ Saved: ${OUTPUT_DIR}/${endpoint}/${endpoint}_offset_${offset}.json"
        return 0
    done

    echo "❌ Failed after $max_retries attempts for offset=$offset. Skipping..."
}


check_file() {
    local file_path="$1"
    local offset="$2"
    local total_count="$3"
    local limit="$4"

    # ✅ Check if the file exists
    if [ ! -f "$file_path" ]; then
        echo "🚨 ERROR: File $file_path does not exist."
        return 1
    fi

    # ✅ Check if the JSON is valid
    if ! jq empty "$file_path" 2>/dev/null; then
        echo "🚨 ERROR: Invalid JSON in $file_path"
        return 1
    fi

    # ✅ Check if the file contains a "results" array and count its elements
    local count
    count=$(jq '.results | length' "$file_path" 2>/dev/null)

    if [ -z "$count" ] || [ "$count" -eq 0 ]; then
        echo "🚨 ERROR: 'results' is missing or empty in $file_path (offset=$offset)"
        return 1
    fi

    # ✅ Check if the number of records matches the expected limit
    if [ "$count" -lt "$limit" ]; then
        echo "⚠️ WARNING: $file_path has only $count records (expected at least $limit, offset=$offset)."
    else
        echo "✅ OK: $file_path contains $count records."
    fi
}

export -f fetch_page check_file

# shellcheck disable=SC2207
#files=($(find "$OUTPUT_DIR" -name "*.json" | sort ))


OFFSETS=$(seq "$START_OFFSET" "$LIMIT" "$TOTAL_COUNT")
# for offset in $OFFSETS; do
#    echo "🔍 Checking offset: $offset"
#     for endpoint in "${ENDPOINTS[@]}"; do
#         check_file "${OUTPUT_DIR}/${endpoint}_offset_${offset}.json" "$offset" "$TOTAL_COUNT" "$LIMIT"
#     done
# done
#

# ## ✅ Fix: Ensure offsets are correctly passed to parallel
parallel --delay 0.2 -j5 fetch_page ::: "${ENDPOINTS[@]}" ::: $OFFSETS &
wait $!  # ✅ Wait for parallel process to finish



