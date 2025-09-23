package edu.sm.controller;

import com.opencsv.CSVReader;
import edu.sm.app.dto.Content;
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Search;
import edu.sm.app.service.MarkerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import edu.sm.app.service.OrderService;
import edu.sm.app.dto.ChartData;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ChartRestController {
    @Value("${app.dir.logsdirRead")
    String dir;

    private final OrderService orderService;

    @RequestMapping("/chart2_1")
    public Object chart2_1() throws Exception {
        JSONArray jsonArray = new JSONArray();
        String [] nation = {"Kor","Eng","Jap","Chn","Usa"};
        Random random = new Random();
        for(int i=0;i<nation.length;i++){
            JSONArray jsonArray1 = new JSONArray();
            jsonArray1.add(nation[i]);
            jsonArray1.add(random.nextInt(100)+1);
            jsonArray.add(jsonArray1);
        }
        return jsonArray;
    }

    @RequestMapping("/chart2_2")
    public Object chart2_2() throws Exception {
        JSONObject jsonObject = new JSONObject();
        String arr [] = {"0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90+"};
        jsonObject.put("cate",arr);
        Random random = new Random();
        JSONArray jsonArray = new JSONArray();
        for(int i=0;i<arr.length;i++){
            jsonArray.add(random.nextInt(100)+1);
        }
        jsonObject.put("data",jsonArray);
        return jsonObject;
    }

    @RequestMapping("/chart2_3")
    public Object chart2_3() throws Exception {
        CSVReader reader =
                new CSVReader(new InputStreamReader(new FileInputStream(dir+"click.log"), "UTF-8"));
        String[] line;
        StringBuffer sb = new StringBuffer();
        while ((line = reader.readNext()) != null) {
            sb.append(line[2]+" ");
        }
        return sb.toString();
    }

    @RequestMapping("/chart2_4")
    public Object chart2_4() throws Exception {
        JSONObject resultObject = new JSONObject();
        JSONArray seriesData = new JSONArray();
        JSONArray drilldownSeries = new JSONArray();
        Random random = new Random();
        String[] mainCategories = {"상의", "하의", "신발", "악세사리"};
        String[][] subCategories = {
                {"후드티", "맨투맨", "크롭티"},
                {"청바지", "데님바지", "슬렉스"},
                {"샌들", "운동화", "슬리퍼", "스니커즈"},
                {"목걸이", "귀걸이", "시계", "팔찌"}
        };

        for (int i = 0; i < mainCategories.length; i++) {
            JSONObject mainItem = new JSONObject();
            String mainName = mainCategories[i];
            mainItem.put("name", mainName);
            mainItem.put("y", random.nextInt(100) + 1);
            mainItem.put("drilldown", mainName);
            seriesData.add(mainItem);

            JSONObject drilldownObject = new JSONObject();
            drilldownObject.put("name", mainName);
            drilldownObject.put("id", mainName);

            JSONArray subData = new JSONArray();
            for (String subName : subCategories[i]) {
                JSONArray subItem = new JSONArray();
                subItem.add(subName);
                subItem.add(random.nextInt(50) + 1);
                subData.add(subItem);
            }
            drilldownObject.put("data", subData);
            drilldownSeries.add(drilldownObject);
        }
        resultObject.put("series", seriesData);
        resultObject.put("drilldown", drilldownSeries);
        return resultObject;
    }

    @RequestMapping("/chart3_1")
    public Object chart3_1() throws Exception {
        List<ChartData> totalSalesList = orderService.getMonthlyTotalSales();
        JSONArray result = new JSONArray();
        for(ChartData data : totalSalesList){
            JSONArray item = new JSONArray();
            item.add(data.getMonth());
            item.add(data.getTotalSales());
            result.add(item);
        }
        return result;
    }

    @RequestMapping("/chart3_2")
    public Object chart3_2() throws Exception {
        List<ChartData> averageSalesList = orderService.getMonthlyAverageSales();
        JSONObject result = new JSONObject();
        JSONArray categories = new JSONArray();
        JSONArray data = new JSONArray();
        for(ChartData item : averageSalesList){
            categories.add(item.getMonth());
            data.add(item.getAverageSales());
        }
        result.put("categories", categories);
        result.put("data", data);
        return result;
    }

    @RequestMapping("/chart1")
    public Object chart1() throws Exception {
        JSONArray jsonArray = new JSONArray();

        JSONObject jsonObject1 = new JSONObject();
        JSONObject jsonObject2 = new JSONObject();
        JSONObject jsonObject3 = new JSONObject();
        jsonObject1.put("name","Korea");
        jsonObject2.put("name","Japan");
        jsonObject3.put("name","China");

        JSONArray data1Array = new JSONArray();
        JSONArray data2Array = new JSONArray();
        JSONArray data3Array = new JSONArray();

        Random random = new Random();
        for(int i=0;i<12;i++){
            data1Array.add(random.nextInt(100)+1);
            data2Array.add(random.nextInt(100)+1);
            data3Array.add(random.nextInt(100)+1);
        }
        jsonObject1.put("data",data1Array);
        jsonObject2.put("data",data2Array);
        jsonObject3.put("data",data3Array);

        jsonArray.add(jsonObject1);
        jsonArray.add(jsonObject2);
        jsonArray.add(jsonObject3);
        return  jsonArray;
    }
}