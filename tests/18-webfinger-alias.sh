#!/usr/bin/env bash
# 18-webfinger-alias.sh — Verify that profile URL resolves via WebFinger
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Query WebFinger with the bare domain URL
output=$(curl -s "${BASE_URL}/.well-known/webfinger?resource=${BASE_URL}/")
assert_contains "$output" "acct:${HANDLE}@${DOMAIN}" \
  "Profile URL should resolve to acct: URI via WebFinger"

# Query WebFinger with /@handle URL
at_output=$(curl -s "${BASE_URL}/.well-known/webfinger?resource=${BASE_URL}/@${HANDLE}")
assert_contains "$at_output" "acct:${HANDLE}@${DOMAIN}" \
  "/@handle URL should resolve to acct: URI via WebFinger"

echo "WebFinger alias OK: profile URL and /@handle both resolve"
