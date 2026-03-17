#!/usr/bin/env bash
# 60-actor-serves-as2-to-get.sh — Actor serves AS2 object in response to GET
# Maps to socialweb.coop test UUID e7ee491d-88d7-4e67-80c8-f74781bb247c
#
# AP §3.2: "Servers MUST present the ActivityStreams object representation in
# response to application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\""
set -euo pipefail
source "$(dirname "$0")/common.sh"

# GET the actor with the exact AP §3.2 Accept header
response=$(curl -s -w "\n%{http_code}" \
  -H 'Accept: application/ld+json; profile="https://www.w3.org/ns/activitystreams"' \
  "$ACTOR_URL")

# Split body and status
body=$(sed '$ d' <<< "$response")
status=$(tail -1 <<< "$response")

# Must return 200
assert_eq "$status" "200" \
  "Actor GET with ld+json Accept should return 200 (got: ${status})"

# Response body must be parseable as JSON
if ! jq -e '.' <<< "$body" >/dev/null 2>&1; then
  echo "ASSERT FAILED: Response body is not valid JSON"
  exit 1
fi

# Response body must be a JSON Object (not array, string, etc.)
json_type=$(jq -r 'type' <<< "$body")
assert_eq "$json_type" "object" \
  "Response body must be a JSON Object (got: ${json_type})"

# Must have @context (ActivityStreams object representation)
assert_json_field "$body" '.["@context"]' \
  "Response must have @context (AS2 object representation)"

# Must have a type indicating this is an Actor
actor_type=$(jq -r '.type // empty' <<< "$body")
assert_match "$actor_type" "^(Person|Application|Group|Organization|Service)$" \
  "Actor type should be a valid AP actor type (got: ${actor_type})"

echo "Actor AS2 GET OK: type=${actor_type}, valid JSON object with @context (AP §3.2, socialweb.coop e7ee491d)"
