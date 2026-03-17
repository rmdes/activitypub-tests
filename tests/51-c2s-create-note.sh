#!/usr/bin/env bash
# 51-c2s-create-note.sh — Create a note via Micropub and verify it appears in the AP outbox
# Tests the full C2S→S2S pipeline: Micropub create → AP syndicator → outbox
set -euo pipefail
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common-micropub.sh"

TEST_SLUG="ap-c2s-test-$(date +%s)"
TEST_CONTENT="C2S test note ${TEST_SLUG} — this is an automated test post"

# Create note via Micropub
post_url=$(micropub_create "$TEST_CONTENT" "$TEST_SLUG")
if [[ -z "$post_url" || "$post_url" == MICROPUB_CREATE_FAILED* ]]; then
  echo "ASSERT FAILED: Micropub create failed: ${post_url}"
  exit 1
fi

# Wait for syndication to process
wait_for_syndication 6

# Verify the post is in the outbox
outbox_json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_page=$(jq -r '.first // empty' <<< "$outbox_json")

if [[ -n "$first_page" && "$first_page" == "http"* ]]; then
  page_json=$(curl -s -H "Accept: application/activity+json" "$first_page")
else
  page_json="$outbox_json"
fi

# Check that our test post appears (search by slug in object URLs or content)
found=$(outbox_find_by_slug "$page_json" "$TEST_SLUG")

assert_match "$found" "^[1-9]" \
  "Test post should appear in outbox (slug: ${TEST_SLUG})"

# Clean up — delete the test post
micropub_delete "$post_url" 2>/dev/null || true

echo "C2S Create OK: post=${post_url}, found in outbox"
