package edu.sm;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.mybatis.spring.annotation.MapperScan; // 이 라인을 추가합니다.

@SpringBootApplication
@MapperScan(basePackages = "edu.sm.app.repository") // 이 라인을 추가합니다.
public class ShopApplication {

    public static void main(String[] args) {
        SpringApplication.run(ShopApplication.class, args);
    }
}