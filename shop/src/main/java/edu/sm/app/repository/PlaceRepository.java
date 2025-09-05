package edu.sm.app.repository;

import edu.sm.app.dto.Place;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@Mapper
public interface PlaceRepository {
    List<Place> findNearby(@Param("lat") double lat, @Param("lng") double lng, @Param("category") String category);
}