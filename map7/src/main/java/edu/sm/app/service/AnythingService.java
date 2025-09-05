package edu.sm.app.service;

import edu.sm.app.dto.Anything;
import edu.sm.app.repository.AnythingRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnythingService implements SmService <Anything, Integer>{
    final AnythingRepository anythingRepository;

    public List<Anything> findByAddress(String address) throws Exception {
        return  anythingRepository.findByAddress(address);
    }

    public List<Anything> findShopsWithinRadius(double lat, double lng, double radius) throws Exception{
        return anythingRepository.findShopsWithinRadius(lat, lng, radius);
    }

    @Override
    public void register(Anything anything) throws Exception {

    }

    @Override
    public void modify(Anything anything) throws Exception {

    }

    @Override
    public void remove(Integer integer) throws Exception {

    }

    @Override
    public List<Anything> get() throws Exception {
        return List.of();
    }

    @Override
    public Anything get(Integer locId) throws Exception {
        return anythingRepository.select(locId);
    }
}
