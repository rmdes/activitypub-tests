#!/usr/bin/env bash
# 48-outbox-create-structure.sh — Verify outbox items have proper Create activity structure
# Each outbox item should be a Create wrapping a Note/Article with required fields.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Get outbox
outbox_json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_page=$(jq -r '.first // empty' <<< "$outbox_json")

if [[ -z "$first_page" ]]; then
  echo "SKIP: Outbox has no first page"
  exit 0
fi

# Handle first page being a string URL or inline object
if [[ "$first_page" == "http"* ]]; then
  page_json=$(curl -s -H "Accept: application/activity+json" "$first_page")
else
  page_json="$outbox_json"
fi

# Get first item
item_count=$(jq '.orderedItems | length' <<< "$page_json" 2>/dev/null || echo "0")
if [[ "$item_count" == "0" ]]; then
  echo "SKIP: Outbox has no items"
  exit 0
fi

# Check first item structure
item_type=$(jq -r '.orderedItems[0].type' <<< "$page_json")
assert_eq "$item_type" "Create" \
  "Outbox item should be a Create activity"

# Create should have actor
assert_json_field "$page_json" '.orderedItems[0].actor' \
  "Create activity should have actor"

# Create should have object
assert_json_field "$page_json" '.orderedItems[0].object' \
  "Create activity should have object"

# Object should have content or name
obj_type=$(jq -r '.orderedItems[0].object.type // empty' <<< "$page_json")
if [[ -n "$obj_type" ]]; then
  assert_match "$obj_type" "^(Note|Article)$" \
    "Create object should be Note or Article (got: $obj_type)"
fi

# Object should have to/cc for visibility
has_to=$(jq -e '.orderedItems[0].object.to // .orderedItems[0].to' <<< "$page_json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$has_to" "true" \
  "Create activity or its object should have to field (for visibility)"

echo "Outbox Create structure OK: type=${item_type}, object=${obj_type}, ${item_count} items on first page"
