package edu.sm.app.repository;

import edu.sm.app.dto.Inquiry;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface InquiryRepository extends SmRepository<Inquiry, Integer> {
    List<Inquiry> selectByCust(@Param("custId") String custId) throws Exception;

    void updateStatus(@Param("inquiryId") Integer inquiryId,
                      @Param("status") String status) throws Exception;
}