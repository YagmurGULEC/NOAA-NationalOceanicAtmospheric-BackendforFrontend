package com.example.backend.service;
import com.example.backend.repository.StationRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import com.example.backend.model.Station;
import java.util.stream.Collectors;
@Service
public class StationService {

    private final StationRepository stationRepository;

    public StationService(StationRepository stationRepository) {
        this.stationRepository = stationRepository;
    }

    public List<Station> getStationsInBoundingBox(double minLng, double minLat, double maxLng, double maxLat) {
       return stationRepository.findStationsInBoundingBox(minLng, minLat, maxLng, maxLat);
               
    }

    
}
