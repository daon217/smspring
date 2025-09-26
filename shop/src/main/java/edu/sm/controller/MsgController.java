package edu.sm.controller;

import edu.sm.app.dto.InquiryMessage;
import edu.sm.app.msg.Msg;
import edu.sm.app.service.InquiryMessageService;
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
// 고객 채팅 메시지를 웹소켓으로 중계하면서 DB에도 기록한다.
public class MsgController {

    private final SimpMessagingTemplate template;
    private final InquiryMessageService inquiryMessageService;
    private final InquiryService inquiryService;

    @MessageMapping("/receiveall") // 모두에게 전송
    public void receiveall(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        msg.setCreatedAt(LocalDateTime.now());
        log.debug("receiveall: {}", msg);
        template.convertAndSend("/send", msg);
    }

    @MessageMapping("/receiveme") // 나에게만 전송 ex)Chatbot
    public void receiveme(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        msg.setCreatedAt(LocalDateTime.now());
        log.debug("receiveme: {}", msg);
        String id = msg.getSendid();
        template.convertAndSend("/send/" + id, msg);
    }

    @MessageMapping("/receiveto") // 특정 Id에게 전송
    // 고객이 관리자에게 보낸 메시지를 저장하고 대상 구독자에게 전달한다.
    public void receiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        msg.setCreatedAt(LocalDateTime.now());
        log.info("receive to: {}", msg);
        template.convertAndSend("/send/to/" + msg.getReceiveid(), msg);
        recordInquiryMessage(msg, "CUSTOMER");
    }

    private void recordInquiryMessage(Msg msg, String defaultSenderType) {
        // 채팅 메시지를 문의별 히스토리로 남긴다.
        if (msg.getInquiryId() == null) {
            return;
        }
        String senderType = (msg.getSenderType() == null || msg.getSenderType().isEmpty())
                ? defaultSenderType
                : msg.getSenderType();
        InquiryMessage inquiryMessage = InquiryMessage.builder()
                .inquiryId(msg.getInquiryId())
                .senderId(msg.getSendid())
                .senderType(senderType)
                .content(msg.getContent1())
                .build();
        try {
            inquiryMessageService.register(inquiryMessage);
            if ("CUSTOMER".equalsIgnoreCase(senderType)) {
                // 고객이 보낸 메시지가 도착하면 상담 진행 상태로 갱신한다.
                inquiryService.updateStatus(msg.getInquiryId(), "IN_PROGRESS");
            }
        } catch (Exception e) {
            log.error("Failed to store inquiry message", e);
        }
    }
}
