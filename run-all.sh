#!/usr/bin/env bash
# run-all.sh — Run all ActivityPub federation tests and generate compliance report
#
# Usage:
#   ./run-all.sh                  # Run all tests, generate report
#   ./run-all.sh --verbose        # Show full output even on pass
#   ./run-all.sh --report-only    # Only print the report path (skip terminal output)
#   ./run-all.sh --skip-c2s       # Skip C2S tests (avoids creating posts that syndicate)
#   DOMAIN=other.site ./run-all.sh  # Test a different domain

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOMAIN="${DOMAIN:-rmendes.net}"
HANDLE="${HANDLE:-rick}"

# Parse flags
VERBOSE=""
SKIP_C2S=false
for arg in "$@"; do
  case "$arg" in
    --verbose) VERBOSE="--verbose" ;;
    --report-only) VERBOSE="--report-only" ;;
    --skip-c2s) SKIP_C2S=true ;;
  esac
done

# ---- Result tracking ----
PASS=0
FAIL=0
SKIP=0
ERRORS=()
RESULTS=()    # Array of "CATEGORY|NAME|STATUS|DETAIL"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
REPORT_FILE="${SCRIPT_DIR}/reports/compliance-$(date -u +%Y%m%d-%H%M%S).md"

mkdir -p "${SCRIPT_DIR}/reports"

# ---- Test runner ----
run_test() {
  local category="$1"
  local name="$2"
  local script="$3"

  if [[ "$VERBOSE" != "--report-only" ]]; then
    printf "  %-50s " "$name"
  fi

  local output rc
  output=$("$SCRIPT_DIR/$script" 2>&1) && rc=0 || rc=$?

  if echo "$output" | grep -q "^SKIP:"; then
    # SKIP: output contains "SKIP:" (exit 0 per convention)
    SKIP=$((SKIP + 1))
    local skip_reason
    skip_reason=$(echo "$output" | grep "^SKIP:" | head -1)
    RESULTS+=("${category}|${name}|SKIP|${skip_reason}")
    if [[ "$VERBOSE" != "--report-only" ]]; then
      echo "- SKIP"
      echo "    $skip_reason"
    fi
  elif [[ $rc -eq 0 ]]; then
    PASS=$((PASS + 1))
    # Extract the detail line (last echo from the script)
    local detail
    detail=$(echo "$output" | tail -1)
    RESULTS+=("${category}|${name}|PASS|${detail}")
    if [[ "$VERBOSE" != "--report-only" ]]; then
      echo "✓ PASS"
      if [[ "$VERBOSE" == "--verbose" ]]; then
        echo "$output" | sed 's/^/    /'
        echo ""
      fi
    fi
  else
    FAIL=$((FAIL + 1))
    ERRORS+=("$name")
    local fail_detail
    fail_detail=$(echo "$output" | grep "ASSERT FAILED:" | head -1)
    RESULTS+=("${category}|${name}|FAIL|${fail_detail}")
    if [[ "$VERBOSE" != "--report-only" ]]; then
      echo "✗ FAIL"
      echo "$output" | sed 's/^/    /'
      echo ""
    fi
  fi
}

# ---- Print section header ----
section() {
  if [[ "$VERBOSE" != "--report-only" ]]; then
    echo ""
    echo "--- $1 ---"
  fi
}

