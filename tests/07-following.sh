#!/usr/bin/env bash
# 07-following.sh — Verify the following collection is accessible
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/following" 2>&1)

assert_contains "$output" "OrderedCollection {" \
  "Following should be an OrderedCollection"

assert_match "$output" "totalItems: [0-9]+" \
  "Following should report totalItems"

assert_contains "$output" "first:" \
  "Following should have a first page link"

# Verify raw JSON type per socialweb.coop test (UUID 018c3e17)
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/following")
assert_json_field "$json" '.type' \
  "Following JSON should have a type"
type=$(jq -r '.type' <<< "$json")
assert_match "$type" "^(OrderedCollection|Collection)$" \
  "Following type MUST be OrderedCollection or Collection (AP §5.4), got: $type"

assert_json_field "$json" '.id' \
  "Following JSON should have an id"

total=$(jq -r '.totalItems // 0' <<< "$json")
echo "Following OK: ${type} with ${total} items"
