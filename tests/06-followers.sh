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

total=$(grep -o 'totalItems: [0-9]*' <<< "$output" | grep -o '[0-9]*')
echo "Followers OK: OrderedCollection with ${total} items"
