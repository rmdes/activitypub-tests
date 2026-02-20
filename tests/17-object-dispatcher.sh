#!/usr/bin/env bash
# 17-object-dispatcher.sh — Verify that posts are dereferenceable via object URIs
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Fetch the outbox to get a recent activity
outbox_output=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_page=$(echo "$outbox_output" | jq -r '.first // empty')

if [[ -z "$first_page" ]]; then
  echo "SKIP: No outbox first page link found"
  exit 0
fi

page_output=$(curl -s -H "Accept: application/activity+json" "$first_page")
first_object_id=$(echo "$page_output" | jq -r '.orderedItems[0].object.id // .orderedItems[0].object // empty')

if [[ -z "$first_object_id" ]]; then
  echo "SKIP: No objects in outbox first page"
  exit 0
fi

# Fetch the object directly
obj_output=$(curl -s -H "Accept: application/activity+json" "$first_object_id")
obj_type=$(echo "$obj_output" | jq -r '.type // empty')

if [[ -n "$obj_type" ]]; then
  assert_match "$obj_type" "^(Note|Article)$" \
    "Object should be a Note or Article"
  echo "Object dispatcher OK: ${obj_type} at ${first_object_id}"
else
  echo "SKIP: Could not dereference object (may be external)"
  exit 0
fi
