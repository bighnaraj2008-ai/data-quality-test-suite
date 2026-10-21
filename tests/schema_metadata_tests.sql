-- ============================================================================
-- TEST:       schema_metadata_tests
-- CATEGORY:   schema
-- ASSERTION:  Warehouse metadata catalog must contain users and events tables.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

SELECT 'missing_table' AS violation,
       'users' AS table_name
WHERE NOT EXISTS (SELECT 1 FROM sqlite_master WHERE type='table' AND name='users')

UNION ALL

SELECT 'missing_table' AS violation,
       'events' AS table_name
WHERE NOT EXISTS (SELECT 1 FROM sqlite_master WHERE type='table' AND name='events');
