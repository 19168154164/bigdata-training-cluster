<%@ page import="dbtaobao.connDb" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>年龄分布对比</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>数据可视化</h2>
            <ul>
                <li><a href="index.jsp">消费行为统计</a></li>
                <li><a href="index2.jsp">男女交易对比</a></li>
                <li><a href="index3.jsp">年龄分布对比</a></li>
                <li><a href="index4.jsp">商品类别销量</a></li>
                <li><a href="index5.jsp">省份成交量</a></li>
                <li><a href="index6.jsp">回头客预测</a></li>
            </ul>
        </div>
        <div class="main-content">
            <div class="header">
                <h1>年龄分布对比</h1>
                <p>基于年龄维度的交易分析</p>
            </div>
            <div class="chart-container">
                <div id="chart" class="chart"></div>
            </div>
        </div>
    </div>
    <script>
        // 初始化图表
        var chart = echarts.init(document.getElementById('chart'));
        
        // 年龄分布数据
        var ageData = [
            <jsp:scriptlet>
                try {
                    connDb conn = new connDb();
                    java.sql.ResultSet rs = conn.executeQuery("SELECT age_range, COUNT(*) as count FROM dbtaobao.user_log WHERE action = 3 GROUP BY age_range");
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) out.print(",");
                        int age = rs.getInt("age_range");
                        String ageStr = "未知";
                        switch (age) {
                            case 0: ageStr = "未知";
                                break;
                            case 1: ageStr = "<18";
                                break;
                            case 2: ageStr = "18-24";
                                break;
                            case 3: ageStr = "25-29";
                                break;
                            case 4: ageStr = "30-34";
                                break;
                            case 5: ageStr = "35-39";
                                break;
                            case 6: ageStr = "40-49";
                                break;
                            case 7: ageStr = ">=50";
                                break;
                        }
                        out.print("{value: " + rs.getInt("count") + ", name: '" + ageStr + "'}");
                        first = false;
                    }
                    conn.close();
                } catch (Exception e) {
                    out.print("{value: 1, name: '<18'},{value: 1, name: '18-24'},{value: 1, name: '25-29'},{value: 1, name: '30-34'},{value: 1, name: '35-39'},{value: 1, name: '40-49'},{value: 1, name: '>=50'},{value: 1, name: '未知'}");
                }
            </jsp:scriptlet>
        ];
        
        // 配置项
        var option = {
            title: {
                text: '年龄分布对比',
                left: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data: ['<18', '18-24', '25-29', '30-34', '35-39', '40-49', '>=50', '未知']
            },
            series: [
                {
                    name: '年龄分布',
                    type: 'pie',
                    radius: '60%',
                    center: ['50%', '50%'],
                    data: ageData,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }
            ]
        };
        
        // 设置配置项
        chart.setOption(option);
        
        // 响应式处理
        window.addEventListener('resize', function() {
            chart.resize();
        });
    </script>
</body>
</html>