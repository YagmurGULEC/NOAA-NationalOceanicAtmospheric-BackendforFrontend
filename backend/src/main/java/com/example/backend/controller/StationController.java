package com.example.backend.controller;

import org.springframework.web.bind.annotation.*;
import com.example.backend.service.StationService;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.example.backend.model.Station;

@RestController
@RequestMapping("/stations")
public class StationController {
    private final StationService stationService;
    public StationController(StationService stationService) {
        this.stationService = stationService;
    }
  @GetMapping("/bbox")
    public Map<String, Object> getStationsInBoundingBox(
            @RequestParam double minLng,
            @RequestParam double minLat,
            @RequestParam double maxLng,
            @RequestParam double maxLat) {

        List<Station> stations = stationService.getStationsInBoundingBox(minLng, minLat, maxLng, maxLat);

        return Map.of(
            "type", "FeatureCollection",
            "features", stations // Automatically serialized as GeoJSON
        );
    }
    
}