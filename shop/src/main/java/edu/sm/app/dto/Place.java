package edu.sm.app.dto;

import lombok.Data;

@Data
public class Place {
    private int id;
    private String name;
    private String category;
    private String address;
    private double lat;
    private double lng;
    private double distance; // 현재 위치로부터의 거리 (계산 결과)
}