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

# Skip C2S tests (avoids creating real posts that syndicate to followers)
./run-all.sh --skip-c2s

# Test a different server
DOMAIN=example.com HANDLE=alice ./run-all.sh

# Verbose output (show details even for passing tests)
./run-all.sh --verbose

# Combine flags
./run-all.sh --skip-c2s --verbose

# Run a single test
./tests/01-webfinger.sh
```

## Configuration

All configuration is via environment variables with sensible defaults:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `rmendes.net` | Target server domain |
| `HANDLE` | `rick` | Actor handle to test |

The test scripts assume the ActivityPub endpoint is mounted at `/activitypub` (standard for `@rmdes/indiekit-endpoint-activitypub`). This is set via `MOUNT_PATH` in `common.sh`.

## Test Suite (58 tests)

### Discovery (8 tests)

| # | Test | What it checks |
|---|------|----------------|
| 01 | WebFinger resolution | `acct:` URI resolves, links to actor, advertises `activity+json` |
| 02 | NodeInfo endpoint | Software name/version, local posts count, protocols, openRegistrations |
| 22 | NodeInfo well-known chain | `.well-known/nodeinfo` links to valid schema 2.1 document |
| 23 | WebFinger subscribe template | OStatus subscribe `rel` link with `{uri}` template for remote follow |
| 35 | NodeInfo version format | Software version is semver-like (digits and dots) |
| 37 | WebFinger error handling | 302/404 for unknown resource, 400 for missing `resource` parameter |
| 47 | WebFinger avatar link | WebFinger includes avatar `rel` link (browser.pub compatibility) |
| 42 | NodeInfo content types | `application/jrd+json` or `application/json` on both NodeInfo endpoints |

### Actor (13 tests)

| # | Test | What it checks |
|---|------|----------------|
| 03 | Actor lookup (Fedify) | Resolves as Person via `fedify lookup`, correct `id` |
| 04 | Actor required fields | inbox, outbox, followers, following, liked, featured, featuredTags, publicKey, assertionMethods, sharedInbox, name, icon, published |
| 19 | Actor JSON structure | Raw JSON validation of all fields, type enum, publicKey PEM, endpoints |
| 24 | Actor attachments | `attachment` is an array of `PropertyValue` objects with `name` and `value` (Mastodon compatibility) |
| 25 | Actor multi-key | RSA `publicKey` with PEM + Ed25519 `assertionMethod` with `publicKeyMultibase` (Fedify 2.0 dual-key) |
| 30 | Actor summary / bio | `summary` field is present and non-empty (SKIP if not configured) |
| 31 | Actor alsoKnownAs | `alsoKnownAs` is an array of URIs (SKIP if not configured, used for Mastodon account migration) |
| 32 | Actor manuallyApprovesFollowers | Boolean field is present (locked/unlocked account indicator) |
| 33 | Actor icon and image | `icon` (avatar) has `type`, `mediaType`, and `url`; optional `image` (header) checked if present |
| 38 | Actor not found | Non-existent actor path returns 404 or 302 (not 200) |
| 45 | Actor endpoints | `endpoints` object has `sharedInbox` without invalid `as:Endpoints` type |
| 46 | Actor published date | `published` date and `discoverable` flag present (Mastodon compatibility) |
| 41 | Actor ld+json Accept | Actor responds to `application/ld+json; profile="https://www.w3.org/ns/activitystreams"` Accept header (AP spec Section 3.2) |

### Collections (16 tests)

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
| 34 | Collection pagination | Outbox pages 1 and 2 return different `orderedItems` |
| 43 | Outbox actor attribution | Outbox items have `actor` field referencing the correct actor URL |
| 44 | Featured tags structure | Featured tags are `Hashtag` objects with `name` starting with `#` and an `href` URL |
| 48 | Outbox Create structure | Outbox items are Create activities wrapping Note/Article with required fields |
| 49 | Followers collection fields | Followers collection is OrderedCollection with proper `totalItems` and structure |
| 56 | Inbox OrderedCollection | Inbox identifies as OrderedCollection via JSON type (socialweb.coop UUID 5e94d155) |
| 57 | Object likes collection | Per-object `likes` collection type is OrderedCollection or Collection (socialweb.coop UUID 200b9bc8, AP §5.7) |
| 58 | Object shares collection | Per-object `shares` collection type is OrderedCollection or Collection (socialweb.coop UUID b03a5245, AP §5.8) |

