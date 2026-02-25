#!/usr/bin/env bash
# 24-actor-attachments.sh — Verify actor attachments are PropertyValue array
# Mastodon requires attachment to be an array (not a plain object from JSON-LD compaction).
# The bridge forces this via the attachment array workaround.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# attachment must be present
assert_json_field "$json" '.attachment' \
  "Actor should have attachment field"

# attachment must be an array (not collapsed to a single object)
is_array=$(jq -e '.attachment | type == "array"' <<< "$json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$is_array" "true" \
  "Actor attachment must be an array (Mastodon compatibility)"

# At least one PropertyValue
has_pv=$(jq -e '.attachment[] | select(.type == "PropertyValue")' <<< "$json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$has_pv" "true" \
  "Actor should have at least one PropertyValue attachment"

# Each PropertyValue should have name and value
count=$(jq '.attachment | length' <<< "$json")
for i in $(seq 0 $((count - 1))); do
  pv_type=$(jq -r ".attachment[$i].type // empty" <<< "$json")
  if [[ "$pv_type" == "PropertyValue" ]]; then
    assert_json_field "$json" ".attachment[$i].name" \
      "PropertyValue[$i] should have a name"
    assert_json_field "$json" ".attachment[$i].value" \
      "PropertyValue[$i] should have a value"
  fi
done

echo "Actor attachments OK: ${count} items, all PropertyValue with name+value, array format confirmed"
