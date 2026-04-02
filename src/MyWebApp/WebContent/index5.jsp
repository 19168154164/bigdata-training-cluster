<%@ page import="dbtaobao.connDb" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>省份成交量</title>
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
                <h1>省份成交量</h1>
                <p>基于省份维度的成交量分析</p>
            </div>
            <div class="chart-container">
                <div id="chart" class="chart"></div>
            </div>
        </div>
    </div>
    <script>
        // 初始化图表
        var chart = echarts.init(document.getElementById('chart'));
        
        // 省份数据
        var provinces = ["广东", "北京", "上海", "浙江", "江苏", "四川", "湖北", "湖南", "山东", "河北", "河南", "辽宁", "吉林", "黑龙江", "福建", "安徽", "江西", "广西", "海南", "贵州", "云南", "陕西", "甘肃", "青海", "台湾", "内蒙古", "宁夏", "新疆", "西藏", "香港", "澳门"];
        var provinceData = [
            <jsp:scriptlet>
                try {
                    connDb conn = new connDb();
                    java.sql.ResultSet rs = conn.executeQuery("SELECT province, COUNT(*) as count FROM dbtaobao.user_log WHERE action = 3 GROUP BY province");
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) out.print(",");
                        out.print("{name: '" + rs.getString("province") + "', value: " + rs.getInt("count") + "}");
                        first = false;
                    }
                    conn.close();
                } catch (Exception e) {
                    out.print("{name: '广东', value: 1},{name: '北京', value: 1},{name: '上海', value: 1},{name: '浙江', value: 1},{name: '江苏', value: 1}");
                }
            </jsp:scriptlet>
        ];
        
        // 配置项
        var option = {
            title: {
                text: '省份成交量分布',
                left: 'center'
            },
            tooltip: {
                trigger: 'item'
            },
            legend: {
                orient: 'vertical',
                left: 'left'
            },
            series: [
                {
                    name: '成交量',
                    type: 'map',
                    map: 'china',
                    data: provinceData,
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