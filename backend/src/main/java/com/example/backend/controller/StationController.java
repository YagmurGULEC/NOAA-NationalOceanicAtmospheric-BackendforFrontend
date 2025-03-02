package com.example.backend.controller;
import com.example.backend.model.StationDTO;
import org.springframework.web.bind.annotation.*;
import com.example.backend.service.StationService;
import java.util.List;

@RestController
@RequestMapping("/stations")
public class StationController {
    private final StationService stationService;
    public StationController(StationService stationService) {
        this.stationService = stationService;
    }
    @GetMapping
    public String hello() {
        return "Hello from the other side!";
    }
    @GetMapping("/bbox")
    public List<StationDTO> getStationsInBoundingBox(
            @RequestParam double minLng,
            @RequestParam double minLat,
            @RequestParam double maxLng,
            @RequestParam double maxLat) {
        return stationService.getStationsInBoundingBox(minLng, minLat, maxLng, maxLat);
    }
}
