package edu.sm.app.msg;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
// 관리자 채널에서 사용하는 웹소켓 메시지에 문의 번호와 발신자 정보를 담는다.
public class Msg {
    private String sendid;
    private String receiveid;
    private String content1;
    private Integer inquiryId;
    private String senderType;
    private LocalDateTime createdAt;
}
