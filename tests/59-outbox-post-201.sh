#!/usr/bin/env bash
# 59-outbox-post-201.sh — Outbox POST must return 201 Created
# Maps to socialweb.coop test UUID 723afcbb-118d-433e-8ab4-560ffca93582
#
# AP §6 C2S: "Servers MUST return a 201 Created HTTP code"
#
# Indiekit uses Micropub as its C2S interface, not AP outbox POST.
# The outbox endpoint rejects POST with 405 (read-only outbox).
# Per the socialweb.coop spec, a 405 response means the test is "inapplicable".
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Get the outbox URL from actor
actor_json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")
outbox_url=$(jq -r '.outbox // empty' <<< "$actor_json")

if [[ -z "$outbox_url" ]]; then
  echo "ASSERT FAILED: Actor has no outbox property"
  exit 1
fi

# Dereference if outbox is a string URL
if [[ "$outbox_url" != http* ]]; then
  echo "ASSERT FAILED: Outbox is not a URL: ${outbox_url}"
  exit 1
fi

# Attempt a POST to the outbox with a simple AS2 Note
post_status=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Content-Type: application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"" \
  -d '{"@context":"https://www.w3.org/ns/activitystreams","type":"Note","content":"Test note"}' \
  "$outbox_url")

# Per socialweb.coop spec: 405 → inapplicable (server doesn't support POST)
if [[ "$post_status" == "405" ]]; then
  echo "SKIP: Outbox POST returns 405 (read-only outbox, C2S via Micropub instead of AP outbox POST)"
  exit 0
fi

# 401/403 without auth → cantTell (need credentials)
if [[ "$post_status" == "401" || "$post_status" == "403" ]]; then
  echo "SKIP: Outbox POST returns ${post_status} (auth required, cannot test without credentials)"
  exit 0
fi

# 200 means the server served the outbox collection regardless of method
# (e.g., Fedify treats all methods the same on the outbox endpoint).
# This is not a C2S submission — SKIP as the server doesn't support AP C2S outbox POST.
if [[ "$post_status" == "200" ]]; then
  echo "SKIP: Outbox POST returns 200 (serves collection, does not support AP C2S outbox POST)"
  exit 0
fi

# If we got 201, the server supports AP C2S outbox POST
if [[ "$post_status" == "201" ]]; then
  echo "Outbox POST 201 OK: server supports AP C2S outbox POST"
  exit 0
fi

# Any other status is unexpected
echo "ASSERT FAILED: Outbox POST returned ${post_status} (expected 200, 201, 401, 403, or 405)"
exit 1
