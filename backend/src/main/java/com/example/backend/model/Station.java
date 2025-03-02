package com.example.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "geo.stations", schema = "geo")
public class Station {

    @Id
    @Column(name = "id")
    private String id;

    @Column(name = "name")
    private String name;

    // Depending on your database and how you want to map the geometry,
    // you can store it as a String (WKT) or use a geometry type.
    @Column(name = "geom")
    private String geom;

    public Station() {} // Default no-arg constructor required by JPA

    public Station(String id, String name, String geom) {
        this.id = id;
        this.name = name;
        this.geom = geom;
    }

    // Getters and setters...
}
