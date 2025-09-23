<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #container_total{ width: 100%; height: 400px; border: 1px solid black; margin-bottom: 20px; }
    #container_average{ width: 100%; height: 400px; border: 1px solid blue; }
</style>
<script>
    const chart3 = {
        init:function(){
            this.getData1();
            this.getData2();
        },
        [cite_start]
        getData1:function(){
            $.ajax({
                url:'/chart3_1',
                success:(data)=>{ this.drawTotalSalesChart(data); },
                error:()=>{ alert('월별 매출 합계 데이터를 불러오는데 실패했습니다.'); }
            });
        },
        [cite_start]
        getData2:function(){
            $.ajax({
                url:'/chart3_2',
                success:(data)=>{ this.drawAverageSalesChart(data); },
                error:()=>{ alert('월별 매출 평균 데이터를 불러오는데 실패했습니다.'); }
            });
        },
        drawTotalSalesChart:function(data){
            const chart = new Highcharts.Chart({
                chart: {
                    renderTo: 'container_total',
                    type: 'column',
                    options3d: { enabled: true, alpha: 15, beta: 15, depth: 50, viewDistance: 25 }
                },
                xAxis: { type: 'category' },
                yAxis: { title: { enabled: false } },
                tooltip: { headerFormat: '<b>{point.key}</b><br>', pointFormat: '매출 합계: {point.y}' },
                title: { text: '월별 매출 합계' },
                subtitle: { text: '데이터 출처: shopDB' },
                legend: { enabled: false },
                plotOptions: { column: { depth: 25 } },
                series: [{ data: data, colorByPoint: true }]
            });
        },
        drawAverageSalesChart:function(data){
            Highcharts.chart('container_average', {
                chart: { type: 'line' },
                title: { text: '월별 매출 평균', align: 'left' },
                subtitle: { text: '데이터 출처: shopDB', align: 'left' },
                yAxis: { title: { text: '매출 평균' } },
                xAxis: { categories: data.categories, accessibility: { rangeDescription: '월별 매출 평균' } },
                legend: { layout: 'vertical', align: 'right', verticalAlign: 'middle' },
                plotOptions: { series: { label: { connectorAllowed: false } } },
                series: [{ name: '매출 평균', data: data.data }]
            });
        }
    };
    $(function(){
        chart3.init();
    });
</script>

<div class="col-sm-10">
    <h2>Chart3 - 월별 매출 현황</h2>
    <div class="row">
        <div class="col-sm-12" id="container_total"></div>
        <div class="col-sm-12" id="container_average"></div>
    </div>
</div>