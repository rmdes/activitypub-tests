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

total=$(echo "$output" | grep -o 'totalItems: [0-9]*' | grep -o '[0-9]*')
echo "Following OK: OrderedCollection with ${total} items"
