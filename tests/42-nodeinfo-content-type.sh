#!/usr/bin/env bash
# 42-nodeinfo-content-type.sh — Verify NodeInfo endpoints return correct content types
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Well-known NodeInfo should return JRD+JSON (RFC 7033) or application/json
wk_headers=$(curl -s -D - -o /dev/null "${BASE_URL}/.well-known/nodeinfo")
assert_match "$wk_headers" "[Cc]ontent-[Tt]ype:.*application/(jrd\+)?json" \
  "NodeInfo well-known should return application/jrd+json or application/json"

# NodeInfo 2.1 document should return JSON
ni_headers=$(curl -s -D - -o /dev/null "${BASE_URL}/nodeinfo/2.1")
assert_match "$ni_headers" "[Cc]ontent-[Tt]ype:.*application/(jrd\+)?json" \
  "NodeInfo 2.1 should return JSON content type"

echo "NodeInfo content types OK: JSON content types on both endpoints"
