#!/usr/bin/env bash
# 09-content-negotiation.sh — Verify post URLs serve AS2 JSON for AP clients
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Fetch the outbox to find a real post URL
# Write to temp file to avoid SIGPIPE from pipefail
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT
fedify lookup --traverse --suppress-errors "${ACTOR_URL}/outbox" > "$tmpfile" 2>&1 || true
outbox=$(head -40 "$tmpfile")

# Extract the first Note URL from outbox (format: url: URL "https://...")
post_url=$(echo "$outbox" | grep -o 'url: URL "[^"]*"' | head -1 | sed 's/url: URL "//;s/"$//')

if [[ -z "$post_url" ]]; then
  echo "SKIP: Could not find a post URL in outbox"
  exit 1
fi

# Request the post URL with Accept: application/activity+json
response=$(curl -s -H "Accept: application/activity+json" "$post_url")

assert_contains "$response" '"@context"' \
  "AS2 response should include @context"

assert_contains "$response" "activitystreams" \
  "AS2 response should reference activitystreams namespace"

assert_contains "$response" '"type"' \
  "AS2 response should include a type field"

assert_contains "$response" '"content"' \
  "AS2 response should include content"

echo "Content negotiation OK: ${post_url} serves AS2 JSON"
