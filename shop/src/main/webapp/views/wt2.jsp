<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #map{ width:auto; height:400px; border:2px solid red; }
    #weather-info { border: 1px solid #ccc; padding: 10px; margin-top: 20px; }
</style>

<div class="col-sm-10">
    <h2>Weather 2 Page</h2>
    <h5>Title description, Sep 2, 2017</h5>
    <button id="btn-seoul" class="btn btn-primary">서울 날씨</button>
    <button id="btn-cb" class="btn btn-primary">충청북도 날씨</button>
    <button id="btn-gn" class="btn btn-primary">경상남도 날씨</button>
    <div id="weather-info"></div>
    <div id="map"></div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APPKEY&libraries=services"></script>
<script>
    var map;
    var marker;

    function setCenter(lat, lng) {
        var moveLatLon = new kakao.maps.LatLng(lat, lng);
        map.setCenter(moveLatLon);

        if (marker) {
            marker.setPosition(moveLatLon);
        }
    }

    function initMap() {
        var mapContainer = document.getElementById('map');
        var mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 3
        };

        map = new kakao.maps.Map(mapContainer, mapOption);

        var zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        var initialPosition = map.getCenter();
        marker = new kakao.maps.Marker({
            position: initialPosition,
            map: map
        });
    }

    function getWeather(regionName, landRegId, taRegId) {
        $.ajax({
            url: '/getWeather',
            data: {
                landRegId: landRegId,
                taRegId: taRegId
            },
            dataType: 'json',
            success: function(data) {
                var weatherInfo = '';
                if (data.resultCode === '00' && data.weather) {
                    var weather = data.weather;
                    weatherInfo += '<h3>' + regionName + ' 날씨 전망</h3>';
                    weatherInfo += '<p>4일 후 날씨 (오전): ' + weather.wf4Am + '</p>';
                    weatherInfo += '<p>4일 후 날씨 (오후): ' + weather.wf4Pm + '</p>';
                    weatherInfo += '<p>최고 기온: ' + weather.taMax4 + '℃</p>';
                    weatherInfo += '<p>최저 기온: ' + weather.taMin4 + '℃</p>';
                    weatherInfo += '<p>강수 확률 (오전): ' + weather.rnSt4Am + '%</p>';
                    weatherInfo += '<p>강수 확률 (오후): ' + weather.rnSt4Pm + '%</p>';
                } else {
                    weatherInfo = '<p>데이터를 불러오는 중 오류가 발생했습니다.</p>';
                }
                $('#weather-info').html(weatherInfo);
            },
            error: function(xhr, status, error) {
                $('#weather-info').html('<p>날씨 정보를 가져오는 중 서버 오류가 발생했습니다.</p>');
                console.error("AJAX Error:", status, error);
            }
        });
    }

    $(document).ready(function() {
        initMap();

        // 서울: 육상예보(11B00000), 기온예보(11B10101)
        $('#btn-seoul').click(function() {
            setCenter(37.537385, 126.989246);
            getWeather('서울', '11B00000', '11B10101');
        });
        // 충청북도: 육상예보(11C10000), 기온예보(11C10301)
        $('#btn-cb').click(function() {
            setCenter(36.996997, 127.915834);
            getWeather('충청북도', '11C10000', '11C10301');
        });
        // 경상남도: 육상예보(11H20000), 기온예보(11H20101)
        $('#btn-gn').click(function() {
            setCenter(35.126505, 129.036911);
            getWeather('경상남도', '11H20000', '11H20101');
        });
    });
</script>