### Content Negotiation (4 tests)

| # | Test | What it checks |
|---|------|----------------|
| 09 | Post returns AS2 JSON | Real post URL serves `@context`, type, content when requested with `Accept: application/activity+json` |
| 10 | Root URL redirect | Root URL redirects AP clients to actor endpoint |
| 17 | Object dispatcher | Posts dereferenceable at their ActivityPub URIs (Note/Article) |
| 40 | HTML requests don't get AS2 | Browser `Accept: text/html` request to a post URL does not return `application/activity+json` |

### Inbox (4 tests)

| # | Test | What it checks |
|---|------|----------------|
| 11 | GET inbox returns 405 | Per-user inbox rejects GET requests |
| 12 | GET shared inbox rejected | Shared inbox rejects GET (returns 400 or 405, not 200) |
| 36 | Unsigned POST rejected | POST to inbox without HTTP Signature returns 401 |
| 39 | Inbox 405 headers | GET 405 response includes `Allow: POST` header and correct Content-Type |

### Instance Actor & Aliases (2 tests)

| # | Test | What it checks |
|---|------|----------------|
| 16 | Instance actor | Application-type actor for the domain, WebFinger discoverable |
| 18 | WebFinger alias resolution | Profile URL and `/@handle` both resolve via WebFinger |

### HTTP Protocol (2 tests)

| # | Test | What it checks |
|---|------|----------------|
| 21 | HTTP headers | Correct content types on actor (`activity+json`/`ld+json`), outbox (200), WebFinger (`jrd+json`) |
| 29 | Vary and CORS headers | `Vary: Accept` on actor endpoint, CORS `Access-Control-Allow-Origin` on WebFinger |

### Endpoints (3 tests)

| # | Test | What it checks |
|---|------|----------------|
| 26 | Authorize interaction | `/authorize_interaction` returns 400 without `uri`, 302 redirect with `uri` (remote follow flow) |
| 27 | Public profile page | Browser request to actor URL returns HTML (not JSON), 404 for unknown actors |
| 28 | Compose auth redirect | Compose endpoint redirects unauthenticated requests (302/303) |

### JSON-LD (1 test)

| # | Test | What it checks |
|---|------|----------------|
| 50 | Context namespaces | `@context` includes AS2 and security namespaces on actor and outbox |

### Client-to-Server / C2S (5 tests)

| # | Test | What it checks |
|---|------|----------------|
| 51 | C2S create note | Micropub create → post appears in outbox |
| 52 | C2S post dereference | Created post returns valid AS2 (type, content, attributedTo) |
| 53 | C2S outbox activity structure | Create activity has correct type, actor, object, public addressing |
| 54 | C2S delete removes post | Micropub delete → post returns 404/410 via AS2 |
| 55 | C2S update reflects | Micropub update → AS2 dereference shows updated content |

