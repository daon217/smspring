package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
// 관리자-고객 대화 흐름을 불러오기 위해 메시지 레코드를 표현한다.
public class InquiryMessage {
    private Integer messageId;
    private Integer inquiryId;
    private String senderId;
    private String senderType;
    private String content;
    private LocalDateTime createdAt;
}
