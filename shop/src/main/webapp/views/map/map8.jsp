<%--map1과 같은 주소를 찍어주는 지도지만 코드가 다름 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #map8 {
        width: auto;
        height: 400px;
        border: 2px solid red;
    }
</style>

<div class="col-sm-10">
    <h2>Map8 <span id="address" style="font-size: 16px; color: #333;"></span></h2>
    <div id="map8"></div>
</div>

<script>
    let map8 = {
        map: null,
        geocoder: null,
        init: function() { // init 함수 시작
            let mapContainer = document.getElementById('map8');
            let mapOption = {
                center: new kakao.maps.LatLng(36.908587, 127.975860),
                level: 5
            };

            this.map = new kakao.maps.Map(mapContainer, mapOption);
            let mapTypeControl = new kakao.maps.MapTypeControl();
            this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
            let zoomControl = new kakao.maps.ZoomControl();
            this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            this.geocoder = new kakao.maps.services.Geocoder();

            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    // 성공 시 콜백 함수
                    (position) => {
                        let lat = position.coords.latitude;
                        let lon = position.coords.longitude;
                        let locPosition = new kakao.maps.LatLng(lat, lon);

                        // 마커를 생성하고 지도에 표시
                        let marker = new kakao.maps.Marker({
                            position: locPosition
                        });
                        marker.setMap(this.map);
                        this.map.panTo(locPosition); // 지도 중심 이동

                        // 좌표로 주소 정보를 요청하고, 결과를 HTML에 표시
                        this.searchAddrFromCoords(locPosition, (result, status) => {
                            if (status === kakao.maps.services.Status.OK) {
                                let addressSpan = document.getElementById('address');
                                let detailAddr = result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                                addressSpan.innerHTML = ' 현재 위치: ' + detailAddr;
                            }
                        });
                    },
                    // 실패 시 콜백 함수
                    (error) => {
                        console.error("Geolocation 오류:", error);
                        alert("위치 정보를 가져오는 데 실패했습니다. 브라우저의 위치 권한을 확인해주세요.");
                        let addressSpan = document.getElementById('address');
                        addressSpan.innerHTML = "위치를 찾을 수 없습니다.";
                    }
                );
            } else {
                alert('이 브라우저는 위치 정보를 지원하지 않습니다.');
            }
        }, // init 함수 끝

        searchAddrFromCoords: function(coords, callback) {
            this.geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
        }
    };

    // HTML 문서가 준비되면 map8.init() 함수를 호출하여 모든 것을 시작
    $(function() {
        map8.init();
    });
</script>