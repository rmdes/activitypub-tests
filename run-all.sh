#!/usr/bin/env bash
# run-all.sh — Run all ActivityPub federation tests against rmendes.net
#
# Usage:
#   ./run-all.sh                  # Run all tests
#   ./run-all.sh --verbose        # Show full output even on pass
#   DOMAIN=other.site ./run-all.sh  # Test a different domain

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOMAIN="${DOMAIN:-rmendes.net}"
HANDLE="${HANDLE:-rick}"
VERBOSE="${1:-}"

PASS=0
FAIL=0
ERRORS=()

run_test() {
  local name="$1"
  local script="$2"
  printf "  %-50s " "$name"

  output=$("$SCRIPT_DIR/$script" 2>&1) && rc=0 || rc=$?

  if [[ $rc -eq 0 ]]; then
    echo "✓ PASS"
    PASS=$((PASS + 1))
    if [[ "$VERBOSE" == "--verbose" ]]; then
      echo "$output" | sed 's/^/    /'
      echo ""
    fi
  else
    echo "✗ FAIL"
    FAIL=$((FAIL + 1))
    ERRORS+=("$name")
    echo "$output" | sed 's/^/    /'
    echo ""
  fi
}

echo "============================================"
echo " ActivityPub Federation Tests"
echo " Target: ${DOMAIN} (@${HANDLE})"
echo " Date:   $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "============================================"
echo ""

echo "--- Discovery ---"
run_test "WebFinger resolution"                "tests/01-webfinger.sh"
run_test "NodeInfo endpoint"                   "tests/02-nodeinfo.sh"

echo ""
echo "--- Actor ---"
run_test "Actor lookup"                        "tests/03-actor.sh"
run_test "Actor has required fields"           "tests/04-actor-fields.sh"

echo ""
echo "--- Collections ---"
run_test "Outbox collection"                   "tests/05-outbox.sh"
run_test "Followers collection"                "tests/06-followers.sh"
run_test "Following collection"                "tests/07-following.sh"
run_test "Outbox traversal (first page)"       "tests/08-outbox-traverse.sh"

echo ""
echo "--- Content Negotiation ---"
run_test "Post returns AS2 JSON"               "tests/09-content-negotiation.sh"
run_test "Root URL redirects to actor"         "tests/10-root-redirect.sh"

echo ""
echo "--- Inbox ---"
run_test "GET inbox returns 405"               "tests/11-inbox-get.sh"
run_test "GET shared inbox returns 405"        "tests/12-shared-inbox-get.sh"

echo ""
echo "============================================"
echo " Results: ${PASS} passed, ${FAIL} failed"
echo "============================================"

if [[ ${FAIL} -gt 0 ]]; then
  echo ""
  echo "Failed tests:"
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
  exit 1
fi
