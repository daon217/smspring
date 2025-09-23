package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@Slf4j
public class WeatherService {

    @Value("${app.key.wkey}")
    private String serviceKey;

    public String getMidFcstWeather(String landRegId, String taRegId) throws IOException {
        String landXml = callMidLandFcst(landRegId);
        String taXml = callMidTa(taRegId);

        String wf4Am = extract(landXml, "wf4Am");
        String wf4Pm = extract(landXml, "wf4Pm");
        String rnSt4Am = extract(landXml, "rnSt4Am");
        String rnSt4Pm = extract(landXml, "rnSt4Pm");

        String taMax4 = extract(taXml, "taMax4");
        String taMin4 = extract(taXml, "taMin4");

        return String.format(
                "{\"resultCode\":\"00\",\"resultMsg\":\"OK\",\"weather\":{\"wf4Am\":\"%s\",\"wf4Pm\":\"%s\",\"rnSt4Am\":\"%s\",\"rnSt4Pm\":\"%s\",\"taMax4\":\"%s\",\"taMin4\":\"%s\"}}",
                wf4Am, wf4Pm, rnSt4Am, rnSt4Pm, taMax4, taMin4
        );
    }

    private String callMidLandFcst(String regId) throws IOException {
        String urlBuilder = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst" +
                "?serviceKey=" + URLEncoder.encode(serviceKey, StandardCharsets.UTF_8) +
                "&numOfRows=10&pageNo=1" +
                "&regId=" + regId +
                "&tmFc=" + getTmFc();
        return getApiResponse(urlBuilder);
    }

    private String callMidTa(String regId) throws IOException {
        String urlBuilder = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa" +
                "?serviceKey=" + URLEncoder.encode(serviceKey, StandardCharsets.UTF_8) +
                "&numOfRows=10&pageNo=1" +
                "&regId=" + regId +
                "&tmFc=" + getTmFc();
        return getApiResponse(urlBuilder);
    }

    private String getApiResponse(String urlBuilder) throws IOException {
        URL url = new URL(urlBuilder);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/xml");

        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();

        return sb.toString();
    }

    private String getTmFc() {
        LocalDateTime now = LocalDateTime.now();
        int hour = now.getHour();
        if (hour < 6) {
            return now.minusDays(1).format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "1800";
        } else if (hour < 18) {
            return now.format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "0600";
        } else {
            return now.format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "1800";
        }
    }

    private String extract(String xmlResponse, String tagName) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlResponse)));
            doc.getDocumentElement().normalize();

            NodeList itemList = doc.getElementsByTagName("item");
            if (itemList.getLength() > 0) {
                Element item = (Element) itemList.item(0);
                String value = getTagValue(item, tagName);
                return value == null ? "" : value;
            }
        } catch (Exception e) {
            log.error("XML parsing error:", e);
        }
        return "";
    }

    private String getTagValue(Element element, String tagName) {
        NodeList nodeList = element.getElementsByTagName(tagName);
        if (nodeList.getLength() > 0 && nodeList.item(0).getFirstChild() != null) {
            return nodeList.item(0).getFirstChild().getNodeValue();
        }
        return "";
    }
}