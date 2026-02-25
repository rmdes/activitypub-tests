#!/usr/bin/env bash
# 33-actor-image.sh — Verify actor icon and optional header image
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# Icon (avatar) — should be present with url and mediaType
assert_json_field "$json" '.icon' \
  "Actor should have an icon (avatar)"

icon_url=$(jq -r '.icon.url // .icon[0].url // empty' <<< "$json")
assert_match "$icon_url" "^https?://" \
  "Actor icon should have a valid URL (got: ${icon_url})"

icon_type=$(jq -r '.icon.mediaType // .icon[0].mediaType // empty' <<< "$json")
if [[ -n "$icon_type" ]]; then
  assert_match "$icon_type" "^image/" \
    "Actor icon mediaType should be an image type (got: ${icon_type})"
fi

# Header image (optional)
image_url=$(jq -r '.image.url // .image[0].url // empty' <<< "$json")
if [[ -n "$image_url" ]]; then
  assert_match "$image_url" "^https?://" \
    "Actor header image should have a valid URL"
  echo "Actor image OK: icon=${icon_url}, header=${image_url}"
else
  echo "Actor image OK: icon=${icon_url} (no header image set)"
fi
