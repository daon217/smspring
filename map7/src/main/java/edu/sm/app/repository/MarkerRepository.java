package edu.sm.app.repository;

import edu.sm.app.dto.Marker;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

//스프링에서 인지할 수 있도록 repository, xml에서 인지하도록  mapper 어노테이션 선언해놓는다.
@Repository
@Mapper
public interface MarkerRepository extends SmRepository<Marker, Integer> {
//    새로운 sql문 만들기 위해서 메소드 추가.
    List<Marker> findByLoc(int loc);
}
