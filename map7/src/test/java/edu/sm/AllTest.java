package edu.sm;

import edu.sm.app.dto.Anything;
import edu.sm.app.repository.AnythingRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
public class AllTest {

    @Autowired
    AnythingRepository repository;

    @Test
    void contextLoads() {
        log.info("===== Spring Context Load Test =====");
    }

    @Test
    void findAllTest() throws Exception {
        List<Anything> list = repository.selectAll();
        for (Anything a : list) {
            log.info(a.toString());
        }
    }

    @Test
    void findByAddressTest() throws Exception {
        List<Anything> list = repository.findByAddress("편의점");
        for (Anything a : list) {
            log.info("검색 결과: {}", a);
        }
    }

//    @Test
//    void findNearbyTest() throws Exception {
//        double lat = 36.800209;
//        double lng = 127.074968;
//        List<Anything> list = repository.findNearby(lat, lng);
//        for (Anything a : list) {
//            log.info("반경 3km 내: {}", a);
//        }
//    }
}