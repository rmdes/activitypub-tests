#!/usr/bin/env bash
# 45-actor-endpoints.sh — Verify actor endpoints object is valid AS2
# browser.pub flags "type": "as:Endpoints" as invalid. The endpoints object
# should only contain sharedInbox (and optionally proxyUrl, oauthAuthorizationEndpoint, etc.)
# with no type field.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# endpoints must be present
assert_json_field "$json" '.endpoints' \
  "Actor should have endpoints field"

# endpoints.sharedInbox must be present and a valid URL
assert_json_field "$json" '.endpoints.sharedInbox' \
  "Actor endpoints should have sharedInbox"

shared_inbox=$(jq -r '.endpoints.sharedInbox' <<< "$json")
assert_match "$shared_inbox" "^https://" \
  "sharedInbox should be an HTTPS URL"

# endpoints should NOT have a type field (browser.pub validation)
endpoints_type=$(jq -r '.endpoints.type // empty' <<< "$json")
if [[ -n "$endpoints_type" ]]; then
  echo "ASSERT FAILED: endpoints should not have a type field (got: $endpoints_type)"
  echo "  This causes browser.pub validation failure"
  exit 1
fi

echo "Actor endpoints OK: sharedInbox=${shared_inbox}, no invalid type field"
