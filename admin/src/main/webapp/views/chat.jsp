<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .inquiry-admin {
        display: flex;
        gap: 1.5rem;
    }
    .inquiry-admin__sidebar {
        width: 220px;
    }
    .inquiry-admin__list {
        list-style: none;
        padding-left: 0;
        margin: 0;
        border: 1px solid #dee2e6;
        border-radius: 0.5rem;
        max-height: 360px;
        overflow-y: auto;
    }
    .inquiry-admin__list-item {
        padding: 0.75rem 1rem;
        border-bottom: 1px solid #f1f3f5;
        cursor: pointer;
    }
    .inquiry-admin__list-item:last-child {
        border-bottom: none;
    }
    .inquiry-admin__list-item.active {
        background-color: #e7f1ff;
        font-weight: bold;
    }
    .inquiry-admin__content {
        flex: 1;
    }
    .inquiry-admin__log {
        height: 360px;
        overflow-y: auto;
        border: 1px solid #dee2e6;
        border-radius: 0.5rem;
        padding: 1rem;
        background-color: #fff;
    }
    .inquiry-admin__entry {
        margin-bottom: 0.75rem;
    }
    .inquiry-admin__entry--mine {
        text-align: right;
    }
    .inquiry-admin__meta {
        font-size: 0.85rem;
        color: #6c757d;
    }
</style>
<script>
    const adminInquiry = {
        stompClient: null,
        adminId: '',
        activeTarget: '',
        conversations: {},
        init() {
            this.adminId = '${sessionScope.admin.adminId}';
            this.bindEvents();
            this.connect();
        },
        bindEvents() {
            $('#send').on('click', () => this.send());
            $('#message').on('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    this.send();
                }
            });
            $('#new-target').on('click', () => {
                const manualTarget = $('#manual-target').val().trim();
                if (manualTarget) {
                    this.ensureConversation(manualTarget);
                    this.setActiveTarget(manualTarget);
                    $('#manual-target').val('');
                }
            });
        },
        connect() {
            const socket = new SockJS('${websocketurl}adminchat');
            this.stompClient = Stomp.over(socket);
            this.stompClient.connect({}, () => {
                $('#status').text('Connected');
                this.subscribe();
            }, () => {
                $('#status').text('Disconnected');
            });
        },
        subscribe() {
            const destination = `/adminsend/to/${this.adminId}`;
            this.stompClient.subscribe(destination, (message) => {
                const payload = JSON.parse(message.body);
                const sender = payload.sendid;
                const text = payload.content1;
                this.ensureConversation(sender);
                this.addMessage(sender, text, false);
                if (!this.activeTarget) {
                    this.setActiveTarget(sender);
                }
            });
        },
        ensureConversation(partner) {
            if (!this.conversations[partner]) {
                this.conversations[partner] = [];
                const item = $('<li/>')
                    .addClass('inquiry-admin__list-item')
                    .attr('data-partner', partner)
                    .text(partner)
                    .on('click', () => this.setActiveTarget(partner));
                $('#partner-list').append(item);
            }
        },
        setActiveTarget(partner) {
            this.activeTarget = partner;
            $('#partner-list .inquiry-admin__list-item').removeClass('active');
            $(`#partner-list .inquiry-admin__list-item[data-partner="${partner}"]`).addClass('active');
            $('#active-partner').text(partner);
            this.renderConversation(partner);
            $('#message').focus();
        },
        addMessage(partner, text, mine) {
            this.conversations[partner].push({ sender: mine ? this.adminId : partner, text, mine });
            if (this.activeTarget === partner) {
                this.renderConversation(partner);
            }
        },
        renderConversation(partner) {
            const log = $('#conversation-log');
            log.empty();
            (this.conversations[partner] || []).forEach((msg) => {
                const entry = $('<div/>').addClass('inquiry-admin__entry');
                if (msg.mine) {
                    entry.addClass('inquiry-admin__entry--mine');
                }
                entry.append($('<div/>').addClass('inquiry-admin__meta').text(msg.sender));
                entry.append($('<div/>').text(msg.text));
                log.append(entry);
            });
            log.scrollTop(log.prop('scrollHeight'));
        },
        send() {
            if (!this.activeTarget) {
                alert('대상 고객을 선택하거나 추가하세요.');
                return;
            }
            const text = $('#message').val().trim();
            if (!text) {
                return;
            }
            if (!this.stompClient || !this.stompClient.connected) {
                alert('연결이 완료되지 않았습니다. 잠시 후 다시 시도하세요.');
                return;
            }
            const payload = {
                sendid: this.adminId,
                receiveid: this.activeTarget,
                content1: text
            };
            this.stompClient.send('/adminreceiveto', {}, JSON.stringify(payload));
            this.addMessage(this.activeTarget, text, true);
            $('#message').val('').focus();
        }
    };
    $(() => adminInquiry.init());
</script>
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">실시간 문의 응대</h1>
            <div class="text-muted small">운영자 ID: <strong>${sessionScope.admin.adminId}</strong> · <span id="status">Connecting...</span></div>
        </div>
    </div>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">대화 목록</h6>
            <div class="input-group input-group-sm" style="width: 240px;">
                <input type="text" id="manual-target" class="form-control" placeholder="고객 ID 직접 입력">
                <button class="btn btn-outline-primary" id="new-target" type="button">대상 설정</button>
            </div>
        </div>
        <div class="card-body">
            <div class="inquiry-admin">
                <aside class="inquiry-admin__sidebar">
                    <ul id="partner-list" class="inquiry-admin__list"></ul>
                </aside>
                <section class="inquiry-admin__content">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h5 class="mb-0">대상: <span id="active-partner" class="text-primary">선택되지 않음</span></h5>
                    </div>
                    <div id="conversation-log" class="inquiry-admin__log mb-3"></div>
                    <div class="input-group">
                        <textarea id="message" class="form-control" rows="2" placeholder="메시지를 입력하세요"></textarea>
                        <button class="btn btn-primary" id="send" type="button">전송</button>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>
