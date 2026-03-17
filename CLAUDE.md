# CLAUDE.md — ActivityPub Federation Tests

## What This Repo Is

A black-box test suite (58 bash scripts) that validates ActivityPub federation compliance against a live server. Tests use `curl`, `jq`, and the Fedify CLI — no application code, no unit tests, no build step. C2S tests (51-55) additionally require a Micropub token from [indiekit-mcp-micropub](https://github.com/rmdes/indiekit-mcp-micropub).

The target server is `@rmdes/indiekit-endpoint-activitypub` running on Indiekit, but the tests are protocol-generic.

## Project Structure

```
activitypub-tests/
  run-all.sh              # Test runner + Markdown compliance report generator
  tests/
    common.sh             # Shared variables (DOMAIN, HANDLE, ACTOR_URL, MOUNT_PATH)
                          # and assertion helpers (assert_contains, assert_eq, etc.)
    01-webfinger.sh       # Individual test scripts, numbered sequentially
    ...
    55-c2s-update-reflects.sh
    56-inbox-orderedcollection.sh
    ...
    58-object-shares-collection.sh
  reports/                # Generated compliance reports (gitignored)
```

## Running Tests

```bash
# All 58 tests against the default target (rmendes.net)
./run-all.sh

# Single test
./tests/01-webfinger.sh

# Different target
DOMAIN=example.com HANDLE=alice ./run-all.sh
```

## Test Categories (58 tests)

| Category | Count | Tests | What they validate |
|----------|-------|-------|-------------------|
| Discovery | 8 | 01, 02, 22, 23, 35, 37, 42, 47 | WebFinger resolution + subscribe template + errors + avatar, NodeInfo chain + version + content types |
| Actor | 13 | 03, 04, 19, 24, 25, 30-33, 38, 41, 45, 46 | Fedify lookup, required fields, JSON structure, attachments, multi-key, bio, alsoKnownAs, manuallyApprovesFollowers, icon/image, 404, ld+json Accept, sharedInbox endpoints, published date |
| Collections | 16 | 05-08, 13-15, 20, 34, 43, 44, 48, 49, 56-58 | Outbox/followers/following/liked/featured/featuredTags as OrderedCollection with JSON type verification, pagination, actor attribution, Hashtag structure, Create structure, inbox OrderedCollection (socialweb.coop), per-object likes/shares collections |
| Content Negotiation | 4 | 09, 10, 17, 40 | AS2 JSON for AP clients, HTML for browsers, object dereferencing, root redirect |
| Inbox | 4 | 11, 12, 36, 39 | GET rejection (405), unsigned POST rejection (401), Allow/Content-Type headers |
| Instance & Aliases | 2 | 16, 18 | Instance actor (Application type), WebFinger alias resolution |
| HTTP Protocol | 2 | 21, 29 | Content-Type headers, Vary: Accept, CORS on WebFinger |
| JSON-LD | 1 | 50 | Context namespace verification |
| Endpoints | 3 | 26, 27, 28 | Authorize interaction (remote follow), public profile (HTML), compose auth redirect |
| C2S (Micropub → AP) | 5 | 51-55 | Micropub create/update/delete → AP outbox verification, AS2 dereference, activity structure (requires MCP micropub token) |

## Critical Conventions

### String handling — NEVER use echo pipes

All assertion helpers and test scripts use here-strings (`<<< "$var"`) instead of `echo "$var" | ...`. This is because `fedify lookup` output can be 7MB+ (inline base64 avatar data), and `echo` fails silently with multi-megabyte arguments.

```bash
# CORRECT
jq -r '.type' <<< "$json"
grep -qF "Person" <<< "$output"

# WRONG — will silently fail with large strings
echo "$json" | jq -r '.type'
echo "$output" | grep -qF "Person"
```

### grep safety — always use `--` before patterns

The `assert_contains` and `assert_not_contains` helpers use `grep -qF -- "$needle"` with `--` to prevent patterns starting with `-` (like PEM keys: `-----BEGIN PUBLIC KEY-----`) from being parsed as grep options.

### SKIP vs FAIL

- **SKIP** (`echo "SKIP: reason"; exit 0`): Optional features not configured on the target (e.g., `alsoKnownAs`, empty outbox). The test runner counts these separately.
- **FAIL** (non-zero exit from `assert_*`): Required federation features that are broken.

### Auth-aware assertions

Indiekit's auth middleware catches unrecognized routes and redirects to login (302) instead of returning 404. Tests for non-existent resources accept both 302 and 404 using `assert_match` with `(404|302)`.

### Test numbering

Sequential by addition order, not by category:
- **01-22**: Original test suite
- **23-29**: Fedify 2.0 high-priority coverage (subscribe template, multi-key, attachments, authorize interaction, public profile, CORS)
- **30-38**: Medium-priority (actor fields, pagination, NodeInfo version, inbox security, error handling)
- **39-44**: Low-priority (405 headers, content negotiation, ld+json, NodeInfo content types, outbox attribution, featured tags structure)
- **45-50**: v2.15.0 coverage (actor endpoints, published date, WebFinger avatar, outbox Create structure, followers fields, JSON-LD context)
- **51-55**: C2S / Micropub → AP pipeline (create note, post dereference, outbox activity structure, delete, update) — requires MCP micropub token
- **56-58**: socialweb.coop compliance (inbox OrderedCollection, per-object likes collection, per-object shares collection)

## Adding New Tests

1. Create `tests/NN-test-name.sh` (next sequential number)
2. Start with the standard header:
   ```bash
   #!/usr/bin/env bash
   # NN-test-name.sh — One-line description
   set -euo pipefail
   source "$(dirname "$0")/common.sh"
   ```
3. Use `assert_*` helpers from `common.sh` — do not write raw `if/then/echo` assertions
4. Print a summary line on success: `echo "Description OK: details"`
5. For optional features: `echo "SKIP: reason"; exit 0`
6. Register in `run-all.sh` under the appropriate `section` block:
   ```bash
   run_test "Category" "Test description" "tests/NN-test-name.sh"
   ```
7. Add the new category to the `for cat in ...` loop in `run-all.sh` if creating a new category
8. `chmod +x` the test file
9. Run individually first, then `./run-all.sh` to verify integration

## Available Assertion Helpers

| Function | Signature | Description |
|----------|-----------|-------------|
| `assert_contains` | `(haystack, needle, msg)` | `grep -qF -- needle <<< haystack` |
| `assert_not_contains` | `(haystack, needle, msg)` | Inverse of above |
| `assert_match` | `(haystack, pattern, msg)` | `grep -qE pattern <<< haystack` |
| `assert_eq` | `(actual, expected, msg)` | `[[ actual == expected ]]` |
| `assert_http_status` | `(url, status, method, headers...)` | curl + assert_eq on HTTP status code |
| `assert_json_field` | `(json, jq_path, msg)` | jq path returns non-null, non-empty |
| `assert_json_eq` | `(json, jq_path, expected, msg)` | jq path returns expected value |

## Shared Variables (common.sh)

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `rmendes.net` | Target server domain |
| `HANDLE` | `rick` | Actor handle |
| `BASE_URL` | `https://${DOMAIN}` | Base URL |
| `ACTOR_URL` | `${BASE_URL}/activitypub/users/${HANDLE}` | Actor endpoint |
| `MOUNT_PATH` | `/activitypub` | Plugin mount path |

## Compliance Report

`run-all.sh` generates a Markdown report in `reports/` (gitignored) with category summary, detailed results, a Fedify Feature Compliance Matrix, and an overall grade (A+ through D). The report categories must match the `for cat in ...` loop — update both when adding categories.

## C2S Test Dependencies

Tests 51-55 exercise the full Micropub → MongoDB → AP syndicator → outbox pipeline. They require:

1. **MCP Micropub token** — An IndieAuth token stored at `~/.config/micropub-mcp/${DOMAIN}.json` by the [indiekit-mcp-micropub](https://github.com/rmdes/indiekit-mcp-micropub) MCP server
2. **`syndicate_to` in Micropub requests** — Posts MUST include `mp-syndicate-to: ["https://${DOMAIN}/"]` to reach ActivityPub. Without it, posts exist only in MongoDB and never appear in the AP outbox, even when the syndicator has `checked: true`
3. **`common-micropub.sh`** — Shared helper sourced by C2S tests. Provides `micropub_create`, `micropub_delete`, `micropub_update_content`, `wait_for_syndication`, and `outbox_find_by_slug`

If no token file exists, C2S tests SKIP gracefully (exit 0).

## Related Repositories

- **Target implementation**: `/home/rick/code/indiekit-dev/indiekit-endpoint-activitypub/` — the Fedify 2.0 ActivityPub plugin
- **MCP Micropub**: `/home/rick/code/indiekit-dev/indiekit-mcp-micropub/` ([GitHub](https://github.com/rmdes/indiekit-mcp-micropub)) — MCP server providing Micropub auth + CRUD, required for C2S tests (51-55)
- **Deployment**: `/home/rick/code/indiekit-dev/indiekit-cloudron/` — Cloudron packaging that deploys the plugin
- **Parent workspace**: `/home/rick/code/indiekit-dev/CLAUDE.md` — full repository map
