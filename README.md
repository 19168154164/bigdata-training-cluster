# 大数据实训集群项目

## 项目简介

本项目是一个基于Hadoop生态系统的大数据实训集群，包含完整的大数据处理流程，从数据准备、存储、处理到可视化分析的全流程实现。

### 主要功能

- **数据处理**：使用Hadoop、Spark进行大数据处理
- **数据存储**：HDFS存储原始数据，Hive进行数据仓库管理
- **数据分析**：使用Hive SQL进行数据分析
- **数据可视化**：基于ECharts的Web应用展示分析结果
- **预测分析**：使用Spark进行回头客预测

## 技术栈

- **Hadoop 3.2.2**：分布式存储和计算框架
- **Hive 3.1.3**：数据仓库工具
- **Spark 3.1.3**：分布式计算框架
- **MySQL 8.0**：元数据和结果存储
- **Tomcat 8.5.88**：Web应用服务器
- **ECharts**：数据可视化库
- **Java**：后端开发
- **JSP**：前端页面

## 项目结构

```
├── README.md          # 项目说明
├── LICENSE            # 许可证
├── .gitignore         # Git忽略文件
├── docs/              # 文档目录
│   ├── 集群启动与网页访问指南.md
│   ├── 总巡检报告.md
│   └── 实验报告/
├── src/               # 源代码
│   ├── MyWebApp/      # Web应用
│   ├── spark/         # Spark应用
│   └── scripts/       # 脚本文件
├── data/              # 数据目录
│   └── dbtaobao/      # 数据集
└── servers/           # 服务器软件（可选）
```

## 快速开始

### 环境要求

- JDK 1.8.0_333
- Hadoop 3.2.2
- Hive 3.1.3
- Spark 3.1.3
- MySQL 8.0
- Tomcat 8.5.88

### 启动步骤

1. **启动Hadoop集群**
   ```bash
   cd /export/servers/hadoop-3.2.2
   ./sbin/start-dfs.sh
   ./sbin/start-yarn.sh
   ```

2. **启动MySQL服务**
   ```bash
   systemctl start mysqld
   ```

3. **启动Tomcat服务**
   ```bash
   cd /export/servers/tomcat-8.5.88
   ./bin/startup.sh
   ```

4. **访问Web应用**
   打开浏览器访问：http://192.168.121.138:8080/MyWebApp/index.jsp

## 实验内容

1. **实验一**：数据准备与预处理
2. **实验二**：Hive数据分析
3. **实验三**：Sqoop数据导入/导出
4. **实验四**：Spark预测分析
5. **实验五**：数据可视化

## 文档

- [集群启动与网页访问指南](docs/集群启动与网页访问指南.md)
- [总巡检报告](docs/总巡检报告.md)
- [实验报告](docs/实验报告/)

## 贡献

欢迎提交Issue和Pull Request！

## 许可证

本项目采用MIT许可证。