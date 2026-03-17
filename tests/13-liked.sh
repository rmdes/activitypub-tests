#!/usr/bin/env bash
# 13-liked.sh — Verify the liked collection is accessible and well-formed
# Maps to socialweb.coop test UUID 018c3df2-d6d8-7f62-805b-b71a96cc6170
#
# AP §5.5: "The liked collection MUST be either an OrderedCollection or a Collection"
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/liked" 2>&1)

assert_contains "$output" "OrderedCollection {" \
  "Liked should be an OrderedCollection"

assert_match "$output" "totalItems: [0-9]+" \
  "Liked should report totalItems"

assert_contains "$output" "first:" \
  "Liked should have a first page link"

# Verify raw JSON type per socialweb.coop test (UUID 018c3df2)
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/liked")
assert_json_field "$json" '.type' \
  "Liked JSON should have a type"
type=$(jq -r '.type' <<< "$json")
assert_match "$type" "^(OrderedCollection|Collection)$" \
  "Liked type MUST be OrderedCollection or Collection (AP §5.5), got: $type"

assert_json_field "$json" '.totalItems' \
  "Liked JSON should have totalItems"

total=$(jq -r '.totalItems' <<< "$json")
echo "Liked OK: ${type} with ${total} items"
