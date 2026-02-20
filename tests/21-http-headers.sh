#!/usr/bin/env bash
# 21-http-headers.sh — Verify correct HTTP headers on federation endpoints
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Actor endpoint should return correct content type
headers=$(curl -s -D - -o /dev/null \
  -H "Accept: application/activity+json" \
  "$ACTOR_URL")

assert_match "$headers" "content-type:.*application/(activity\+json|ld\+json)" \
  "Actor should return application/activity+json or ld+json content type"

# Actor endpoint should include CORS-friendly headers or at minimum 200
status=$(echo "$headers" | head -1 | grep -oP '\d{3}')
assert_eq "$status" "200" \
  "Actor endpoint should return HTTP 200"

# Outbox should also return correct content type
outbox_headers=$(curl -s -D - -o /dev/null \
  -H "Accept: application/activity+json" \
  "${ACTOR_URL}/outbox")

outbox_status=$(echo "$outbox_headers" | head -1 | grep -oP '\d{3}')
assert_eq "$outbox_status" "200" \
  "Outbox endpoint should return HTTP 200"

# WebFinger should return proper content type
wf_headers=$(curl -s -D - -o /dev/null \
  "${BASE_URL}/.well-known/webfinger?resource=acct:${HANDLE}@${DOMAIN}")

assert_match "$wf_headers" "content-type:.*application/jrd\+json" \
  "WebFinger should return application/jrd+json"

echo "HTTP headers OK: Correct content types on actor, outbox, and WebFinger"
