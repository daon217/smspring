<%--day1의 과제였던 랜덤 위치 찍는 지도 --%>
<div id="map7" style="width: 100%; height: 400px;">

</div>

<script>
    // 페이지 로딩이 완료된 후, 지도 관련 코드를 실행합니다.
    window.onload = function() {

        const mapContainer = document.getElementById('map7');

        if (!mapContainer) {
            console.error("HTML에서 id가 'map7'인 div를 찾을 수 없습니다.");
            return;
        }

        const mapOption = {
            center: new kakao.maps.LatLng(36.798587, 127.075860),
            level: 7
        };
        const map = new kakao.maps.Map(mapContainer, mapOption);
        const mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        const zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 마커를 생성합니다. 처음 위치는 지도 중앙으로 설정합니다.
        const marker = new kakao.maps.Marker({
            position: map.getCenter()
        });
        marker.setMap(map);

        // 인포윈도우를 생성합니다.
        const infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;">위치가 곧 업데이트됩니다!</div>',
            removable: true // 닫기 버튼을 추가합니다.
        });

        kakao.maps.event.addListener(marker, 'mouseover', function() {
            infowindow.open(map, marker);
        });
        kakao.maps.event.addListener(marker, 'mouseout', function() {
            infowindow.close();
        });
        kakao.maps.event.addListener(marker, 'click', function() {
            location.href = '<c:url value="/cust/get"/>';
        });

        function updateMarkerPosition() {
            const baseLat = 36.798587;
            const baseLng = 127.075860;
            const offset = 0.01;

            // 새로운 랜덤 좌표 생성
            const randomLat = baseLat + (Math.random() - 0.5) * 2 * offset;
            const randomLng = baseLng + (Math.random() - 0.5) * 2 * offset;
            const newPosition = new kakao.maps.LatLng(randomLat, randomLng);

            // 기존 마커의 위치를 새로운 좌표로 이동시킵니다.
            marker.setPosition(newPosition);

            // 인포윈도우의 내용도 새로운 좌표로 업데이트합니다.
            const newContent = '<div style="padding:5px;">랜덤 위치<br>위도: ' + randomLat.toFixed(6) + '<br>경도: ' + randomLng.toFixed(6) + '</div>';
            infowindow.setContent(newContent);
        }
        // 페이지가 로드되자마자 한 번 실행해서 바로 위치를 바꿉니다.
        updateMarkerPosition();

        setInterval(updateMarkerPosition, 3000);
    };
</script>