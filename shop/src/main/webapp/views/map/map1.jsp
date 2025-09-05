<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #map1{ width:auto; height:400px; border:2px solid red; }
</style>

<script>
    let map1 = {
        map: null,
        currentPosition: null,
        markers: [],

        init: function() {
            this.makeMap();
            $('#btn1').click(() => {
                this.currentPosition ? this.getData('병원') : alert('현재 위치를 먼저 확인해주세요.');
            });
            $('#btn2').click(() => {
                this.currentPosition ? this.getData('편의점') : alert('현재 위치를 먼저 확인해주세요.');
            });
        },

        clearMarkers: function() {
            this.markers.forEach(marker => marker.setMap(null));
            this.markers = [];
        },

        getData: function(category) {
            this.clearMarkers();

            $.ajax({
                url: '/getnearby',
                data: {
                    lat: this.currentPosition.getLat(),
                    lng: this.currentPosition.getLng(),
                    category: category
                },
                success: (places) => {
                    places.forEach(place => {
                        let placePosition = new kakao.maps.LatLng(place.lat, place.lng);
                        let marker = new kakao.maps.Marker({
                            map: this.map,
                            position: placePosition,
                            title: place.name
                        });
                        this.markers.push(marker);
                    });
                }
            });
        },

        makeMap: function() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((position) => {
                    // 1. 사용자의 현재 위치를 먼저 얻어옵니다.
                    let lat = position.coords.latitude;
                    let lng = position.coords.longitude;

                    this.currentPosition = new kakao.maps.LatLng(lat, lng);

                    // 2. 현재 위치를 중심으로 지도 생성 옵션을 만듭니다.
                    let mapContainer = document.getElementById('map1');
                    let mapOption = {
                        center: this.currentPosition, // 지도의 중심을 현재 위치로 설정
                        level: 5
                    };

                    // 3. 지도와 컨트롤들을 생성합니다.
                    this.map = new kakao.maps.Map(mapContainer, mapOption);
                    let mapTypeControl = new kakao.maps.MapTypeControl();
                    this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
                    let zoomControl = new kakao.maps.ZoomControl();
                    this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

                    // 4. 현재 위치에 마커를 표시합니다.
                    new kakao.maps.Marker({ map: this.map, position: this.currentPosition });

                    // 5. 현재 위치의 주소를 가져옵니다.
                    var geocoder = new kakao.maps.services.Geocoder();
                    geocoder.coord2Address(lng, lat, (result, status) => {
                        if (status === kakao.maps.services.Status.OK) {
                            var detailAddr = result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                            $('#addr1').html('현재위치: ' + detailAddr);
                        }
                    });
                }, (error) => {
                    console.error("Geolocation 오류:", error);
                    alert("위치 정보를 가져오는 데 실패했습니다. 브라우저의 위치 권한을 확인해주세요.");
                });
            } else {
                alert('이 브라우저는 위치 정보를 지원하지 않습니다.');
            }
        }
    };

    $(function() {
        map1.init();
    });
</script>

<div class="col-sm-10">
    <h2>Map1</h2>
    <h5 id="latlog"></h5>
    <h3 id="addr1">위치 정보를 찾는 중...</h3>
    <h3 id="addr2"></h3>
    <button id="btn1" class="btn btn-primary">병원</button>
    <button id="btn2" class="btn btn-primary">편의점</button>
    <div id="map1"></div>
</div>