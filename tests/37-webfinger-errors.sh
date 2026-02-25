#!/usr/bin/env bash
# 37-webfinger-errors.sh — Verify WebFinger error handling for invalid queries
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Non-existent resource should return 404 (or 302 if auth middleware intercepts)
status_unknown=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}/.well-known/webfinger?resource=acct:nonexistent-user-xyz@${DOMAIN}")
assert_match "$status_unknown" "^(404|302)$" \
  "WebFinger for unknown resource should return 404 or 302 (got ${status_unknown})"

# Missing resource parameter should return 400
status_no_param=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}/.well-known/webfinger")
assert_eq "$status_no_param" "400" \
  "WebFinger without resource parameter should return 400 (got ${status_no_param})"

echo "WebFinger errors OK: ${status_unknown} for unknown, ${status_no_param} for missing resource"
