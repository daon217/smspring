<%--day1의 과제였던 랜덤 위치 찍는 지도 --%>
<div id="map7" style="width: 100%; height: 400px;">

</div>

<script>
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

        const marker = new kakao.maps.Marker({
            position: map.getCenter()
        });
        marker.setMap(map);

        const infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;">위치가 곧 업데이트됩니다!</div>',
            removable: true
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

            const randomLat = baseLat + (Math.random() - 0.5) * 2 * offset;
            const randomLng = baseLng + (Math.random() - 0.5) * 2 * offset;
            const newPosition = new kakao.maps.LatLng(randomLat, randomLng);

            marker.setPosition(newPosition);

            const newContent = '<div style="padding:5px;">랜덤 위치<br>위도: ' + randomLat.toFixed(6) + '<br>경도: ' + randomLng.toFixed(6) + '</div>';
            infowindow.setContent(newContent);
        }
        updateMarkerPosition();

        setInterval(updateMarkerPosition, 3000);
    };
</script>