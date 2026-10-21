#!/usr/bin/env bash
# Sample Slack notification hook for failed data quality runs
WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
if [[ -n "$WEBHOOK_URL" ]]; then
    curl -s -X POST -H 'Content-type: application/json' \
        --data '{"text":"🚨 Data Quality Test Suite Failure detected!"}' \
        "$WEBHOOK_URL"
fi
