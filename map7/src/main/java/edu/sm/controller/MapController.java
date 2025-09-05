package edu.sm.controller;

import edu.sm.app.dto.Anything;
import edu.sm.app.dto.Marker;
import edu.sm.app.service.AnythingService;
import edu.sm.app.service.MarkerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequestMapping("/map")
@RequiredArgsConstructor
public class MapController {


    private final AnythingService anythingService;

    String dir="map/";



    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center",dir+"center");
        model.addAttribute("left",dir+"left");
        return "index";
    }

    @RequestMapping("/go")
    public String go(Model model, @RequestParam("locId") int locId) {
        try {
            // 마커 정보를 데이터베이스에서 조회
            Anything marker = anythingService.get(locId);
            model.addAttribute("marker", marker);
            model.addAttribute("locId", locId);
        } catch (Exception e) {
            log.error("마커 조회 실패: " + e.getMessage());
            // 에러 처리
        }

        model.addAttribute("center", dir+"go");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/map1")
    public String map1(Model model) {
        model.addAttribute("center",dir+"map1");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map2")
    public String map2(Model model) {
        model.addAttribute("center",dir+"map2");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map3")
    public String map3(Model model) {
        model.addAttribute("center",dir+"map3");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map4")
    public String map4(Model model) {
        model.addAttribute("center",dir+"map4");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map5")
    public String map5(Model model) {
        model.addAttribute("center",dir+"map5");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map6")
    public String map6(Model model) {
        model.addAttribute("center",dir+"map6");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map7")
    public String map7(Model model) {
        model.addAttribute("center",dir+"map7");
        model.addAttribute("left",dir+"left");
        return "index";
    }
    @RequestMapping("/map8")
    public String map8(Model model) {
        model.addAttribute("center",dir+"map8");
        model.addAttribute("left",dir+"left");
        return "index";
    }

}