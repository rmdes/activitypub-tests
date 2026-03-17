#!/usr/bin/env bash
# 53-c2s-outbox-activity-structure.sh — Create a note and verify the outbox Create activity structure
# Validates actor, object, to/cc addressing, and activity type.
set -euo pipefail
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/common-micropub.sh"

TEST_SLUG="ap-c2s-struct-$(date +%s)"
TEST_CONTENT="C2S activity structure test ${TEST_SLUG}"

# Create note via Micropub
post_url=$(micropub_create "$TEST_CONTENT" "$TEST_SLUG")
if [[ -z "$post_url" || "$post_url" == MICROPUB_CREATE_FAILED* ]]; then
  echo "ASSERT FAILED: Micropub create failed: ${post_url}"
  exit 1
fi

# Wait for syndication
wait_for_syndication 6

# Get outbox first page
outbox_json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox")
first_page=$(jq -r '.first // empty' <<< "$outbox_json")

if [[ -n "$first_page" && "$first_page" == "http"* ]]; then
  page_json=$(curl -s -H "Accept: application/activity+json" "$first_page")
else
  page_json="$outbox_json"
fi

# Find our test activity
activity=$(outbox_get_activity_by_slug "$page_json" "$TEST_SLUG")

if [[ -z "$activity" || "$activity" == "null" ]]; then
  micropub_delete "$post_url" 2>/dev/null || true
  echo "ASSERT FAILED: Test activity not found in outbox (slug: ${TEST_SLUG})"
  exit 1
fi

# Activity should be type Create
activity_type=$(jq -r '.type // empty' <<< "$activity")
assert_eq "$activity_type" "Create" \
  "Outbox activity should be Create (got: ${activity_type})"

# Activity should have actor matching our actor URL
activity_actor=$(jq -r '.actor // empty' <<< "$activity")
assert_contains "$activity_actor" "${HANDLE}" \
  "Create activity actor should reference our handle"

# Activity should have an object
assert_json_field "$activity" '.object' \
  "Create activity should have object"

# Object should have type
obj_type=$(jq -r '.object.type // empty' <<< "$activity")
assert_match "$obj_type" "^(Note|Article)$" \
  "Object should be Note or Article (got: ${obj_type})"

# Activity or object should have to (public addressing)
has_to=$(jq -e '.to // .object.to' <<< "$activity" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$has_to" "true" \
  "Create activity or object should have to field"

# Check public addressing includes AS public collection
to_json=$(jq -c '.to // .object.to // []' <<< "$activity")
assert_contains "$to_json" "https://www.w3.org/ns/activitystreams#Public" \
  "Public post should address AS2 Public collection"

# Clean up
micropub_delete "$post_url" 2>/dev/null || true

echo "C2S Activity Structure OK: type=${activity_type}, object=${obj_type}, public addressing present"
