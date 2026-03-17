#!/usr/bin/env bash
# 52-object-likes-collection.sh — Verify per-object likes collection type
# Maps to socialweb.coop test UUID 200b9bc8-aae3-46f2-a6ab-5366042c0f6e
#
# AP §5.7: "Every object MAY have a likes collection."
# "The likes collection MUST be either an OrderedCollection or a Collection"
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

# Check for likes property
likes_val=$(jq -r '.likes // empty' <<< "$object_json" 2>/dev/null)
if [[ -z "$likes_val" ]]; then
  echo "SKIP: Object ${object_url} has no likes property (optional per AP §5.7)"
  exit 0
fi

# likes can be a URL or inline object
likes_type=$(jq -r '.likes.type // empty' <<< "$object_json" 2>/dev/null)
if [[ -n "$likes_type" ]]; then
  # Inline object
  assert_match "$likes_type" "^(OrderedCollection|Collection)$" \
    "Object likes type MUST be OrderedCollection or Collection (AP §5.7), got: $likes_type"
  echo "Object likes OK: inline ${likes_type}"
  exit 0
fi

# likes is a URL — dereference it
likes_json=$(curl -s -H "Accept: application/activity+json" "$likes_val")
assert_json_field "$likes_json" '.type' \
  "Likes collection JSON should have a type"
type=$(jq -r '.type' <<< "$likes_json")
assert_match "$type" "^(OrderedCollection|Collection)$" \
  "Object likes type MUST be OrderedCollection or Collection (AP §5.7), got: $type"

echo "Object likes OK: ${type} at ${likes_val}"
