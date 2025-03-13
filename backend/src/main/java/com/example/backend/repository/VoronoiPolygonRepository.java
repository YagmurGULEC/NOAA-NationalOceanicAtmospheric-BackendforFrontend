package com.example.backend.repository;

import com.example.backend.model.VoronoiPolygon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.locationtech.jts.geom.Geometry;

import java.util.List;

public interface VoronoiPolygonRepository extends JpaRepository<VoronoiPolygon, Long> {

   @Query(value = "SELECT id, station_id, geom FROM geo.voronoi_polygons WHERE ST_Intersects(geom, ST_MakeEnvelope(:minLon, :minLat, :maxLon, :maxLat, 4326))", 
       nativeQuery = true)
    List<VoronoiPolygon> findByBoundingBox(
            @Param("minLon") double minLon, 
            @Param("minLat") double minLat, 
            @Param("maxLon") double maxLon, 
            @Param("maxLat") double maxLat);

   @Query(value = "SELECT id, station_id, geom FROM geo.voronoi_polygons LIMIT :limit", 
       nativeQuery = true)
    List<VoronoiPolygon> getAllPolygons(@Param("limit") int limit);
}
