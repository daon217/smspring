<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .chart-container {
        width: 100%;
        min-height: 300px;
        margin-bottom: 2rem;
    }
</style>
<script>
    function createChart(containerId, titleText, dataUrl, chartType) {
        Highcharts.chart(containerId, {
            chart: {
                type: chartType,
                events: {
                    load: function () {
                        var series = this.series[0];
                        setInterval(function () {
                            $.ajax({
                                url: dataUrl,
                                success: function (result) {
                                    if (Array.isArray(result) && result.length > 0) {
                                        if (series) {
                                            series.setData(result.map(item => item[1]));
                                        } else {
                                            // Handle multi-series data
                                            result.forEach((seriesData, index) => {
                                                if (this.series[index]) {
                                                    this.series[index].setData(seriesData.data);
                                                }
                                            });
                                        }
                                    } else if (result && result.data && Array.isArray(result.data)) {
                                        if (series) {
                                            series.setData(result.data);
                                        }
                                    }
                                }
                            });
                        }, 5000);
                    }
                }
            },
            title: {
                text: titleText
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
            series: [{
                name: 'Data',
                data: []
            }]
        });
    }

    $(function() {
        // Chart 1
        Highcharts.chart('container1', {
            chart: {
                type: 'line',
                events: {
                    load: function () {
                        var chart = this;
                        setInterval(function () {
                            $.ajax({
                                url: '/chart1',
                                success: function (result) {
                                    if (Array.isArray(result)) {
                                        chart.update({
                                            series: result
                                        });
                                    }
                                }
                            });
                        }, 5000);
                    }
                }
            },
            title: {
                text: 'Live Data 1 (Multi-series)'
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            }
        });

        // Chart 2
        Highcharts.chart('container2', {
            chart: {
                type: 'column',
                events: {
                    load: function () {
                        var series = this.series[0];
                        setInterval(function () {
                            $.ajax({
                                url: '/chart2_1',
                                success: function (result) {
                                    if (Array.isArray(result) && result.length > 0) {
                                        var data = result.map(item => item[1]);
                                        var categories = result.map(item => item[0]);
                                        series.setData(data);
                                        series.chart.xAxis[0].setCategories(categories);
                                    }
                                }
                            });
                        }, 5000);
                    }
                }
            },
            title: {
                text: 'Live Data 2'
            },
            xAxis: {
                categories: []
            },
            series: [{
                name: 'Random Value',
                data: []
            }]
        });

        // Chart 3
        Highcharts.chart('container3', {
            chart: {
                type: 'area',
                events: {
                    load: function () {
                        var series = this.series[0];
                        setInterval(function () {
                            $.ajax({
                                url: '/chart3_1',
                                success: function (result) {
                                    if (Array.isArray(result) && result.length > 0) {
                                        var data = result.map(item => item[1]);
                                        var categories = result.map(item => item[0]);
                                        series.setData(data);
                                        series.chart.xAxis[0].setCategories(categories);
                                    }
                                }
                            });
                        }, 5000);
                    }
                }
            },
            title: {
                text: 'Live Data 3 (Monthly Sales)'
            },
            xAxis: {
                categories: []
            },
            series: [{
                name: 'Total Sales',
                data: []
            }]
        });

        // Chart 4
        Highcharts.chart('container4', {
            chart: {
                type: 'bar',
                events: {
                    load: function () {
                        var series = this.series[0];
                        setInterval(function () {
                            $.ajax({
                                url: '/chart2_2',
                                success: function (result) {
                                    if (result && Array.isArray(result.data)) {
                                        series.setData(result.data);
                                        series.chart.xAxis[0].setCategories(result.cate);
                                    }
                                }
                            });
                        }, 5000);
                    }
                }
            },
            title: {
                text: 'Live Data 4 (Age Distribution)'
            },
            xAxis: {
                categories: []
            },
            series: [{
                name: 'Random Value',
                data: []
            }]
        });
    });
</script>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Chart</h1>
        <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm"><i
                class="fas fa-download fa-sm text-white-50"></i> Generate Report</a>
    </div>

    <div class="row">
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Live Data 1</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area" id="container1"></div>
                </div>
            </div>
        </div>

        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Live Data 2</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area" id="container2"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Live Data 3</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area" id="container3"></div>
                </div>
            </div>
        </div>

        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Live Data 4</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area" id="container4"></div>
                </div>
            </div>
        </div>
    </div>
</div>