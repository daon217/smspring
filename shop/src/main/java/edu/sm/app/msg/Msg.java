package edu.sm.app.msg;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Msg {
    private String sendid;
    private String receiveid;
    private String content1;
    private Integer inquiryId;
    private String senderType;
    private LocalDateTime createdAt;
}
