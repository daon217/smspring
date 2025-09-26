<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .inquiry-chat-wrapper {
        height: 520px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        display: flex;
        flex-direction: column;
    }

    .inquiry-chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 16px;
        background-color: #f8f9fc;
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
        background-color: #1cc88a;
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
    const adminEndChatUrl = '<c:url value="/" />';


    const adminInquiryChat = {
        inquiryId: ${inquiry.inquiryId},
        senderId: '${sessionScope.admin.adminId}',
        targetId: '${inquiry.custId}',
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
            const content = $('#adminInquiryMessage').val().trim();
            if (!content) {
                return;
            }
            const payload = {
                sendid: this.senderId,
                receiveid: this.channel,
                content1: content,
                inquiryId: this.inquiryId,
                senderType: 'ADMIN'
            };
            this.stompClient.send('/adminreceiveto', {}, JSON.stringify(payload));
            $('#adminInquiryMessage').val('');
        },
        appendMessage: function (payload) {
            const isMine = payload.sendid === this.senderId;
            const wrapper = $('<div class="mb-2"></div>').addClass(isMine ? 'text-right' : 'text-left');
            const bubble = $('<div class="chat-bubble"></div>').addClass(isMine ? 'me' : 'other').text(payload.content1);
            const meta = $('<div class="chat-meta"></div>');
            const timeText = payload.createdAt ? payload.createdAt.replace('T', ' ').substring(0, 16) : new Date().toISOString().replace('T', ' ').substring(0, 16);
            meta.text((isMine ? '관리자' : '고객') + ' · ' + timeText);
            wrapper.append(bubble).append('<br/>').append(meta);
            $('#adminChatHistory').append(wrapper);
            const history = document.getElementById('adminChatHistory');
            history.scrollTop = history.scrollHeight;
        },
        endChat: function () {
            const redirectUrl = adminEndChatUrl;
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
            $('#adminSendInquiryMessage').click(() => this.send());
            $('#adminInquiryMessage').on('keypress', event => {
                if (event.which === 13 && !event.shiftKey) {
                    event.preventDefault();
                    this.send();
                }
            });
            $('#adminEndChat').click(() => this.endChat());
        },
        init: function () {
            this.bind();
            this.connect();
            const history = document.getElementById('adminChatHistory');
            history.scrollTop = history.scrollHeight;
        }
    };

    $(function () {
        adminInquiryChat.init();
    });
</script>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">문의 채팅</h1>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <div>
                <h6 class="m-0 font-weight-bold text-primary">${inquiry.custId} 고객님과의 상담</h6>
                <small class="text-muted">분류: ${inquiry.category} · 상태: ${inquiry.status}</small>
            </div>
            <button type="button" class="btn btn-outline-secondary btn-sm" id="adminEndChat">
                <i class="fas fa-door-open mr-1"></i>채팅 종료
            </button>
        </div>
        <div class="card-body">
            <div class="inquiry-chat-wrapper">
                <div class="inquiry-chat-messages" id="adminChatHistory">
                    <c:forEach var="message" items="${messages}">
                        <c:set var="isMe" value="${message.senderId == sessionScope.admin.adminId}" />
                        <div class="mb-2 ${isMe ? 'text-right' : 'text-left'}">
                            <div class="chat-bubble ${isMe ? 'me' : 'other'}">
                                    ${message.content}
                            </div>
                            <br/>
                            <div class="chat-meta">
                                <c:choose>
                                    <c:when test="${isMe}">관리자</c:when>
                                    <c:otherwise>고객</c:otherwise>
                                </c:choose>
                                ·
                                <c:out value="${fn:substring(fn:replace(message.createdAt, 'T', ' '), 0, 16)}" />
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="inquiry-chat-input">
                    <div class="input-group">
                        <textarea class="form-control" id="adminInquiryMessage" rows="2" placeholder="답변을 입력하세요" style="resize: none;"></textarea>
                        <div class="input-group-append">
                            <button class="btn btn-success" type="button" id="adminSendInquiryMessage">보내기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>