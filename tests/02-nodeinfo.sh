#!/usr/bin/env bash
# 02-nodeinfo.sh — Verify NodeInfo endpoint returns valid data
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify nodeinfo "$DOMAIN" --raw 2>&1)

assert_contains "$output" '"name": "indiekit"' \
  "NodeInfo software name should be indiekit"

assert_contains "$output" '"activitypub"' \
  "NodeInfo protocols should include activitypub"

assert_contains "$output" '"version": "2.1"' \
  "NodeInfo version should be 2.1"

assert_match "$output" '"localPosts": [0-9]+' \
  "NodeInfo should report localPosts count"

assert_match "$output" '"total": [0-9]+' \
  "NodeInfo should report user totals"

# Extract localPosts count for informational output
posts=$(echo "$output" | grep -o '"localPosts": [0-9]*' | grep -o '[0-9]*')
echo "NodeInfo OK: indiekit v1.0.0, ${posts} local posts, protocol: activitypub"
