package edu.sm.controller;



import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;


@RestController
@Slf4j
public class MainRestController3 {

    @RequestMapping("/savedata3")
    public Object savedata(@RequestParam("data") String data) throws IOException {
        log.info(data);
        return "OK";
    }

}
