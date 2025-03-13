"use client";
import React, { useEffect, useState } from "react";
import DeckGL, { LayersList } from "deck.gl";
import { Map } from "react-map-gl/maplibre";
// import { GeoJsonLayer } from "@deck.gl/layers";
import { HeatmapLayer } from "@deck.gl/aggregation-layers";
// import { FeatureCollection, Point } from "geojson"; // ✅ Import GeoJSON types
import "maplibre-gl/dist/maplibre-gl.css";



// Initial view state
const INITIAL_VIEW_STATE = {
    latitude: 51.47,
    longitude: 0.45,
    zoom: 4,
    bearing: 0,
    pitch: 0,
};

export default function DeckMap() {
    // const [polygonData, setPolygonData] = useState<any>(null);
    // const [pointData, setPointData] = useState<FeatureCollection<Point> | null>(null);
    const [layers, setLayers] = useState<LayersList>([]);
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

                setLayers([
                    new HeatmapLayer({
                        id: "heatmap-layer",
                        data: data.features, // ✅ Pass only the array of features
                        getPosition: (d) => d.geometry.coordinates as [number, number], // ✅ Type fixed
                        getWeight: (d) => d.properties?.intensity || 1, // ✅ Use intensity if available
                        radiusPixels: 30,
                    }),
                ]);

                console.log(data.features.length, "points fetched");
            } catch (error) {
                console.error("Error fetching point data:", error);
            }
        }
        fetchPoints();
    }, []);

    return (
        <DeckGL controller={true} initialViewState={INITIAL_VIEW_STATE} layers={layers}>

            <Map
                mapStyle="https://basemaps.cartocdn.com/gl/positron-gl-style/style.json" // OpenStreetMap style
            />


        </DeckGL>

    );
}
