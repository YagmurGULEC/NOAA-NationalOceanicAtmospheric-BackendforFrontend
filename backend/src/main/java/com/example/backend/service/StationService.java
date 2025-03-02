package com.example.backend.service;


import com.example.backend.repository.StationRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import com.example.backend.model.StationDTO;
import java.util.stream.Collectors;
@Service
public class StationService {

    private final StationRepository stationRepository;

    public StationService(StationRepository stationRepository) {
        this.stationRepository = stationRepository;
    }

    public List<StationDTO> getStationsInBoundingBox(double minLng, double minLat, double maxLng, double maxLat) {
        List<Object[]> results=stationRepository.findStationsInBoundingBox(minLng, minLat, maxLng, maxLat);
        return results.stream()
                .map(obj -> new StationDTO((String) obj[0], (String) obj[1], (String) obj[2]))
                .collect(Collectors.toList());
    }
}
