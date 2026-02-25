#!/usr/bin/env bash
# 43-outbox-actor-attribution.sh — Verify outbox items reference the correct actor
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Fetch outbox first page as raw JSON
outbox=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_url=$(jq -r '.first // empty' <<< "$outbox")
if [[ -z "$first_url" ]]; then
  echo "SKIP: No outbox first page"
  exit 0
fi

page=$(curl -s -H "Accept: application/activity+json" "$first_url")
items_count=$(jq '.orderedItems | length' <<< "$page")
if [[ "$items_count" -eq 0 ]]; then
  echo "SKIP: Outbox is empty"
  exit 0
fi

# Check actor attribution on first item
actor_ref=$(jq -r '.orderedItems[0].actor // empty' <<< "$page")
assert_contains "$actor_ref" "${MOUNT_PATH}/users/${HANDLE}" \
  "Outbox item actor should reference our actor URL (got: ${actor_ref})"

echo "Outbox actor attribution OK: items reference ${MOUNT_PATH}/users/${HANDLE}"
