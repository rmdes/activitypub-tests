#!/usr/bin/env bash
# 10-root-redirect.sh — Verify root URL redirects AP clients to the actor
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Follow redirects, capture the final URL
response=$(curl -s -L -o /dev/null -w "%{url_effective}" \
  -H "Accept: application/activity+json" \
  "${BASE_URL}/")

assert_contains "$response" "/activitypub/users/${HANDLE}" \
  "Root URL should redirect AP clients to actor endpoint"

echo "Root redirect OK: ${BASE_URL}/ → ${response}"
