#!/usr/bin/env bash
# common.sh — Shared variables and helpers for all tests

DOMAIN="${DOMAIN:-rmendes.net}"
HANDLE="${HANDLE:-rick}"
BASE_URL="https://${DOMAIN}"
ACTOR_URL="${BASE_URL}/activitypub/users/${HANDLE}"
MOUNT_PATH="/activitypub"

# assert_contains <haystack> <needle> <message>
assert_contains() {
  if echo "$1" | grep -qF "$2"; then
    return 0
  else
    echo "ASSERT FAILED: $3"
    echo "  Expected to contain: $2"
    echo "  Got: $(echo "$1" | head -5)"
    return 1
  fi
}

# assert_match <haystack> <pattern> <message>
assert_match() {
  if echo "$1" | grep -qE "$2"; then
    return 0
  else
    echo "ASSERT FAILED: $3"
    echo "  Expected to match: $2"
    echo "  Got: $(echo "$1" | head -5)"
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
