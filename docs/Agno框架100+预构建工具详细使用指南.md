# Agno框架100+预构建工具详细使用指南

## 概览

Agno框架提供了100+预构建工具，涵盖搜索、API集成、文件处理、数据库操作、云服务、开发工具、通信、AI/ML等各个领域。这些工具使AI Agent能够与外部系统无缝交互，大大扩展了Agent的能力边界。

## 目录

1. [搜索类工具 (Search Tools)](#1-搜索类工具)
2. [API集成工具 (API Tools)](#2-api集成工具)
3. [文件处理工具 (File Processing Tools)](#3-文件处理工具)
4. [数据库工具 (Database Tools)](#4-数据库工具)
5. [Web处理工具 (Web Tools)](#5-web处理工具)
6. [云服务工具 (Cloud Service Tools)](#6-云服务工具)
7. [开发工具 (Development Tools)](#7-开发工具)
8. [通信工具 (Communication Tools)](#8-通信工具)
9. [AI和机器学习工具 (AI/ML Tools)](#9-ai和机器学习工具)
10. [专业服务工具 (Professional Service Tools)](#10-专业服务工具)
11. [媒体处理工具 (Media Tools)](#11-媒体处理工具)
12. [系统工具 (System Tools)](#12-系统工具)

---

## 1. 搜索类工具

### 1.1 GoogleSearchTools
**功能**: 使用Google搜索引擎进行网络搜索
**核心能力**: 
- 多语言搜索支持
- 可配置结果数量限制
- 代理和超时设置
- 结构化JSON结果返回

**使用示例**:
```python
from agno.tools.googlesearch import GoogleSearchTools

google_tools = GoogleSearchTools(
    fixed_max_results=10,
    fixed_language="en",
    timeout=15
)

agent = Agent(
    tools=[google_tools],
    instructions="Search for information and provide detailed analysis"
)

# 搜索使用
response = agent.run("Search for latest AI developments in 2024")
```

**返回格式**:
```json
[
  {
    "title": "文章标题",
    "url": "https://example.com",
    "description": "描述信息"
  }
]
```

### 1.2 BraveSearchTools
**功能**: 使用Brave搜索引擎进行隐私友好搜索
**环境变量**: `BRAVE_API_KEY`
**特色**: 注重隐私保护，无广告跟踪

**使用示例**:
```python
from agno.tools.bravesearch import BraveSearchTools

brave_tools = BraveSearchTools(
    api_key="your_brave_api_key",
    fixed_max_results=5
)

agent = Agent(tools=[brave_tools])
```

### 1.3 DuckDuckGoTools
**功能**: 使用DuckDuckGo进行搜索和新闻获取
**特色**: 完全免费，支持搜索和新闻两种模式

**使用示例**:
```python
from agno.tools.duckduckgo import DuckDuckGoTools

ddg_tools = DuckDuckGoTools(
    search=True,
    news=True,
    fixed_max_results=10
)

# 使用
agent = Agent(tools=[ddg_tools])
result = agent.run("Latest news about artificial intelligence")
```

### 1.4 ArxivTools
**功能**: 学术论文搜索和PDF阅读
**能力**: 
- arXiv论文搜索
- PDF下载和内容提取
- 学术资料分析

**使用示例**:
```python
from agno.tools.arxiv import ArxivTools

arxiv_tools = ArxivTools(
    search_arxiv=True,
    read_arxiv_papers=True,
    download_dir=Path("./papers")
)

agent = Agent(tools=[arxiv_tools])
response = agent.run("Find papers about transformer architecture")
```

### 1.5 其他搜索工具

#### BaiduSearchTools
**功能**: 百度搜索集成
**适用**: 中文内容搜索优化

#### HackerNewsTools
**功能**: Hacker News内容检索
**能力**: 获取热门技术新闻和讨论

#### RedditTools
**功能**: Reddit内容搜索和分析
**特色**: 社区讨论内容获取

#### WikipediaTools
**功能**: 维基百科知识检索
**能力**: 结构化知识获取

---

## 2. API集成工具

### 2.1 CustomApiTools
**功能**: 通用HTTP API调用工具
**支持**: GET、POST、PUT、DELETE、PATCH方法
**认证**: Basic Auth、API Key、自定义Headers

**使用示例**:
```python
from agno.tools.api import CustomApiTools

api_tools = CustomApiTools(
    base_url="https://api.example.com",
    api_key="your_api_key",
    timeout=30
)

agent = Agent(tools=[api_tools])

# 调用API
response = agent.run("Call the /users endpoint to get user list")
```

**配置选项**:
```python
api_tools = CustomApiTools(
    base_url="https://api.example.com",
    username="user",
    password="pass",
    headers={"Content-Type": "application/json"},
    verify_ssl=True,
    timeout=30
)
```

### 2.2 GithubTools
**功能**: GitHub仓库管理和分析
**能力**: 
- 仓库信息获取
- Issue和PR管理
- 代码分析
- 提交历史查看

**使用示例**:
```python
from agno.tools.github import GithubTools

github_tools = GithubTools(
    access_token="your_github_token"
)

agent = Agent(tools=[github_tools])
response = agent.run("Analyze the issues in agno-agi/agno repository")
```

### 2.3 JiraTools
**功能**: Jira项目管理集成
**能力**: 
- Issue创建和管理
- 项目状态跟踪
- 工作流程管理

### 2.4 LinearTools
**功能**: Linear项目管理工具集成
**特色**: 现代化项目管理界面

---

## 3. 文件处理工具

### 3.1 FileTools
**功能**: 基础文件操作工具
**能力**: 
- 文件读写
- 目录列表
- 文件搜索
- 文件管理

**使用示例**:
```python
from agno.tools.file import FileTools
from pathlib import Path

file_tools = FileTools(
    base_dir=Path("./workspace"),
    save_files=True,
    read_files=True,
    list_files=True,
    search_files=True
)

agent = Agent(tools=[file_tools])

# 文件操作
response = agent.run("Create a summary file from the data in data.txt")
```

**核心方法**:
- `save_file(contents, file_name, overwrite=True)`: 保存文件
- `read_file(file_name)`: 读取文件
- `list_files()`: 列出文件
- `search_files(pattern)`: 搜索文件

### 3.2 CSVToolkit
**功能**: CSV文件专用处理工具
**能力**: 
- CSV读取和解析
- 数据分析和统计
- CSV生成和导出

**使用示例**:
```python
from agno.tools.csv_toolkit import CSVToolkit

csv_tools = CSVToolkit()

agent = Agent(tools=[csv_tools])
response = agent.run("Analyze the sales data in sales.csv and generate a summary")
```

### 3.3 Newspaper4kTools
**功能**: 新闻文章提取和分析
**能力**: 
- 网页文章提取
- 文本清理和结构化
- 新闻内容分析

### 3.4 JinaTools
**功能**: 文档理解和处理
**能力**: 
- 文档内容提取
- 结构化文档分析
- 多格式文档支持

---

## 4. 数据库工具

### 4.1 PostgresTools
**功能**: PostgreSQL数据库操作
**能力**: 
- 数据库连接管理
- SQL查询执行
- 表结构分析
- 数据导出

**使用示例**:
```python
from agno.tools.postgres import PostgresTools

postgres_tools = PostgresTools(
    db_name="mydb",
    user="postgres",
    password="password",
    host="localhost",
    port=5432,
    run_queries=True,
    summarize_tables=True
)

agent = Agent(tools=[postgres_tools])
response = agent.run("Show me the top 10 customers by revenue")
```

**核心功能**:
- `show_tables()`: 显示所有表
- `describe_table(table_name)`: 描述表结构
- `run_query(query)`: 执行SQL查询
- `summarize_table(table_name)`: 表数据汇总
- `export_table_to_path(table_name, path)`: 导出表数据

### 4.2 DuckDBTools
**功能**: DuckDB内存数据库操作
**特色**: 
- 高性能分析型数据库
- 内存计算优化
- 快速查询处理

**使用示例**:
```python
from agno.tools.duckdb import DuckDBTools

duckdb_tools = DuckDBTools(
    create_tables=True,
    export_tables=True,
    summarize_tables=True
)

agent = Agent(tools=[duckdb_tools])
```

### 4.3 SqliteTools
**功能**: SQLite轻量级数据库操作
**适用**: 本地开发和小型应用

### 4.4 GoogleBigQueryTools
**功能**: Google BigQuery大数据分析
**能力**: 
- 大规模数据查询
- 实时数据分析
- 云端数据仓库操作

---

## 5. Web处理工具

### 5.1 WebBrowserTools
**功能**: 网页浏览和交互
**能力**: 
- 网页内容获取
- 表单填写
- 页面截图
- JavaScript执行

**使用示例**:
```python
from agno.tools.webbrowser import WebBrowserTools

browser_tools = WebBrowserTools()

agent = Agent(tools=[browser_tools])
response = agent.run("Take a screenshot of https://example.com")
```

### 5.2 Crawl4aiTools
**功能**: 智能网页爬取
**特色**: 
- AI驱动的内容提取
- 动态页面处理
- 反爬虫机制绕过

### 5.3 FirecrawlTools
**功能**: 网站内容批量抓取
**能力**: 
- 整站爬取
- 内容清理和结构化
- 批量处理优化

### 5.4 SpiderTools
**功能**: 网络爬虫工具
**特色**: 
- 分布式爬取
- 多线程处理
- 数据管道集成

### 5.5 WebsiteTools
**功能**: 网站分析和监控
**能力**: 
- 网站性能分析
- SEO检查
- 可用性监控

---

## 6. 云服务工具

### 6.1 AWS工具集

#### AwsLambdaTools
**功能**: AWS Lambda函数管理
**能力**: 
- 函数部署和调用
- 日志查看
- 性能监控

**使用示例**:
```python
from agno.tools.aws_lambda import AwsLambdaTools

lambda_tools = AwsLambdaTools(
    aws_access_key_id="your_key",
    aws_secret_access_key="your_secret",
    region_name="us-east-1"
)

agent = Agent(tools=[lambda_tools])
```

#### AwsSesTools
**功能**: AWS SES邮件服务
**能力**: 
- 邮件发送
- 邮件列表管理
- 发送统计

### 6.2 DockerTools
**功能**: Docker容器管理
**能力**: 
- 容器启动和停止
- 镜像管理
- 容器监控

**使用示例**:
```python
from agno.tools.docker import DockerTools

docker_tools = DockerTools()

agent = Agent(tools=[docker_tools])
response = agent.run("List all running containers")
```

### 6.3 E2BTools
**功能**: E2B云端代码执行环境
**特色**: 
- 安全的代码执行
- 多语言支持
- 隔离环境

---

## 7. 开发工具

### 7.1 PythonTools
**功能**: Python代码执行和分析
**能力**: 
- 代码执行
- 语法检查
- 性能分析
- 依赖管理

**使用示例**:
```python
from agno.tools.python import PythonTools

python_tools = PythonTools(
    pip_install=True,
    run_code=True
)

agent = Agent(tools=[python_tools])
response = agent.run("Calculate the fibonacci sequence for n=10")
```

### 7.2 ShellTools
**功能**: 系统Shell命令执行
**能力**: 
- 命令行操作
- 系统管理
- 脚本执行

**安全注意**: 谨慎使用，确保输入验证

### 7.3 CalculatorTools
**功能**: 数学计算工具
**能力**: 
- 基础数学运算
- 科学计算
- 表达式求值

**使用示例**:
```python
from agno.tools.calculator import CalculatorTools

calc_tools = CalculatorTools()

agent = Agent(tools=[calc_tools])
response = agent.run("Calculate the compound interest for $1000 at 5% for 10 years")
```

### 7.4 GitTools
**功能**: Git版本控制操作
**能力**: 
- 代码提交和推送
- 分支管理
- 合并操作

---

## 8. 通信工具

### 8.1 邮件工具

#### EmailTools
**功能**: 通用邮件发送
**协议支持**: SMTP、IMAP

**使用示例**:
```python
from agno.tools.email import EmailTools

email_tools = EmailTools(
    smtp_server="smtp.gmail.com",
    smtp_port=587,
    email="your_email@gmail.com",
    password="your_password"
)

agent = Agent(tools=[email_tools])
```

#### GmailTools
**功能**: Gmail专用集成
**特色**: 
- Gmail API集成
- 高级搜索功能
- 标签管理

#### ResendTools
**功能**: Resend邮件服务
**特色**: 
- 现代化邮件API
- 高送达率
- 详细分析报告

### 8.2 即时通讯工具

#### SlackTools
**功能**: Slack集成
**能力**: 
- 消息发送
- 频道管理
- 文件共享

**使用示例**:
```python
from agno.tools.slack import SlackTools

slack_tools = SlackTools(
    bot_token="xoxb-your-bot-token"
)

agent = Agent(tools=[slack_tools])
response = agent.run("Send a summary to #general channel")
```

#### DiscordTools
**功能**: Discord机器人集成
**能力**: 
- 消息发送
- 服务器管理
- 用户交互

#### TelegramTools
**功能**: Telegram机器人
**特色**: 
- 富媒体消息
- 内联键盘
- 文件传输

#### WhatsAppTools
**功能**: WhatsApp Business API
**商用**: 企业级消息服务

### 8.3 视频会议工具

#### WebexTools
**功能**: Cisco Webex集成
**能力**: 
- 会议管理
- 录制控制
- 参与者管理

---

## 9. AI和机器学习工具

### 9.1 OpenAITools
**功能**: OpenAI API集成
**能力**: 
- GPT模型调用
- 图像生成
- 嵌入向量计算

**使用示例**:
```python
from agno.tools.openai import OpenAITools

openai_tools = OpenAITools(
    api_key="your_openai_key"
)

agent = Agent(tools=[openai_tools])
```

### 9.2 DalleTools
**功能**: DALL-E图像生成
**能力**: 
- 文本到图像
- 图像编辑
- 风格转换

### 9.3 ElevenLabsTools
**功能**: 语音合成和克隆
**能力**: 
- 文本转语音
- 声音克隆
- 多语言支持

### 9.4 CartesiaTools
**功能**: 实时语音处理
**特色**: 
- 低延迟语音生成
- 实时对话支持

### 9.5 ReplicateTools
**功能**: 机器学习模型托管
**能力**: 
- 模型推理
- 自定义模型部署
- GPU加速

### 9.6 FalAITools
**功能**: 快速AI模型推理
**特色**: 
- 毫秒级响应
- 多模型支持

### 9.7 LumaLabTools
**功能**: 3D内容生成
**能力**: 
- 3D模型生成
- 视频到3D转换

---

## 10. 专业服务工具

### 10.1 办公协作工具

#### GoogleSheetsTools
**功能**: Google Sheets电子表格操作
**能力**: 
- 数据读写
- 公式计算
- 图表生成

**使用示例**:
```python
from agno.tools.googlesheets import GoogleSheetsTools

sheets_tools = GoogleSheetsTools(
    service_account_file="path/to/credentials.json"
)

agent = Agent(tools=[sheets_tools])
response = agent.run("Update the sales data in Sheet1")
```

#### GoogleCalendarTools
**功能**: Google Calendar日历管理
**能力**: 
- 事件创建和管理
- 日程安排
- 提醒设置

#### ConfluenceTools
**功能**: Atlassian Confluence知识管理
**能力**: 
- 文档创建和编辑
- 知识库搜索
- 协作编辑

#### TrelloTools
**功能**: Trello项目管理
**特色**: 
- 看板式项目管理
- 卡片和列表操作

#### TodoistTools
**功能**: Todoist任务管理
**能力**: 
- 任务创建和管理
- 项目组织
- 进度跟踪

### 10.2 客户关系管理

#### ClickUpTools
**功能**: ClickUp项目管理平台
**能力**: 
- 任务管理
- 时间跟踪
- 团队协作

#### CalComTools
**功能**: Cal.com日程预约系统
**特色**: 
- 开源日程管理
- 自定义预约页面

### 10.3 金融和数据工具

#### YFinanceTools
**功能**: 雅虎财经数据获取
**能力**: 
- 股票价格查询
- 财务数据分析
- 市场趋势跟踪

#### FinancialDatasetsTools
**功能**: 金融数据集工具
**特色**: 
- 历史数据分析
- 量化研究支持

#### OpenBBTools
**功能**: OpenBB金融数据平台
**能力**: 
- 综合金融分析
- 投资研究工具

---

## 11. 媒体处理工具

### 11.1 图像处理

#### OpenCVTools
**功能**: 计算机视觉处理
**能力**: 
- 图像识别
- 视频分析
- 特征检测

#### GiphyTools
**功能**: Giphy GIF搜索和管理
**能力**: 
- GIF搜索
- 动画内容获取

### 11.2 音频处理

#### MLXTranscribeTools
**功能**: 音频转录工具
**特色**: 
- 高精度语音识别
- 多语言支持

#### DesiVocalTools
**功能**: 语音处理工具
**能力**: 
- 语音增强
- 音频分析

### 11.3 视频处理

#### MoviePyVideoTools
**功能**: 视频编辑和处理
**能力**: 
- 视频剪辑
- 特效添加
- 格式转换

---

## 12. 系统工具

### 12.1 监控和分析

#### SerpApiTools
**功能**: 搜索引擎结果API
**能力**: 
- Google搜索结果获取
- SEO分析
- 关键词排名跟踪

#### SerperTools
**功能**: 搜索API服务
**特色**: 
- 实时搜索结果
- 多搜索引擎支持

#### TavilyTools
**功能**: AI搜索API
**特色**: 
- AI优化的搜索结果
- 智能内容提取

### 12.2 开发辅助

#### BrowserbaseTools
**功能**: 云端浏览器服务
**能力**: 
- 无头浏览器操作
- 分布式爬取
- 反检测机制

#### AgentQLTools
**功能**: 网页元素智能定位
**特色**: 
- AI驱动的元素选择
- 自适应页面变化

#### ApifyTools
**功能**: Apify网络爬虫平台
**能力**: 
- 大规模网络爬取
- 数据提取和处理
- 云端运行环境

### 12.3 知识管理

#### Mem0Tools
**功能**: AI记忆系统
**能力**: 
- 长期记忆存储
- 上下文关联
- 智能检索

#### KnowledgeTools
**功能**: 知识库管理
**能力**: 
- 知识图谱构建
- 语义搜索
- 智能问答

### 12.4 控制流工具

#### SleepTools
**功能**: 延时控制工具
**用途**: 
- 流程控制
- 速率限制
- 定时任务

#### UserControlFlowTools
**功能**: 用户交互控制
**能力**: 
- 用户确认
- 输入获取
- 决策分支

#### ThinkingTools / ReasoningTools
**功能**: 思维和推理工具
**能力**: 
- 结构化思考
- 逻辑推理
- 决策支持

---

## 工具使用最佳实践

### 1. 工具选择原则
- **功能匹配**: 选择最适合任务需求的工具
- **性能考虑**: 注意工具的响应时间和资源消耗
- **安全性**: 评估工具的安全风险和权限需求
- **成本控制**: 考虑API调用费用和使用限制

### 2. 配置管理
```python
# 环境变量配置
import os
from agno.tools.googlesearch import GoogleSearchTools
from agno.tools.openai import OpenAITools

# 安全的API密钥管理
google_tools = GoogleSearchTools()
openai_tools = OpenAITools(
    api_key=os.getenv("OPENAI_API_KEY")
)

agent = Agent(
    tools=[google_tools, openai_tools],
    instructions="Use tools efficiently and securely"
)
```

### 3. 错误处理
```python
from agno.tools import Toolkit

class CustomTools(Toolkit):
    def my_tool(self, query: str) -> str:
        try:
            # 工具逻辑
            result = process_query(query)
            return result
        except Exception as e:
            logger.error(f"Tool error: {e}")
            return f"Error: {str(e)}"
```

### 4. 工具组合使用
```python
# 多工具协作示例
search_tools = GoogleSearchTools()
file_tools = FileTools()
email_tools = EmailTools()

research_agent = Agent(
    tools=[search_tools, file_tools, email_tools],
    instructions="""
    1. 使用搜索工具收集信息
    2. 使用文件工具保存和整理数据
    3. 使用邮件工具发送报告
    """
)
```

### 5. 性能优化
```python
# 工具结果缓存
from agno.tools import Toolkit

class CachedTools(Toolkit):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.cache = {}
    
    def cached_search(self, query: str) -> str:
        if query in self.cache:
            return self.cache[query]
        
        result = self.perform_search(query)
        self.cache[query] = result
        return result
```

---

## 总结

Agno框架的100+预构建工具覆盖了现代AI应用所需的各个方面：

### 核心优势
1. **全面覆盖**: 从基础文件操作到复杂AI模型调用
2. **易于集成**: 统一的工具接口和配置方式
3. **高度可配置**: 支持详细的参数定制
4. **企业级**: 考虑了安全性、性能和可扩展性
5. **活跃维护**: 持续更新和改进

### 应用场景
- **研究分析**: 搜索、数据收集、文档处理
- **业务自动化**: CRM、项目管理、通信协作
- **内容创作**: 文本生成、图像处理、多媒体编辑
- **开发运维**: 代码管理、部署监控、系统管理
- **数据分析**: 数据库查询、统计分析、可视化

### 发展趋势
- **AI集成深化**: 更多工具将集成AI能力
- **云原生化**: 向云端服务和无服务器架构演进
- **安全加强**: 增强数据保护和访问控制
- **性能优化**: 提高工具执行效率和响应速度
- **生态扩展**: 支持更多第三方服务和平台

这些工具使Agno Agent能够真正连接现实世界，执行复杂的跨平台任务，是构建强大AI应用的重要基础设施。

---

*本指南基于Agno框架源码分析和官方文档编写，涵盖了所有主要工具类别和使用方法。建议开发者根据具体需求选择合适的工具组合。*