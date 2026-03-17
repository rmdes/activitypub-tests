#!/usr/bin/env bash
# 28-compose-auth-redirect.sh — Verify compose endpoint redirects unauthenticated requests
# The old quick-replies endpoint was replaced by /admin/reader/compose (Micropub-based).
# Since it's behind IndieAuth, unauthenticated requests should redirect to login (302).
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Compose endpoint should redirect to login (not 404 or 500)
status=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}${MOUNT_PATH}/admin/reader/compose")
assert_match "$status" "^(302|303)$" \
  "Compose endpoint should redirect unauthenticated requests (got ${status})"

# Compose with replyTo param should also redirect (not crash)
status=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}${MOUNT_PATH}/admin/reader/compose?replyTo=https://example.com/note/123")
assert_match "$status" "^(302|303)$" \
  "Compose with replyTo should redirect unauthenticated requests (got ${status})"

echo "Compose auth redirect OK: unauthenticated requests properly redirected to login"
