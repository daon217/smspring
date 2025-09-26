package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class InquiryMessage {
    private Integer messageId;
    private Integer inquiryId;
    private String senderId;
    private String senderType;
    private String content;
    private LocalDateTime createdAt;
}
