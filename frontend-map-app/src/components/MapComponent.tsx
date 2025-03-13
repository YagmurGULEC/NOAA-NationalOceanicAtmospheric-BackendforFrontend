"use client"; // Ensures this component is only rendered on the client

import dynamic from "next/dynamic";
import "leaflet/dist/leaflet.css";

const Map = dynamic(() => import("./DeckMap"), { ssr: false });

const MapComponent: React.FC = () => {
  return (
    <div>

      <Map />
    </div>
  );
};

export default MapComponent;
