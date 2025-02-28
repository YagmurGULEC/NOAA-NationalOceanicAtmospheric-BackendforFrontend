"use client"; // Ensures this component is only rendered on the client

import dynamic from "next/dynamic";
import "leaflet/dist/leaflet.css";

const Map = dynamic(() => import("./LeafletMap"), { ssr: false });

const MapComponent: React.FC = () => {
  return (
    <div>
      <h1>Next.js Leaflet Map</h1>
      <Map />
    </div>
  );
};

export default MapComponent;
