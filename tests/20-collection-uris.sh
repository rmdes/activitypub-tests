#!/usr/bin/env bash
# 20-collection-uris.sh — Verify all collection URIs from actor are resolvable
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# Test each collection URI returns 200 with valid JSON
check_collection() {
  local name="$1"
  local url
  url=$(echo "$json" | jq -r ".$name // empty")

  if [[ -z "$url" ]]; then
    echo "SKIP: Actor has no $name URI"
    return 0
  fi

  local status
  status=$(curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/activity+json" "$url")
  if [[ "$status" != "200" ]]; then
    echo "ASSERT FAILED: $name collection at $url should return 200 (got $status)"
    return 1
  fi

  local col_json
  col_json=$(curl -s -H "Accept: application/activity+json" "$url")
  local col_type
  col_type=$(echo "$col_json" | jq -r '.type // empty')
  if [[ -z "$col_type" ]]; then
    echo "ASSERT FAILED: $name collection should return valid JSON with type"
    return 1
  fi

  echo "  $name → $col_type (HTTP 200)"
}

echo "Checking collection URIs..."
check_collection "outbox"
check_collection "followers"
check_collection "following"
check_collection "liked"
check_collection "featured"
check_collection "featuredTags"

echo "Collection URIs OK: All actor collection endpoints return valid JSON"
