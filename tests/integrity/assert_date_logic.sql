-- ============================================================================
-- TEST:       assert_date_logic
-- CATEGORY:   integrity
-- TABLE:      users, events
-- ASSERTION:  No records should contain future timestamps relative to execution.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

SELECT u.id AS record_key,
       u.created_at AS invalid_date,
       'future_user_created_at' AS violation_reason
FROM users AS u
WHERE date(u.created_at) > date('now')

UNION ALL

SELECT e.id AS record_key,
       e.occurred_at AS invalid_date,
       'future_event_occurred_at' AS violation_reason
FROM events AS e
WHERE date(e.occurred_at) > date('now');
