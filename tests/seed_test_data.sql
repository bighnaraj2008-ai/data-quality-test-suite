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

-- ---------------------------------------------------------------------------
-- 120 users across 60 days
-- ---------------------------------------------------------------------------
WITH RECURSIVE seq(i) AS (
    SELECT 1
    UNION ALL
    SELECT i + 1 FROM seq WHERE i < 120
)
INSERT INTO users (id, email, created_at, age, country)
SELECT
    i,
    'user' || i || '@example.com',
    date('now', '-' || ((120 - i) % 60) || ' day'),
    18 + (i * 7) % 53,
    CASE (i % 4)
        WHEN 0 THEN 'US'
        WHEN 1 THEN 'DE'
        WHEN 2 THEN 'IN'
        ELSE 'BR'
    END
FROM seq;

-- ---------------------------------------------------------------------------
-- 1500 events, exactly 25 per day for the last 60 days
-- ---------------------------------------------------------------------------
WITH RECURSIVE seq(i) AS (
    SELECT 1
    UNION ALL
    SELECT i + 1 FROM seq WHERE i < 1500
)
INSERT INTO events (id, event_type, user_id, occurred_at)
SELECT
    i,
    CASE
        WHEN i % 10 < 5 THEN 'page_view'
        WHEN i % 10 < 8 THEN 'click'
        ELSE 'purchase'
    END,
    ((i * 13) % 120) + 1,
    date('now', '-' || (i % 60) || ' day')
FROM seq;

-- ---------------------------------------------------------------------------
-- Intentional Anomaly Injection Fixtures (Validation Catalog)
-- Uncomment or execute selectively to validate test suite failure detection:
--
-- 1. NULL primary key:
--    INSERT INTO users (id, email, created_at, age, country) VALUES (999, NULL, date('now'), 30, 'US');
-- 2. NULL foreign key:
--    INSERT INTO events (id, event_type, user_id, occurred_at) VALUES (99999, 'page_view', NULL, date('now', '-1 day'));
-- 3. Duplicate email:
--    INSERT INTO users (id, email, created_at, age, country) VALUES (1000, 'user1@example.com', date('now'), 41, 'DE');
-- 4. Duplicate event id:
--    INSERT INTO events (id, event_type, user_id, occurred_at) VALUES (1, 'click', 5, date('now', '-2 day'));
-- ---------------------------------------------------------------------------
