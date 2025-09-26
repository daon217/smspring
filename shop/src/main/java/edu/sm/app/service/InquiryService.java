package edu.sm.app.service;

import edu.sm.app.dto.Inquiry;
import edu.sm.app.repository.InquiryRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
// 고객이 생성한 문의의 생성·수정·조회 흐름을 담당하는 서비스다.
public class InquiryService implements SmService<Inquiry, Integer> {

    private final InquiryRepository inquiryRepository;

    @Override
    // 신규 문의가 접수되면 기본 상태를 설정하고 저장한다.
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
        // 마이페이지 문의 목록을 보여주기 위해 고객별 문의만 조회한다.
        return inquiryRepository.selectByCust(custId);
    }

    public void updateStatus(Integer inquiryId, String status) throws Exception {
        // 상담 진행 단계가 바뀔 때 상태 코드를 반영한다.
        inquiryRepository.updateStatus(inquiryId, status);
    }
}
