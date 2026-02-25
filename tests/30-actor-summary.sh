#!/usr/bin/env bash
# 30-actor-summary.sh — Verify actor has a summary/bio field
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

summary=$(jq -r '.summary // empty' <<< "$json")
if [[ -n "$summary" ]]; then
  # Summary should be HTML (Mastodon expects HTML-formatted bio)
  echo "Actor summary OK: present ($(echo "$summary" | head -c 80)...)"
else
  echo "SKIP: No summary/bio set on actor profile (optional field)"
  exit 0
fi
