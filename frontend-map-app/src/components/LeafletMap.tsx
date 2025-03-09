"use client"; // Ensures this runs only on the client

import { useState, useEffect, useRef } from "react";
import { MapContainer, TileLayer, CircleMarker,Marker, Popup, useMapEvents } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

const position: [number, number] = [51.505, -0.09];

const MapWithEvents: React.FC<{
  setBounds: (bounds: L.LatLngBounds) => void;
  setZoom: (zoom: number) => void;
  setPoints: (points: { lat: number; lng: number }[]) => void;
}> = ({ setBounds, setZoom, setPoints }) => {
  const map = useMapEvents({
    moveend: () => {
      const newBounds = map.getBounds();
      setBounds(newBounds);
      setZoom(map.getZoom());
      generatePointsInsideBounds(newBounds);
    },
    zoomend: () => {
      const newBounds = map.getBounds();
      setBounds(newBounds);
      setZoom(map.getZoom());
      generatePointsInsideBounds(newBounds);
    },
  });

  // Generate random points inside the bounding box
  const generatePointsInsideBounds = (bounds: L.LatLngBounds) => {
    const numPoints = 5; // Number of points to generate
    const newPoints = [];

    for (let i = 0; i < numPoints; i++) {
      const lat =
        bounds.getSouthWest().lat +
        Math.random() * (bounds.getNorthEast().lat - bounds.getSouthWest().lat);
      const lng =
        bounds.getSouthWest().lng +
        Math.random() * (bounds.getNorthEast().lng - bounds.getSouthWest().lng);
      newPoints.push({ lat, lng });
    }

    setPoints(newPoints);
  };

  return null;
};

const LeafletMap: React.FC = () => {
  const [bounds, setBounds] = useState<L.LatLngBounds | null>(null);
  const [zoom, setZoom] = useState<number>(13);
  const [points, setPoints] = useState<{ lat: number; lng: number }[]>([]);
  const mapRef = useRef<L.Map | null>(null);

  useEffect(() => {
    if (mapRef.current && !bounds) {
      const initialBounds = mapRef.current.getBounds();
      setBounds(initialBounds);
      generateInitialPoints(initialBounds);
    }
  }, [mapRef.current]);

  // Generate points when the map is first created
  const generateInitialPoints = (bounds: L.LatLngBounds) => {
    if (!bounds) return;
    console.log("Generating initial points...");
    const numPoints = 5; // Number of points to generate
    const newPoints = [];

    for (let i = 0; i < numPoints; i++) {
      const lat =
        bounds.getSouthWest().lat +
        Math.random() * (bounds.getNorthEast().lat - bounds.getSouthWest().lat);
      const lng =
        bounds.getSouthWest().lng +
        Math.random() * (bounds.getNorthEast().lng - bounds.getSouthWest().lng);
      newPoints.push({ lat, lng });
    }

    setPoints(newPoints);
  };

  return (
    <div style={{ position: "absolute", top: 0, left: 0, width: "90vw", height: "100vh" }}>
      <MapContainer
        center={position}
        zoom={zoom}
        style={{ width: "100%", height: "100%" }}
        whenCreated={(map) => {
          mapRef.current = map;
          setBounds(map.getBounds());
          setZoom(map.getZoom());
          generateInitialPoints(map.getBounds());
        }}
      >
        {/* Base map with no roads */}
                <TileLayer
                  url="https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png"
                  attribution='&copy; OpenStreetMap contributors'
                />


        <Marker position={position}>
          <Popup>A simple Leaflet map in Next.js</Popup>
        </Marker>


     {/* Draw Points as Circles */}
            {points.map((point, index) => (
              <CircleMarker
                key={index}
                center={[point.lat, point.lng]}
                radius={5} // Adjust point size
                color="red" // Outline color
                fillColor="red" // Fill color
                fillOpacity={0.8} // Adjust opacity
              >
                <Popup>
                  Point {index + 1} <br />
                  {point.lat.toFixed(5)}, {point.lng.toFixed(5)}
                </Popup>
              </CircleMarker>
            ))}


        {/* Handle map events */}
        <MapWithEvents setBounds={setBounds} setZoom={setZoom} setPoints={setPoints} />
      </MapContainer>


    </div>
  );
};

export default LeafletMap;
