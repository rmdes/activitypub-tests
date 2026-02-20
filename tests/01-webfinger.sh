#!/usr/bin/env bash
# 01-webfinger.sh — Verify WebFinger resolves the actor handle
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify webfinger "@${HANDLE}@${DOMAIN}" 2>&1)

assert_contains "$output" "acct:${HANDLE}@${DOMAIN}" \
  "WebFinger subject should be acct:${HANDLE}@${DOMAIN}"

assert_contains "$output" "${ACTOR_URL}" \
  "WebFinger should contain actor URL"

assert_contains "$output" "application/activity+json" \
  "WebFinger should advertise activity+json content type"

assert_contains "$output" "http://webfinger.net/rel/profile-page" \
  "WebFinger should include profile-page link"

echo "WebFinger OK: acct:${HANDLE}@${DOMAIN} → ${ACTOR_URL}"
