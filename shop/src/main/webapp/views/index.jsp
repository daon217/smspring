<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap 4 Website Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8ebb7e444a8cd5d1f3bbc02bbacb744a&libraries=services"></script>

    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/data.js"></script>
    <script src="https://code.highcharts.com/highcharts-more.js"></script>
    <script src="https://code.highcharts.com/modules/wordcloud.js"></script>
    <script src="https://code.highcharts.com/modules/series-label.js"></script>
    <script src="https://code.highcharts.com/highcharts-3d.js"></script>
    <script src="https://code.highcharts.com/modules/drilldown.js"></script>
    <script src="https://code.highcharts.com/modules/cylinder.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/export-data.js"></script>
    <script src="https://code.highcharts.com/modules/accessibility.js"></script>
    <script src="https://code.highcharts.com/modules/non-cartesian-zoom.js"></script>
    <script src="https://code.highcharts.com/themes/adaptive.js"></script>

    <%-- Web Socket Lib --%>
    <script src="/webjars/sockjs-client/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/stomp.min.js"></script>
</head>
<body>

<div class="jumbotron text-center" style="margin-bottom:0">
    <h1>My First Bootstrap 4 Page</h1>
    <h1><spring:message code="site.title"  arguments="aa,bb"  /></h1>
</div>
<ul class="nav justify-content-end">
    <c:choose>
        <c:when test="${sessionScope.cust.custId == null}">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/register"/> ">Register</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/login"/>">Login</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Link</a>
            </li>
            <li class="nav-item">
                <a class="nav-link disabled" href="#">Disabled</a>
            </li>
        </c:when>
        <c:otherwise>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/custinfo?id=${sessionScope.cust.custId}"/> ">${sessionScope.cust.custId}</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/logout"/> ">Logout</a>
            </li>
        </c:otherwise>
    </c:choose>
</ul>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
    <a class="navbar-brand" href="<c:url value="/"/>">Home</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/cust"/>">Cust</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/product"/>">Product</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/map"/> ">Map</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/chart"/>">Chart</a>
            </li>
            <c:if test="${sessionScope.cust.custId != null}">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value="/chat"/>">Chat</a>
                </li>
            </c:if>
        </ul>
    </div>
</nav>
<div class="container" style="margin-top:30px; margin-bottom: 30px;">
    <div class="row">
        <c:choose>
            <c:when test="${left == null}">
                <jsp:include page="left.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${left}.jsp"/>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${center == null}">
                <jsp:include page="center.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${center}.jsp"/>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="text-center" style="background-color:black; color: white; margin-bottom:0; max-height: 50px;">
    <p>Footer</p>
</div>


<div class="position-fixed" style="right: 24px; bottom: 24px; z-index: 1050;">
    <%-- 고객이 문의 모달을 열 수 있는 플로팅 버튼 --%>
    <button class="btn btn-primary rounded-circle shadow" style="width: 64px; height: 64px;" data-toggle="modal" data-target="#inquiryModal">
        문의사항
    </button>
</div>

<div class="modal fade" id="inquiryModal" tabindex="-1" role="dialog" aria-labelledby="inquiryModalLabel" aria-hidden="true">
    <%-- 문의 분류와 내용을 입력하는 모달 폼 --%>
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="inquiryModalLabel">문의사항 보내기</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="inquiryForm">
                    <div class="form-group">
                        <label for="inquiryCategory">문의 분류</label>
                        <select class="form-control" id="inquiryCategory" name="category" required>
                            <option value="" disabled selected>선택하세요</option>
                            <option value="상품파손">상품파손</option>
                            <option value="배송지연">배송지연</option>
                            <option value="환불문의">환불문의</option>
                            <option value="취소문의">취소문의</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="inquiryContent">문의 내용</label>
                        <textarea class="form-control" id="inquiryContent" name="content" rows="4" required placeholder="문의 내용을 입력하세요"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                <c:if test="${sessionScope.cust.custId != null}">
                    <%-- 로그인 고객에게 기존 문의 목록으로 이동 버튼 제공 --%>
                    <button type="button" class="btn btn-outline-primary" id="openInquiryList">내 문의</button>
                </c:if>
                <button type="button" class="btn btn-primary" id="inquirySubmit">보내기</button>
            </div>
        </div>
    </div>
</div>

<script>
    const inquiryModalHandler = {
        // 문의 모달 동작을 초기화하는 헬퍼
        init: function () {
            $('#inquiryModal').on('hidden.bs.modal', function () {
                // 모달을 닫을 때 입력값 초기화
                $('#inquiryForm')[0].reset();
            });
            $('#inquirySubmit').click(function () {
                // 문의 폼을 서버 제출로 전송
                $('#inquiryForm').attr('action', '<c:url value="/inquiry/submit"/>');
                $('#inquiryForm').attr('method', 'post');
                $('#inquiryForm')[0].submit();
            });
            const openListButton = $('#openInquiryList');
            if (openListButton.length) {
                openListButton.click(function () {
                    // 내 문의 버튼을 누르면 모달을 닫고 목록 페이지로 이동
                    $('#inquiryModal').modal('hide');
                    window.location.href = '<c:url value="/inquiry/list"/>';
                });
            }
        }
    };
    $(function () {
        inquiryModalHandler.init();
    });
</script>

</body>
</html>
