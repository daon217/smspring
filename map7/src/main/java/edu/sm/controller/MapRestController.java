package edu.sm.controller;

import edu.sm.app.dto.Anything;
import edu.sm.app.dto.Marker;
import edu.sm.app.service.AnythingService;
import edu.sm.app.service.MarkerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MapRestController {
    final MarkerService markerService;
    final AnythingService anythingService;
    private double lat;
    private double lng;

    @RequestMapping("/iot")
    public Object iot(@RequestParam("lat") double lat, @RequestParam("lng") double lng) throws Exception{
        log.info(lat+" : "+lng);
        this.lat = lat;
        this.lng = lng;
        return "ok";
    }

    @RequestMapping("/getshop")
    public Object getshop(@RequestParam("lat") double lat, @RequestParam("lng") double lng) throws Exception{
        List<Anything> Shops = anythingService.findShopsWithinRadius(lat, lng, 3.0);

        return Shops;
    }

    @RequestMapping("/getlatlng")
    public Object getlatlng() throws Exception{
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("lat", this.lat);
        jsonObject.put("lng", this.lng);
        // {lat:xxxxxx, lng:xxxxxx}
        return jsonObject;
    }

    @RequestMapping("/getmarkers")
    public Object getmarkers(@RequestParam("target") int target) throws Exception{
        List<Marker> list = markerService.findByLoc(target);
        return list;
    }
}
