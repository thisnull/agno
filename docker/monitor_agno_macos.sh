#!/bin/bash

echo "🍎 MacBook Agno资源监控"
echo "========================"

# 确保在正确的目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 检查是否在docker目录中
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ 请在docker目录中运行此脚本"
    echo "使用: cd docker && ./monitor_agno_macos.sh"
    exit 1
fi

# 检查docker-compose命令
if command -v docker-compose &> /dev/null; then
    COMPOSE_COMMAND="docker-compose"
else
    COMPOSE_COMMAND="docker compose"
fi

# Docker容器状态
echo "📊 Docker容器状态:"
$COMPOSE_COMMAND ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}\t{{.State}}"

echo -e "\n💾 容器内存使用情况:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

echo -e "\n💿 Docker磁盘使用情况:"
docker system df

echo -e "\n🌡️ 系统负载:"
uptime

echo -e "\n🔋 电池状态:"
pmset -g batt | head -2

echo -e "\n💻 系统内存使用:"
vm_stat | head -5

echo -e "\n🌡️ CPU使用率:"
top -l 1 -n 0 | grep "CPU usage"

echo -e "\n🌡️ CPU温度 (需要安装osx-cpu-temp):"
if command -v osx-cpu-temp &> /dev/null; then
    osx-cpu-temp
else
    echo "安装CPU温度监控: brew install osx-cpu-temp"
fi

echo -e "\n🗂️ 磁盘空间使用:"
df -h | head -2
df -h | grep -E "/$|/System"

echo -e "\n🌐 网络连接测试:"
echo "测试Google DNS..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo "✅ 网络连接正常"
else
    echo "❌ 网络连接异常"
fi

echo -e "\n🏥 Docker健康检查:"
UNHEALTHY=$(docker ps --filter "health=unhealthy" --format "{{.Names}}")
if [ -z "$UNHEALTHY" ]; then
    echo "✅ 所有容器健康状态正常"
else
    echo "⚠️  不健康的容器: $UNHEALTHY"
fi

echo -e "\n🔍 端口占用检查:"
echo "PostgreSQL (5432):"
lsof -i :5432 | head -2 || echo "端口5432未被占用"

echo "pgvector (5433):"
lsof -i :5433 | head -2 || echo "端口5433未被占用"

echo "Redis (6379):"
lsof -i :6379 | head -2 || echo "端口6379未被占用"

echo "ChromaDB (8000):"
lsof -i :8000 | head -2 || echo "端口8000未被占用"

echo "Qdrant (6333):"
lsof -i :6333 | head -2 || echo "端口6333未被占用"

echo -e "\n📈 实时监控命令:"
echo "实时监控: watch -n 5 './monitor_agno_macos.sh'"
echo "查看日志: $COMPOSE_COMMAND logs -f [service_name]"

echo -e "\n🔧 管理命令:"
echo "停止所有服务: $COMPOSE_COMMAND down"
echo "重启所有服务: $COMPOSE_COMMAND restart"
echo "查看服务日志: $COMPOSE_COMMAND logs -f [service_name]"
echo "清理系统: docker system prune -f"
echo "清理卷: docker volume prune -f"

echo -e "\n📁 当前目录: $(pwd)"
echo "📁 项目根目录: $(dirname "$SCRIPT_DIR")"