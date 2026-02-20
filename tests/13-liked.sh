#!/usr/bin/env bash
# 13-liked.sh — Verify the liked collection is accessible and well-formed
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/liked" 2>&1)

assert_contains "$output" "OrderedCollection {" \
  "Liked should be an OrderedCollection"

assert_match "$output" "totalItems: [0-9]+" \
  "Liked should report totalItems"

assert_contains "$output" "first:" \
  "Liked should have a first page link"

# Also verify via raw JSON
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/liked")
assert_json_eq "$json" '.type' 'OrderedCollection' \
  "Liked JSON type should be OrderedCollection"

assert_json_field "$json" '.totalItems' \
  "Liked JSON should have totalItems"

total=$(echo "$json" | jq -r '.totalItems')
echo "Liked OK: OrderedCollection with ${total} items"
