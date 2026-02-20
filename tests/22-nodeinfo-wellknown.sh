#!/usr/bin/env bash
# 22-nodeinfo-wellknown.sh — Verify NodeInfo well-known discovery chain
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Step 1: Fetch well-known/nodeinfo
wk_json=$(curl -s "${BASE_URL}/.well-known/nodeinfo")
assert_json_field "$wk_json" '.links[0].href' \
  "NodeInfo well-known should have links"

href=$(echo "$wk_json" | jq -r '.links[0].href')
rel=$(echo "$wk_json" | jq -r '.links[0].rel')

assert_contains "$rel" "nodeinfo" \
  "NodeInfo link rel should reference nodeinfo schema"

# Step 2: Verify the linked document is reachable
status=$(curl -s -o /dev/null -w "%{http_code}" "$href")
assert_eq "$status" "200" \
  "NodeInfo document at ${href} should return 200"

# Step 3: Validate document structure
doc=$(curl -s "$href")
assert_json_eq "$doc" '.version' '2.1' \
  "NodeInfo document version should be 2.1"

assert_json_field "$doc" '.software.name' \
  "NodeInfo should have software.name"

assert_json_field "$doc" '.software.version' \
  "NodeInfo should have software.version"

echo "NodeInfo well-known OK: Discovery chain valid, schema 2.1"
