package edu.sm.controller;

import edu.sm.app.dto.Content;
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Search;
import edu.sm.app.service.MarkerService;
import edu.sm.util.FileUploadUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {
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
}






