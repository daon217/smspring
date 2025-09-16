package edu.sm.app.service;

import edu.sm.app.dto.ChartData;
import edu.sm.app.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;

    public List<ChartData> getMonthlyTotalSales() {
        return orderRepository.findMonthlyTotalSales();
    }

    public List<ChartData> getMonthlyAverageSales() {
        return orderRepository.findMonthlyAverageSales();
    }
}