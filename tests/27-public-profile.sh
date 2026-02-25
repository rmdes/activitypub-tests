#!/usr/bin/env bash
# 27-public-profile.sh — Verify the public profile HTML page for browsers
# Fedify serves JSON-LD for AP clients; browsers get HTML from this fallback.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Browser-like request should return 200 with HTML
status=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Accept: text/html" \
  "${BASE_URL}${MOUNT_PATH}/users/${HANDLE}")
assert_eq "$status" "200" \
  "Public profile should return 200 for HTML request"

headers=$(curl -s -D - -o /dev/null \
  -H "Accept: text/html" \
  "${BASE_URL}${MOUNT_PATH}/users/${HANDLE}")
assert_match "$headers" "[Cc]ontent-[Tt]ype:.*text/html" \
  "Public profile should serve text/html"

# Body should contain the handle
body=$(curl -s -H "Accept: text/html" \
  "${BASE_URL}${MOUNT_PATH}/users/${HANDLE}")
assert_contains "$body" "${HANDLE}" \
  "Public profile HTML should contain the handle"

# Non-existent actor should not return 200
status_bad=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Accept: text/html" \
  "${BASE_URL}${MOUNT_PATH}/users/nonexistent-user-xyz")
assert_match "$status_bad" "^(404|302)$" \
  "Non-existent actor public profile should return 404 or redirect (got ${status_bad})"

echo "Public profile OK: HTML at ${MOUNT_PATH}/users/${HANDLE}, 404 for unknown actors"
