<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #container{
        width:auto;
        border:2px #ccc solid;
    }

    #container2{
        width:auto;
        border:2px #2a96a5 solid;
    }

    #container3{
        width:auto;
        border:2px #2d4373 solid;
    }

    #container4{
        width:auto;
        border:2px #093b29 solid;
    }

</style>
<script>
    let chart = {
        url1:'https://127.0.0.1:8443/logs/maininfo1.log',
        url2:'https://127.0.0.1:8443/logs/maininfo2.log',
        url3:'https://127.0.0.1:8443/logs/maininfo3.log',
        url4:'https://127.0.0.1:8443/logs/maininfo4.log',
        init: function () {
            this.createChart1();
            this.createChart2();
            this.createChart3();
            this.createChart4();
        },
        createChart1: function () {
            Highcharts.chart('container', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#32CD32',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#32CD32'],
                                [1, '#32CD3200']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url1,
                    enablePolling: 2,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        },
        createChart2: function () {
            Highcharts.chart('container2', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#FF0000',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#FF0000'],
                                [1, '#FF000000']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url2,
                    enablePolling: 2,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        },createChart3: function () {
            Highcharts.chart('container3', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#682699',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#682699'],
                                [1, '#68269900']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url3,
                    enablePolling: 2,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        },
        createChart4: function () {
            Highcharts.chart('container4', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#0000FF',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#0000FF'],
                                [1, '#0000FF00']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url4,
                    enablePolling: 2,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        }
    }
    $(()=>{
        chart.init();
    })
</script>
<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Chart</h1>
        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                class="fas fa-download fa-sm text-white-50"></i> Generate Report</a>
    </div>


    <!-- Content Row -->

    <div class="row">

        <!-- Line Chart -->
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <!-- Card Header - Dropdown -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Earnings Overview</h6>
                </div>
                <!-- Card Body -->
                <div class="card-body">
                    <div class="row">
                        <div class="col-sm-6" id="container"></div>
                        <div class="col-sm-6" id="container2"></div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6" id="container3"></div>
                        <div class="col-sm-6" id="container4"></div>
                    </div>

                </div>
            </div>
        </div>

        <!-- Pie Chart -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <!-- Card Header - Dropdown -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Revenue Sources</h6>
                </div>

                <!-- Card Body -->
                <div class="card-body">

                </div>
            </div>
        </div>
    </div>


</div>
