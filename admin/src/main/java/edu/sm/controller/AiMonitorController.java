package edu.sm.controller;

import edu.sm.app.springai.service3.AiImageService;
import edu.sm.sse.SseEmitters;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import java.io.IOException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai/monitor")
@RequiredArgsConstructor
@Slf4j
public class AiMonitorController {

    private static final String DEFAULT_ANALYSIS_QUESTION = "현재 화면에 보이는 상황을 3문장 이상으로 자세히 설명하고 위험 요소가 있다면 알려주세요. 마지막 문장에 현재 시각을 포함해 주세요.";

    private static final DateTimeFormatter DISPLAY_TIMESTAMP_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").withZone(ZoneId.systemDefault());

    private final AiImageService aiImageService;
    private final SseEmitters sseEmitters;

    @PostMapping(value = "/frame", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Map<String, Object> analyzeFrame(
            @RequestParam("frame") MultipartFile frame,
            @RequestParam(value = "question", required = false) String question
    ) throws IOException {

        if (frame == null || frame.isEmpty()) {
            return Map.of(
                    "message", "전달된 이미지가 없습니다.",
                    "timestamp", Instant.now().toString()
            );
        }

        String contentType = frame.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return Map.of(
                    "message", "이미지 파일만 업로드할 수 있습니다.",
                    "timestamp", Instant.now().toString()
            );
        }

        String prompt = (question == null || question.isBlank()) ? DEFAULT_ANALYSIS_QUESTION : question;
        Flux<String> responseFlux = aiImageService.imageAnalysis(prompt, contentType, frame.getBytes());

        List<String> pieces = responseFlux.collectList().blockOptional().orElse(List.of("분석 결과를 가져오지 못했습니다."));
        String analysis = String.join("", pieces).trim();
        String finalMessage = analysis.isEmpty() ? "분석 결과를 가져오지 못했습니다." : analysis;

        Instant now = Instant.now();
        String displayTimestamp = DISPLAY_TIMESTAMP_FORMATTER.format(now);
        sseEmitters.msg(String.format("[%s] %s", displayTimestamp, finalMessage));

        Map<String, Object> result = new HashMap<>();
        result.put("message", finalMessage);
        result.put("question", prompt);
        result.put("timestamp", now.toString());
        return result;
    }
}
