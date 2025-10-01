package edu.sm.app.springai.service2;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ShopMenuItem;
import edu.sm.app.dto.ShopOrderResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AiServiceShop {

    private static final String SYSTEM_PROMPT = """
            아래 규칙과 예시에 따라 순수한 JSON 객체를 생성하세요.
            절대 JSON 이외의 설명, 주석, 마크다운(` ``` `)을 포함해서는 안 됩니다.

            --- 응답 JSON 구조 ---
            {
              "status": "상태",
              "message": "고객에게 보여줄 친절한 응답 메시지",
              "orderData": { "order_items": [] },
              "unavailableItems": ["주문 불가 메뉴 이름"],
              "clarificationQuestions": ["고객에게 할 질문"]
            }

            --- 규칙 ---
            1.  상태(status)는 `SUCCESS`, `PARTIAL_SUCCESS`, `NEEDS_CLARIFICATION`, `SHOW_MENU`, `FAILED` 중 하나여야 합니다.
            2.  주문 처리 규칙:
                - `orderData`: 'SUCCESS' 또는 'PARTIAL_SUCCESS'일 때, 유효한 주문 항목만 JSON 객체 배열로 채웁니다. 각 객체는 `menu_name`, `quantity`, `price`, `image_name`을 포함해야 합니다.
                - `unavailableItems`: 고객이 주문했지만 메뉴판에 없는 항목이 있을 경우, 해당 메뉴 이름을 배열에 추가합니다.
                - `clarificationQuestions`: 고객이 '수육'처럼 사이즈 선택이 필요한 메뉴를 그냥 주문한 경우, "수육은 어떤 사이즈로 하시겠어요? (대, 중, 소)" 와 같이 되물을 질문을 배열에 추가합니다. 이때 '수육'은 `orderData`에 포함시키지 마세요.
            3.  `message` 필드에는 항상 고객에게 보여줄 자연스러운 메시지를 작성해야 합니다.
            4.  가장 중요한 규칙: 당신의 최종 출력물은 반드시 `{`로 시작하여 `}`로 끝나는, 검증 가능한(valid) 순수 JSON 문자열이어야 합니다.

            --- 올바른 응답 예시 ---
            [요청1]: 돼지국밥 2개랑 수육 소짜 하나 주세요.
            [응답1]:
            {
              "status": "SUCCESS",
              "message": "네, 돼지국밥 2개, 수육(소) 1개 주문이 정상적으로 접수되었습니다!",
              "orderData": { "order_items": [ { "menu_name": "돼지국밥", "quantity": 2, "price": 9000, "image_name": "k2.jpg" }, { "menu_name": "수육(소)", "quantity": 1, "price": 15000, "image_name": "k12.jpg" } ] },
              "unavailableItems": [],
              "clarificationQuestions": []
            }

            [요청2]: 메뉴판 좀 보여주세요.
            [응답2]:
            {
              "status": "SHOW_MENU",
              "message": "네, 메뉴판을 보여드릴게요!",
              "orderData": { "order_items": [] },
              "unavailableItems": [],
              "clarificationQuestions": []
            }
            --- 올바른 응답 예시 끝 ---

            --- **절대 해서는 안 되는 잘못된 응답 예시** ---
            [요청]: 메뉴판 좀 보여주세요.
            [잘못된 응답]:
            ```json
            {
              "status": "SHOW_MENU",
              "message": "네, 메뉴판을 보여드릴게요!",
              "orderData": { "order_items": [] },
              "unavailableItems": [],
              "clarificationQuestions": []
            }
            ```
            [올바른 응답]:
            {
              "status": "SHOW_MENU",
              "message": "네, 메뉴판을 보여드릴게요!",
              "orderData": { "order_items": [] },
              "unavailableItems": [],
              "clarificationQuestions": []
            }
            --- 예시 끝 ---
            """;

    private final ChatClient chatClient;
    private final ShopMenuRepository shopMenuRepository;
    private final ObjectMapper objectMapper;

    public AiServiceShop(ChatClient.Builder chatClientBuilder,
                         ShopMenuRepository shopMenuRepository,
                         ObjectMapper objectMapper) {
        this.chatClient = chatClientBuilder.build();
        this.shopMenuRepository = shopMenuRepository;
        this.objectMapper = objectMapper;
    }

    public ShopOrderResponse processOrder(String order) {
        List<ShopMenuItem> menuItems = shopMenuRepository.findAll();
        String userMessage = buildUserMessage(order, menuItems);

        String responseText = chatClient.prompt()
                .system(SYSTEM_PROMPT)
                .user(userMessage)
                .call()
                .content();
        log.debug("AI 응답: {}", responseText);

        ShopOrderResponse response;
        try {
            response = objectMapper.readValue(responseText, ShopOrderResponse.class);
        } catch (JsonProcessingException e) {
            log.error("AI 응답 파싱 실패", e);
            response = new ShopOrderResponse();
            response.setStatus("FAILED");
            response.setMessage("응답 처리 중 오류가 발생했습니다. 다시 시도해주세요.");
            response.setRawResponse(responseText);
            return response;
        }

        if (response.getOrderData() == null) {
            response.setOrderData(new ShopOrderResponse.OrderData());
        }
        if (response.getUnavailableItems() == null) {
            response.setUnavailableItems(new ArrayList<>());
        }
        if (response.getClarificationQuestions() == null) {
            response.setClarificationQuestions(new ArrayList<>());
        }

        if ("SHOW_MENU".equalsIgnoreCase(response.getStatus())) {
            response.setMenuCategories(buildMenuCategories(menuItems));
        }

        return response;
    }

    public List<ShopOrderResponse.MenuCategory> getMenuCategories() {
        return buildMenuCategories(shopMenuRepository.findAll());
    }

    private String buildUserMessage(String order, List<ShopMenuItem> menuItems) {
        String menuSection = buildMenuSection(menuItems);

        return """
                --- 메뉴판 ---
                %s
                --- 메뉴판 끝 ---

                --- 고객의 현재 요청 ---
                %s
                --- 요청 끝 ---
                """.formatted(menuSection, order);
    }

    private String buildMenuSection(List<ShopMenuItem> menuItems) {
        Map<String, List<ShopMenuItem>> grouped = menuItems.stream()
                .collect(Collectors.groupingBy(ShopMenuItem::getCategory, LinkedHashMap::new, Collectors.toList()));

        List<String> sections = new ArrayList<>();
        for (Map.Entry<String, List<ShopMenuItem>> entry : grouped.entrySet()) {
            String items = entry.getValue().stream()
                    .map(item -> "- %s / 가격: %d / 이미지: %s".formatted(item.getMenuName(), item.getPrice(), item.getImageName()))
                    .collect(Collectors.joining("\n"));
            sections.add("[%s]\n%s".formatted(entry.getKey(), items));
        }
        return String.join("\n\n", sections);
    }

    private List<ShopOrderResponse.MenuCategory> buildMenuCategories(List<ShopMenuItem> menuItems) {
        Map<String, List<ShopMenuItem>> grouped = menuItems.stream()
                .collect(Collectors.groupingBy(ShopMenuItem::getCategory, LinkedHashMap::new, Collectors.toList()));

        List<ShopOrderResponse.MenuCategory> categories = new ArrayList<>();
        for (Map.Entry<String, List<ShopMenuItem>> entry : grouped.entrySet()) {
            ShopOrderResponse.MenuCategory category = new ShopOrderResponse.MenuCategory();
            category.setCategory(entry.getKey());
            category.setItems(entry.getValue());
            categories.add(category);
        }
        return categories;
    }
}
