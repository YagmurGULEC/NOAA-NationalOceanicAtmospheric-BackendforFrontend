package com.example.backend.model;


import com.example.backend.util.StationGeoJsonSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import jakarta.persistence.*;
import org.locationtech.jts.geom.Point;

@Entity
@Table(name = "stations", schema = "geo")
@JsonSerialize(using = StationGeoJsonSerializer.class)  // Attach custom serializer
public class Station {

    @Id
    @Column(name = "id")
    private String id;

    @Column(name = "name")
    private String name;

    @Column(name = "geom", columnDefinition = "geometry(Point,4326)")
    private Point geom;

    public Station() {} // Default no-arg constructor required by JPA

    public Station(String id, String name, Point geom) {
        this.id = id;
        this.name = name;
        this.geom = geom;
    }

    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public Point getGeom() { return geom; }
    public void setGeom(Point geom) { this.geom = geom; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
