package edu.sm.controller;

import edu.sm.app.msg.Msg;
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
// 고객 채팅 메시지를 웹소켓으로 중계한다.
public class MsgController {

    private final SimpMessagingTemplate template;

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
    // 고객이 관리자에게 보낸 메시지를 실시간으로 전달한다.
    public void receiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        msg.setCreatedAt(LocalDateTime.now());
        log.info("receive to: {}", msg);
        template.convertAndSend("/send/to/" + msg.getReceiveid(), msg);
    }
}
