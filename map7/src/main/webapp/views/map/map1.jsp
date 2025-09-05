<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #map1{
        width:auto;
        height:400px;
        border:2px solid red;
    }
</style>
<script>
    let map1 = {
        map:null,
        marker:null,
        PosMarker: null,
        init:function(){
            this.makeMap();
            this.getShop();
            // setInterval(()=>{this.getData()}, 3000);
        },
        getData:function(){
            $.ajax({
                url:'<c:url value="/getlatlng"/>',
                success:(result)=>{
                    console.log(result.lat);
                    console.log(result.lng);
                    this.showMarker(result);
                }
            });
        },
        getShop:function(lat, lng){
            if (lat !== undefined && lng !== undefined){
                $.ajax({
                    url: '<c:url value="/getshop"/>',
                    data:{lat: lat, lng: lng},
                    success: (result) => {
                        this.showMarker(result);
                    }
                });
                return;
            }

            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        let lat = position.coords.latitude;
                        let lng = position.coords.longitude;

                        // 지도 중심을 현재 위치로 이동
                        let moveLatLng = new kakao.maps.LatLng(lat, lng);
                        this.map.setCenter(moveLatLng);

                        if (!this.PosMarker) {
                            // 현재 위치 마커가 없으면 새로 생성
                            this.PosMarker = new kakao.maps.Marker({
                                position: moveLatLng,
                                map: this.map
                            });
                        } else {
                            // 마커가 이미 있으면 위치만 이동
                            this.PosMarker.setPosition(moveLatLng);
                        }

                        // 현재 위치 기준으로 shop 검색
                        this.getShop(lat, lng);
                    },
                    (error) => {
                        console.error('위치 정보를 가져올 수 없습니다:', error);
                        // 위치 정보 실패시 기본값으로 검색
                        this.getShop(36.798745, 127.075888);
                    }
                );
            } else {
                console.error('Geolocation을 지원하지 않는 브라우저입니다.');
                // geolocation 미지원시 기본값으로 검색
                this.getShop(33.798745, 124.075888);
            }
        },
        makeMap:function(){
            let mapContainer = document.getElementById('map1'); // 지도를 표시할 div
            let mapOption = {
                center: new kakao.maps.LatLng(36.798745, 127.075888),
                level: 5
            }
            this.map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성

            let mapTypeControl = new kakao.maps.MapTypeControl(); // 지도 타입 컨트롤
            this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT); // 우측 위에 컨트롤 표시 위치 설정

            let zoomControl = new kakao.maps.ZoomControl(); // 지도 확대/축소 컨트롤 생성
            this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // this.map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC); // 교통정보 표시


        },
        showMarker:function(shops){
            shops.forEach(shop => {
                // 마커 생성
                let marker = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(shop.lat, shop.lng),
                    map: this.map
                });

                // 인포윈도우
                let iwContent  = '<div style="padding:5px;min-width:200px;">';
                iwContent += '<strong>' + shop.addrName + '</strong><br/>';
                iwContent += '주소: ' + shop.address + '<br/>';
                iwContent += '좌표: ' + shop.lat + ', ' + shop.lng + '<br/>';
                iwContent += '<img src="/img/' + shop.img + '" style=" width:100px;">';
                iwContent += '</div>';

                let infowindow = new kakao.maps.InfoWindow({
                    content : iwContent
                });

                // 클릭 이벤트
                kakao.maps.event.addListener(marker, 'mouseover', () => {
                    infowindow.open(this.map, marker);
                });
                kakao.maps.event.addListener(marker, 'mouseout', () => {
                    infowindow.close();
                });
                kakao.maps.event.addListener(marker, 'click', () => {
                    // 상세 페이지 이동
                    kakao.maps.event.addListener(marker, 'click', () => {
                        <%--location.href = '<c:url value="/map/go"/>?locId=' + shop.locId;--%>
                        location.href = '/map/go?locId=' + shop.locId;
                    });

                });
            });
        }

    }
    $(function(){
        map1.init()
    })
</script>

<div class="col-sm-10">
    <h2>Map1</h2>
    <div id="map1"></div>
</div>
