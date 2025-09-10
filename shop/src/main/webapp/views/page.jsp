<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 컨트롤러에서 넘어오는 모델 객체 이름이 clist 또는 plist로 다르므로, 이를 pageData라는 공통 변수로 설정합니다. --%>
<c:choose>
    <c:when test="${not empty clist}">
        <c:set var="pageData" value="${clist}" />
    </c:when>
    <c:otherwise>
        <c:set var="pageData" value="${plist}" />
    </c:otherwise>
</c:choose>


<div class="col text-center ">
    <ul class="pagination justify-content-center">
        <c:choose>
            <c:when test="${pageData.prePage != 0}">
                <li class="page-item">
                    <a  class="page-link"  href="<c:url value="${target}/getpage?pageNo=${pageData.prePage}" />">Previous</a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="page-item disabled">
                    <a  class="page-link"  href="#">Previous</a>
                </li>
            </c:otherwise>
        </c:choose>

        <c:forEach begin="${pageData.navigateFirstPage }" end="${pageData.navigateLastPage }" var="page">
            <c:choose>
                <c:when test="${pageData.pageNum == page}">
                    <li class="page-item active">
                        <a class="page-link"  href="<c:url value="${target}/getpage?pageNo=${page}" />">${page }</a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link"  href="<c:url value="${target}/getpage?pageNo=${page}" />">${page }</a>
                    </li>
                </c:otherwise>
            </c:choose>

        </c:forEach>
        <c:choose>
            <c:when test="${pageData.nextPage != 0}">
                <li class="page-item">
                    <a class="page-link"  href="<c:url value="${target}/getpage?pageNo=${pageData.nextPage}" />">Next</a>
                </li>
            </c:when>
            <c:otherwise>
                <li class="page-item disabled">
                    <a class="page-link"  href="#">Next</a>
                </li>
            </c:otherwise>
        </c:choose>

    </ul>
</div>