<%--정규과정--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #map{
        width:auto;
        height:400px;
        border: 2px solid blue;
    }
    #content{
        margin-top: 83px;
        width:auto;
        height:400px;
        border: 2px solid red;
        overflow: auto;
    }
</style>
<script>
    const map3 = {
        map:null,
        target: 100,
        type: 10,
        markers:[],
        showMarkers:function(map){
            $(this.markers).each((index,item)=>{
                item.setMap(map);
            });
        },
        init:function(){
            this.makeMap(37.554472, 126.980841);

            $('#sbtn').click(()=>{
                this.target = 100;
                this.makeMap(37.554472, 126.980841);
            });
            $('#bbtn').click(()=>{
                this.target = 200;
                this.makeMap(35.175109, 129.175474);
            });
            $('#jbtn').click(()=>{
                this.target = 300;
                this.makeMap(33.254564, 126.560944);
            });
            $('#bank_btn').click(()=>{
                this.showMarkers(null);
                this.markers = [];
                this.type = 10;
                this.getData();
            });
            $('#shop_btn').click(()=>{
                this.showMarkers(null);
                this.markers = [];
                this.type = 20;
                this.getData();
            });
            $('#hos_btn').click(()=>{
                this.showMarkers(null);
                this.markers = [];
                this.type = 30;
                this.getData();
            });
        },
        makeMap:function(lat, lng){
            var mapContainer = document.getElementById('map');
            var mapOption = {
                center: new kakao.maps.LatLng(lat, lng),
                level: 7
            };
            this.map = new kakao.maps.Map(mapContainer, mapOption);

            var mapTypeControl = new kakao.maps.MapTypeControl();
            this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
            var zoomControl = new kakao.maps.ZoomControl();
            this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
        },
        getData:function(){
            $.ajax({
                url:'<c:url value="/getcontents"/>',
                data:{target:this.target,type:this.type },
                success:(result)=>{
                    this.makeMarkers(result);
                }
            });
        },
        // ✅ 이 함수 전체를 교체해주세요.
        makeMarkers: function(datas) {
            let imgSrc2 = '<c:url value="/img/m.jpg"/>';
            let result = '';

            $(datas).each((index, item) => {
                let imgSize = new kakao.maps.Size(30, 30);
                let markerImg = new kakao.maps.MarkerImage(imgSrc2, imgSize);
                var markerPosition = new kakao.maps.LatLng(item.lat, item.lng);

                // ✅ 수정 1: 마커를 생성할 때 'map' 속성을 추가하여 지도에 바로 표시합니다.
                var marker = new kakao.maps.Marker({
                    map: this.map, // 이 줄을 추가합니다.
                    image: markerImg,
                    position: markerPosition
                });

                let iwContent = '<p>' + item.title + '</p>';
                iwContent += '<img style="width:80px;" src="<c:url value="/img/' + item.img + '"/>">';
                var infowindow = new kakao.maps.InfoWindow({
                    content: iwContent
                });

                // ✅ 수정 2: 'this' 문제 해결을 위해 화살표 함수를 사용합니다.
                kakao.maps.event.addListener(marker, 'mouseover', () => {
                    infowindow.open(this.map, marker);
                });
                kakao.maps.event.addListener(marker, 'mouseout', () => {
                    infowindow.close();
                });
                kakao.maps.event.addListener(marker, 'click', () => {
                    location.href = '<c:url value="/map/go?target=' + item.target + '"/>';
                });

                this.markers.push(marker);

                // Make Content List
                result += '<p>';
                result += '<a href="<c:url value="/map/go?target=' + item.target + '"/>">';
                result += '<img width="20px" src="<c:url value="/img/' + item.img + '"/> ">';
                result += item.target + ' ' + item.title;
                result += '</a>';
                result += '</p>';
            });

            $('#content').html(result);
            // this.showMarkers(this.map); // 이제 마커가 바로 표시되므로 이 줄은 사실상 필요 없지만, 그대로 두어도 문제는 없습니다.
        }
    };
    $(function(){
        map3.init();
    });
</script>

<div class="col-sm-10">
    <div class="row">
        <div class="col-sm-8 col-lg-6">
            <h2>Map3 Page</h2>
            <button id="sbtn" class="btn btn-primary">서울</button>
            <button id="bbtn" class="btn btn-primary">부산</button>
            <button id="jbtn" class="btn btn-primary">제주</button>
            <br>
            <button id="bank_btn" class="btn btn-danger">은행</button>
            <button id="shop_btn" class="btn btn-danger">식당</button>
            <button id="hos_btn" class="btn btn-danger">병원</button>
            <div id="map"></div>
        </div>
        <div class="col-sm-4 col-lg-6">
            <div id="content"></div>
        </div>
    </div>
</div>