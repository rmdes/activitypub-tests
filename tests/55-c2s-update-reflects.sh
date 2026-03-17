#!/usr/bin/env bash
# 55-c2s-update-reflects.sh — Create, update, verify updated content appears in AS2
# Tests that Micropub updates are reflected when dereferencing the post as AS2.
set -euo pipefail
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common-micropub.sh"

TEST_SLUG="ap-c2s-upd-$(date +%s)"
ORIGINAL_CONTENT="C2S update test ORIGINAL ${TEST_SLUG}"
UPDATED_CONTENT="C2S update test UPDATED ${TEST_SLUG}"

# Create note via Micropub
post_url=$(micropub_create "$ORIGINAL_CONTENT" "$TEST_SLUG")
if [[ -z "$post_url" || "$post_url" == MICROPUB_CREATE_FAILED* ]]; then
  echo "ASSERT FAILED: Micropub create failed: ${post_url}"
  exit 1
fi

# Wait for syndication
wait_for_syndication 6

# Verify original content via AS2
original_json=$(curl -s -H "Accept: application/activity+json" "$post_url")
original_as2_content=$(jq -r '.content // ""' <<< "$original_json")
assert_contains "$original_as2_content" "ORIGINAL" \
  "Original AS2 content should contain ORIGINAL"

# Update via Micropub
micropub_update_content "$post_url" "$UPDATED_CONTENT"

# Wait for update to propagate
wait_for_syndication 4

# Verify updated content via AS2
updated_json=$(curl -s -H "Accept: application/activity+json" "$post_url")
updated_as2_content=$(jq -r '.content // ""' <<< "$updated_json")
assert_contains "$updated_as2_content" "UPDATED" \
  "Updated AS2 content should contain UPDATED"

# Clean up
micropub_delete "$post_url" 2>/dev/null || true

echo "C2S Update OK: post=${post_url}, content updated and reflected in AS2"
