package edu.sm.cust;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.CustSearch;
import edu.sm.app.service.CustService;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@SpringBootTest
@Slf4j
class SearchTests {

    @Autowired
    CustService custService;

    @Test
    void contextLoads() throws Exception {
        List<Cust> list = null;
        CustSearch custSearch = CustSearch.builder()
                .custName("김")
                .startDate("2025-09-01")
                .endDate("2025-09-10")
                .build();
        list = custService.searchCustList(custSearch);
        list.forEach((c)->{log.info(c.toString());});

    }

}





