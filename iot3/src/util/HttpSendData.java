package util;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpSendData {
    public static void send(String url, String data) throws IOException {

        HttpURLConnection httpClient =
                (HttpURLConnection) new URL(url + data).openConnection();
        // optional default is GET
        httpClient.setRequestMethod("GET");
        int responseCode = httpClient.getResponseCode();
    }

}