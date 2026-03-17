#!/usr/bin/env bash
# 06-followers.sh — Verify the followers collection is accessible
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/followers" 2>&1)

assert_contains "$output" "OrderedCollection {" \
  "Followers should be an OrderedCollection"

assert_match "$output" "totalItems: [0-9]+" \
  "Followers should report totalItems"

assert_contains "$output" "first:" \
  "Followers should have a first page link"

# Verify raw JSON type per socialweb.coop test (UUID 018c3e08)
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/followers")
assert_json_field "$json" '.type' \
  "Followers JSON should have a type"
type=$(jq -r '.type' <<< "$json")
assert_match "$type" "^(OrderedCollection|Collection)$" \
  "Followers type MUST be OrderedCollection or Collection (AP §5.3), got: $type"

assert_json_field "$json" '.id' \
  "Followers JSON should have an id"

total=$(jq -r '.totalItems // 0' <<< "$json")
echo "Followers OK: ${type} with ${total} items"
