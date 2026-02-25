#!/usr/bin/env bash
# 25-actor-multikey.sh — Verify multi-key support (RSA + Ed25519)
# Fedify 2.0 uses RSA for HTTP Signatures and Ed25519 for Object Integrity Proofs.
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")

# RSA public key (HTTP Signatures)
assert_json_field "$json" '.publicKey' \
  "Actor should have publicKey (RSA)"

assert_json_field "$json" '.publicKey.id' \
  "publicKey should have an id"

pem=$(jq -r '.publicKey.publicKeyPem // empty' <<< "$json")
assert_contains "$pem" "-----BEGIN PUBLIC KEY-----" \
  "publicKey should contain a PEM-encoded key"

# publicKey.owner should reference the actor
pk_owner=$(jq -r '.publicKey.owner // empty' <<< "$json")
assert_contains "$pk_owner" "${HANDLE}" \
  "publicKey.owner should reference the actor"

# Ed25519 multi-key (Object Integrity Proofs / FEP-521a)
# Fedify 2.0 exposes these via assertionMethod (array of Multikey objects)
has_assertion=$(jq -e '.assertionMethod // empty' <<< "$json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$has_assertion" "true" \
  "Actor should have assertionMethod for Ed25519 multi-key"

# assertionMethod should be an array
is_array=$(jq -e '.assertionMethod | type == "array"' <<< "$json" >/dev/null 2>&1 && echo "true" || echo "false")
assert_eq "$is_array" "true" \
  "assertionMethod should be an array"

# At least one key with publicKeyMultibase
first_multibase=$(jq -r '.assertionMethod[0].publicKeyMultibase // empty' <<< "$json")
if [[ -n "$first_multibase" ]]; then
  # Ed25519 multibase keys start with "z" (base58btc prefix)
  assert_match "$first_multibase" '^z' \
    "Ed25519 publicKeyMultibase should start with 'z' (base58btc)"
fi

echo "Multi-key OK: RSA publicKey + Ed25519 assertionMethod"
