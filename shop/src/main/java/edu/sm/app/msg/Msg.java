package edu.sm.app.msg;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
// 웹소켓으로 오가는 채팅 메시지를 문의 ID와 함께 전달하기 위한 모델이다.
public class Msg {
    private String sendid;
    private String receiveid;
    private String content1;
    private Integer inquiryId;
    private String senderType;
    private LocalDateTime createdAt;
}
