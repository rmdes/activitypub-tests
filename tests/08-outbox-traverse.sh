#!/usr/bin/env bash
# 08-outbox-traverse.sh — Verify outbox items can be traversed and contain activities
set -euo pipefail
source "$(dirname "$0")/common.sh"

# Traverse with suppressed errors (some remote objects may be unavailable)
# Write to temp file to avoid SIGPIPE from head in a pipefail context
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT
fedify lookup --traverse --suppress-errors "${ACTOR_URL}/outbox" > "$tmpfile" 2>&1 || true
output=$(head -600 "$tmpfile")

# Should contain at least one Create activity
assert_match "$output" "Create \{" \
  "Outbox should contain Create activities"

# Activities should reference the actor
assert_contains "$output" "actor: URL \"${ACTOR_URL}\"" \
  "Activities should reference the actor URL"

# Should contain Note or Article objects
assert_match "$output" "(Note|Article) \{" \
  "Outbox should contain Note or Article objects"

# Objects should have required fields
assert_contains "$output" "published:" \
  "Objects should have published timestamps"

assert_contains "$output" "content:" \
  "Objects should have content"

# Addressing — should be public or addressed to followers
assert_match "$output" 'to: URL "https://www.w3.org/ns/activitystreams#Public"' \
  "Public posts should address as:Public"

echo "Outbox traversal OK: Contains Create activities with Note/Article objects, proper addressing"
