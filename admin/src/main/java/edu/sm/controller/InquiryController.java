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
// 관리자용 문의 게시판과 채팅 화면을 연결하는 컨트롤러다.
public class InquiryController {

    private final InquiryService inquiryService;
    private final InquiryMessageService inquiryMessageService;

    @Value("${app.url.wsurl}")
    String wsUrl;

    @GetMapping("/board")
    // 신규 문의를 빠르게 파악할 수 있도록 전체 목록을 전달한다.
    public String board(Model model) throws Exception {
        List<Inquiry> inquiries = inquiryService.get();
        model.addAttribute("inquiries", inquiries);
        model.addAttribute("center", "inquiry/board");
        return "index";
    }

    @GetMapping("/chat")
    // 선택된 문의의 상세 대화 내용을 채팅 화면에 세팅한다.
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
        // 채팅창이 열린 상태에서 주기적으로 메시지를 새로고침할 때 사용한다.
        return ResponseEntity.ok(messages);
    }
}
