package edu.sm.app.repository;

import edu.sm.app.dto.ChartData;
import edu.sm.app.dto.Order;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface OrderRepository {

    List<ChartData> findMonthlyTotalSales();

    List<ChartData> findMonthlyAverageSales();
}