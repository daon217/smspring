<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
  .inquiry-chat-wrapper {
    height: 480px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    display: flex;
    flex-direction: column;
  }

  .inquiry-chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
    background-color: #fafafa;
  }

  .inquiry-chat-input {
    border-top: 1px solid #e0e0e0;
    padding: 12px 16px;
    background-color: #ffffff;
  }

  .chat-bubble {
    padding: 10px 14px;
    border-radius: 16px;
    display: inline-block;
    max-width: 75%;
    word-break: break-word;
  }

  .chat-bubble.me {
    background-color: #007bff;
    color: #ffffff;
  }

  .chat-bubble.other {
    background-color: #e9ecef;
    color: #212529;
  }

  .chat-meta {
    font-size: 0.75rem;
    color: #6c757d;
  }
</style>

<script>
  const inquiryEndChatUrl = '<c:url value="/" />';

  const inquiryChat = {
    inquiryId: ${inquiry.inquiryId},
    senderId: '${sessionScope.cust.custId}',
    channel: 'inquiry-' + ${inquiry.inquiryId},
    stompClient: null,
    connect: function () {
      const socket = new SockJS('${websocketurl}adminchat');
      this.stompClient = Stomp.over(socket);
      this.stompClient.connect({}, frame => {
        console.log('Connected: ' + frame);
        this.stompClient.subscribe('/adminsend/to/' + this.channel, message => {
          const payload = JSON.parse(message.body);
          if (payload.inquiryId !== this.inquiryId) {
            return;
          }
          this.appendMessage(payload);
        });
      });
    },
    send: function () {
      if (!this.stompClient) {
        return;
      }
      const content = $('#inquiryMessage').val().trim();
      if (!content) {
        return;
      }
      const payload = {
        sendid: this.senderId,
        receiveid: this.channel,
        content1: content,
        inquiryId: this.inquiryId,
        senderType: 'CUSTOMER'
      };
      this.stompClient.send('/adminreceiveto', {}, JSON.stringify(payload));
      $('#inquiryMessage').val('');
    },
    appendMessage: function (payload) {
      const isMine = payload.sendid === this.senderId;
      const wrapper = $('<div class="mb-2"></div>').addClass(isMine ? 'text-right' : 'text-left');
      const bubble = $('<div class="chat-bubble"></div>').addClass(isMine ? 'me' : 'other').text(payload.content1);
      const meta = $('<div class="chat-meta"></div>');
      const timeText = payload.createdAt ? payload.createdAt.replace('T', ' ').substring(0, 16) : new Date().toISOString().replace('T', ' ').substring(0, 16);
      meta.text((isMine ? '나' : '관리자') + ' · ' + timeText);
      wrapper.append(bubble).append('<br/>').append(meta);
      $('#chatHistory').append(wrapper);
      const history = document.getElementById('chatHistory');
      history.scrollTop = history.scrollHeight;
    },
    endChat: function () {
      const redirectUrl = inquiryEndChatUrl;
      if (this.stompClient && typeof this.stompClient.disconnect === 'function') {
        try {
          this.stompClient.disconnect();
        } catch (error) {
          console.warn('채팅 연결 종료 중 오류', error);
        }
        this.stompClient = null;
      }
      window.location.href = redirectUrl;
    },
    bind: function () {
      $('#sendInquiryMessage').click(() => this.send());
      $('#inquiryMessage').on('keypress', event => {
        if (event.which === 13 && !event.shiftKey) {
          event.preventDefault();
          this.send();
        }
      });
      $('#endInquiryChat').click(() => this.endChat());
    },
    init: function () {
      this.bind();
      this.connect();
      const history = document.getElementById('chatHistory');
      history.scrollTop = history.scrollHeight;
    }
  };

  $(function () {
    inquiryChat.init();
  });
</script>

<div class="col-sm-10">
  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <div>
        <h5 class="mb-0">문의 채팅</h5>
        <small class="text-muted">분류: ${inquiry.category} · 상태: ${inquiry.status}</small>
      </div>
      <button type="button" class="btn btn-outline-secondary btn-sm" id="endInquiryChat">
        <i class="fas fa-door-open mr-1"></i>채팅 종료
      </button>
    </div>
    <div class="card-body">
      <div class="inquiry-chat-wrapper">
        <div class="inquiry-chat-messages" id="chatHistory">
          <c:forEach var="message" items="${messages}">
            <c:set var="isMe" value="${message.senderId == sessionScope.cust.custId}" />
            <div class="mb-2 ${isMe ? 'text-right' : 'text-left'}">
              <div class="chat-bubble ${isMe ? 'me' : 'other'}">
                  ${message.content}
              </div>
              <br/>
              <div class="chat-meta">
                <c:choose>
                  <c:when test="${isMe}">나</c:when>
                  <c:otherwise>관리자</c:otherwise>
                </c:choose>
                ·
                <c:out value="${fn:substring(fn:replace(message.createdAt, 'T', ' '), 0, 16)}" />
              </div>
            </div>
          </c:forEach>
        </div>
        <div class="inquiry-chat-input">
          <div class="input-group">
            <textarea class="form-control" id="inquiryMessage" rows="2" placeholder="메시지를 입력하세요" style="resize: none;"></textarea>
            <div class="input-group-append">
              <button class="btn btn-primary" type="button" id="sendInquiryMessage">보내기</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>