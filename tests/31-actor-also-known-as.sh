#!/usr/bin/env bash
# 31-actor-also-known-as.sh — Verify alsoKnownAs field for account migration
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

aka=$(jq -r '.alsoKnownAs // empty' <<< "$json")
if [[ -z "$aka" || "$aka" == "null" ]]; then
  echo "SKIP: alsoKnownAs not configured (optional, used for Mastodon migration)"
  exit 0
fi

# If present, it should be an array
is_array=$(jq -e '.alsoKnownAs | type == "array"' <<< "$json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$is_array" "true" \
  "alsoKnownAs should be an array"

# Each entry should be a valid URL
count=$(jq '.alsoKnownAs | length' <<< "$json")
for i in $(seq 0 $((count - 1))); do
  entry=$(jq -r ".alsoKnownAs[$i]" <<< "$json")
  assert_match "$entry" "^https?://" \
    "alsoKnownAs[$i] should be a URL (got: $entry)"
done

echo "Actor alsoKnownAs OK: ${count} alias(es)"
