package edu.sm.app.repository;

import edu.sm.app.dto.InquiryMessage;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
// 관리자 채팅 화면에서 문의별 메시지 목록을 다루는 매퍼다.
public interface InquiryMessageRepository extends SmRepository<InquiryMessage, Integer> {
    List<InquiryMessage> selectByInquiry(@Param("inquiryId") Integer inquiryId) throws Exception;

    void deleteByInquiry(@Param("inquiryId") Integer inquiryId) throws Exception;
}
