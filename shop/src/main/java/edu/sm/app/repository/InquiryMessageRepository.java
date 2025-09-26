package edu.sm.app.repository;

import edu.sm.app.dto.InquiryMessage;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
// 문의별 메시지를 불러오거나 정리하기 위한 매퍼 메서드를 선언한다.
public interface InquiryMessageRepository extends SmRepository<InquiryMessage, Integer> {
    List<InquiryMessage> selectByInquiry(@Param("inquiryId") Integer inquiryId) throws Exception;

    void deleteByInquiry(@Param("inquiryId") Integer inquiryId) throws Exception;
}
