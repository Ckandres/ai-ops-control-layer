-- Migration: Create AI Ops Control Layer Schema and Tables
-- Date: 2026-01-11

-- 1. Create Schema
CREATE SCHEMA IF NOT EXISTS ai_ops_control_layer;

-- 2. Create Tables

-- Tenants: Management of different organizational units
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    config JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Projects: AI-driven projects within a tenant
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES ai_ops_control_layer.ai_ops_tenants(id),
    name TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Policies: Definitions of AI operation constraints
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES ai_ops_control_layer.ai_ops_projects(id),
    type TEXT NOT NULL,
    rules JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Memory: Contextual storage for AI operations
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_memory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES ai_ops_control_layer.ai_ops_projects(id),
    context_key TEXT NOT NULL,
    context_value JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Audits: Traceability of all system actions
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_audits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor TEXT NOT NULL,
    action TEXT NOT NULL,
    target TEXT NOT NULL,
    details JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Executions: Log of AI task executions
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES ai_ops_control_layer.ai_ops_projects(id),
    task_name TEXT NOT NULL,
    status TEXT NOT NULL,
    result JSONB,
    duration_ms INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- API Usage: Meters for rate limiting and billing
CREATE TABLE IF NOT EXISTS ai_ops_control_layer.ai_ops_api_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES ai_ops_control_layer.ai_ops_tenants(id),
    service TEXT NOT NULL,
    token_count INTEGER,
    cost NUMERIC,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Enable RLS
ALTER TABLE ai_ops_control_layer.ai_ops_tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ops_control_layer.ai_ops_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ops_control_layer.ai_ops_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ops_control_layer.ai_ops_memory ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ops_control_layer.ai_ops_audits ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ops_control_layer.ai_ops_executions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_ops_control_layer.ai_ops_api_usage ENABLE ROW LEVEL SECURITY;

-- Note: Specific RLS policies will be defined as the security model matures.
