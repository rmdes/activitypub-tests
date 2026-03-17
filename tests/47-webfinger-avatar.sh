#!/usr/bin/env bash
# 47-webfinger-avatar.sh — Verify WebFinger includes avatar link rel
# browser.pub looks for the avatar rel in WebFinger response.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s "${BASE_URL}/.well-known/webfinger?resource=acct:${HANDLE}@${DOMAIN}")

# Check for avatar link
has_avatar=$(jq -e '.links[] | select(.rel == "http://webfinger.net/rel/avatar")' <<< "$json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$has_avatar" "true" \
  "WebFinger should include avatar link (rel=http://webfinger.net/rel/avatar)"

# Avatar href should be a URL
avatar_href=$(jq -r '.links[] | select(.rel == "http://webfinger.net/rel/avatar") | .href' <<< "$json")
assert_match "$avatar_href" "^https://" \
  "Avatar href should be an HTTPS URL"

# Avatar should have a type (media type)
avatar_type=$(jq -r '.links[] | select(.rel == "http://webfinger.net/rel/avatar") | .type // empty' <<< "$json")
if [[ -n "$avatar_type" ]]; then
  assert_match "$avatar_type" "^image/" \
    "Avatar type should be an image/* media type"
fi

echo "WebFinger avatar OK: href=${avatar_href}, type=${avatar_type:-not specified}"
