package com.example.backend.util;

import com.example.backend.model.VoronoiPolygon;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Polygon;
import java.io.IOException;
import java.util.*;

public class VoronoiPolygonGeoJsonSerializer extends JsonSerializer<VoronoiPolygon> {

    @Override
    public void serialize(VoronoiPolygon polygon, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        gen.writeStartObject(); // Start Feature object

        gen.writeStringField("type", "Feature");

        // Writing geometry
        gen.writeObjectFieldStart("geometry");
        gen.writeStringField("type", "Polygon");

        List<List<List<Double>>> coordinates = new ArrayList<>();
        if (polygon.getGeom() instanceof Polygon) {
            Polygon poly = polygon.getGeom();

            // Extract exterior ring
            List<List<Double>> exteriorRing = extractCoordinates(poly.getExteriorRing().getCoordinates());
            coordinates.add(exteriorRing);

            // Extract interior rings
            for (int i = 0; i < poly.getNumInteriorRing(); i++) {
                List<List<Double>> interiorRing = extractCoordinates(poly.getInteriorRingN(i).getCoordinates());
                coordinates.add(interiorRing);
            }
        }
        gen.writeArrayFieldStart("coordinates");
        for (List<List<Double>> ring : coordinates) {
            gen.writeStartArray();
            for (List<Double> coord : ring) {
                gen.writeArray(new double[]{coord.get(0), coord.get(1)}, 0, 2);
            }
            gen.writeEndArray();
        }
        gen.writeEndArray();
        gen.writeEndObject(); // End geometry

        // Writing properties
        gen.writeObjectFieldStart("properties");
        gen.writeNumberField("id", polygon.getId());
        gen.writeStringField("station_id", polygon.getStationId());
        gen.writeEndObject(); // End properties

        gen.writeEndObject(); // End Feature object
    }

    private List<List<Double>> extractCoordinates(Coordinate[] coordinates) {
        List<List<Double>> ring = new ArrayList<>();
        for (Coordinate coord : coordinates) {
            ring.add(Arrays.asList(coord.x, coord.y));
        }
        return ring;
    }
}
