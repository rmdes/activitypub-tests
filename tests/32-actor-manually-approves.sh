#!/usr/bin/env bash
# 32-actor-manually-approves.sh — Verify manuallyApprovesFollowers is set
# Without this, some servers default to pending follow requests.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

maf=$(jq '.manuallyApprovesFollowers' <<< "$json")
assert_match "$maf" "^(true|false)$" \
  "manuallyApprovesFollowers should be a boolean (got: ${maf})"

echo "Actor manuallyApprovesFollowers OK: ${maf}"
