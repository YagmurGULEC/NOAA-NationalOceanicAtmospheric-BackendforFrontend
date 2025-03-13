package com.example.backend.model;

import jakarta.persistence.*;
import org.locationtech.jts.geom.Geometry;

import org.hibernate.annotations.Type;
import com.example.backend.util.VoronoiPolygonGeoJsonSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.locationtech.jts.geom.Polygon;
@Entity
@Table(name = "voronoi_polygons", schema = "geo")
@JsonSerialize(using = VoronoiPolygonGeoJsonSerializer.class)
public class VoronoiPolygon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "station_id")
    private String stationId;

    @Column(name = "geom", columnDefinition = "geometry(Polygon,4326)")
  
    private Polygon geom;

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStationId() {
        return stationId;
    }

    public void setStationId(String stationId) {
        this.stationId = stationId;
    }

    public Polygon getGeom() {
        return geom;
    }

    public void setGeom(Polygon geom) {
        this.geom = geom;
    }
}
