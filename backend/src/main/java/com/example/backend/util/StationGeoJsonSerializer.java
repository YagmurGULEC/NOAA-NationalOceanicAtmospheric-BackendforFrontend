package com.example.backend.util;

import com.example.backend.model.Station;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Point;
import java.io.IOException;
import java.util.*;

public class StationGeoJsonSerializer extends JsonSerializer<Station> {

    @Override
    public void serialize(Station station, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        gen.writeStartObject(); // Start Feature object

        gen.writeStringField("type", "Feature");

        // Writing geometry
        gen.writeObjectFieldStart("geometry");
        gen.writeStringField("type", "Point");

        if (station.getGeom() instanceof Point) {
            Point point = (Point) station.getGeom();
            List<Double> coordinates = Arrays.asList(point.getX(), point.getY());
            gen.writeArrayFieldStart("coordinates");
            for (Double coord : coordinates) {
                gen.writeNumber(coord);
            }
            gen.writeEndArray();
        }

        gen.writeEndObject(); // End geometry

        // Writing properties
        gen.writeObjectFieldStart("properties");
        gen.writeStringField("id", station.getId());
        gen.writeStringField("name", station.getName());
        gen.writeEndObject(); // End properties

        gen.writeEndObject(); // End Feature object
    }
}
