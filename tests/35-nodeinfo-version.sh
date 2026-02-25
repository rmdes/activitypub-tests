#!/usr/bin/env bash
# 35-nodeinfo-version.sh — Verify NodeInfo reports a valid semver software version
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/json" "${BASE_URL}/nodeinfo/2.1")

version=$(jq -r '.software.version // empty' <<< "$json")
assert_match "$version" '^[0-9]+\.[0-9]+\.[0-9]+' \
  "NodeInfo software version should be semver-like (got: ${version})"

software_name=$(jq -r '.software.name // empty' <<< "$json")
assert_eq "$software_name" "indiekit" \
  "NodeInfo software name should be indiekit"

echo "NodeInfo version OK: ${software_name} v${version}"
