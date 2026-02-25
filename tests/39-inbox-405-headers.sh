#!/usr/bin/env bash
# 39-inbox-405-headers.sh — Verify inbox 405 includes Allow and Content-Type headers
set -euo pipefail
source "$(dirname "$0")/common.sh"

headers=$(curl -s -D - -o /dev/null -X GET \
  "${BASE_URL}${MOUNT_PATH}/users/${HANDLE}/inbox")

# Should include Allow: POST
assert_match "$headers" "[Aa]llow:.*POST" \
  "Inbox 405 should include Allow: POST header"

# Should return application/activity+json content type
assert_match "$headers" "application/activity\\+json" \
  "Inbox 405 should return application/activity+json"

echo "Inbox 405 headers OK: Allow: POST, Content-Type: activity+json"
