package edu.sm;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.*;

@SpringBootTest
class CSVApplicationTests {

    @Test
    void contextLoads() throws IOException, CsvValidationException {
        CSVReader reader = new CSVReader(new InputStreamReader(new FileInputStream("C:\\smspring\\logs\\click.log"), "UTF-8"));
        String[] line;
//        reader.readNext();  // 헤더 건너뜀
        StringBuffer sb = new StringBuffer();

        while ((line = reader.readNext()) != null) {
            sb.append(line[2]).append("\n");
        }
        log.info(sb.toString());
    }

}
