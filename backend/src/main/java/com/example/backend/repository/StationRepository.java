package com.example.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import jakarta.persistence.PersistenceContext;
import com.example.backend.model.Station;

import java.util.List;

@Repository
public interface StationRepository extends JpaRepository<Station, String> {

    @Query(value = "SELECT id, name, geom FROM geo.stations s " +
            "WHERE ST_Within(s.geom, ST_MakeEnvelope(:minLng, :minLat, :maxLng, :maxLat, 4326))",
            nativeQuery = true)
    List<Station> findStationsInBoundingBox(@Param("minLng") double minLng,
                                             @Param("minLat") double minLat,
                                             @Param("maxLng") double maxLng,
                                             @Param("maxLat") double maxLat);

}
