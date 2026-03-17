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

# Verify the post is in the outbox (search multiple pages — pagination may not be chronological)
page_json=$(outbox_search_pages "$TEST_SLUG" 3)

if [[ -z "$page_json" ]]; then
  micropub_delete "$post_url" 2>/dev/null || true
  echo "ASSERT FAILED: Test post should appear in outbox (slug: ${TEST_SLUG})"
  exit 1
fi

# Clean up — delete the test post
micropub_delete "$post_url" 2>/dev/null || true

echo "C2S Create OK: post=${post_url}, found in outbox"
