#!/usr/bin/env bash
# 16-instance-actor.sh — Verify the instance actor resolves
set -euo pipefail
source "$(dirname "$0")/common.sh"

# WebFinger lookup for the instance actor (hostname@hostname)
wf_output=$(curl -s "${BASE_URL}/.well-known/webfinger?resource=acct:${DOMAIN}@${DOMAIN}")

assert_contains "$wf_output" "acct:${DOMAIN}@${DOMAIN}" \
  "WebFinger should resolve instance actor"

# Actor endpoint
actor_output=$(fedify lookup "${BASE_URL}${MOUNT_PATH}/users/${DOMAIN}" 2>&1)

assert_contains "$actor_output" "Application {" \
  "Instance actor should be an Application"

assert_contains "$actor_output" "preferredUsername: \"${DOMAIN}\"" \
  "Instance actor preferredUsername should be the hostname"

echo "Instance actor OK: Application type with hostname identifier"
