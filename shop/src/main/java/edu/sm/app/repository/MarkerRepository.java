package edu.sm.app.repository;

import edu.sm.app.dto.Marker;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
@Repository
@Mapper
public interface MarkerRepository extends SmRepository<Marker, Integer> {
    List<Marker> findByLoc(int loc);
}