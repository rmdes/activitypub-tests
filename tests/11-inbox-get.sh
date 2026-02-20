#!/usr/bin/env bash
# 11-inbox-get.sh — Verify GET on per-user inbox returns 405 Method Not Allowed
set -euo pipefail
source "$(dirname "$0")/common.sh"

assert_http_status \
  "${BASE_URL}/activitypub/users/${HANDLE}/inbox" \
  "405" \
  "GET" \
  "Accept: application/activity+json"

echo "Inbox GET OK: returns 405 Method Not Allowed"
