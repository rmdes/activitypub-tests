#!/usr/bin/env bash
# 49-followers-fields.sh — Verify followers collection has proper OrderedCollection structure
# The followers collection should be an OrderedCollection with totalItems count.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/followers")

# Must be OrderedCollection
assert_json_eq "$json" '.type' "OrderedCollection" \
  "Followers should be an OrderedCollection"

# Must have totalItems
assert_json_field "$json" '.totalItems' \
  "Followers should have totalItems"

total=$(jq -r '.totalItems' <<< "$json")
assert_match "$total" "^[0-9]+$" \
  "totalItems should be a number"

# Must have id
assert_json_field "$json" '.id' \
  "Followers collection should have id"

# id should match the expected URL
followers_id=$(jq -r '.id' <<< "$json")
assert_contains "$followers_id" "/followers" \
  "Followers id should contain /followers path"

# Should have first page link if there are followers
if [[ "$total" -gt 0 ]]; then
  assert_json_field "$json" '.first' \
    "Followers with items should have first page"
fi

echo "Followers collection OK: totalItems=${total}, proper OrderedCollection structure"
