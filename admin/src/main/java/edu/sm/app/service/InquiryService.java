package edu.sm.app.service;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.repository.InquiryRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
// 관리자 포털에서 문의 데이터를 다루기 위한 서비스 계층이다.
public class InquiryService implements SmService<Inquiry, Integer> {

    private final InquiryRepository inquiryRepository;

    @Override
    // 새 문의가 저장될 때 기본 진행 상태를 보정한다.
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
        // 특정 고객의 문의 이력을 조회해 상담 대상자를 파악한다.
        return inquiryRepository.selectByCust(custId);
    }

    public void updateStatus(Integer inquiryId, String status) throws Exception {
        // 상담 처리 단계 변경 요청을 저장한다.
        inquiryRepository.updateStatus(inquiryId, status);
    }
}
