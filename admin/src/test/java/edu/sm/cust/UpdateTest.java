package edu.sm.cust;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class UpdateTest {
    @Autowired
    CustService custService;
    @Test
    void contextLoads() throws Exception {
        Cust cust = Cust.builder()
                .custId("id04")
                .custName("박말수")
                .custAddr("천안시")
                .build();
        custService.modify(cust);

        log.info(custService.get("id04").toString());
    }

}