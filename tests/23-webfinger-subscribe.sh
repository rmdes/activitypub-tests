#!/usr/bin/env bash
# 23-webfinger-subscribe.sh — Verify WebFinger includes OStatus subscribe template
# This link enables remote follow buttons on WordPress AP, Misskey, etc.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s "${BASE_URL}/.well-known/webfinger?resource=acct:${HANDLE}@${DOMAIN}")

# The subscribe link must exist
subscribe_rel=$(jq -r '.links[] | select(.rel == "http://ostatus.org/schema/1.0/subscribe") | .rel' <<< "$json")
assert_eq "$subscribe_rel" "http://ostatus.org/schema/1.0/subscribe" \
  "WebFinger should include OStatus subscribe link"

# The template must contain the authorize_interaction endpoint with {uri} placeholder
template=$(jq -r '.links[] | select(.rel == "http://ostatus.org/schema/1.0/subscribe") | .template' <<< "$json")
assert_contains "$template" "authorize_interaction?uri={uri}" \
  "Subscribe template should point to authorize_interaction with {uri} placeholder"

assert_contains "$template" "${DOMAIN}" \
  "Subscribe template should include the domain"

echo "WebFinger subscribe OK: template=${template}"
