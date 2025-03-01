import asyncio
import aiofiles
import glob
import json
import csv
import aiohttp
import os
import random
import pandas as pd

MAX_CONCURRENT_REQUESTS = 5  # Limit concurrent API requests
semaphore_api = asyncio.Semaphore(MAX_CONCURRENT_REQUESTS)
semaphore = asyncio.Semaphore(50)
# Directory containing JSON files
JSON_DIR = "../api_responses/station/"
OUTPUT_CSV = "output_stations.csv"
API_KEY="fYtUjDsUnAwZJHAUEwNpZMoktpvwRUIZ"
BASE_URL="https://www.ncei.noaa.gov/cdo-web/api/v2"

async def read_json(data):
    """Asynchronously read a JSON file and extract required fields."""
    async with semaphore:
        try:
            results = data.get("results", [])  # Extract 'results' array if it exists

            processed_data = []

            for record in results:
                try:

                    station_id = record["id"]
                    name = record["name"]
                    latitude = record["latitude"]
                    longitude = record["longitude"]
                    geom = f"SRID=4326;POINT({longitude} {latitude})"

                    processed_data.append((station_id, name, geom))
                except KeyError:
                    print(f"⚠️ Missing fields in {file_path}: {record}")

            return processed_data

        except json.JSONDecodeError:
            print(f"❌ Error parsing {file_path}")
            return []

async def read_json_file(file):
    """Read JSON files and extract required fields."""
    async with semaphore:
        async with aiofiles.open(file, "r", encoding="utf-8") as f:
            try:
                data = json.loads(await f.read())
                try:
                    results=data.get("results", [])
                    processed_data = []
                    for res in results:
                        try:
                            station_id = res["id"]
                            name = res["name"]
                            latitude = res["latitude"]
                            longitude = res["longitude"]
                            geom = f"SRID=4326;POINT({longitude} {latitude})"
                            processed_data.append((station_id, name, geom))
                        except KeyError:
                            print(f"⚠️ Missing fields in {file}: {res}")
                    write_to_csv(processed_data)
                    return processed_data

                except KeyError:
                    print(f"⚠️ Missing 'results' field in {file}")
                    return None

            except json.JSONDecodeError:
                print(f"❌ Error parsing {file}")
                return None

async def fetch_data(session, offset,attempt=1):
    """Asynchronously fetch data from the API with retry logic."""
    headers = {
        "token": API_KEY,
        "Content-Type": "application/json"
    }
    url = f"{BASE_URL}/stations?limit=100&offset={offset}"

    async with semaphore_api:  # Limit concurrent API calls

        try:
            async with session.get(url, headers=headers, timeout=50) as response:
                if response.status == 200:
                    data = await response.json()  # Parse JSON response
                    await write_to_json(data,offset)  # Write to JSON file
                    return data  # ✅ Success

                else:
                    print(f"❌ Error fetching {url}: {response.status}")
                    return None

        except Exception as e:
            print(f"❌ Error fetching {url}: {e}")
            return None


async def fetch_all_data(offsets):
    """Fetch all data from the API asynchronously."""

    async with aiohttp.ClientSession() as session:
        tasks = [fetch_data(session, offset) for offset in offsets]
        results = await asyncio.gather(*tasks)
        return results


def write_to_csv(data):
    """Writes API response data to CSV."""
    if not data:
        print("❌ No data to write!")
        return
    file_exists = os.path.isfile(OUTPUT_CSV)  # Check if file exists
    with open(OUTPUT_CSV, mode='a', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["id", "name", "geom"])  # CSV Header

        for record in data:
            try:

                station_id = record[0]
                name = record[1]
                geom = record[2]
                writer.writerow([station_id, name, geom])  # Write each row
            except KeyError:
                print(f"⚠️ Missing fields in response: {record}")

async def main():
#     files=glob.glob(f"{JSON_DIR}*.json")
# #     files=files[:1]
#     print (f"Total files: {len(files)}")
#     tasks = [read_json_file(file) for file in files]
#     results = await asyncio.gather(*tasks)
#     data = [record for result in results if result for record in result]
#     print (len(data))
    df=pd.read_csv(OUTPUT_CSV)
    df.drop_duplicates(subset=['id'], inplace=True)
    print (df.shape)
#     df.to_csv(OUTPUT_CSV,index=False)


asyncio.run(main())
