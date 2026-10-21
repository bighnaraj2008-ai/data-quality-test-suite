-- ============================================================================
-- seed_test_data.sql — deterministic sample warehouse for data quality suite
-- ============================================================================
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id          INTEGER NOT NULL,
    email       TEXT,
    created_at  TEXT,
    age         INTEGER,
    country     TEXT
);

CREATE TABLE events (
    id          INTEGER NOT NULL,
    event_type  TEXT,
    user_id     INTEGER,
    occurred_at TEXT
);
