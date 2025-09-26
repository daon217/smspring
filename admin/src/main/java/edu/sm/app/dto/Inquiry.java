package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
// 관리자 화면에서 문의 현황을 조회하기 위해 고객 문의 기본 정보를 담는다.
public class Inquiry {
    private Integer inquiryId;
    private String custId;
    private String category;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
