#!/bin/bash

echo "🍎 MacBook Agno环境启动脚本"
echo "================================"

# 确保在正确的目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 检查必要的依赖
echo "📋 检查系统环境..."

# 检查Python版本
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 未安装"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "✅ Python版本: $PYTHON_VERSION"

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装Docker Desktop"
    echo "下载地址: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker 未运行，请启动Docker Desktop"
    exit 1
fi

echo "✅ Docker 运行正常"

# 检查docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo "⚠️  docker-compose 未找到，尝试使用 docker compose"
    COMPOSE_COMMAND="docker compose"
else
    COMPOSE_COMMAND="docker-compose"
    echo "✅ docker-compose 可用"
fi

# 检查是否在docker目录中
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ 请在docker目录中运行此脚本"
    echo "使用: cd docker && ./start_agno_macos.sh"
    exit 1
fi

# 检查项目根目录的虚拟环境
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
echo "🔧 检查虚拟环境..."
if [ -d "$PROJECT_ROOT/venv" ]; then
    source "$PROJECT_ROOT/venv/bin/activate"
    echo "✅ 虚拟环境已激活"
else
    echo "⚠️  虚拟环境不存在，创建新环境..."
    cd "$PROJECT_ROOT"
    python3 -m venv venv
    source venv/bin/activate
    cd "$SCRIPT_DIR"
    echo "✅ 虚拟环境创建并激活"
fi

# 检查.env文件
ENV_FILE="$PROJECT_ROOT/.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "⚠️  .env文件不存在，创建示例配置..."
    cat > "$ENV_FILE" << EOF
# === LLM模型API密钥 ===
# OpenAI (必需)
OPENAI_API_KEY=your-openai-api-key-here

# Anthropic Claude (可选)
ANTHROPIC_API_KEY=your-anthropic-key-here

# === Docker数据库配置 ===
DATABASE_URL=postgresql://agno_user:agno_password@localhost:5432/agno_db
PGVECTOR_URL=postgresql://agno_user:agno_password@localhost:5433/agno_vectordb
REDIS_URL=redis://localhost:6379
MONGODB_URL=mongodb://agno_user:agno_password@localhost:27017/agno_db

# === 向量数据库配置 ===
CHROMADB_HOST=localhost
CHROMADB_PORT=8000
QDRANT_URL=http://localhost:6333
MILVUS_HOST=localhost
MILVUS_PORT=19530

# === Agno配置 ===
AGNO_MONITOR=false
AGNO_TELEMETRY=true

# === MacBook性能优化 ===
DOCKER_MEMORY_LIMIT=4g
DOCKER_CPU_LIMIT=2
EOF
    echo "✅ 已创建 .env 文件模板，请填入您的API密钥"
fi

# 启动Docker服务
echo "🐳 启动Docker服务..."
$COMPOSE_COMMAND up -d

# 等待服务就绪
echo "⏳ 等待服务启动完成..."
sleep 30

# 检查服务状态
echo "✅ 检查服务状态..."
$COMPOSE_COMMAND ps

# 测试数据库连接
echo "🔍 测试数据库连接..."
cd "$PROJECT_ROOT"
python3 -c "
import sys
try:
    import psycopg2
    conn = psycopg2.connect('postgresql://agno_user:agno_password@localhost:5432/agno_db')
    print('✅ PostgreSQL连接成功')
    conn.close()
except ImportError:
    print('⚠️  psycopg2未安装，运行: pip3 install psycopg2-binary')
except Exception as e:
    print(f'❌ PostgreSQL连接失败: {e}')

try:
    import redis
    r = redis.Redis(host='localhost', port=6379, decode_responses=True)
    r.ping()
    print('✅ Redis连接成功')
except ImportError:
    print('⚠️  redis未安装，运行: pip3 install redis')
except Exception as e:
    print(f'❌ Redis连接失败: {e}')
"

# 检查示例文件
QUICK_START_FILE="$PROJECT_ROOT/quick_start_macos.py"
if [ -f "$QUICK_START_FILE" ]; then
    echo "🚀 运行MacBook示例..."
    python3 "$QUICK_START_FILE"
else
    echo "🚀 创建并运行简单示例..."
    cat > "$PROJECT_ROOT/simple_test.py" << 'EOF'
from agno.agent import Agent
from agno.models.openai import OpenAIChat

try:
    # 创建简单代理
    agent = Agent(
        name="测试代理",
        model=OpenAIChat(id="gpt-4o-mini"),
        instructions=["你是一个友好的助手"]
    )
    print("🤖 Agno代理创建成功！")
    print("现在可以开始开发您的AI应用了。")
except Exception as e:
    print(f"⚠️  代理创建失败: {e}")
    print("请检查API密钥配置和网络连接。")
EOF
    python3 "$PROJECT_ROOT/simple_test.py"
fi

echo ""
echo "🎉 MacBook Agno环境启动完成！"
echo ""
echo "📚 接下来您可以："
echo "   1. 编辑项目根目录的 .env 文件添加您的API密钥"
echo "   2. 运行示例: cd .. && python3 cookbook/getting_started/01_basic_agent.py"
echo "   3. 查看文档: https://docs.agno.com"
echo ""
echo "🛑 停止服务: $COMPOSE_COMMAND down"
echo "📊 监控资源: ./monitor_agno_macos.sh"
echo "📁 当前目录: $(pwd)"