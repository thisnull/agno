-- 初始化数据库脚本
-- 为Agno项目创建必要的扩展和基础数据

-- 创建UUID扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 创建pgcrypto扩展用于加密
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 创建hstore扩展用于键值存储
CREATE EXTENSION IF NOT EXISTS "hstore";

-- 设置时区
SET timezone = 'UTC';

-- 创建基础schema
CREATE SCHEMA IF NOT EXISTS agno;

-- 创建会话表
CREATE TABLE IF NOT EXISTS agno.sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255),
    session_id VARCHAR(255) UNIQUE NOT NULL,
    session_name VARCHAR(255),
    session_data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建代理表
CREATE TABLE IF NOT EXISTS agno.agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    description TEXT,
    config JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建记忆表
CREATE TABLE IF NOT EXISTS agno.memories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255),
    agent_id VARCHAR(255),
    session_id VARCHAR(255),
    memory_type VARCHAR(50),
    content TEXT,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引优化查询
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON agno.sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_session_id ON agno.sessions(session_id);
CREATE INDEX IF NOT EXISTS idx_agents_agent_id ON agno.agents(agent_id);
CREATE INDEX IF NOT EXISTS idx_memories_user_id ON agno.memories(user_id);
CREATE INDEX IF NOT EXISTS idx_memories_agent_id ON agno.memories(agent_id);
CREATE INDEX IF NOT EXISTS idx_memories_session_id ON agno.memories(session_id);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为表添加自动更新触发器
CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON agno.sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agno.agents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_memories_updated_at BEFORE UPDATE ON agno.memories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();