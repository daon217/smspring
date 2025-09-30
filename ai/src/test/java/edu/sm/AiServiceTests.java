package edu.sm;

import edu.sm.app.springai.service1.AiService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import reactor.core.publisher.Flux;

@SpringBootTest
@Slf4j
class AiServiceTests {

    @Autowired
    AiService aiService;

    @Test
    void contextLoads() {
        String question = "천안에 맛집 알려줘";

        Flux<String> result = aiService.generateStreamText(question);

        // 방법 1: 스트리밍으로 바로 출력
        result.doOnNext(chunk -> System.out.print(chunk)) // chunk 단위 출력
                .blockLast(); // Flux 끝까지 기다림

        // 방법 2: 로그로 전체 답변 찍기
        // String fullAnswer = result.collectList().block().stream().reduce("", String::concat);
        // log.info("AI 답변: {}", fullAnswer);
    }
}
