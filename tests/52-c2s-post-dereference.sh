#!/usr/bin/env bash
# 52-c2s-post-dereference.sh — Create a note and verify it's dereferenceable as AS2 JSON
# Remote servers dereference Note IDs during Create activity verification.
set -euo pipefail
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common-micropub.sh"

TEST_SLUG="ap-c2s-deref-$(date +%s)"
TEST_CONTENT="C2S dereference test ${TEST_SLUG}"

# Create note via Micropub
post_url=$(micropub_create "$TEST_CONTENT" "$TEST_SLUG")
if [[ -z "$post_url" || "$post_url" == MICROPUB_CREATE_FAILED* ]]; then
  echo "ASSERT FAILED: Micropub create failed: ${post_url}"
  exit 1
fi

# Wait for syndication
wait_for_syndication 6

# Dereference the post URL with AS2 Accept header
as2_json=$(curl -s -H "Accept: application/activity+json" "$post_url")
as2_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/activity+json" "$post_url")

# Should return 200 with AS2 content
assert_eq "$as2_status" "200" \
  "Post should return 200 for AS2 request (got ${as2_status})"

# Should have a type (Note or Article)
obj_type=$(jq -r '.type // empty' <<< "$as2_json")
assert_match "$obj_type" "^(Note|Article)$" \
  "Dereferenced object should be Note or Article (got: ${obj_type})"

# Should have content
assert_json_field "$as2_json" '.content' \
  "Dereferenced object should have content"

# Content should contain our test text
content=$(jq -r '.content // ""' <<< "$as2_json")
assert_contains "$content" "$TEST_SLUG" \
  "Content should contain our test slug"

# Should have attributedTo pointing to our actor
assert_json_field "$as2_json" '.attributedTo' \
  "Object should have attributedTo"

# Should have id
assert_json_field "$as2_json" '.id' \
  "Object should have id"

# Should have published
assert_json_field "$as2_json" '.published' \
  "Object should have published date"

# Clean up
micropub_delete "$post_url" 2>/dev/null || true

echo "C2S Dereference OK: post=${post_url}, type=${obj_type}, AS2 fields present"
