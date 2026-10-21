-- ============================================================================
-- TEST:       assert_no_null_users
-- CATEGORY:   nulls
-- TABLE:      users
-- ASSERTION:  Critical columns of `users` must never contain unexpected NULLs.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per violation: (record_key, violated_column).
-- SEVERITY:   error (blocking)
-- ============================================================================

SELECT u.id AS record_key,
       'id' AS violated_column
FROM users AS u
WHERE u.id IS NULL

UNION ALL

SELECT u.id AS record_key,
       'email' AS violated_column
FROM users AS u
WHERE u.email IS NULL

UNION ALL

SELECT u.id AS record_key,
       'created_at' AS violated_column
FROM users AS u
WHERE u.created_at IS NULL

UNION ALL

SELECT u.id AS record_key,
       'country' AS violated_column
FROM users AS u
WHERE u.country IS NULL

UNION ALL

SELECT u.id AS record_key,
       'age' AS violated_column
FROM users AS u
WHERE u.age IS NULL;
