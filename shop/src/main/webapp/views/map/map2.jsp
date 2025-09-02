center.jsp<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #map{
        width: auto;
        height: 400px;
        border: 2px solid blue;
    }
</style>
<script>
    let map2={
        init:function(){
            // 37.540502, 127.055486
            // $('#sbtn').click(()=>{ 주석하면 서울이 가장먼저 자동으로 나옴
                this.makeMap(37.540502, 127.055486, '남산', 's1.jpg', 100);
            // });
            // 35.171131, 129.174447
            $('#bbtn').click(()=>{
                this.makeMap(35.171131, 129.174447, '해운대', 's2.jpg', 200);
            });
            // 33.248616, 126.412439
            $('#jbtn').click(()=>{
                this.makeMap(33.248616, 126.412439, '중문', 's3.jpg', 300);
            });
        },
        makeMap:function(lat, lng, title, imgName, target){
            let mapContainer = document.getElementById('map');
            let mapOption = {
                center: new kakao.maps.LatLng(lat, lng),
                level: 7
            }
            let map = new kakao.maps.Map(mapContainer, mapOption);
            // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
            let mapTypeControl = new kakao.maps.MapTypeControl();

            // 지도에 컨트롤을 추가해야 지도위에 표시됩니다
            // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

            // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
            let zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // 마커를 생성합니다
            let marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(lat, lng),
                map: map
            });

            //infowindow
            let iwContent ='<p>'+tltle+'</p>';
            iwContent += '<img src="<c:url value="/img/'+imgName+'"/> " style="width:80px;">';
            var infowindow = new kakao.maps.InfoWindow({
                content : iwContent
            });

            // Event
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
            kakao.maps.event.addListener(marker, 'click', function() {
                location.href='<c:url value="/cust/get"/> '
            });
        }
    }

    $(function(){
        map2.init();
    })
</script>
<div class="col-sm-10">
    <h2>map2</h2>
    <butten id="sbtn" class="btn btn-primary">Seoul</butten>
    <butten id="bbtn" class="btn btn-primary">Busan</butten>
    <butten id="jbtn" class="btn btn-primary">Jeju</butten>
    <div id="map"></div>
</div>
