# Troubleshooting Guide

## Common Issues
### Tests failing on drift detection
- Ensure test execution window excludes partial active days.
- Verify historical seed volume has at least 37 complete days.

### Database connection errors
- For Postgres: Verify `DATABASE_URL` is set and network is reachable.
- For SQLite: Ensure parent directory of `target/quality.db` exists.
