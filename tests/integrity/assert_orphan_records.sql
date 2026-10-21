-- ============================================================================
-- TEST:       assert_orphan_records
-- CATEGORY:   integrity
-- TABLE:      events -> users
-- ASSERTION:  Every event must reference an existing valid user in users table.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

SELECT e.id AS orphan_event_id,
       e.user_id AS invalid_user_id
FROM events AS e
LEFT JOIN users AS u ON e.user_id = u.id
WHERE u.id IS NULL;
