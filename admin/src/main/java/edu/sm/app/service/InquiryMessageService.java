package edu.sm.app.service;

import edu.sm.app.dto.InquiryMessage;
import edu.sm.app.repository.InquiryMessageRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
// 관리자 채팅 화면에서 메시지를 적재·조회하기 위한 서비스다.
public class InquiryMessageService implements SmService<InquiryMessage, Integer> {

    private final InquiryMessageRepository inquiryMessageRepository;

    @Override
    // 관리자가 남긴 답변도 동일한 저장 흐름을 사용한다.
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
        // 선택한 문의방의 전체 대화 내용을 불러온다.
        return inquiryMessageRepository.selectByInquiry(inquiryId);
    }

    public void removeByInquiry(Integer inquiryId) throws Exception {
        // 문의 삭제 시 대화 로그를 함께 정리한다.
        inquiryMessageRepository.deleteByInquiry(inquiryId);
    }
}