C2S tests require a Micropub token. See [C2S Test Setup](#c2s-test-setup) below.

### socialweb.coop Compliance (3 tests)

| # | Test | What it checks |
|---|------|----------------|
| 56 | Inbox OrderedCollection | Inbox identifies as OrderedCollection (AP §5.2, socialweb.coop UUID 5e94d155) |
| 57 | Object likes collection | Per-object `likes` is OrderedCollection or Collection (AP §5.7, UUID 200b9bc8) |
| 58 | Object shares collection | Per-object `shares` is OrderedCollection or Collection (AP §5.8, UUID b03a5245) |

These tests map to specific [socialweb.coop activitypub-testing](https://socialweb.coop/activitypub-testing/) test cases and verify raw JSON `type` fields via `curl` + `jq` (not Fedify lookup). Tests 57-58 SKIP if the server doesn't expose per-object `likes`/`shares` properties (they are MAY per the AP spec).

## C2S Test Setup

C2S tests create, update, and delete posts via Micropub, then verify the results appear correctly in the ActivityPub layer. They reuse the IndieAuth token stored by the [indiekit-mcp-micropub](https://github.com/rmdes/indiekit-mcp-micropub) MCP server.

### Prerequisites

1. **MCP Micropub authentication** — Run `micropub_auth` via the MCP client once to obtain and store an IndieAuth token at `~/.config/micropub-mcp/${DOMAIN}.json`
2. **AP syndicator auto-checked** — The ActivityPub syndicator plugin must have `checked: true` in its Indiekit config so posts are automatically syndicated

### How C2S tests create posts

The bash helper `micropub_create` in `common-micropub.sh` sends a Micropub JSON request equivalent to this MCP tool call:

```
micropub_create(
  type: "note",
  content: "Test post content",
  slug: "test-slug",
  syndicate_to: ["https://rmendes.net/"],
  ai_text_level: "2",
  ai_tools: "Claude",
  ai_description: "Automated C2S test via Micropub"
)
```

Which translates to this Micropub JSON body:

```json
{
  "type": ["h-entry"],
  "properties": {
    "content": ["Test post content"],
    "mp-slug": ["test-slug"],
    "mp-syndicate-to": ["https://rmendes.net/"],
    "ai-text-level": ["2"],
    "ai-tools": ["Claude"],
    "ai-description": ["Automated C2S test via Micropub"]
  }
}
```

**Note:** Since the AP syndicator has `checked: true`, the `mp-syndicate-to` field is technically optional — posts are auto-syndicated regardless. The test helper includes it for explicitness. The `ai-*` fields are AI provenance metadata ([draft W3C spec](https://www.w3.org/TR/ai-web-impact/)) and are optional.

### Token file format

`~/.config/micropub-mcp/${DOMAIN}.json`:

```json
{
  "access_token": "...",
  "micropub_endpoint": "https://rmendes.net/micropub"
}
```

If no token file exists, C2S tests print `SKIP` and exit 0 (not a failure).

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
    common-micropub.sh    # Micropub helpers for C2S tests (token, create/delete/update)
    01-webfinger.sh       # S2S test scripts (01-50, self-contained)
    ...
    50-context-jsonld.sh
    51-c2s-create-note.sh # C2S test scripts (51-55, require Micropub token)
    ...
    55-c2s-update-reflects.sh
    56-inbox-orderedcollection.sh  # socialweb.coop compliance (56-58)
    ...
    58-object-shares-collection.sh
  reports/                # Generated compliance reports (gitignored)
```

### Assertion Helpers (common.sh)

| Function | Description |
|----------|-------------|
| `assert_contains` | String contains substring (safe for strings starting with `-`) |
| `assert_not_contains` | String does not contain substring |
| `assert_match` | String matches regex pattern (ERE) |
| `assert_eq` | Exact string equality |
| `assert_http_status` | HTTP endpoint returns expected status code |
| `assert_json_field` | jq path returns non-null, non-empty value |
| `assert_json_eq` | jq path returns expected value |

All helpers use here-strings (`<<< "$var"`) instead of `echo "$var" | ...` to handle multi-megabyte strings (e.g., Fedify lookup output with inline base64 avatar data).

### Micropub Helpers (common-micropub.sh)

| Function | Description |
|----------|-------------|
| `micropub_create` | Create a note with AP syndication + AI provenance, returns Location URL |
| `micropub_delete` | Delete a post by URL |
| `micropub_update_content` | Update a post's content |
| `micropub_query_source` | Query Micropub source for a post |
| `wait_for_syndication` | Sleep N seconds for AP syndicator to process |
| `outbox_find_by_slug` | Count outbox activities matching a slug (handles string + object) |
| `outbox_get_activity_by_slug` | Get first outbox activity matching a slug as JSON |

### Writing New Tests

Each test script should:

1. Start with `#!/usr/bin/env bash` and `set -euo pipefail`
2. Source `common.sh` for variables and assertion helpers
3. Use `assert_*` functions for all checks
4. Print a summary line on success (captured by `run-all.sh`)
5. Print `SKIP: <reason>` and `exit 0` for skippable conditions (e.g., optional features not configured)

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

### Conventions

- **Test numbering**: Sequential, grouped by when they were added (01-22 original, 23-29 Fedify 2.0 high priority, 30-38 medium priority, 39-44 low priority, 45-50 browser.pub/v2.15, 51-55 C2S/Micropub, 56-58 socialweb.coop compliance)
- **SKIP vs FAIL**: Use SKIP for optional features (e.g., `alsoKnownAs` not configured). Use FAIL for required federation features.
- **Auth-aware assertions**: Some endpoints redirect to login (302) instead of returning 404 when Indiekit auth middleware catches the request. Tests accept both where appropriate.
- **Large string handling**: Never use `echo "$var" | grep` — use `grep ... <<< "$var"` or `jq ... <<< "$var"` to avoid silent failures with multi-MB strings.

## License

MIT
