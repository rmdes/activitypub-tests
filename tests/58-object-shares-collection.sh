#!/usr/bin/env bash
# 58-object-shares-collection.sh — Verify per-object shares collection type
# Maps to socialweb.coop test UUID b03a5245-1072-426d-91b3-a3d412d45ae8
#
# AP §5.8: "Every object MAY have a shares collection."
# "The shares collection MUST be either an OrderedCollection or a Collection"
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Get outbox first page to find an object
outbox_json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_url=$(jq -r '.first // empty' <<< "$outbox_json")

if [[ -z "$first_url" ]]; then
  echo "SKIP: Outbox has no first page"
  exit 0
fi

# Handle first as string URL or inline object
if [[ "$first_url" == http* ]]; then
  page_json=$(curl -s -H "Accept: application/activity+json" "$first_url")
else
  page_json=$(jq '.first' <<< "$outbox_json")
fi

# Find the first activity's object URL
object_url=$(jq -r '
  (.orderedItems // .items // [])[] |
  if .object then
    (if (.object | type) == "string" then .object
     elif .object.id then .object.id
     else empty end)
  else empty end
' <<< "$page_json" 2>/dev/null | head -1)

if [[ -z "$object_url" ]]; then
  echo "SKIP: No dereferenceable objects found in outbox first page"
  exit 0
fi

# Fetch the object
object_json=$(curl -s -H "Accept: application/activity+json" "$object_url")

# Check for shares property
shares_val=$(jq -r '.shares // empty' <<< "$object_json" 2>/dev/null)
if [[ -z "$shares_val" ]]; then
  echo "SKIP: Object ${object_url} has no shares property (optional per AP §5.8)"
  exit 0
fi

# shares can be a URL or inline object
shares_type=$(jq -r '.shares.type // empty' <<< "$object_json" 2>/dev/null)
if [[ -n "$shares_type" ]]; then
  # Inline object
  assert_match "$shares_type" "^(OrderedCollection|Collection)$" \
    "Object shares type MUST be OrderedCollection or Collection (AP §5.8), got: $shares_type"
  echo "Object shares OK: inline ${shares_type}"
  exit 0
fi

# shares is a URL — dereference it
shares_json=$(curl -s -H "Accept: application/activity+json" "$shares_val")
assert_json_field "$shares_json" '.type' \
  "Shares collection JSON should have a type"
type=$(jq -r '.type' <<< "$shares_json")
assert_match "$type" "^(OrderedCollection|Collection)$" \
  "Object shares type MUST be OrderedCollection or Collection (AP §5.8), got: $type"

echo "Object shares OK: ${type} at ${shares_val}"
