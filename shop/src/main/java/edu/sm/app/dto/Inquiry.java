package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
// 고객 문의 기본 정보를 보관해 문의 목록과 채팅창에서 공통으로 활용하는 DTO다.
public class Inquiry {
    private Integer inquiryId;
    private String custId;
    private String category;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
