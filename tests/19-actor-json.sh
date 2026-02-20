#!/usr/bin/env bash
# 19-actor-json.sh — Verify actor JSON has all required fields via raw HTTP
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# Context
assert_json_field "$json" '.["@context"]' \
  "Actor JSON should have @context"

# Type
type=$(echo "$json" | jq -r '.type')
assert_match "$type" "^(Person|Service|Organization|Group)$" \
  "Actor type should be a valid actor type (got: $type)"

# Required AP fields
assert_json_eq "$json" '.preferredUsername' "$HANDLE" \
  "preferredUsername should match handle"

assert_json_field "$json" '.inbox' \
  "Actor should have inbox URL"

assert_json_field "$json" '.outbox' \
  "Actor should have outbox URL"

assert_json_field "$json" '.followers' \
  "Actor should have followers URL"

assert_json_field "$json" '.following' \
  "Actor should have following URL"

# New collection fields
assert_json_field "$json" '.liked' \
  "Actor should have liked URL"

assert_json_field "$json" '.featured' \
  "Actor should have featured URL"

assert_json_field "$json" '.featuredTags' \
  "Actor should have featuredTags URL"

# Security
assert_json_field "$json" '.publicKey.publicKeyPem' \
  "Actor should have publicKey with PEM"

assert_json_field "$json" '.publicKey.id' \
  "Actor publicKey should have an id"

# Endpoints
assert_json_field "$json" '.endpoints.sharedInbox' \
  "Actor should declare a shared inbox endpoint"

# Profile fields
assert_json_field "$json" '.name' "Actor should have a display name"
assert_json_field "$json" '.url' "Actor should have a profile URL"

echo "Actor JSON OK: $type with all required fields, collection links, and security keys"
