-- ============================================================================
-- Database initialization script for PostgreSQL testing container
-- ============================================================================
CREATE SCHEMA IF NOT EXISTS quality;

CREATE TABLE IF NOT EXISTS quality.users (
    id INTEGER,
    email VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE,
    age INTEGER,
    country VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS quality.events (
    id INTEGER,
    event_type VARCHAR(50),
    user_id INTEGER,
    occurred_at TIMESTAMP WITH TIME ZONE
);
