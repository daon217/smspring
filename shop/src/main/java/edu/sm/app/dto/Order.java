package edu.sm.app.dto;

import lombok.*;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Order {
    private int orderId;
    private String custId;
    private int orderPrice;
    private Timestamp orderDate;
}