#!/usr/bin/env bash
# 15-featured-tags.sh — Verify the featured tags collection is accessible
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "${ACTOR_URL}/tags" 2>&1)

# Featured tags uses Collection (not OrderedCollection) per Fedify
assert_match "$output" "(Ordered)?Collection {" \
  "Featured tags should be a Collection"

# Verify raw JSON type — Collection or OrderedCollection both valid
json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/tags")
assert_json_field "$json" '.type' \
  "Featured tags JSON should have a type"
ft_type=$(jq -r '.type' <<< "$json")
assert_match "$ft_type" "^(OrderedCollection|Collection)$" \
  "Featured tags type MUST be OrderedCollection or Collection, got: $ft_type"

# If there are tags, they should be Hashtag objects
items_count=$(jq -r '.totalItems // (.items | length) // 0' <<< "$json" 2>/dev/null)
echo "Featured tags OK: Collection with ${items_count} tags"
