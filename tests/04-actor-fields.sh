#!/usr/bin/env bash
# 04-actor-fields.sh — Verify the actor has all required AP fields
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "$ACTOR_URL" 2>&1)

# Required fields per ActivityPub spec
assert_contains "$output" "preferredUsername: \"${HANDLE}\"" \
  "Actor should have preferredUsername"

assert_contains "$output" "inbox:" \
  "Actor should have an inbox"

assert_contains "$output" "outbox:" \
  "Actor should have an outbox"

assert_contains "$output" "followers:" \
  "Actor should have a followers collection"

assert_contains "$output" "following:" \
  "Actor should have a following collection"

assert_contains "$output" "publicKey:" \
  "Actor should have a public key (HTTP Signatures)"

assert_contains "$output" "endpoints: Endpoints" \
  "Actor should have endpoints (sharedInbox)"

assert_contains "$output" "sharedInbox:" \
  "Actor should declare a shared inbox"

# New collection links (Fedify features)
assert_contains "$output" "liked:" \
  "Actor should have a liked collection link"

assert_contains "$output" "featured:" \
  "Actor should have a featured (pinned) collection link"

assert_contains "$output" "featuredTags:" \
  "Actor should have a featured tags collection link"

# Crypto keys
assert_contains "$output" "assertionMethods:" \
  "Actor should have assertionMethods (multi-key support)"

# Optional but important fields
assert_contains "$output" "name:" \
  "Actor should have a display name"

assert_contains "$output" "url:" \
  "Actor should have a profile URL"

assert_contains "$output" "icon:" \
  "Actor should have an icon/avatar"

assert_contains "$output" "published:" \
  "Actor should have a published date"

echo "Actor fields OK: inbox, outbox, followers, following, liked, featured, featuredTags, publicKey, assertionMethods, sharedInbox, name, icon, published"
