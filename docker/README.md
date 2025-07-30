# Agno Docker 环境配置

本目录包含了Agno项目的完整Docker环境配置，特别针对MacBook用户优化。

## 📁 文件结构

```
docker/
├── docker-compose.yml      # Docker服务编排配置
├── init-db.sql            # PostgreSQL数据库初始化脚本
├── start_agno_macos.sh     # MacBook一键启动脚本
├── monitor_agno_macos.sh   # 资源监控脚本
└── README.md              # 本说明文件
```

## 🐳 包含的服务

| 服务名 | 端口 | 描述 | 用途 |
|--------|------|------|------|
| **postgres** | 5432 | PostgreSQL 15 | 主数据库，存储会话、代理配置等 |
| **pgvector** | 5433 | PostgreSQL + pgvector | 向量数据库，支持向量相似性搜索 |
| **redis** | 6379 | Redis 7 | 缓存和会话存储 |
| **chromadb** | 8000 | ChromaDB | 轻量级向量数据库 |
| **qdrant** | 6333, 6334 | Qdrant | 高性能向量数据库 |
| **mongodb** | 27017 | MongoDB 7 | 文档数据库 |
| **milvus** | 19530, 9091 | Milvus + 依赖 | 企业级向量数据库 |

## 🚀 快速开始

### 方式一：使用启动脚本（推荐）

```bash
# 进入docker目录
cd docker

# 运行启动脚本
./start_agno_macos.sh
```

### 方式二：手动启动

```bash
# 进入docker目录
cd docker

# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

## 📊 监控和管理

```bash
# 资源监控
./monitor_agno_macos.sh

# 查看特定服务日志
docker-compose logs -f postgres
docker-compose logs -f redis

# 重启服务
docker-compose restart [service_name]

# 停止所有服务
docker-compose down

# 停止并清理数据（谨慎使用）
docker-compose down -v
```

## 🔧 配置说明

### 环境变量

在项目根目录创建 `.env` 文件：

```bash
# === LLM模型API密钥 ===
OPENAI_API_KEY=your-openai-api-key-here
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
```

### 数据库凭据

**默认凭据（可在docker-compose.yml中修改）：**
- 用户名: `agno_user`
- 密码: `agno_password`
- PostgreSQL主库: `agno_db`
- pgvector库: `agno_vectordb`

### 健康检查

所有服务都配置了健康检查，确保服务正常运行：

```bash
# 检查所有服务健康状态
docker-compose ps --format "table {{.Name}}\t{{.Status}}"

# 查看不健康的容器
docker ps --filter "health=unhealthy"
```

## 🍎 MacBook 优化

### 资源限制
- 默认内存限制: 4GB
- CPU限制: 2核心
- 可在 `.env` 文件中调整：
  ```bash
  DOCKER_MEMORY_LIMIT=6g
  DOCKER_CPU_LIMIT=4
  ```

### Apple Silicon 支持
- 所有镜像都支持 ARM64 架构
- 如遇兼容性问题，可在 `docker-compose.yml` 中添加 `platform: linux/amd64`

### 电池优化
```bash
# 开发完成后停止服务
docker-compose stop

# 长时间不用时清理
docker-compose down
```

## 🛠️ 故障排除

### 端口冲突
```bash
# 检查端口占用
lsof -i :5432  # PostgreSQL
lsof -i :6379  # Redis
lsof -i :8000  # ChromaDB

# 杀死占用进程
kill -9 $(lsof -t -i:5432)
```

### 服务启动失败
```bash
# 查看详细日志
docker-compose logs [service_name]

# 重新构建并启动
docker-compose up -d --force-recreate [service_name]

# 清理并重新启动
docker-compose down
docker system prune -f
docker-compose up -d
```

### 数据持久化
所有数据都存储在Docker volumes中：
```bash
# 查看volumes
docker volume ls | grep agno

# 备份数据
docker-compose exec postgres pg_dump -U agno_user agno_db > backup.sql

# 恢复数据
docker-compose exec -T postgres psql -U agno_user agno_db < backup.sql
```

## 📈 性能调优

### 选择性启动服务
```bash
# 基础开发环境
docker-compose up -d postgres redis

# 向量搜索开发
docker-compose up -d postgres redis chromadb

# 全功能开发
docker-compose up -d
```

### 资源监控
使用监控脚本定期检查：
```bash
# 实时监控
watch -n 5 './monitor_agno_macos.sh'

# 一次性检查
./monitor_agno_macos.sh
```

## 🔐 安全注意事项

1. **生产环境**：修改默认密码
2. **网络访问**：仅本地访问，不暴露到公网
3. **数据备份**：定期备份重要数据
4. **API密钥**：妥善保管 `.env` 文件

## 📚 相关文档

- [Agno官方文档](https://docs.agno.com)
- [Docker Compose文档](https://docs.docker.com/compose/)
- [PostgreSQL文档](https://www.postgresql.org/docs/)
- [Redis文档](https://redis.io/documentation)