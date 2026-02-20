# ActivityPub Federation Tests

Black-box test suite for validating ActivityPub federation compliance. Tests are run against a live server using HTTP requests and the [Fedify CLI](https://fedify.dev/).

Built for [Indiekit](https://getindiekit.com/) with the [@rmdes/indiekit-endpoint-activitypub](https://github.com/rmdes/indiekit-endpoint-activitypub) plugin, but the tests are generic enough to validate any ActivityPub server that follows the standard.

## Prerequisites

- **Bash** 4.0+
- **curl** with HTTPS support
- **jq** for JSON parsing
- **[Fedify CLI](https://fedify.dev/cli)** (`fedify lookup`, `fedify webfinger`)

Install Fedify CLI:

```bash
npm install -g @fedify/cli
# or
deno install -A jsr:@fedify/cli
```

## Quick Start

```bash
# Test the default target
./run-all.sh

# Test a different server
DOMAIN=example.com HANDLE=alice ./run-all.sh

# Verbose output (show details even for passing tests)
./run-all.sh --verbose

# Run a single test
./tests/01-webfinger.sh
```

## Configuration

All configuration is via environment variables with sensible defaults:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `rmendes.net` | Target server domain |
| `HANDLE` | `rick` | Actor handle to test |

The test scripts assume the ActivityPub endpoint is mounted at `/activitypub` (standard for `@rmdes/indiekit-endpoint-activitypub`).

## Test Suite

### Discovery (3 tests)

| # | Test | What it checks |
|---|------|----------------|
| 01 | WebFinger resolution | `acct:` URI resolves, links to actor, advertises `activity+json` |
| 02 | NodeInfo endpoint | Software name/version, local posts count, protocols, openRegistrations |
| 22 | NodeInfo well-known chain | `.well-known/nodeinfo` links to valid schema 2.1 document |

### Actor (3 tests)

| # | Test | What it checks |
|---|------|----------------|
| 03 | Actor lookup | Resolves as Person, correct `id` |
| 04 | Actor required fields | inbox, outbox, followers, following, liked, featured, featuredTags, publicKey, assertionMethods, sharedInbox, name, icon, published |
| 19 | Actor JSON structure | Raw JSON validation of all fields, type enum, publicKey PEM, endpoints |

### Collections (7 tests)

| # | Test | What it checks |
|---|------|----------------|
| 05 | Outbox collection | OrderedCollection with totalItems and first page |
| 06 | Followers collection | OrderedCollection with totalItems and first page |
| 07 | Following collection | OrderedCollection with totalItems and first page |
| 08 | Outbox traversal | Create activities, Note objects, actor references, public addressing |
| 13 | Liked collection | OrderedCollection via both Fedify and raw JSON |
| 14 | Featured (pinned) | OrderedCollection for pinned posts |
| 15 | Featured tags | OrderedCollection for hashtag discovery |
| 20 | Collection URI resolution | All collection URIs from actor return HTTP 200 with valid JSON |

### Content Negotiation (3 tests)

| # | Test | What it checks |
|---|------|----------------|
| 09 | Post returns AS2 JSON | Real post URL serves `@context`, type, content when requested with `Accept: application/activity+json` |
| 10 | Root URL redirect | Root URL redirects AP clients to actor endpoint |
| 17 | Object dispatcher | Posts dereferenceable at their ActivityPub URIs (Note/Article) |

### Inbox (2 tests)

| # | Test | What it checks |
|---|------|----------------|
| 11 | GET inbox returns 405 | Per-user inbox rejects GET requests |
| 12 | GET shared inbox rejected | Shared inbox rejects GET (returns 400 or 405, not 200) |

### Instance Actor & Aliases (2 tests)

| # | Test | What it checks |
|---|------|----------------|
| 16 | Instance actor | Application-type actor for the domain, WebFinger discoverable |
| 18 | WebFinger alias resolution | Profile URL and `/@handle` both resolve via WebFinger |

### HTTP Protocol (1 test)

| # | Test | What it checks |
|---|------|----------------|
| 21 | HTTP headers | Correct content types on actor (`activity+json`/`ld+json`), outbox (200), WebFinger (`jrd+json`) |

## Compliance Report

`run-all.sh` generates a Markdown compliance report in `reports/` with:

- Per-category pass/fail/skip summary table
- Detailed results for each test
- Fedify Feature Compliance Matrix mapping SDK features to implementation status
- Overall grade (A+ through D)

Reports are gitignored since they contain run-specific output. Generate one with:

```bash
./run-all.sh
# Report path is printed at the end
```

## Architecture

```
activitypub-tests/
  run-all.sh              # Test runner + compliance report generator
  tests/
    common.sh             # Shared variables, assertion helpers
    01-webfinger.sh       # Individual test scripts (self-contained)
    02-nodeinfo.sh
    ...
    22-nodeinfo-wellknown.sh
  reports/                # Generated compliance reports (gitignored)
```

### Assertion Helpers (common.sh)

| Function | Description |
|----------|-------------|
| `assert_contains` | String contains substring |
| `assert_not_contains` | String does not contain substring |
| `assert_match` | String matches regex pattern |
| `assert_eq` | Exact string equality |
| `assert_http_status` | HTTP endpoint returns expected status code |
| `assert_json_field` | jq path returns non-null, non-empty value |
| `assert_json_eq` | jq path returns expected value |

### Writing New Tests

Each test script should:

1. Start with `#!/usr/bin/env bash` and `set -euo pipefail`
2. Source `common.sh` for variables and assertion helpers
3. Use `assert_*` functions for all checks
4. Print a summary line on success (captured by `run-all.sh`)
5. Print `SKIP: <reason>` and `exit 0` (or `exit 1`) for skippable conditions

Example:

```bash
#!/usr/bin/env bash
# NN-test-name.sh — One-line description
set -euo pipefail
source "$(dirname "$0")/common.sh"

json=$(curl -s -H "Accept: application/activity+json" "$ACTOR_URL")
assert_json_eq "$json" '.type' 'Person' "Actor should be a Person"
echo "Test OK: Actor is a Person"
```

Register the test in `run-all.sh` under the appropriate section:

```bash
run_test "Category" "Test description" "tests/NN-test-name.sh"
```

## License

MIT
