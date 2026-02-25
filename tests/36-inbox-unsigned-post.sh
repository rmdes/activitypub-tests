#!/usr/bin/env bash
# 36-inbox-unsigned-post.sh — Verify unsigned POST to inbox is rejected
# Accepting unsigned activities would be a security vulnerability.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# POST unsigned activity to per-user inbox
status=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "Content-Type: application/activity+json" \
  -d '{"@context":"https://www.w3.org/ns/activitystreams","type":"Follow","actor":"https://example.com/actor","object":"'"${ACTOR_URL}"'"}' \
  "${BASE_URL}${MOUNT_PATH}/users/${HANDLE}/inbox")
# Should reject — not 200 or 202
assert_match "$status" "^(400|401|403|404|405|500)$" \
  "Unsigned POST to user inbox should be rejected (got ${status})"
assert_not_contains "$status" "202" \
  "Unsigned POST should NOT be accepted (202)"

# POST unsigned activity to shared inbox
shared_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  -H "Content-Type: application/activity+json" \
  -d '{"@context":"https://www.w3.org/ns/activitystreams","type":"Follow","actor":"https://example.com/actor","object":"'"${ACTOR_URL}"'"}' \
  "${BASE_URL}${MOUNT_PATH}/inbox")
assert_match "$shared_status" "^(400|401|403|404|405|500)$" \
  "Unsigned POST to shared inbox should be rejected (got ${shared_status})"

echo "Inbox security OK: unsigned POST rejected (user: ${status}, shared: ${shared_status})"
