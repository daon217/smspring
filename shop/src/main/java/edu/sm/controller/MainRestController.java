package edu.sm.controller;

import edu.sm.app.dto.Content;
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Search;
import edu.sm.app.dto.ChartStreamMessage;
import edu.sm.app.service.LoggerService1;
import edu.sm.app.service.LoggerService2;
import edu.sm.app.service.LoggerService3;
import edu.sm.app.service.LoggerService4;
import edu.sm.app.service.MarkerService;
import edu.sm.sse.SseEmitters;
import edu.sm.util.FileUploadUtil;
import edu.sm.util.WeatherUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {

    private final LoggerService1 loggerService1;
    private final LoggerService2 loggerService2;
    private final LoggerService3 loggerService3;
    private final LoggerService4 loggerService4;
    private final SseEmitters sseEmitters;

    @Value("${app.key.wkey}")
    String wkey;

    @RequestMapping("/getwt1")
    public Object getwt1(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeather(loc, wkey);
    }

    @GetMapping(value = "/connect/{id}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public ResponseEntity<SseEmitter> connect(@PathVariable("id") String clientId) {
        SseEmitter emitter = sseEmitters.add(clientId);
        sseEmitters.sendConnectMessage(clientId);
        return ResponseEntity.ok(emitter);
    }

    @RequestMapping("/savedata1")
    public Object savedata1(@RequestParam("data") String data,
                            @RequestParam(value = "provider", required = false) String provider) throws IOException {
        loggerService1.logData(data);
        sendChartUpdate("chart1", data, provider);
        return "OK";
    }

    @RequestMapping("/savedata2")
    public Object savedata2(@RequestParam("data") String data,
                            @RequestParam(value = "provider", required = false) String provider) throws IOException {
        loggerService2.logData(data);
        sendChartUpdate("chart2", data, provider);
        return "OK";
    }

    @RequestMapping("/savedata3")
    public Object savedata3(@RequestParam("data") String data,
                            @RequestParam(value = "provider", required = false) String provider) throws IOException {
        loggerService3.logData(data);
        sendChartUpdate("chart3", data, provider);
        return "OK";
    }

    @RequestMapping("/savedata4")
    public Object savedata4(@RequestParam("data") String data,
                            @RequestParam(value = "provider", required = false) String provider) throws IOException {
        loggerService4.logData(data);
        sendChartUpdate("chart4", data, provider);
        return "OK";
    }

    @RequestMapping("/saveaudio")
    public Object saveaudio(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/audios/");
        return "OK";
    }

    @RequestMapping("/saveimg")
    public Object saveimg(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/imgs/");
        return "OK";
    }

    private void sendChartUpdate(String chartId, String rawValue, String provider) {
        int value;
        try {
            value = Integer.parseInt(rawValue);
        } catch (NumberFormatException e) {
            log.warn("invalid numeric data for {}: {}", chartId, rawValue);
            return;
        }
        String normalizedProvider = (provider != null && !provider.trim().isEmpty())
                ? provider.trim()
                : "unknown";
        ChartStreamMessage message = ChartStreamMessage.builder()
                .chartId(chartId)
                .value(value)
                .provider(normalizedProvider)
                .timestamp(System.currentTimeMillis())
                .build();
        sseEmitters.sendChartData(message);
    }
}
