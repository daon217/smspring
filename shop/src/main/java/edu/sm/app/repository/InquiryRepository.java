package edu.sm.app.repository;

import edu.sm.app.dto.Inquiry;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
// 고객이 등록한 문의를 조회하고 상태를 갱신하기 위한 MyBatis 매퍼 인터페이스다.
public interface InquiryRepository extends SmRepository<Inquiry, Integer> {
    List<Inquiry> selectByCust(@Param("custId") String custId) throws Exception;

    void updateStatus(@Param("inquiryId") Integer inquiryId,
                      @Param("status") String status) throws Exception;
}
