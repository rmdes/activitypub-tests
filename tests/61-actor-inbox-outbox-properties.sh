#!/usr/bin/env bash
# 61-actor-inbox-outbox-properties.sh — Actor must have inbox and outbox properties
# Maps to socialweb.coop test UUID acaacb5f-8f7e-4f28-8d81-c7955070a767
#
# AP §4.1: "Actor objects MUST have... the following properties: inbox... outbox..."
# This test only checks presence, not values (per the socialweb.coop spec).
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Fetch actor JSON
actor_json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# Must be valid JSON
if ! jq -e '.' <<< "$actor_json" >/dev/null 2>&1; then
  echo "ASSERT FAILED: Actor response is not valid JSON"
  exit 1
fi

# Must have a type indicating it's an Actor
actor_type=$(jq -r '.type // empty' <<< "$actor_json")
if [[ -z "$actor_type" ]]; then
  echo "ASSERT FAILED: Actor JSON has no type property"
  exit 1
fi
assert_match "$actor_type" "^(Person|Application|Group|Organization|Service)$" \
  "Actor type should be valid AP actor type (got: ${actor_type})"

# Must have inbox property
assert_json_field "$actor_json" '.inbox' \
  "Actor MUST have inbox property (AP §4.1)"

# Must have outbox property
assert_json_field "$actor_json" '.outbox' \
  "Actor MUST have outbox property (AP §4.1)"

inbox=$(jq -r '.inbox' <<< "$actor_json")
outbox=$(jq -r '.outbox' <<< "$actor_json")
echo "Actor inbox+outbox OK: inbox=${inbox}, outbox=${outbox} (AP §4.1, socialweb.coop acaacb5f)"
