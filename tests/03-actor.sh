#!/usr/bin/env bash
# 03-actor.sh — Verify the actor can be looked up and is a Person
set -euo pipefail
source "$(dirname "$0")/common.sh"

output=$(fedify lookup "$ACTOR_URL" 2>&1)

assert_contains "$output" "Person {" \
  "Actor should be a Person object"

assert_contains "$output" "id: URL \"${ACTOR_URL}\"" \
  "Actor id should match the lookup URL"

assert_contains "$output" "Fetched object:" \
  "Lookup should complete successfully"

echo "Actor OK: Person at ${ACTOR_URL}"