# ---- Detect versions ----
FEDIFY_CLI_VERSION=$(fedify --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
NODEINFO_JSON=$(curl -s "https://${DOMAIN}/nodeinfo/2.1" 2>/dev/null)
SERVER_SOFTWARE=$(jq -r '.software.name // "unknown"' <<< "$NODEINFO_JSON" 2>/dev/null || echo "unknown")
SERVER_VERSION=$(jq -r '.software.version // "unknown"' <<< "$NODEINFO_JSON" 2>/dev/null || echo "unknown")

# ====================================================================
# RUN TESTS
# ====================================================================

if [[ "$VERBOSE" != "--report-only" ]]; then
  echo "============================================"
  echo " ActivityPub Federation Tests"
  echo " Target: ${DOMAIN} (@${HANDLE})"
  echo " Date:   ${TIMESTAMP}"
  echo " Server: ${SERVER_SOFTWARE} ${SERVER_VERSION}"
  echo " Fedify CLI: ${FEDIFY_CLI_VERSION}"
  echo "============================================"
fi

section "Discovery"
run_test "Discovery" "WebFinger resolution"                "tests/01-webfinger.sh"
run_test "Discovery" "WebFinger subscribe template"        "tests/23-webfinger-subscribe.sh"
run_test "Discovery" "WebFinger error handling"            "tests/37-webfinger-errors.sh"
run_test "Discovery" "WebFinger avatar link"              "tests/47-webfinger-avatar.sh"
run_test "Discovery" "NodeInfo endpoint"                   "tests/02-nodeinfo.sh"
run_test "Discovery" "NodeInfo well-known chain"           "tests/22-nodeinfo-wellknown.sh"
run_test "Discovery" "NodeInfo version format"             "tests/35-nodeinfo-version.sh"
run_test "Discovery" "NodeInfo content types"              "tests/42-nodeinfo-content-type.sh"

section "Actor"
run_test "Actor" "Actor lookup (fedify)"                   "tests/03-actor.sh"
run_test "Actor" "Actor required fields"                   "tests/04-actor-fields.sh"
run_test "Actor" "Actor JSON structure"                    "tests/19-actor-json.sh"
run_test "Actor" "Actor attachments (PropertyValue)"       "tests/24-actor-attachments.sh"
run_test "Actor" "Actor multi-key (RSA + Ed25519)"         "tests/25-actor-multikey.sh"
run_test "Actor" "Actor summary / bio"                     "tests/30-actor-summary.sh"
run_test "Actor" "Actor alsoKnownAs"                       "tests/31-actor-also-known-as.sh"
run_test "Actor" "Actor manuallyApprovesFollowers"         "tests/32-actor-manually-approves.sh"
run_test "Actor" "Actor icon and image"                    "tests/33-actor-image.sh"
run_test "Actor" "Actor not found (404)"                   "tests/38-actor-not-found.sh"
run_test "Actor" "Actor ld+json Accept header"             "tests/41-actor-ld-json-accept.sh"
run_test "Actor" "Actor endpoints (sharedInbox)"          "tests/45-actor-endpoints.sh"
run_test "Actor" "Actor published date"                   "tests/46-actor-published.sh"

section "Collections"
run_test "Collections" "Outbox collection"                 "tests/05-outbox.sh"
run_test "Collections" "Followers collection"              "tests/06-followers.sh"
run_test "Collections" "Following collection"              "tests/07-following.sh"
run_test "Collections" "Liked collection"                  "tests/13-liked.sh"
run_test "Collections" "Featured (pinned) collection"      "tests/14-featured.sh"
run_test "Collections" "Featured tags collection"          "tests/15-featured-tags.sh"
run_test "Collections" "Featured tags structure"            "tests/44-featured-tags-structure.sh"
run_test "Collections" "Collection URI resolution"         "tests/20-collection-uris.sh"
run_test "Collections" "Collection pagination"             "tests/34-collection-pagination.sh"
run_test "Collections" "Outbox traversal (first page)"     "tests/08-outbox-traverse.sh"
run_test "Collections" "Outbox actor attribution"          "tests/43-outbox-actor-attribution.sh"
run_test "Collections" "Outbox Create structure"           "tests/48-outbox-create-structure.sh"
run_test "Collections" "Followers collection fields"       "tests/49-followers-fields.sh"

section "Content Negotiation"
run_test "Content" "Post returns AS2 JSON"                 "tests/09-content-negotiation.sh"
run_test "Content" "HTML requests don't get AS2 JSON"      "tests/40-content-neg-html.sh"
run_test "Content" "Root URL redirects to actor"           "tests/10-root-redirect.sh"
run_test "Content" "Object dispatcher (dereference)"       "tests/17-object-dispatcher.sh"

section "Inbox"
run_test "Inbox" "GET inbox returns 405"                   "tests/11-inbox-get.sh"
run_test "Inbox" "GET shared inbox returns 405"            "tests/12-shared-inbox-get.sh"
run_test "Inbox" "Inbox 405 headers (Allow, Content-Type)" "tests/39-inbox-405-headers.sh"
run_test "Inbox" "Unsigned POST to inbox rejected"         "tests/36-inbox-unsigned-post.sh"

section "Instance Actor & Aliases"
run_test "Federation" "Instance actor (Application)"       "tests/16-instance-actor.sh"
run_test "Federation" "WebFinger alias resolution"         "tests/18-webfinger-alias.sh"

section "HTTP Protocol"
run_test "HTTP" "HTTP headers compliance"                  "tests/21-http-headers.sh"
run_test "HTTP" "Vary and CORS headers"                    "tests/29-vary-headers.sh"

section "JSON-LD"
run_test "JSON-LD" "Context namespaces"                    "tests/50-context-jsonld.sh"

section "Endpoints"
run_test "Endpoints" "Authorize interaction"               "tests/26-authorize-interaction.sh"
run_test "Endpoints" "Public profile page"                 "tests/27-public-profile.sh"
run_test "Endpoints" "Compose auth redirect"                "tests/28-quick-replies-404.sh"

section "socialweb.coop Compliance"
run_test "socialweb.coop" "Inbox OrderedCollection type"      "tests/56-inbox-orderedcollection.sh"
run_test "socialweb.coop" "Object likes collection"           "tests/57-object-likes-collection.sh"
run_test "socialweb.coop" "Object shares collection"          "tests/58-object-shares-collection.sh"
run_test "socialweb.coop" "Outbox POST returns 201"           "tests/59-outbox-post-201.sh"
run_test "socialweb.coop" "Actor serves AS2 to GET"           "tests/60-actor-serves-as2-to-get.sh"
run_test "socialweb.coop" "Actor has inbox+outbox properties" "tests/61-actor-inbox-outbox-properties.sh"

if [[ "$SKIP_C2S" == "false" ]]; then
  section "Client-to-Server (Micropub → AP)"
  run_test "C2S" "Create note appears in outbox"          "tests/51-c2s-create-note.sh"
  run_test "C2S" "Post dereferenceable as AS2"            "tests/52-c2s-post-dereference.sh"
  run_test "C2S" "Outbox Create activity structure"       "tests/53-c2s-outbox-activity-structure.sh"
  run_test "C2S" "Delete removes post from AP"            "tests/54-c2s-delete-removes-post.sh"
  run_test "C2S" "Update reflects in AS2"                 "tests/55-c2s-update-reflects.sh"
else
  SKIP=$((SKIP + 5))
  for c2s_name in "Create note appears in outbox" "Post dereferenceable as AS2" "Outbox Create activity structure" "Delete removes post from AP" "Update reflects in AS2"; do
    RESULTS+=("C2S|${c2s_name}|SKIP|SKIP: --skip-c2s flag (avoids creating real posts)")
  done
  if [[ "$VERBOSE" != "--report-only" ]]; then
    echo ""
    echo "--- Client-to-Server (Micropub → AP) [SKIPPED via --skip-c2s] ---"
    echo "  5 tests skipped"
  fi
fi

# ====================================================================
# TERMINAL SUMMARY
# ====================================================================

if [[ "$VERBOSE" != "--report-only" ]]; then
  echo ""
  echo "============================================"
  echo " Results: ${PASS} passed, ${FAIL} failed, ${SKIP} skipped"
  echo "============================================"

  if [[ ${FAIL} -gt 0 ]]; then
    echo ""
    echo "Failed tests:"
    for err in "${ERRORS[@]}"; do
      echo "  - $err"
    done
  fi
fi

# ====================================================================
# GENERATE MARKDOWN REPORT
# ====================================================================

# Determine overall grade
TOTAL=$((PASS + FAIL + SKIP))
if [[ $FAIL -eq 0 && $SKIP -eq 0 ]]; then
  GRADE="A+"
  GRADE_DESC="Full compliance — all tests pass"
elif [[ $FAIL -eq 0 ]]; then
  GRADE="A"
  GRADE_DESC="Compliant — all tests pass (some skipped)"
elif [[ $FAIL -le 2 ]]; then
  GRADE="B"
  GRADE_DESC="Minor issues — $FAIL test(s) failed"
elif [[ $FAIL -le 5 ]]; then
  GRADE="C"
  GRADE_DESC="Moderate issues — $FAIL test(s) failed"
else
  GRADE="D"
  GRADE_DESC="Significant issues — $FAIL test(s) failed"
fi

# Build the report
cat > "$REPORT_FILE" << HEADER
# ActivityPub / Fedify Compliance Report

| Field | Value |
|-------|-------|
| **Target** | \`${DOMAIN}\` (\`@${HANDLE}\`) |
| **Date** | ${TIMESTAMP} |
| **Tests** | ${TOTAL} total: ${PASS} passed, ${FAIL} failed, ${SKIP} skipped |
| **Grade** | **${GRADE}** — ${GRADE_DESC} |
| **Server** | ${SERVER_SOFTWARE} ${SERVER_VERSION} |
| **Fedify CLI** | ${FEDIFY_CLI_VERSION} |

---

## Summary

HEADER

# Category summary table
{
  echo "| Category | Pass | Fail | Skip | Status |"
  echo "|----------|------|------|------|--------|"

  for cat in "Discovery" "Actor" "Collections" "Content" "Inbox" "Federation" "HTTP" "JSON-LD" "Endpoints" "socialweb.coop" "C2S"; do
    cat_pass=0; cat_fail=0; cat_skip=0
    for r in "${RESULTS[@]}"; do
      IFS='|' read -r rcat rname rstatus rdetail <<< "$r"
      if [[ "$rcat" == "$cat" ]]; then
        case "$rstatus" in
          PASS) cat_pass=$((cat_pass + 1)) ;;
          FAIL) cat_fail=$((cat_fail + 1)) ;;
          SKIP) cat_skip=$((cat_skip + 1)) ;;
        esac
      fi
    done
    total_cat=$((cat_pass + cat_fail + cat_skip))
    if [[ $total_cat -eq 0 ]]; then continue; fi

    if [[ $cat_fail -eq 0 && $cat_skip -eq 0 ]]; then
      status_emoji="✅"
    elif [[ $cat_fail -eq 0 ]]; then
      status_emoji="⚠️"
    else
      status_emoji="❌"
    fi
    echo "| ${cat} | ${cat_pass} | ${cat_fail} | ${cat_skip} | ${status_emoji} |"
  done
} >> "$REPORT_FILE"

# Detailed results
cat >> "$REPORT_FILE" << 'DIVIDER'

---

## Detailed Results

DIVIDER

current_cat=""
for r in "${RESULTS[@]}"; do
  IFS='|' read -r rcat rname rstatus rdetail <<< "$r"

  if [[ "$rcat" != "$current_cat" ]]; then
    current_cat="$rcat"
    echo "" >> "$REPORT_FILE"
    echo "### ${current_cat}" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "| Test | Status | Detail |" >> "$REPORT_FILE"
    echo "|------|--------|--------|" >> "$REPORT_FILE"
  fi

  case "$rstatus" in
    PASS) icon="✅" ;;
    FAIL) icon="❌" ;;
    SKIP) icon="⏭️" ;;
    *) icon="?" ;;
  esac

  # Escape pipe characters in detail
  safe_detail=$(echo "$rdetail" | sed 's/|/\\|/g' | head -c 200)
  echo "| ${rname} | ${icon} ${rstatus} | ${safe_detail} |" >> "$REPORT_FILE"
done

# Fedify Feature Compliance Matrix
cat >> "$REPORT_FILE" << 'MATRIX'

---

## Fedify Feature Compliance Matrix

Maps implemented Fedify features against the Fedify SDK capabilities.

### Core Federation

| Feature | Fedify API | Status | Notes |
|---------|-----------|--------|-------|
| Actor Dispatcher | `setActorDispatcher()` | ✅ Implemented | Person/Service/Group/Organization via config |
| Key Pairs | `setKeyPairsDispatcher()` | ✅ Implemented | RSA-2048 + Ed25519 dual keys |
| Handle Mapping | `.mapHandle()` | ✅ Implemented | Handle + hostname (instance actor) |
| Alias Mapping | `.mapAlias()` | ✅ Implemented | Profile URL + /@handle resolution |
| Inbox Listeners | `setInboxListeners()` | ✅ Implemented | Follow, Undo, Accept, Reject, Like, Announce, Create, Update, Delete |
| Shared Inbox | Inbox URL pattern | ✅ Implemented | `/activitypub/inbox` |
| WebFinger | Automatic | ✅ Implemented | Via Fedify's built-in handler |
| NodeInfo | `setNodeInfoDispatcher()` | ✅ Implemented | Schema 2.1, dynamic version |

### Collections

| Feature | Fedify API | Status | Notes |
|---------|-----------|--------|-------|
| Outbox | `setOutboxDispatcher()` | ✅ Implemented | Paginated, Create activities |
| Followers | `setFollowersDispatcher()` | ✅ Implemented | Paginated, ordered |
| Following | `setFollowingDispatcher()` | ✅ Implemented | Paginated, ordered |
| Liked | `setLikedDispatcher()` | ✅ Implemented | Objects the actor has liked |
| Featured | `setFeaturedDispatcher()` | ✅ Implemented | Pinned posts, admin UI |
| Featured Tags | `setFeaturedTagsDispatcher()` | ✅ Implemented | Hashtag discovery, admin UI |

### Content Resolution

| Feature | Fedify API | Status | Notes |
|---------|-----------|--------|-------|
| Object Dispatcher | `setObjectDispatcher()` | ✅ Implemented | Note/Article dereferencing |
| Content Negotiation | Custom middleware | ✅ Implemented | AS2 JSON for post URLs |

### Delivery & Reliability

| Feature | Fedify API | Status | Notes |
|---------|-----------|--------|-------|
| Message Queue | `RedisMessageQueue` | ✅ Implemented | Redis-backed persistent queue |
| Parallel Queue | `ParallelMessageQueue` | ✅ Implemented | Configurable worker count (default: 5) |
| Ordering Keys | `sendActivity({ orderingKey })` | ✅ Implemented | Per-follower ordering |
| Collection Sync | `sendActivity({ syncCollection })` | ✅ Implemented | FEP-8fcf, shared inbox sync |
| Permanent Failure Handler | `setOutboxPermanentFailureHandler()` | ⏳ Deferred | Requires Fedify 2.0+ API changes |
| Context Data | `createFederation({ contextData })` | ✅ Implemented | Handle + publication URL |

### Security & Identity

| Feature | Fedify API | Status | Notes |
|---------|-----------|--------|-------|
| HTTP Signatures | Automatic (RSA) | ✅ Implemented | Via key pairs dispatcher |
| Object Integrity Proofs | Automatic (Ed25519) | ✅ Implemented | Via assertionMethods multikey |
| Instance Actor | Application type actor | ✅ Implemented | Domain-level federation actor |
| Authorized Fetch | `.authorize()` predicate | ⏳ Deferred | Removed — requires authenticated document loader to avoid 401 loops with remote servers |
| Configurable Actor Type | Constructor selection | ✅ Implemented | Person/Service/Organization/Group |

### Discovery Extensions

| Feature | Fedify API | Status | Notes |
|---------|-----------|--------|-------|
| NodeInfo Dynamic Version | `createRequire()` | ✅ Implemented | Reads from @indiekit/indiekit/package.json |
| alsoKnownAs | Actor property | ✅ Implemented | For Mastodon account migration |
| Profile Attachments | PropertyValue | ✅ Implemented | Key-value metadata fields |

MATRIX

# Failed tests detail (if any)
if [[ ${FAIL} -gt 0 ]]; then
  cat >> "$REPORT_FILE" << 'FAILHDR'

---

## Failed Tests — Details

FAILHDR

  for r in "${RESULTS[@]}"; do
    IFS='|' read -r rcat rname rstatus rdetail <<< "$r"
    if [[ "$rstatus" == "FAIL" ]]; then
      echo "### ❌ ${rname}" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"
      echo "- **Category:** ${rcat}" >> "$REPORT_FILE"
      echo "- **Error:** ${rdetail}" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"
    fi
  done
fi

# Footer
cat >> "$REPORT_FILE" << FOOTER

---

*Generated by activitypub-tests/run-all.sh — $(date -u +%Y-%m-%dT%H:%M:%SZ)*
FOOTER

echo ""
echo "📄 Report: ${REPORT_FILE}"

# Exit with failure if any tests failed
if [[ ${FAIL} -gt 0 ]]; then
  exit 1
fi
