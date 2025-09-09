package edu.sm.controller;

// 필요한 클래스들을 모두 import 합니다.
// 프로젝트 구조에 맞는 올바른 경로로 수정
import edu.sm.app.dto.Content; // 또는 edu.sm.dto.Cust 등
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Place;
import edu.sm.app.service.MarkerService;
import edu.sm.app.service.PlaceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.core.annotation.MergedAnnotations;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MapRestController {
    // 기존 서비스와 새로운 서비스를 모두 주입합니다.
    final MarkerService markerService;
    final PlaceService placeService;

    // 주변 장소 검색을 위한 새 API
    @RequestMapping("/getnearby")
    public List<Place> getnearby(
            @RequestParam("lat") double lat,
            @RequestParam("lng") double lng,
            @RequestParam("category") String category) {
        log.info("주변 검색: 위도={}, 경도={}, 종류={}", lat, lng, category);
        return placeService.findNearby(lat, lng, category);
    }

    @RequestMapping("/getlatlng")
    public Object getlatlng() throws Exception {
        JSONObject jsonObject = new JSONObject();
        Random r = new Random();

        double lat = 36.798587 + (r.nextDouble() * 0.005);
        double lng = 127.075860 + (r.nextDouble() * 0.005);

        // ✅ 2. 'this.'를 빼고 메소드 안에서 생성된 지역 변수를 사용하도록 수정
        jsonObject.put("lat", lat);
        jsonObject.put("lng", lng);
        return jsonObject;
    }

    @RequestMapping("/iot")
    public Object iot(@RequestParam("lat") double lat, @RequestParam("lng") double lng) throws Exception {
        log.info(lat+" : "+lng);
        // ✅ 1. 중복 선언된 변수 삭제
        return "ok";
    }

    @RequestMapping("/getmarkers")
    public Object getMarkers(@RequestParam("target") int target) throws Exception {
        List<Marker> list = markerService.findByLoc(target);
        return list;
    }

    // 기존에 사용하시던 하드코딩된 테스트용 메소드
    @RequestMapping("/getcontents")
    public Object getcontents(@RequestParam("target") int target, @RequestParam("type") int type){
        log.info("Get Contents --- Target: {}, Type: {}", target, type);
        List<Content> contents = new ArrayList<>();

        if(target == 100){
            if(type == 10){
                contents.add(new Content(37.564472,126.990841,"순대국1", "ss1.jpg", 101));
                contents.add(new Content(37.544472,126.970841,"순대국2", "ss2.jpg", 102));
                contents.add(new Content(37.564472,126.970841,"순대국3", "ss3.jpg", 103));
            }else if(type == 20){
                contents.add(new Content(37.554472,126.910841,"순1", "ss1.jpg", 101));
                contents.add(new Content(37.514472,126.920841,"순2", "ss2.jpg", 102));
                contents.add(new Content(37.534472,126.990841,"순3", "ss3.jpg", 103));
            }else if(type == 30){
                contents.add(new Content(37.574472,126.920841,"순대국1", "ss1.jpg", 101));
                contents.add(new Content(37.584472,126.970841,"순대국2", "ss2.jpg", 102));
                contents.add(new Content(37.514472,126.930841,"순대국3", "ss3.jpg", 103));
            }
        }else if(target == 200){
            if(type == 10){
                contents.add(new Content(35.175109, 129.171474,"순대국1", "ss1.jpg", 101));
                contents.add(new Content(35.176109, 129.176474,"순대국2", "ss2.jpg", 102));
                contents.add(new Content(35.172109, 129.179474,"순대국3", "ss3.jpg", 103));
            }else if(type == 20){
                contents.add(new Content(35.171109, 129.174474,"순1", "ss1.jpg", 101));
                contents.add(new Content(35.175109, 129.170474,"순2", "ss2.jpg", 102));
                contents.add(new Content(35.179109, 129.171474,"순3", "ss3.jpg", 103));
            }else if(type == 30){
                contents.add(new Content(35.165109, 129.170474,"순대국1", "ss1.jpg", 101));
                contents.add(new Content(35.171109, 129.171474,"순대국2", "ss2.jpg", 102));
                contents.add(new Content(35.169109, 129.168474,"순대국3", "ss3.jpg", 103));
            }
        }else if(target == 300){
            if(type == 10){
                contents.add(new Content(33.254564, 126.569944,"순대국1", "ss1.jpg", 101));
                contents.add(new Content(33.251564, 126.566944,"순대국2", "ss2.jpg", 102));
                contents.add(new Content(33.259564, 126.561944,"순대국3", "ss3.jpg", 103));
            }else if(type == 20){
                contents.add(new Content(33.259564, 126.561944,"순1", "ss1.jpg", 101));
                contents.add(new Content(33.252564, 126.565944,"순2", "ss2.jpg", 102));
                contents.add(new Content(33.256564, 126.568944,"순3", "ss3.jpg", 103));
            }else if(type == 30){
                contents.add(new Content(33.251564, 126.568944,"순대국1", "ss1.jpg", 101));
                contents.add(new Content(33.256564, 126.561944,"순대국2", "ss2.jpg", 102));
                contents.add(new Content(33.259564, 126.565944,"순대국3", "ss3.jpg", 103));
            }
        }
        return contents;
    }
}