package edu.sm.controller;

import edu.sm.app.dto.Product;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.Random;

@Controller
@Slf4j
public class MainController {

    @Value("${app.url.sse}")
    String sseUrl;

    @Value("${app.url.shop-sse}")
    String shopSseUrl;

    @Value("${app.url.wsurl}")
    String wsUrl;

    @RequestMapping("/")
    public String main(Model model) {
        model.addAttribute("sseUrl", sseUrl);
        return "index";
    }

    @RequestMapping("/chart")
    public String chart(Model model) {
        model.addAttribute("center", "chart");
        model.addAttribute("sseUrl", sseUrl);
        model.addAttribute("shopSseUrl", shopSseUrl);
        return "index";
    }
    @RequestMapping("/chat")
    public String chat(Model model) {
        model.addAttribute("websocketurl", wsUrl);
        model.addAttribute("center", "inquiry/chat");
        return "index";
    }


}
