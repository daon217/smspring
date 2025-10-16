package edu.sm.sse;

import edu.sm.app.dto.AdminMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
@Slf4j
public class SseEmitters {

    private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();

    /* ---------- public API ---------- */

    public void sendData(AdminMsg adminMsg) {
        emitters.entrySet().removeIf(entry -> {
            String key = entry.getKey();
            // 특정 클라이언트만 선택 전송
            if (!("admin".equals(key) || "admin2".equals(key))) return false;

            SseEmitter emitter = entry.getValue();
            boolean ok = safeSend(emitter, "adminmsg", adminMsg);
            return !ok; // 실패하면 맵에서 제거
        });
    }

    public void msg(String msg) {
        emitters.entrySet().removeIf(entry -> !safeSend(entry.getValue(), "msg", msg));
    }

    public void count(int num) {
        emitters.entrySet().removeIf(entry -> !safeSend(entry.getValue(), "count", num));
    }

    public SseEmitter add(String clientId, SseEmitter emitter) {
        emitters.put(clientId, emitter);
        log.info("SSE emitter added: id={}, size={}", clientId, emitters.size());

        // 연결 종료/오류/타임아웃 시 조용히 제거
        emitter.onCompletion(() -> removeQuiet(clientId, "completion"));
        emitter.onTimeout(() -> removeQuiet(clientId, "timeout"));
        emitter.onError(ex -> removeQuiet(clientId, "error: " + ex.getClass().getSimpleName()));

        return emitter;
    }

    public void close(String clientId) {
        removeQuiet(clientId, "manual-close");
    }

    /* ---------- internal helpers ---------- */

    /** 클라이언트가 중간에 끊어도 예외를 터뜨리지 않고 조용히 정리 */
    private boolean safeSend(SseEmitter emitter, String eventName, Object data) {
        try {
            emitter.send(SseEmitter.event().name(eventName).data(data));
            return true;
        } catch (IllegalStateException | IOException ex) {
            // 대부분 ClientAbort / 브라우저 네비게이션 / DevTools 리로드
            log.debug("SSE send aborted ({}): {}", eventName, ex.toString());
            cleanupEmitter(emitter);
            return false;
        } catch (Exception ex) {
            // 예외 상황을 너무 시끄럽게 만들지 않기 위해 warn 정도만
            log.warn("SSE send failed ({}): {}", eventName, ex.toString());
            cleanupEmitter(emitter);
            return false;
        }
    }

    private void removeQuiet(String clientId, String reason) {
        SseEmitter emitter = emitters.remove(clientId);
        if (emitter != null) {
            log.debug("SSE emitter removed: id={}, reason={}, size={}", clientId, reason, emitters.size());
            cleanupEmitter(emitter);
        }
    }

    private void cleanupEmitter(SseEmitter emitter) {
        try {
            emitter.complete();
        } catch (Exception ignore) {
            // 이미 종료된 경우가 많음
        }
    }
}
