#!/usr/bin/env bash
# 14-featured.sh — Verify the featured (pinned) collection is accessible
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/featured" 2>&1)

assert_contains "$output" "OrderedCollection {" \
  "Featured should be an OrderedCollection"

# Also verify via raw JSON
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/featured")
assert_json_eq "$json" '.type' 'OrderedCollection' \
  "Featured JSON type should be OrderedCollection"

# totalItems is optional per AP spec when empty — check type and id instead
assert_json_field "$json" '.id' \
  "Featured JSON should have an id"

total=$(echo "$json" | jq -r '.totalItems // 0')
echo "Featured OK: OrderedCollection with ${total} pinned items"
