package iot3.src.main;
import iot3.src.util.HttpSendData;

import java.util.Random;

public class Main4 {
    public static void main(String[] args) {
        String url = "https://127.0.0.1:8443/savedata1";
        Random r = new Random();
        try {
            while (true) {
                int ran = r.nextInt(100);
                HttpSendData.sendData(url, ran);
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}