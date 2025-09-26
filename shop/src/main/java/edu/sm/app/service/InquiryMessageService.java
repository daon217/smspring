package edu.sm.app.service;

import edu.sm.app.dto.InquiryMessage;
import edu.sm.app.repository.InquiryMessageRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
// 문의에 연결된 메시지를 저장하고 조회하는 서비스 계층이다.
public class InquiryMessageService implements SmService<InquiryMessage, Integer> {

    private final InquiryMessageRepository inquiryMessageRepository;

    @Override
    // 대화창에서 전송된 메시지를 DB에 적재한다.
    public void register(InquiryMessage inquiryMessage) throws Exception {
        inquiryMessageRepository.insert(inquiryMessage);
    }

    @Override
    public void modify(InquiryMessage inquiryMessage) throws Exception {
        inquiryMessageRepository.update(inquiryMessage);
    }

    @Override
    public void remove(Integer messageId) throws Exception {
        inquiryMessageRepository.delete(messageId);
    }

    @Override
    public List<InquiryMessage> get() throws Exception {
        return inquiryMessageRepository.selectAll();
    }

    @Override
    public InquiryMessage get(Integer messageId) throws Exception {
        return inquiryMessageRepository.select(messageId);
    }

    public List<InquiryMessage> getByInquiry(Integer inquiryId) throws Exception {
        // 특정 상담방의 대화 기록을 불러온다.
        return inquiryMessageRepository.selectByInquiry(inquiryId);
    }

    public void removeByInquiry(Integer inquiryId) throws Exception {
        // 문의가 종료될 때 관련 메시지를 일괄 정리한다.
        inquiryMessageRepository.deleteByInquiry(inquiryId);
    }
}
