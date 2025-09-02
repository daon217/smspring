<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    /* 1. 지도를 감싸는 컨테이너 - 가로 정렬을 위해 flexbox 사용 */
    #mapWrapper {
        width: 100%; /* 전체 너비를 사용하도록 변경 */
        height: 400px;
        margin-top: 20px;
        display: flex; /* flexbox 사용 */
        justify-content: space-between; /* 요소 사이의 간격 조정 */
    }

    /* 2. 지도와 로드뷰 영역 - 가로 50%씩 차지하도록 변경 */
    #map, #roadview {
        width: 50%;
        height: 100%;
    }

    /* 3. 로드뷰 워커 아이콘 스타일 (이 부분은 동일) */
    .MapWalker {
        width: 50px;
        height: 50px;
        position: relative;
        background: url(https://t1.daumcdn.net/localimg/localimages/07/2018/pc/map_walk.png) no-repeat;
    }

    .MapWalker .figure {
        position: absolute;
        top: 0;
        left: 0;
        width: 50px;
        height: 50px;
        background: url(https://t1.daumcdn.net/localimg/localimages/07/2018/pc/map_walk.png) no-repeat;
        background-position: -50px 0;
    }

    .MapWalker .angleBack {
        position: absolute;
        top: 0;
        left: 0;
        width: 50px;
        height: 50px;
        background: url(https://t1.daumcdn.net/localimg/localimages/07/2018/pc/map_walk.png) no-repeat;
        background-position: -100px 0;
        -webkit-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -ms-transform: rotate(0deg);
        -o-transform: rotate(0deg);
        transform: rotate(0deg);
    }

    .m0 { background-position: 0 -50px; }
    .m1 { background-position: -50px -50px; }
    .m2 { background-position: -100px -50px; }
    .m3 { background-position: -150px -50px; }
    .m4 { background-position: -200px -50px; }
    .m5 { background-position: -250px -50px; }
    .m6 { background-position: -300px -50px; }
    .m7 { background-position: -350px -50px; }
    .m8 { background-position: -400px -50px; }
    .m9 { background-position: -450px -50px; }
    .m10 { background-position: -500px -50px; }
    .m11 { background-position: -550px -50px; }
    .m12 { background-position: -600px -50px; }
    .m13 { background-position: -650px -50px; }
    .m14 { background-position: -700px -50px; }
    .m15 { background-position: -750px -50px; }
</style>

<script>
    // 지도 위에 현재 로드뷰의 위치와, 각도를 표시하기 위한 map walker 아이콘 생성 클래스
    function MapWalker(position) {
        var content = document.createElement('div');
        var figure = document.createElement('div');
        var angleBack = document.createElement('div');
        content.className = 'MapWalker';
        figure.className = 'figure';
        angleBack.className = 'angleBack';
        content.appendChild(angleBack);
        content.appendChild(figure);
        var walker = new kakao.maps.CustomOverlay({
            position: position,
            content: content,
            yAnchor: 1
        });
        this.walker = walker;
        this.content = content;
    }

    // 로드뷰의 pan(좌우 각도)값에 따라 map walker의 백그라운드 이미지를 변경 시키는 함수
    MapWalker.prototype.setAngle = function(angle) {
        var threshold = 22.5;
        for (var i = 0; i < 16; i++) {
            if (angle > (threshold * i) && angle < (threshold * (i + 1))) {
                var className = 'm' + i;
                this.content.className = this.content.className.split(' ')[0];
                this.content.className += (' ' + className);
                break;
            }
        }
    };

    // map walker의 위치를 변경시키는 함수
    MapWalker.prototype.setPosition = function(position) {
        this.walker.setPosition(position);
    };

    // map walker를 지도위에 올리는 함수
    MapWalker.prototype.setMap = function(map) {
        this.walker.setMap(map);
    };

    // 로드뷰와 지도 객체를 저장할 전역 변수
    var map;
    var roadview;
    var roadviewClient;

    // 초기화 함수
    let map7 = {
        init: function() {
            var mapContainer = document.getElementById('map');
            var mapCenter = new kakao.maps.LatLng(33.450701, 126.570667);
            var mapOption = {
                center: mapCenter,
                level: 3
            };

            map = new kakao.maps.Map(mapContainer, mapOption);
            map.addOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);

            var roadviewContainer = document.getElementById('roadview');
            roadview = new kakao.maps.Roadview(roadviewContainer);
            roadviewClient = new kakao.maps.RoadviewClient();

            roadviewClient.getNearestPanoId(mapCenter, 50, function(panoId) {
                roadview.setPanoId(panoId, mapCenter);
            });

            var mapWalker = null;

            kakao.maps.event.addListener(roadview, 'init', function() {
                mapWalker = new MapWalker(mapCenter);
                mapWalker.setMap(map);

                kakao.maps.event.addListener(roadview, 'viewpoint_changed', function() {
                    var viewpoint = roadview.getViewpoint();
                    mapWalker.setAngle(viewpoint.pan);
                });

                kakao.maps.event.addListener(roadview, 'position_changed', function() {
                    var position = roadview.getPosition();
                    mapWalker.setPosition(position);
                    map.setCenter(position);
                });
            });
        }
    };

    $(function() {
        map7.init();
    });
</script>

<div class="col-sm-10">
    <h2>Map6</h2>
    <div id="mapWrapper">
        <div id="map"></div>
        <div id="roadview"></div>
    </div>
</div>