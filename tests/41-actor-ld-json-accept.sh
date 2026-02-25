#!/usr/bin/env bash
# 41-actor-ld-json-accept.sh — Verify actor responds to ld+json Accept header
# AP spec Section 3.2 requires both application/activity+json AND
# application/ld+json; profile="https://www.w3.org/ns/activitystreams"
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Request with ld+json profile Accept header
response=$(curl -s \
  -H 'Accept: application/ld+json; profile="https://www.w3.org/ns/activitystreams"' \
  "$ACTOR_URL")

assert_contains "$response" '"@context"' \
  "ld+json Accept should return valid AS2 with @context"

assert_contains "$response" '"preferredUsername"' \
  "ld+json Accept should return actor with preferredUsername"

echo "Actor ld+json Accept OK: responds correctly to both AS2 content types"
