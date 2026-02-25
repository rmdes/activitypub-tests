#!/usr/bin/env bash
# 29-vary-headers.sh — Verify Vary headers on federation endpoints
# Without Vary: Accept, CDNs/proxies may cache JSON-LD and serve it to browsers.
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Actor endpoint should include Vary header
actor_headers=$(curl -s -D - -o /dev/null \
  -H "Accept: application/activity+json" "${ACTOR_URL}")
assert_match "$actor_headers" "[Vv]ary:" \
  "Actor endpoint should include Vary header"

# WebFinger should include CORS header (Access-Control-Allow-Origin)
wf_headers=$(curl -s -D - -o /dev/null \
  "${BASE_URL}/.well-known/webfinger?resource=acct:${HANDLE}@${DOMAIN}")
assert_match "$wf_headers" "[Aa]ccess-[Cc]ontrol-[Aa]llow-[Oo]rigin" \
  "WebFinger should include Access-Control-Allow-Origin"

echo "Vary/CORS headers OK: Vary on actor, CORS on WebFinger"
