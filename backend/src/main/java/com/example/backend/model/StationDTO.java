package com.example.backend.model;

public class StationDTO {
    private String id;
    private String name;
    private String geom; // WKT format

    public StationDTO(String id, String name, String geom) {
        this.id = id;
        this.name = name;
        this.geom = geom;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGeom() {
        return geom;
    }

    public void setGeom(String geom) {
        this.geom = geom;
    }

}