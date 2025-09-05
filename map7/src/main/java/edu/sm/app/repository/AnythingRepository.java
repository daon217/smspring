package edu.sm.app.repository;

import edu.sm.app.dto.Anything;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
@Repository
@Mapper
public interface AnythingRepository extends SmRepository<Anything, Integer>{
    List<Anything> findByAddress(String address) throws Exception;
    List<Anything> findShopsWithinRadius(@RequestParam("lat") double lat,
                                         @RequestParam("lng") double lng,
                                         @RequestParam("radius") double radius) throws Exception;
}
