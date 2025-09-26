package edu.sm.app.service;

import edu.sm.app.dto.InquiryMessage;
import edu.sm.app.repository.InquiryMessageRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InquiryMessageService implements SmService<InquiryMessage, Integer> {

    private final InquiryMessageRepository inquiryMessageRepository;

    @Override
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
        return inquiryMessageRepository.selectByInquiry(inquiryId);
    }

    public void removeByInquiry(Integer inquiryId) throws Exception {
        inquiryMessageRepository.deleteByInquiry(inquiryId);
    }
}