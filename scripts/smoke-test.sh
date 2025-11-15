#!/usr/bin/env bash
# scripts/smoke-test.sh
# Simple smoke test against DTB BankingOnline HTTP endpoint.

set -euo pipefail

APP_URL="${1:-http://localhost:8080/actuator/health}"
MAX_RETRIES="${MAX_RETRIES:-20}"
SLEEP_SECONDS="${SLEEP_SECONDS:-10}"

echo "Starting smoke test against: $APP_URL"
echo "Max retries: $MAX_RETRIES, sleep: ${SLEEP_SECONDS}s"

for i in $(seq 1 "$MAX_RETRIES"); do
  echo "Attempt $i/$MAX_RETRIES..."
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL" || echo "000")
  echo "HTTP status: $STATUS_CODE"

  if [ "$STATUS_CODE" -eq 200 ]; then
    echo "Smoke test PASSED."
    exit 0
  fi

  sleep "$SLEEP_SECONDS"
done

echo "Smoke test FAILED after $MAX_RETRIES attempts."
exit 1
