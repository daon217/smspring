package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
// 한 건의 문의에 속한 개별 대화 메시지 정보를 표현하는 DTO다.
public class InquiryMessage {
    private Integer messageId;
    private Integer inquiryId;
    private String senderId;
    private String senderType;
    private String content;
    private LocalDateTime createdAt;
}
