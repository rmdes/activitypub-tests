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

# Extract count
total=$(echo "$output" | grep -o 'totalItems: [0-9]*' | grep -o '[0-9]*')
echo "Outbox OK: OrderedCollection with ${total} items"
