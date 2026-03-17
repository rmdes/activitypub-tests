#!/usr/bin/env bash
# 54-c2s-delete-removes-post.sh — Create then delete a note, verify it's gone from AP
# Tests the Micropub delete → AP Delete broadcast pipeline.
set -euo pipefail
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common-micropub.sh"

TEST_SLUG="ap-c2s-del-$(date +%s)"
TEST_CONTENT="C2S delete test ${TEST_SLUG} — will be deleted"

# Create note via Micropub
post_url=$(micropub_create "$TEST_CONTENT" "$TEST_SLUG")
if [[ -z "$post_url" || "$post_url" == MICROPUB_CREATE_FAILED* ]]; then
  echo "ASSERT FAILED: Micropub create failed: ${post_url}"
  exit 1
fi

# Wait for syndication
wait_for_syndication 6

# Verify it exists first (AS2 dereference should work, cache-busted)
pre_status=$(ap_status "$post_url")
assert_eq "$pre_status" "200" \
  "Post should exist before delete (got ${pre_status})"

# Delete via Micropub
micropub_delete "$post_url"

# Wait for delete to propagate
wait_for_syndication 3

# Verify the post is gone — should return 404 or 410 (Gone)
# Must cache-bust to bypass nginx proxy_cache (10 min TTL)
post_status=$(ap_status "$post_url")
assert_match "$post_status" "^(302|404|410)$" \
  "Deleted post should return 404/410/302 (got ${post_status})"

echo "C2S Delete OK: created=${post_url}, post-delete status=${post_status}"
