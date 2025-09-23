package iot3.src.util;

import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpSendData {
    public static void sendData(String url, int data) {
        try {
            URL obj = new URL(url);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; charset=utf-8");
            con.setDoOutput(true);

            // Send POST request
            OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
            wr.write("data=" + data);
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}