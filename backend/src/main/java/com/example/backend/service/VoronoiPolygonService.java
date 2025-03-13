package com.example.backend.service;

import com.example.backend.model.VoronoiPolygon;
import com.example.backend.repository.VoronoiPolygonRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VoronoiPolygonService {

    private final VoronoiPolygonRepository repository;

    public VoronoiPolygonService(VoronoiPolygonRepository repository) {
        this.repository = repository;
    }

    public List<VoronoiPolygon> getPolygonsByBoundingBox(double minLon, double minLat, double maxLon, double maxLat) {
        return repository.findByBoundingBox(minLon, minLat, maxLon, maxLat);
    }
    public List<VoronoiPolygon> getPolygons(int limit) {
        return repository.getAllPolygons(limit);
    }
}
