#!/usr/bin/env bash
# common.sh — Shared variables and helpers for all tests
#
# NOTE: All assertion helpers use here-strings (<<< "$var") instead of
# echo "$var" | ... because fedify lookup output can be 7MB+ (inline
# base64 avatar data). echo fails silently with multi-MB arguments;
# here-strings handle them correctly.

DOMAIN="${DOMAIN:-rmendes.net}"
HANDLE="${HANDLE:-rick}"
BASE_URL="https://${DOMAIN}"
ACTOR_URL="${BASE_URL}/activitypub/users/${HANDLE}"
MOUNT_PATH="/activitypub"

# Test result tracking (used by run-all.sh report generator)
_TEST_DETAILS=""

# assert_contains <haystack> <needle> <message>
assert_contains() {
  if grep -qF -- "$2" <<< "$1"; then
    return 0
  else
    echo "ASSERT FAILED: $3"
    echo "  Expected to contain: $2"
    echo "  Got: $(head -5 <<< "$1")"
    return 1
  fi
}

# assert_not_contains <haystack> <needle> <message>
assert_not_contains() {
  if grep -qF -- "$2" <<< "$1"; then
    echo "ASSERT FAILED: $3"
    echo "  Expected NOT to contain: $2"
    return 1
  else
    return 0
  fi
}

# assert_match <haystack> <pattern> <message>
assert_match() {
  if grep -qE "$2" <<< "$1"; then
    return 0
  else
    echo "ASSERT FAILED: $3"
    echo "  Expected to match: $2"
    echo "  Got: $(head -5 <<< "$1")"
    return 1
  fi
}

# assert_eq <actual> <expected> <message>
assert_eq() {
  if [[ "$1" == "$2" ]]; then
    return 0
  else
    echo "ASSERT FAILED: $3"
    echo "  Expected: $2"
    echo "  Got:      $1"
    return 1
  fi
}

# assert_http_status <url> <expected_status> <method> <extra_headers...>
assert_http_status() {
  local url="$1"
  local expected="$2"
  local method="${3:-GET}"
  shift 3 || true
  local headers=("$@")

  local curl_args=(-s -o /dev/null -w "%{http_code}" -X "$method")
  for h in "${headers[@]}"; do
    curl_args+=(-H "$h")
  done
  curl_args+=("$url")

  local status
  status=$(curl "${curl_args[@]}")
  assert_eq "$status" "$expected" "HTTP $method $url should return $expected (got $status)"
}

# assert_json_field <json> <jq_path> <message>
# Asserts the jq path returns a non-null, non-empty value
assert_json_field() {
  local json="$1"
  local path="$2"
  local msg="$3"
  local val
  val=$(jq -r "$path // empty" <<< "$json" 2>/dev/null)
  if [[ -z "$val" ]]; then
    echo "ASSERT FAILED: $msg"
    echo "  jq path '$path' returned empty/null"
    echo "  JSON (first 200 chars): $(head -c 200 <<< "$json")"
    return 1
  fi
  return 0
}

# assert_json_eq <json> <jq_path> <expected> <message>
assert_json_eq() {
  local json="$1"
  local path="$2"
  local expected="$3"
  local msg="$4"
  local val
  val=$(jq -r "$path // empty" <<< "$json" 2>/dev/null)
  assert_eq "$val" "$expected" "$msg"
}
