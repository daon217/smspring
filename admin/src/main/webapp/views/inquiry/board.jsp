<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="container-fluid">
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">이용자 문의 게시판</h1>
  </div>

  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">문의 목록</h6>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-bordered" width="100%" cellspacing="0">
          <thead class="thead-light">
          <tr>
            <th style="width: 80px;">번호</th>
            <th style="width: 140px;">회원 ID</th>
            <th style="width: 160px;">문의 분류</th>
            <th style="width: 140px;">상태</th>
            <th>등록일</th>
            <th style="width: 120px;">상세</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="inquiry" items="${inquiries}">
            <tr>
              <td>${inquiry.inquiryId}</td>
              <td>${inquiry.custId}</td>
              <td>${inquiry.category}</td>
              <td>${inquiry.status}</td>
              <td>${fn:substring(fn:replace(inquiry.createdAt, 'T', ' '), 0, 16)}</td>
              <td class="text-center">
                <a class="btn btn-sm btn-primary" href="<c:url value='/inquiry/chat?id=${inquiry.inquiryId}'/>">채팅</a>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty inquiries}">
            <tr>
              <td colspan="6" class="text-center text-muted">등록된 문의가 없습니다.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>