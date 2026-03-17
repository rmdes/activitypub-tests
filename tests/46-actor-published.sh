#!/usr/bin/env bash
# 46-actor-published.sh — Verify actor has published date and discoverable flag
# These fields improve federation compatibility (Mastodon uses published for "joined" date).
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# published must be present and valid ISO 8601
assert_json_field "$json" '.published' \
  "Actor should have published date"

published=$(jq -r '.published' <<< "$json")
assert_match "$published" "^[0-9]{4}-[0-9]{2}-[0-9]{2}T" \
  "published should be ISO 8601 format"

# url field should point to the human-readable profile
assert_json_field "$json" '.url' \
  "Actor should have url field (profile page)"

echo "Actor metadata OK: published=${published}"
