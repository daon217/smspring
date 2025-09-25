package edu.sm.sse;

import edu.sm.app.dto.ChartStreamMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
@Slf4j
public class SseEmitters {
    private static final long DEFAULT_TIMEOUT = 0L;
    private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();

    public SseEmitter add(String clientId) {
        SseEmitter emitter = new SseEmitter(DEFAULT_TIMEOUT);
        emitters.put(clientId, emitter);
        log.info("new emitter added: {}", clientId);
        log.info("emitter list size: {}", emitters.size());

        emitter.onCompletion(() -> remove(clientId));
        emitter.onTimeout(() -> remove(clientId));
        emitter.onError(throwable -> remove(clientId));

        return emitter;
    }

    public void sendConnectMessage(String clientId) {
        SseEmitter emitter = emitters.get(clientId);
        if (emitter == null) {
            return;
        }
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data(clientId));
        } catch (IOException e) {
            log.warn("failed to send connect message to {}", clientId, e);
            remove(clientId);
        }
    }

    public void sendChartData(ChartStreamMessage message) {
        emitters.forEach((clientId, emitter) -> {
            if (!isAdminClient(clientId)) {
                return;
            }
            try {
                emitter.send(SseEmitter.event()
                        .name("chart-data")
                        .data(message));
            } catch (IOException e) {
                log.warn("failed to send chart data to {}", clientId, e);
                remove(clientId);
            }
        });
    }

    private boolean isAdminClient(String clientId) {
        return clientId != null && clientId.toLowerCase().contains("admin");
    }

    private void remove(String clientId) {
        SseEmitter emitter = emitters.remove(clientId);
        if (emitter != null) {
            try {
                emitter.complete();
            } catch (Exception ignore) {
            }
        }
        log.info("emitter removed: {}", clientId);
    }
}
