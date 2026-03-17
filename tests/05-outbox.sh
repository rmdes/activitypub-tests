#!/usr/bin/env bash
# 05-outbox.sh — Verify the outbox collection is accessible and has items
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/outbox" 2>&1)

assert_contains "$output" "OrderedCollection {" \
  "Outbox should be an OrderedCollection"

assert_match "$output" "totalItems: [0-9]+" \
  "Outbox should report totalItems"

assert_contains "$output" "first:" \
  "Outbox should have a first page link"

# Verify raw JSON type per socialweb.coop test (UUID 4af549f4)
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
assert_json_eq "$json" '.type' 'OrderedCollection' \
  "Outbox JSON type MUST be OrderedCollection (AP §5.1)"

assert_json_field "$json" '.id' \
  "Outbox JSON should have an id"

# Extract count
total=$(jq -r '.totalItems // 0' <<< "$json")
echo "Outbox OK: OrderedCollection with ${total} items"
