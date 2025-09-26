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
// 관리자 채팅 메시지를 브로드캐스팅하고 문의 상태만 갱신한다.
public class AdminMsgController {

    private final SimpMessagingTemplate template;
    private final InquiryService inquiryService;

    @MessageMapping("/adminreceiveto") // 특정 Id에게 전송
    // 관리자와 고객 간 메시지를 실시간으로만 전달하고 상태를 조정한다.
    public void adminreceiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        msg.setCreatedAt(LocalDateTime.now());
        log.info("admin receive to: {}", msg);
        template.convertAndSend("/adminsend/to/" + msg.getReceiveid(), msg);
        updateInquiryStatus(msg);
    }

    private void updateInquiryStatus(Msg msg) {
        // 메시지 주체에 따라 문의 상태만 갱신한다.
        if (msg.getInquiryId() == null) {
            return;
        }
        String senderType = (msg.getSenderType() == null || msg.getSenderType().isEmpty())
                ? "ADMIN"
                : msg.getSenderType();
        try {
            if ("ADMIN".equalsIgnoreCase(senderType)) {
                // 답변이 등록되면 문의 상태를 답변 완료로 바꾼다.
                inquiryService.updateStatus(msg.getInquiryId(), "ANSWERED");
            } else if ("CUSTOMER".equalsIgnoreCase(senderType)) {
                // 고객 메시지를 받으면 진행 중 상태로 유지한다.
                inquiryService.updateStatus(msg.getInquiryId(), "IN_PROGRESS");
            }
        } catch (Exception e) {
            log.error("Failed to update inquiry status", e);
        }
    }
}
