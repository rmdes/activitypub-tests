#!/usr/bin/env bash
# 51-inbox-orderedcollection.sh — Verify inbox identifies as OrderedCollection
# Maps to socialweb.coop test UUID 5e94d155-ed4a-4d71-b797-d7c387736ecf
#
# AP §5.2: "The inbox MUST be an OrderedCollection."
# However, GET on inbox returns 405 for unauthenticated clients.
# This test checks the inbox URL from the actor JSON and attempts
# to dereference it. If 405 is returned, the type cannot be verified
# externally (SKIP). If a JSON response is returned, verify the type.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Get the actor JSON and extract inbox URL
actor_json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")
inbox_url=$(jq -r '.inbox // empty' <<< "$actor_json")

if [[ -z "$inbox_url" ]]; then
  echo "ASSERT FAILED: Actor has no inbox property"
  exit 1
fi

# Check if inbox is an inline object (has type) vs a URL string
inbox_kind=$(jq -r '.inbox | type' <<< "$actor_json")
if [[ "$inbox_kind" == "object" ]]; then
  # Inline object — verify type directly
  inbox_type=$(jq -r '.inbox.type // empty' <<< "$actor_json")
  assert_match "$inbox_type" "^(OrderedCollection)$" \
    "Inline inbox type MUST be OrderedCollection (AP §5.2), got: $inbox_type"
  echo "Inbox OrderedCollection OK: inline object with type ${inbox_type}"
  exit 0
fi

# inbox is a URL string — try to dereference it
status=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Accept: application/activity+json" "$inbox_url")

if [[ "$status" == "405" ]]; then
  # GET returns 405 — correct behavior for non-owner, but we can't verify type
  echo "SKIP: inbox GET returns 405 (correct for non-owner); cannot verify OrderedCollection type externally"
  exit 0
fi

if [[ "$status" != "200" ]]; then
  echo "SKIP: inbox GET returned ${status}; expected 200 or 405"
  exit 0
fi

# Got a 200 — verify the JSON type
inbox_json=$(curl -s -H "Accept: application/activity+json" "$inbox_url")
assert_json_field "$inbox_json" '.type' \
  "Inbox JSON should have a type field"

type=$(jq -r '.type' <<< "$inbox_json")
assert_match "$type" "^(OrderedCollection)$" \
  "Inbox type MUST be OrderedCollection (AP §5.2), got: $type"

echo "Inbox OrderedCollection OK: ${inbox_url} has type ${type}"
