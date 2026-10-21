-- ============================================================================
-- Executive test results summary view definition
-- ============================================================================
CREATE VIEW IF NOT EXISTS v_data_quality_summary AS
SELECT 
    'users' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS null_emails,
    COUNT(DISTINCT email) AS unique_emails
FROM users
UNION ALL
SELECT 
    'events' AS table_name,
    COUNT(*) AS total_records,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_ids,
    COUNT(DISTINCT id) AS unique_ids
FROM events;

SELECT * FROM v_data_quality_summary WHERE 1=0;
