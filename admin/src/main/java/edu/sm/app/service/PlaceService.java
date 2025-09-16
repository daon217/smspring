package edu.sm.app.service;

import edu.sm.app.dto.Place;
import edu.sm.app.repository.PlaceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PlaceService {
    final PlaceRepository placeRepository;

    public List<Place> findNearby(double lat, double lng, String category) {
        return placeRepository.findNearby(lat, lng, category);
    }
}