package edu.sm.app.dto;

import lombok.*;
import org.springframework.boot.context.properties.bind.DefaultValue;

import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class ProductSearch {
    String productName;
    int startPrice;
    int endPrice;
    int cateId;
}