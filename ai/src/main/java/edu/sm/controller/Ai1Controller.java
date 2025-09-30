package edu.sm.controller;

import edu.sm.app.springai.service1.AiServiceByChatClient;
import edu.sm.app.springai.service1.AiServiceChainOfThoughtPrompt; // 오타 수정
import edu.sm.app.springai.service1.AiServiceFewShotPrompt;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/ai1")
@Slf4j
@RequiredArgsConstructor
public class Ai1Controller {

    // 스프링에서 주입받은 서비스 인스턴스
    private final AiServiceByChatClient aiService;
    private final AiServiceChainOfThoughtPrompt aiServicetp; // 세미콜론 추가, import 경로 수정
    final private AiServiceFewShotPrompt aiServicefsp;

    // 일반 텍스트 응답
    @RequestMapping(value = "/chat-model")
    public String chatModel(@RequestParam("question") String question) {
        return aiService.generateText(question);
    }

    // 스트리밍 텍스트 응답
    @RequestMapping(value = "/chat-model-stream")
    public Flux<String> chatModelStream(@RequestParam("question") String question) {
        return aiService.generateStreamText(question);
    }

    // 체인 오브 쏘트 응답
    @RequestMapping(value = "/chat-of-thought")
    public Flux<String> chainOfThought(@RequestParam("question") String question) {
        return aiServicetp.chainOfThought(question);
    }

    @RequestMapping(value = "/few-shot-prompt")
    public String fewShotPrompt(@RequestParam("question") String question) {
        String answer = aiServicefsp.fewShotPrompt(question);
        return answer;
    }
}
