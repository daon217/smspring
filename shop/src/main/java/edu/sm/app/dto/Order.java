package edu.sm.app.dto;

import lombok.*;
import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Order {
    private int orderId;
    private int productId;
    private int cateId;
    private LocalDateTime orderDate;
    private int orderQt;
}