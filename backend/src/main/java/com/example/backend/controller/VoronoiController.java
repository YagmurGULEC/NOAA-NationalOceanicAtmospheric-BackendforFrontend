package com.example.backend.controller;

import org.springframework.web.bind.annotation.*;
import com.example.backend.model.VoronoiPolygon;
import com.example.backend.service.VoronoiPolygonService;
import org.locationtech.jts.geom.Polygon;
import org.locationtech.jts.geom.Coordinate;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/voronoi")
public class VoronoiController {
    private final VoronoiPolygonService service;

    public VoronoiController(VoronoiPolygonService service) {
        this.service = service;
    }

    @GetMapping("/bbox")
    public Map<String, Object> getVoronoiPolygonsByBoundingBox(
            @RequestParam double minLon, @RequestParam double minLat,
            @RequestParam double maxLon, @RequestParam double maxLat) {

        List<VoronoiPolygon> polygons = service.getPolygonsByBoundingBox(minLon, minLat, maxLon, maxLat);

        return Map.of(
            "type", "FeatureCollection",
            "features", polygons // Automatically serialized as GeoJSON
        );
    }
    @GetMapping("/polygons")
    public Map<String, Object> getVoronoiPolygons(@RequestParam int limit) {

        List<VoronoiPolygon> polygons = service.getPolygons(limit);

        return Map.of(
            "type", "FeatureCollection",
            "features", polygons // Automatically serialized as GeoJSON
        );
    }
}