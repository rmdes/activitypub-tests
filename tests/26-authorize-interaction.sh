#!/usr/bin/env bash
# 26-authorize-interaction.sh — Verify the authorize_interaction endpoint
# This is the target of the WebFinger subscribe template for remote follow.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Missing uri parameter should return 400
status_no_uri=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}${MOUNT_PATH}/authorize_interaction")
assert_eq "$status_no_uri" "400" \
  "authorize_interaction without uri should return 400"

# With uri parameter, unauthenticated user should get a redirect (302/303)
status_with_uri=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}${MOUNT_PATH}/authorize_interaction?uri=https://mastodon.social/@Gargron")
assert_match "$status_with_uri" "^(301|302|303)$" \
  "authorize_interaction with uri should redirect (got ${status_with_uri})"

# The redirect should point to the login page
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" \
  "${BASE_URL}${MOUNT_PATH}/authorize_interaction?uri=https://mastodon.social/@Gargron")
assert_contains "$redirect_url" "/session/login" \
  "Unauthenticated redirect should go to login page"

# acct: URI format should also work
status_acct=$(curl -s -o /dev/null -w "%{http_code}" \
  "${BASE_URL}${MOUNT_PATH}/authorize_interaction?uri=acct:user@example.com")
assert_match "$status_acct" "^(301|302|303)$" \
  "authorize_interaction with acct: URI should redirect (got ${status_acct})"

echo "Authorize interaction OK: 400 without uri, 302 redirect to login with uri"
