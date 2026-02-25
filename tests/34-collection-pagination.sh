#!/usr/bin/env bash
# 34-collection-pagination.sh — Verify collection pagination works beyond first page
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Fetch outbox to get the first page URL
outbox=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_url=$(jq -r '.first // empty' <<< "$outbox")
assert_match "$first_url" "^https?://" \
  "Outbox should have a first page URL"

# Fetch first page
page1=$(curl -s -H "Accept: application/activity+json" "$first_url")
assert_json_field "$page1" '.orderedItems' \
  "First page should have orderedItems"

items_count=$(jq '.orderedItems | length' <<< "$page1")

# Check for next page link
next_url=$(jq -r '.next // empty' <<< "$page1")
if [[ -n "$next_url" ]]; then
  # Fetch second page
  page2=$(curl -s -H "Accept: application/activity+json" "$next_url")
  assert_json_field "$page2" '.orderedItems' \
    "Second page should have orderedItems"

  items2_count=$(jq '.orderedItems | length' <<< "$page2")

  # Second page items should be different from first page
  first_id_p1=$(jq -r '.orderedItems[0] | (.id // (if .object | type == "object" then .object.id else .object end) // empty)' <<< "$page1")
  first_id_p2=$(jq -r '.orderedItems[0] | (.id // (if .object | type == "object" then .object.id else .object end) // empty)' <<< "$page2")
  if [[ -n "$first_id_p1" && -n "$first_id_p2" ]]; then
    assert_not_contains "$first_id_p2" "$first_id_p1" \
      "Second page first item should differ from first page first item"
  fi

  echo "Pagination OK: page1=${items_count} items, page2=${items2_count} items"
else
  echo "Pagination OK: page1=${items_count} items (single page, no next link needed)"
fi
