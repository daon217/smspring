<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #detailMap {
    width: auto;
    height: 400px;
    border: 2px solid lightgray;
  }
  .product-info {
    padding: 20px;
    border: 1px solid #dddddd;
    border-radius: 5px;
    margin-bottom: 20px;
  }
</style>

<script>
  let detailMap = {
    init: function() {
      <c:if test="${marker != null}"> // ← 서버에서 전달받은 marker 데이터가 있는지 확인
      let mapContainer = document.getElementById('detailMap');  // 지도를 담을 HTML 요소
      let mapOption = {
        center: new kakao.maps.LatLng(${marker.lat}, ${marker.lng}),  // 지도 중심좌표
        level: 3  // 확대 레벨 (1~14, 숫자가 작을수록 더 확대)
      };
      let map = new kakao.maps.Map(mapContainer, mapOption);  // 지도 객체 생성

      let mapTypeControl = new kakao.maps.MapTypeControl(); // 지도 타입 컨트롤
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT); // 우측 위에 컨트롤 표시 위치 설정

      let zoomControl = new kakao.maps.ZoomControl(); // 지도 확대/축소 컨트롤
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT); // 우측 위치 설정

      // 마커 생성
      let markerPosition = new kakao.maps.LatLng(${marker.lat}, ${marker.lng});  // 마커 위치
      let marker = new kakao.maps.Marker({
        position: markerPosition,  // 마커 위치
        map: map  // 어떤 지도에 표시할지
      });

      // 정보창 생성
      let iwContent = '<div style="padding:5px;">${marker.addrName}</div>';  // 정보창 내용
      let infowindow = new kakao.maps.InfoWindow({
        content: iwContent  // 정보창에 표시할 HTML 내용
      });

      // 마커에 정보창 표시
      infowindow.open(map, marker);  // 정보창을 지도의 마커 위에 표시
      </c:if>
    }
  };

  $(function() {
    detailMap.init();
  });
</script>

<div class="col-sm-10">
  <h2>상품 상세 정보</h2>

  <c:if test="${marker != null}">  <!-- 마커 데이터가 있을 때만 표시 -->
    <div class="product-info">
      <h4>${marker.addrName}</h4>  <!-- 상점명 -->
      <p><strong>상점 ID:</strong> ${marker.locId}</p>  <!-- 상점 ID -->
      <p><strong>주소:</strong> ${marker.address}</p>  <!-- 상점 주소 -->
      <p><strong>위치:</strong> 위도 ${marker.lat}, 경도 ${marker.lng}</p>  <!-- 좌표 -->

      <c:if test="${marker.img != null}">  <!-- 이미지가 있을 때만 표시 -->
        <img src="<c:url value='/img/${marker.img}'/>" alt="${marker.addrName}" style="max-width: 200px;">
      </c:if>
    </div>

    <h5>위치 정보</h5>
    <div id="detailMap"></div>  <!-- 지도가 표시될 영역 -->
  </c:if>

  <c:if test="${marker == null}">  <!-- 마커 데이터가 없을 때 -->
    <div class="alert alert-warning">
      상품 정보를 찾을 수 없습니다.
    </div>
  </c:if>
</div>