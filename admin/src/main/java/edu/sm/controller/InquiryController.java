package edu.sm.controller;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.service.InquiryService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/inquiry")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService inquiryService;

    @Value("${app.url.websocketurl}")
    String wsUrl;

    @GetMapping("/board")
    public String board(Model model) throws Exception {
        List<Inquiry> inquiries = inquiryService.get();
        model.addAttribute("inquiries", inquiries);
        model.addAttribute("center", "inquiry/board");
        return "index";
    }

    @GetMapping("/chat")
    public String chat(@RequestParam("id") Integer inquiryId,
                       Model model) throws Exception {
        Inquiry inquiry = inquiryService.get(inquiryId);
        if (inquiry == null) {
            return "redirect:/inquiry/board";
        }
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("websocketurl", wsUrl);
        model.addAttribute("center", "inquiry/chat");
        return "index";
    }
}