<%--내가만든 교통정보 및 로드뷰 정보 보여주는 지도 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #map5{
        width:auto;
        height:400px;
        border:2px solid red;
    }
</style>

<script>
    // 지도에 추가된 지도타입 정보를 가지고 있을 변수입니다. 전역 변수로 선언합니다.
    var currentTypeId;
    var map; // 지도 객체를 저장할 전역 변수입니다.

    let map5 = {
        init: function() {
            let mapContainer = document.getElementById('map5');
            let mapOption = {
                center: new kakao.maps.LatLng(36.798587, 127.075860),
                level: 7
            };

            // 지도를 생성하여 전역 변수 'map'에 할당합니다.
            map = new kakao.maps.Map(mapContainer, mapOption);
        }
    };

    // setOverlayMapTypeId 함수를 전역 스코프에 정의합니다.
    function setOverlayMapTypeId(maptype) {
        var changeMaptype;

        if (maptype === 'traffic') {
            changeMaptype = kakao.maps.MapTypeId.TRAFFIC;
        } else if (maptype === 'roadview') {
            changeMaptype = kakao.maps.MapTypeId.ROADVIEW;
        } else if (maptype === 'terrain') {
            changeMaptype = kakao.maps.MapTypeId.TERRAIN;
        } else if (maptype === 'use_district') {
            changeMaptype = kakao.maps.MapTypeId.USE_DISTRICT;
        }

        if (currentTypeId) {
            map.removeOverlayMapTypeId(currentTypeId);
        }

        map.addOverlayMapTypeId(changeMaptype);
        currentTypeId = changeMaptype;
    }

    $(function() {
        map5.init();

        // 버튼 클릭 이벤트를 추가합니다.
        // 예를 들어, HTML에 <button onclick="setOverlayMapTypeId('traffic')">교통정보</button> 와 같은 버튼이 있어야 합니다.
    });
</script>

<div class="col-sm-10">
    <h2>map5</h2>
    <div id="map5"> </div>
    <button onclick="setOverlayMapTypeId('traffic')">교통정보 보기</button>
    <button onclick="setOverlayMapTypeId('roadview')">로드뷰 도로정보 보기</button>
</div>