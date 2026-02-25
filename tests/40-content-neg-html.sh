#!/usr/bin/env bash
# 40-content-neg-html.sh — Verify HTML requests don't get AS2 JSON
# Browsers should get HTML, not raw JSON-LD.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Get a post URL from the outbox
outbox=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_url=$(jq -r '.first // empty' <<< "$outbox")
if [[ -z "$first_url" ]]; then
  echo "SKIP: No outbox first page URL"
  exit 0
fi

page=$(curl -s -H "Accept: application/activity+json" "$first_url")
post_url=$(jq -r '.orderedItems[0].object.id // .orderedItems[0].object // empty' <<< "$page")
if [[ -z "$post_url" || "$post_url" == "null" ]]; then
  echo "SKIP: No post URL found in outbox"
  exit 0
fi

# Request the post URL with Accept: text/html (browser)
headers=$(curl -s -D - -o /dev/null -H "Accept: text/html" "$post_url")

# Should NOT return application/activity+json
assert_not_contains "$headers" "application/activity+json" \
  "HTML request to post URL should not get AS2 JSON response"

echo "Content negotiation HTML OK: browser requests don't get AS2 JSON"
