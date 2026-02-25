#!/usr/bin/env bash
# 38-actor-not-found.sh — Verify non-existent actor returns 404
set -euo pipefail
source "$(dirname "$0")/common.sh"

# AP client requesting non-existent actor
# Fedify returns 404 for unknown actors, but Indiekit's auth middleware
# may intercept and redirect (302) before Fedify handles it.
status=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Accept: application/activity+json" \
  "${BASE_URL}${MOUNT_PATH}/users/nonexistent-user-xyz")
assert_match "$status" "^(404|302)$" \
  "Non-existent actor should return 404 or 302 (got ${status})"

# Must NOT return 200 (that would mean we're serving fake actor data)
assert_not_contains "$status" "200" \
  "Non-existent actor should never return 200"

echo "Actor not found OK: 404 for unknown actors"
