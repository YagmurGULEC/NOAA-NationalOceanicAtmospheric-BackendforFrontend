"use client";
import React, { useEffect, useState } from "react";
import DeckGL, { LayersList } from "deck.gl";
import { Map } from "react-map-gl/maplibre";
import { GeoJsonLayer, ScatterplotLayer } from "@deck.gl/layers";
import { HeatmapLayer } from "@deck.gl/aggregation-layers";
import { DataFilterExtension, DataFilterExtensionProps } from '@deck.gl/extensions';
import { FeatureCollection, Point } from "geojson"; // ✅ Import GeoJSON types
import "maplibre-gl/dist/maplibre-gl.css";
import styles from "../app/page.module.css";
import ReactSlider from "react-slider";
import "bootstrap/dist/css/bootstrap.min.css";
import { time } from "console";


// Number of time steps available (e.g., 5 temperature records over time)
const TIME_STEPS = 5;
// Initial view state
const INITIAL_VIEW_STATE = {
    latitude: 51.47,
    longitude: 0.45,
    zoom: 2,
    bearing: 0,
    pitch: 0,
};

const layout = {

    sliders: [
        {
            active: 0,

        },
    ],
}
// Define a color scale for temperature values
const TEMP_COLORS = {
    cold: [0, 0, 255], // Blue (cold)
    cool: [0, 255, 255], // Cyan (cool)
    warm: [255, 165, 0], // Orange (warm)
    hot: [255, 0, 0], // Red (hot)
};
const getTempColor = (temp: number) => {
    if (temp <= 15) {
        return TEMP_COLORS.cold;
    } else if (temp <= 20) {
        return TEMP_COLORS.cool;
    } else if (temp <= 25) {
        return TEMP_COLORS.warm;
    } else {
        return TEMP_COLORS.hot;
    }
}

export default function DeckMap() {
    // const [polygonData, setPolygonData] = useState<any>(null);
    const [pointData, setPointData] = useState<any>(null);
    const [layers, setLayers] = useState<LayersList>([]);
    const [timestamps, setTimestamps] = useState<string[]>([]); // List of timestamps
    const [selectedTimestampIndex, setSelectedTimestampIndex] = useState(0);
    const [isPlaying, setIsPlaying] = useState(false);

    // Update Heatmap based on selected time step
    useEffect(() => {
        if (!pointData || timestamps.length === 0) {
            return;
        }
        const selectedTimestamp = timestamps[selectedTimestampIndex];
        setLayers([
            new ScatterplotLayer({
                id: `scatterplot-layer-${selectedTimestamp}`,
                data: pointData.filter(d => d.properties.Tavg[selectedTimestamp] !== undefined),
                getPosition: (d) => d.geometry.coordinates as [number, number],
                getRadius: 50000, // Circle size in meters
                getFillColor: (d) => getTempColor(d.properties.Tavg[selectedTimestamp]),
                pickable: true,
                opacity: 0.8,
            }),
        ]);

    }, [pointData, timestamps, selectedTimestampIndex]);

    // Handle slider change
    const handleSliderChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const newTimeStep = parseInt(event.target.value);
        setSelectedTimestampIndex(newTimeStep);

    };

    // Fetch Points
    useEffect(() => {
        async function fetchPoints() {
            try {
                const response = await fetch("http://localhost:8080/stations/bbox?minLng=-180&minLat=-90&maxLng=180&maxLat=90", {
                    method: "GET",
                    headers: {
                        "Content-Type": "application/json",
                    }
                });
                const data = await response.json();
                // Add time-varying temperature data
                const processedData = data.features.map((feature: { properties: any; }) => ({
                    ...feature,
                    properties: {
                        ...feature.properties,
                        Tavg: {

                            "2024-03-01": 15,
                            "2024-03-02": 20,
                            "2024-03-03": 25,
                            "2024-03-04": 30,
                            "2024-03-05": 35,
                        }

                    }
                }));
                // Extract unique sorted timestamps
                const uniqueTimestamps = [...new Set(processedData.flatMap((f: { properties: { Tavg: {}; }; }) => Object.keys(f.properties.Tavg)))]
                    .sort(); // Ensure timestamps are sorted in ascending order
                console.log(uniqueTimestamps);
                setPointData(processedData);
                setTimestamps(uniqueTimestamps as string[]);



            } catch (error) {
                console.error("Error fetching point data:", error);
            }
        }
        fetchPoints();
    }, []);
    // Toggle play/pause state and auto-advance timestamps when playing
    useEffect(() => {
        let interval: NodeJS.Timeout | null = null;
        if (isPlaying && timestamps.length > 0) {
            interval = setInterval(() => {
                setSelectedTimestampIndex((prevIndex) =>
                    prevIndex === timestamps.length - 1 ? 0 : prevIndex + 1
                );
            }, 1000); // Change the time interval as needed (e.g., 1000ms = 1 second)
        }
        return () => {
            if (interval) clearInterval(interval);
        };
    }, [isPlaying, timestamps]);
    return (
        <div className="container-fluid overflow-hidden">

            <DeckGL controller={true} initialViewState={INITIAL_VIEW_STATE} layers={layers}>
                <Map
                    mapStyle="https://basemaps.cartocdn.com/gl/positron-gl-style/style.json"

                />
            </DeckGL>
            {timestamps.length > 0 && (

                <div className={styles.sliderContainer}>

                    <input
                        type="range"
                        min={0}
                        max={timestamps.length - 1}
                        value={selectedTimestampIndex}
                        onChange={handleSliderChange}
                        className="form-range w-75 position-relative"
                        step={1}
                        list="tickmarks"



                    />
                    {/* Tick marks using datalist */}
                    <datalist id="tickmarks">
                        {timestamps.map((_, index) => (
                            <option key={index} value={index} />
                        ))}
                    </datalist>
                    {/* Tick Labels */}
                    {/* Tick Labels */}
                    <h4 className="text-center text-white mx-3">{timestamps[selectedTimestampIndex]}</h4>
                    <button className="btn btn-primary mx-3" onClick={() => setIsPlaying(!isPlaying)}>

                        {isPlaying ? "Pause" : "Play"}
                    </button>

                </div>
            )}



        </div>


    );

}
