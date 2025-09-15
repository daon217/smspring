package edu.sm.app.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class ChartData {
    private String month;
    private int totalSales;
    private double averageSales;
}