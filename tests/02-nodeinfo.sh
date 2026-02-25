#!/usr/bin/env bash
# 02-nodeinfo.sh — Verify NodeInfo endpoint returns valid data
set -euo pipefail
source "$(dirname "$0")/common.sh"

# First check the well-known link
wk_json=$(curl -s "${BASE_URL}/.well-known/nodeinfo")
assert_json_field "$wk_json" '.links[0].href' \
  "NodeInfo well-known should have a link href"

# Fetch the actual NodeInfo document
output=$(curl -s -H "Accept: application/json" \
  "$(jq -r '.links[0].href' <<< "$wk_json")")

assert_json_eq "$output" '.software.name' 'indiekit' \
  "NodeInfo software name should be indiekit"

assert_json_eq "$output" '.version' '2.1' \
  "NodeInfo version should be 2.1"

assert_json_field "$output" '.software.version' \
  "NodeInfo should report a software version"

assert_json_field "$output" '.usage.localPosts' \
  "NodeInfo should report localPosts count"

assert_json_field "$output" '.usage.users.total' \
  "NodeInfo should report user totals"

# openRegistrations is a boolean — use tostring to avoid jq treating false as empty
open_reg=$(jq '.openRegistrations' <<< "$output")
assert_eq "$open_reg" "false" \
  "NodeInfo should report openRegistrations as false"

# Verify protocols include activitypub
protocols=$(jq -r '.protocols[]' <<< "$output")
assert_contains "$protocols" "activitypub" \
  "NodeInfo protocols should include activitypub"

version=$(jq -r '.software.version' <<< "$output")
posts=$(jq -r '.usage.localPosts' <<< "$output")
echo "NodeInfo OK: indiekit v${version}, ${posts} local posts, protocol: activitypub"
