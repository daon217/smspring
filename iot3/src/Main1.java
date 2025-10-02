import util.HttpSendData;

import java.io.IOException;
import java.util.Random;

public class Main1 {
    public static void main(String[] args) throws IOException {
        String url = "https://10.20.36.102:8444/savedata1";
        String provider = "iot-main1";
        Random r = new Random();
        for (int i = 0; i < 1000; i++) {
            int num = r.nextInt(100) + 1;
            HttpSendData.send(url, "?provider=" + provider + "&data=" + num);
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
