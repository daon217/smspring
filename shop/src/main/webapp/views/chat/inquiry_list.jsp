<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="container-fluid">
    <div class="row mb-3">
        <div class="col">
            <h3 class="font-weight-bold">내 문의 내역</h3>
        </div>
    </div>
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table mb-0">
                    <thead class="thead-light">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th style="width: 140px;">분류</th>
                        <th style="width: 140px;">상태</th>
                        <th>등록일</th>
                        <th style="width: 120px;" class="text-center">상세</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="inquiry" items="${inquiries}">
                        <tr>
                            <td>${inquiry.inquiryId}</td>
                            <td>${inquiry.category}</td>
                            <td>${inquiry.status}</td>
                            <td>${fn:substring(fn:replace(inquiry.createdAt, 'T', ' '), 0, 16)}</td>
                            <td class="text-center">
                                <a class="btn btn-sm btn-primary" href="<c:url value='/inquiry/chat?inquiryId=${inquiry.inquiryId}'/>">채팅</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty inquiries}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">등록된 문의가 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
