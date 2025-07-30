# MacBook + Docker + Python 3.13.5 环境说明

本项目已针对MacBook环境进行优化配置，包含以下文件：

## 🐳 Docker配置
- `docker-compose.yml` - 完整的Docker服务配置
- `init-db.sql` - PostgreSQL数据库初始化脚本

## 🍎 MacBook专用脚本
- `start_agno_macos.sh` - 一键启动脚本
- `monitor_agno_macos.sh` - 资源监控脚本

## 📋 环境要求
- macOS (Intel或Apple Silicon)
- Python 3.13.5
- Docker Desktop
- 4GB+ 可用内存

## 🚀 快速开始
```bash
# 1. 运行启动脚本
./start_agno_macos.sh

# 2. 监控资源使用
./monitor_agno_macos.sh

# 3. 停止服务
docker-compose down
```

## 📊 包含的服务
- PostgreSQL (5432) - 主数据库
- pgvector (5433) - 向量数据库
- Redis (6379) - 缓存
- ChromaDB (8000) - 向量存储
- Qdrant (6333) - 高性能向量DB
- MongoDB (27017) - 文档数据库
- Milvus (19530) - 企业级向量DB

所有服务都经过MacBook环境优化，支持Apple Silicon和Intel芯片。