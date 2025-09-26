package edu.sm.controller;

import edu.sm.app.msg.Msg;
import edu.sm.app.service.InquiryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminMsgController {

    private final SimpMessagingTemplate template;
    private final InquiryService inquiryService;

    @MessageMapping("/adminreceiveto") // 특정 Id에게 전송
    public void adminreceiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        msg.setCreatedAt(LocalDateTime.now());
        log.info("admin receive to: {}", msg);
        template.convertAndSend("/adminsend/to/" + msg.getReceiveid(), msg);
        updateInquiryStatus(msg);
    }

    private void updateInquiryStatus(Msg msg) {
        if (msg.getInquiryId() == null) {
            return;
        }
        String senderType = (msg.getSenderType() == null || msg.getSenderType().isEmpty())
                ? "ADMIN"
                : msg.getSenderType();
        try {
            if ("ADMIN".equalsIgnoreCase(senderType)) {
                inquiryService.updateStatus(msg.getInquiryId(), "ANSWERED");
            }
        } catch (Exception e) {
            log.error("Failed to update inquiry status", e);
        }
    }
}
