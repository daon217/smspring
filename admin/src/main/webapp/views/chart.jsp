<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .chart-wrapper {
        margin-bottom: 1.5rem;
    }

    .chart-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 0.5rem;
    }

    .chart-provider {
        font-size: 0.85rem;
        color: #6c757d;
    }

    #container,
    #container2,
    #container3,
    #container4 {
        width: 100%;
        height: 260px;
        border-radius: 0.35rem;
    }

    #container {
        border: 2px #32CD32 solid;
    }

    #container2 {
        border: 2px #FF0000 solid;
    }

    #container3 {
        border: 2px #682699 solid;
    }

    #container4 {
        border: 2px #0000FF solid;
    }

    .metric-card-value {
        font-size: 1.75rem;
        font-weight: 700;
    }
</style>
<script>
    const chartPage = {
        adminId: null,
        sse: null,
        charts: {},
        providers: {},
        metrics: {},
        maxPoints: 20,
        init: function () {
            this.createCharts();
            <c:if test="${sessionScope.admin.adminId != null}">
            this.adminId = '${sessionScope.admin.adminId}';
            this.connect();
            </c:if>
        },
        createCharts: function () {
            this.createChart('chart1', 'container', '#32CD32', '센서 1');
            this.createChart('chart2', 'container2', '#FF0000', '센서 2');
            this.createChart('chart3', 'container3', '#682699', '센서 3');
            this.createChart('chart4', 'container4', '#0000FF', '센서 4');
        },
        createChart: function (chartId, containerId, color, title) {
            const gradient = {
                linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                stops: [
                    [0, color],
                    [1, Highcharts.color(color).setOpacity(0).get('rgba')]
                ]
            };
            const chart = Highcharts.chart(containerId, {
                chart: {
                    type: 'areaspline',
                    animation: Highcharts.svg,
                    marginRight: 10
                },
                title: {
                    text: title
                },
                time: {
                    useUTC: false
                },
                xAxis: {
                    type: 'datetime',
                    tickPixelInterval: 150
                },
                yAxis: {
                    title: {
                        text: '값'
                    },
                    min: 0
                },
                tooltip: {
                    xDateFormat: '%H:%M:%S',
                    pointFormat: '<b>{point.y}</b>'
                },
                legend: {
                    enabled: false
                },
                credits: {
                    enabled: false
                },
                plotOptions: {
                    areaspline: {
                        color: color,
                        fillColor: gradient,
                        threshold: null,
                        marker: {
                            enabled: true,
                            radius: 3,
                            lineWidth: 1,
                            lineColor: color,
                            fillColor: '#ffffff'
                        }
                    }
                },
                series: [{
                    name: title,
                    data: []
                }]
            });
            this.charts[chartId] = chart;
            this.providers[chartId] = $('#source-' + chartId);
            this.metrics[chartId] = $('#metric-' + chartId);
        },
        connect: function () {
            if (!this.adminId) {
                console.warn('관리자 계정으로 로그인해야 실시간 데이터를 볼 수 있습니다.');
                return;
            }
            const url = '${shopSseUrl}' + 'connect/' + this.adminId;
            this.sse = new EventSource(url);
            this.sse.addEventListener('connect', (event) => {
                console.log('shop sse connected', event.data);
            });
            this.sse.addEventListener('chart-data', (event) => {
                try {
                    const payload = JSON.parse(event.data);
                    this.updateChart(payload);
                } catch (error) {
                    console.error('차트 데이터를 처리할 수 없습니다.', error, event.data);
                }
            });
        },
        updateChart: function (payload) {
            if (!payload || !payload.chartId) {
                return;
            }
            const chart = this.charts[payload.chartId];
            if (!chart) {
                return;
            }
            const timestamp = payload.timestamp || Date.now();
            const value = typeof payload.value === 'number' ? payload.value : parseInt(payload.value, 10);
            if (Number.isNaN(value)) {
                return;
            }
            const shouldShift = chart.series[0].data.length >= this.maxPoints;
            chart.series[0].addPoint([timestamp, value], true, shouldShift);
            const providerLabel = this.providers[payload.chartId];
            if (providerLabel && providerLabel.length) {
                const providerText = payload.provider && payload.provider.trim().length > 0
                    ? payload.provider
                    : '알 수 없음';
                providerLabel.text('최근 데이터 제공: ' + providerText);
            }
            const metricDisplay = this.metrics[payload.chartId];
            if (metricDisplay && metricDisplay.length) {
                metricDisplay.text(value.toLocaleString());
            }
        }
    };
    $(function () {
        chartPage.init();
        $(window).on('beforeunload', function () {
            if (chartPage.sse) {
                chartPage.sse.close();
            }
        });
    });
</script>
<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Chart</h1>
        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                class="fas fa-download fa-sm text-white-50"></i> Generate Report</a>
    </div>

    <!-- Metrics Row -->
    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Live A
                            </div>
                            <div class="metric-card-value text-gray-800" id="metric-chart1">-</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-thermometer-half fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Live B
                            </div>
                            <div class="metric-card-value text-gray-800" id="metric-chart2">-</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-bolt fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Live C
                            </div>
                            <div class="metric-card-value text-gray-800" id="metric-chart3">-</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-tachometer-alt fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Live D
                            </div>
                            <div class="metric-card-value text-gray-800" id="metric-chart4">-</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-water fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
                    <c:if test="${sessionScope.admin.adminId == null}">
                        <div class="alert alert-warning mb-4" role="alert">
                            로그인 하쇼
                        </div>
                    </c:if>
                    <div class="row">
                        <div class="col-sm-6 chart-wrapper">
                            <div class="chart-header">
                                <h6 class="font-weight-bold mb-0">LiveData A</h6>
                                <div class="chart-provider" id="source-chart1">데이터 없음</div>
                            </div>
                            <div id="container"></div>
                        </div>
                        <div class="col-sm-6 chart-wrapper">
                            <div class="chart-header">
                                <h6 class="font-weight-bold mb-0">LiveData B</h6>
                                <div class="chart-provider" id="source-chart2">데이터 없음</div>
                            </div>
                            <div id="container2"></div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6 chart-wrapper">
                            <div class="chart-header">
                                <h6 class="font-weight-bold mb-0">LiveData C</h6>
                                <div class="chart-provider" id="source-chart3">데이터 없음</div>
                            </div>
                            <div id="container3"></div>
                        </div>
                        <div class="col-sm-6 chart-wrapper">
                            <div class="chart-header">
                                <h6 class="font-weight-bold mb-0">LiveData D</h6>
                                <div class="chart-provider" id="source-chart4">데이터 없음</div>
                            </div>
                            <div id="container4"></div>
                        </div>
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
