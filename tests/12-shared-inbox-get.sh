#!/usr/bin/env bash
# 12-shared-inbox-get.sh — Verify GET on shared inbox is rejected (not 200)
#
# Fedify intercepts the shared inbox route and returns 400 (invalid JSON body)
# for non-POST requests, rather than the plugin's 405 catch-all. Either 400 or
# 405 is acceptable — the key assertion is that GET does NOT return 200.
set -euo pipefail
source "$(dirname "$0")/common.sh"

status=$(curl -s -o /dev/null -w "%{http_code}" -X GET \
  -H "Accept: application/activity+json" \
  "${BASE_URL}/activitypub/inbox")

if [[ "$status" == "200" || "$status" == "301" || "$status" == "302" ]]; then
  echo "ASSERT FAILED: GET on shared inbox should be rejected"
  echo "  Expected: 400 or 405"
  echo "  Got:      $status"
  exit 1
fi

echo "Shared inbox GET OK: returns ${status} (rejected)"
