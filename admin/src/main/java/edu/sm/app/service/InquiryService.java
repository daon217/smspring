package edu.sm.app.service;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.repository.InquiryRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InquiryService implements SmService<Inquiry, Integer> {

    private final InquiryRepository inquiryRepository;

    @Override
    public void register(Inquiry inquiry) throws Exception {
        if (inquiry.getStatus() == null || inquiry.getStatus().isEmpty()) {
            inquiry.setStatus("OPEN");
        }
        inquiryRepository.insert(inquiry);
    }

    @Override
    public void modify(Inquiry inquiry) throws Exception {
        inquiryRepository.update(inquiry);
    }

    @Override
    public void remove(Integer inquiryId) throws Exception {
        inquiryRepository.delete(inquiryId);
    }

    @Override
    public List<Inquiry> get() throws Exception {
        return inquiryRepository.selectAll();
    }

    @Override
    public Inquiry get(Integer inquiryId) throws Exception {
        return inquiryRepository.select(inquiryId);
    }

    public List<Inquiry> getByCust(String custId) throws Exception {
        return inquiryRepository.selectByCust(custId);
    }

    public void updateStatus(Integer inquiryId, String status) throws Exception {
        inquiryRepository.updateStatus(inquiryId, status);
    }
}
