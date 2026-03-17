#!/usr/bin/env bash
# 50-context-jsonld.sh — Verify actor JSON-LD @context includes required namespaces
# Fedify 2.0 should include AS2, security, and Mastodon-compatible contexts.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# Must have @context
assert_json_field "$json" '."@context"' \
  "Actor should have @context"

context=$(jq -c '."@context"' <<< "$json")

# AS2 namespace
assert_contains "$context" "https://www.w3.org/ns/activitystreams" \
  "@context should include ActivityStreams namespace"

# Security namespace (for publicKey)
assert_contains "$context" "https://w3id.org/security" \
  "@context should include security namespace"

# Data integrity (for assertionMethod / Multikey)
assert_contains "$context" "https://w3id.org/security/data-integrity" \
  "@context should include data-integrity namespace"

# Multikey namespace
assert_contains "$context" "https://w3id.org/security/multikey" \
  "@context should include multikey namespace"

# Mastodon toot namespace (for featured, featuredTags, discoverable, etc.)
assert_contains "$context" "joinmastodon.org" \
  "@context should include Mastodon namespace (toot:)"

echo "JSON-LD @context OK: AS2 + security + data-integrity + multikey + Mastodon namespaces present"
