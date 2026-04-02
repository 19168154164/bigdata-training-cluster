<%@ page import="dbtaobao.connDb" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>男女交易对比</title>
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
                <h1>男女交易对比</h1>
                <p>基于性别维度的交易分析</p>
            </div>
            <div class="chart-container">
                <div id="chart" class="chart"></div>
            </div>
        </div>
    </div>
    <script>
        // 初始化图表
        var chart = echarts.init(document.getElementById('chart'));
        
        // 性别数据
        var genderData = [
            <jsp:scriptlet>
                try {
                    connDb conn = new connDb();
                    java.sql.ResultSet rs = conn.executeQuery("SELECT gender, COUNT(*) as count FROM dbtaobao.user_log WHERE action = 3 GROUP BY gender");
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) out.print(",");
                        out.print("{value: " + rs.getInt("count") + ", name: '" + (rs.getInt("gender") == 0 ? "未知" : rs.getInt("gender") == 1 ? "男" : "女") + "'}");
                        first = false;
                    }
                    conn.close();
                } catch (Exception e) {
                    out.print("{value: 1, name: '男'},{value: 1, name: '女'},{value: 1, name: '未知'}");
                }
            </jsp:scriptlet>
        ];
        
        // 配置项
        var option = {
            title: {
                text: '男女交易对比',
                left: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data: ['男', '女', '未知']
            },
            series: [
                {
                    name: '性别分布',
                    type: 'pie',
                    radius: '60%',
                    center: ['50%', '50%'],
                    data: genderData,
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