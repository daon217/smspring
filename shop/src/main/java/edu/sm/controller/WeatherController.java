package edu.sm.controller;

import edu.sm.app.service.WeatherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@Slf4j
@RequiredArgsConstructor
public class WeatherController {

    final WeatherService weatherService;

    @GetMapping("/getWeather")
    public String getWeather(@RequestParam("landRegId") String landRegId,
                             @RequestParam("taRegId") String taRegId) throws IOException {
        return weatherService.getMidFcstWeather(landRegId, taRegId);
    }
}