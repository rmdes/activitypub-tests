#!/usr/bin/env bash
# 28-quick-replies-404.sh — Verify quick-replies endpoint returns 404 for non-existent notes
# Remote servers dereference Note IDs during Create activity verification.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Non-existent note should return 404
status=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Accept: application/activity+json" \
  "${BASE_URL}${MOUNT_PATH}/quick-replies/nonexistent-id-12345")
assert_eq "$status" "404" \
  "Quick replies for non-existent ID should return 404 (got ${status})"

echo "Quick replies OK: 404 for non-existent notes"
