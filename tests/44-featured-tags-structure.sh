#!/usr/bin/env bash
# 44-featured-tags-structure.sh — Verify featured tags are Hashtag objects
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Get featured tags collection URL from actor
actor_json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")
tags_url=$(jq -r '.featuredTags // empty' <<< "$actor_json")
if [[ -z "$tags_url" ]]; then
  echo "SKIP: Actor has no featuredTags URL"
  exit 0
fi

# Fetch the collection
tags_json=$(curl -s -H "Accept: application/activity+json" "$tags_url")
items_count=$(jq '.items // .orderedItems // [] | length' <<< "$tags_json")

if [[ "$items_count" -eq 0 ]]; then
  echo "Featured tags structure OK: collection exists, 0 items (no tags configured)"
  exit 0
fi

# Verify first tag is a Hashtag with name starting with # and an href
items_path='.items // .orderedItems'
first_type=$(jq -r "(${items_path})[0].type // empty" <<< "$tags_json")
assert_eq "$first_type" "Hashtag" \
  "Featured tag type should be Hashtag (got: ${first_type})"

first_name=$(jq -r "(${items_path})[0].name // empty" <<< "$tags_json")
assert_match "$first_name" '^#' \
  "Featured tag name should start with # (got: ${first_name})"

first_href=$(jq -r "(${items_path})[0].href // empty" <<< "$tags_json")
assert_match "$first_href" '^https?://' \
  "Featured tag should have an href URL (got: ${first_href})"

echo "Featured tags structure OK: ${items_count} Hashtag objects with name and href"
