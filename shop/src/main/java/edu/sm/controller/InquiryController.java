package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Inquiry;
import edu.sm.app.dto.InquiryMessage;
import edu.sm.app.service.InquiryMessageService;
import edu.sm.app.service.InquiryService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/inquiry")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService inquiryService;
    private final InquiryMessageService inquiryMessageService;

    @Value("${app.url.websocketurl}")
    String webSocketUrl;

    String dir = "chat/";

    @PostMapping("/submit")
    public String submit(@RequestParam("category") String category,
                         @RequestParam("content") String content,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            redirectAttributes.addFlashAttribute("msg", "로그인 후 문의를 등록할 수 있습니다.");
            return "redirect:/login";
        }
        String trimmedContent = content == null ? "" : content.trim();
        if (trimmedContent.isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "문의 내용을 입력해주세요.");
            return "redirect:/";
        }
        Inquiry inquiry = Inquiry.builder()
                .custId(cust.getCustId())
                .category(category)
                .status("OPEN")
                .build();
        inquiryService.register(inquiry);
        InquiryMessage message = InquiryMessage.builder()
                .inquiryId(inquiry.getInquiryId())
                .senderId(cust.getCustId())
                .senderType("CUSTOMER")
                .content(trimmedContent)
                .build();
        inquiryMessageService.register(message);
        inquiryService.updateStatus(inquiry.getInquiryId(), "IN_PROGRESS");
        redirectAttributes.addFlashAttribute("inquiryCreated", true);
        return "redirect:/inquiry/chat?inquiryId=" + inquiry.getInquiryId();
    }

    @GetMapping("/chat")
    public String chat(@RequestParam("inquiryId") Integer inquiryId,
                       HttpSession session,
                       Model model,
                       RedirectAttributes redirectAttributes) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            redirectAttributes.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            return "redirect:/login";
        }
        Inquiry inquiry = inquiryService.get(inquiryId);
        if (inquiry == null || !cust.getCustId().equals(inquiry.getCustId())) {
            redirectAttributes.addFlashAttribute("msg", "문의 내역을 확인할 수 없습니다.");
            return "redirect:/";
        }
        List<InquiryMessage> messages = inquiryMessageService.getByInquiry(inquiryId);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("messages", messages);
        model.addAttribute("websocketurl", webSocketUrl);
        model.addAttribute("center", dir + "inquiry");
        model.addAttribute("left", "left");
        return "index";
    }

    @GetMapping("/messages")
    @ResponseBody
    public ResponseEntity<?> messages(@RequestParam("inquiryId") Integer inquiryId,
                                      HttpSession session) throws Exception {
        Cust cust = (Cust) session.getAttribute("cust");
        if (cust == null) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        Inquiry inquiry = inquiryService.get(inquiryId);
        if (inquiry == null || !cust.getCustId().equals(inquiry.getCustId())) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "조회 권한이 없습니다.");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
        List<InquiryMessage> messages = inquiryMessageService.getByInquiry(inquiryId);
        return ResponseEntity.ok(messages);
    }
}
