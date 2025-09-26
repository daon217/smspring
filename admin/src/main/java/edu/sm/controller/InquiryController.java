package edu.sm.controller;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.dto.InquiryMessage;
import edu.sm.app.service.InquiryMessageService;
import edu.sm.app.service.InquiryService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/inquiry")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService inquiryService;
    private final InquiryMessageService inquiryMessageService;

    @Value("${app.url.wsurl}")
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
        List<InquiryMessage> messages = inquiryMessageService.getByInquiry(inquiryId);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("messages", messages);
        model.addAttribute("websocketurl", wsUrl);
        model.addAttribute("center", "inquiry/chat");
        return "index";
    }

    @GetMapping("/messages")
    @ResponseBody
    public ResponseEntity<List<InquiryMessage>> messages(@RequestParam("inquiryId") Integer inquiryId) throws Exception {
        List<InquiryMessage> messages = inquiryMessageService.getByInquiry(inquiryId);
        return ResponseEntity.ok(messages);
    }
}
