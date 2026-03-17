#!/usr/bin/env bash
# common-micropub.sh — Micropub helpers for C2S tests
#
# Reuses the IndieAuth token stored by indiekit-mcp-micropub.
# Token file: ~/.config/micropub-mcp/${DOMAIN}.json
#
# All C2S tests source this AFTER common.sh.

# ---- Load token ----
MICROPUB_TOKEN_FILE="${MICROPUB_TOKEN_FILE:-${HOME}/.config/micropub-mcp/${DOMAIN}.json}"

if [[ ! -f "$MICROPUB_TOKEN_FILE" ]]; then
  echo "SKIP: No Micropub token at ${MICROPUB_TOKEN_FILE} (run micropub_auth via MCP first)"
  exit 0
fi

MICROPUB_TOKEN=$(jq -r '.access_token' "$MICROPUB_TOKEN_FILE")
MICROPUB_ENDPOINT=$(jq -r '.micropub_endpoint' "$MICROPUB_TOKEN_FILE")

if [[ -z "$MICROPUB_TOKEN" || "$MICROPUB_TOKEN" == "null" ]]; then
  echo "SKIP: Micropub token file exists but access_token is empty"
  exit 0
fi

# ---- Micropub helpers ----

# Syndication target for AP (set via env or default to publication URL)
SYNDICATE_TO="${SYNDICATE_TO:-https://${DOMAIN}/}"

# micropub_create <content> [slug]
# Creates a note with AP syndication and AI provenance, returns the Location URL.
#
# Equivalent MCP tool call:
#   micropub_create(
#     type: "note", content: "...", slug: "...",
#     syndicate_to: ["https://rmendes.net/"],
#     ai_text_level: "2", ai_tools: "Claude",
#     ai_description: "Automated C2S test via Micropub"
#   )
micropub_create() {
  local content="$1"
  local slug="${2:-}"

  local properties="{\"content\": [\"${content}\"]"
  if [[ -n "$slug" ]]; then
    properties="${properties}, \"mp-slug\": [\"${slug}\"]"
  fi
  properties="${properties}, \"mp-syndicate-to\": [\"${SYNDICATE_TO}\"]"
  properties="${properties}, \"ai-text-level\": [\"2\"]"
  properties="${properties}, \"ai-tools\": [\"Claude\"]"
  properties="${properties}, \"ai-description\": [\"Automated C2S test via Micropub\"]"
  properties="${properties}}"

  local body="{\"type\": [\"h-entry\"], \"properties\": ${properties}}"

  local response headers
  headers=$(mktemp)
  response=$(curl -s -D "$headers" -o /dev/null -w "%{http_code}" \
    -X POST \
    -H "Authorization: Bearer ${MICROPUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -d "$body" \
    "$MICROPUB_ENDPOINT")

  local location
  location=$(grep -i "^location:" "$headers" | tr -d '\r' | sed 's/^[Ll]ocation: *//')
  rm -f "$headers"

  if [[ "$response" != "201" && "$response" != "202" ]]; then
    echo "MICROPUB_CREATE_FAILED: HTTP ${response}"
    return 1
  fi

  echo "$location"
}

# micropub_delete <url>
# Deletes a post by URL
micropub_delete() {
  local url="$1"

  local response
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST \
    -H "Authorization: Bearer ${MICROPUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"action\": \"delete\", \"url\": \"${url}\"}" \
    "$MICROPUB_ENDPOINT")

  if [[ "$response" != "200" && "$response" != "204" ]]; then
    echo "MICROPUB_DELETE_FAILED: HTTP ${response}" >&2
    return 1
  fi
}

# micropub_update_content <url> <new_content>
# Updates a post's content
micropub_update_content() {
  local url="$1"
  local new_content="$2"

  local body="{\"action\": \"update\", \"url\": \"${url}\", \"replace\": {\"content\": [\"${new_content}\"]}}"

  local response
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST \
    -H "Authorization: Bearer ${MICROPUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$body" \
    "$MICROPUB_ENDPOINT")

  if [[ "$response" != "200" && "$response" != "204" ]]; then
    echo "MICROPUB_UPDATE_FAILED: HTTP ${response}" >&2
    return 1
  fi
}

# micropub_query_source <url>
# Returns the source JSON for a post
micropub_query_source() {
  local url="$1"

  curl -s \
    -H "Authorization: Bearer ${MICROPUB_TOKEN}" \
    -H "Accept: application/json" \
    "${MICROPUB_ENDPOINT}?q=source&url=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${url}', safe=''))")"
}

# wait_for_syndication [seconds]
# Wait for the AP syndicator to process the post
wait_for_syndication() {
  local seconds="${1:-5}"
  sleep "$seconds"
}

# ap_fetch <url>
# Fetch an AP resource with cache-busting to bypass nginx proxy_cache.
# The Cloudron deployment caches AP responses for 10 minutes — C2S tests
# need uncached responses to verify create/update/delete immediately.
ap_fetch() {
  local url="$1"
  local sep="?"
  [[ "$url" == *"?"* ]] && sep="&"
  curl -s -H "Accept: application/activity+json" "${url}${sep}_=$(date +%s%N)"
}

# ap_status <url>
# Like ap_fetch but returns only the HTTP status code.
ap_status() {
  local url="$1"
  local sep="?"
  [[ "$url" == *"?"* ]] && sep="&"
  curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/activity+json" "${url}${sep}_=$(date +%s%N)"
}

# outbox_search_pages <slug> [max_pages]
# Searches multiple outbox pages for an activity matching the slug.
# Returns the page JSON of the first page containing a match, or empty.
# Follows the `next` link from each page response (cursor is a document
# offset, not a page number — e.g. cursor=0, cursor=20, cursor=40).
#
# NOTE: Appends a cache-busting param (_=<epoch>) to bypass nginx's
# proxy_cache (10 min TTL). Without this, newly-created posts won't
# appear in the outbox during tests.
outbox_search_pages() {
  local slug="$1"
  local max_pages="${2:-3}"
  local cache_bust="_=$(date +%s%N)"

  local outbox_json next_url
  outbox_json=$(curl -s -H "Accept: application/activity+json" "${ACTOR_URL}/outbox?${cache_bust}")
  next_url=$(jq -r '.first // empty' <<< "$outbox_json")

  local page=0 page_json found
  while [[ $page -lt $max_pages && -n "$next_url" && "$next_url" == "http"* ]]; do
    # Append cache-bust param (next_url already has ?cursor=N)
    page_json=$(curl -s -H "Accept: application/activity+json" "${next_url}&${cache_bust}")
    found=$(outbox_find_by_slug "$page_json" "$slug")
    if [[ "$found" -gt 0 ]]; then
      echo "$page_json"
      return
    fi
    next_url=$(jq -r '.next // empty' <<< "$page_json")
    page=$((page + 1))
  done

  echo ""
}

# outbox_find_by_slug <page_json> <slug>
# Finds an activity in the outbox page matching the slug.
# Handles both inline objects and string-URL objects.
# Returns the count of matching items.
outbox_find_by_slug() {
  local page_json="$1"
  local slug="$2"

  jq -r --arg slug "$slug" \
    '[.orderedItems[] | select(
      if .object | type == "object" then
        (.object.id // "" | contains($slug)) or
        (.object.url // "" | contains($slug)) or
        (.object.content // "" | contains($slug))
      elif .object | type == "string" then
        (.object | contains($slug))
      else false end
    )] | length' <<< "$page_json" 2>/dev/null || echo "0"
}

# outbox_get_activity_by_slug <page_json> <slug>
# Returns the first matching activity JSON.
outbox_get_activity_by_slug() {
  local page_json="$1"
  local slug="$2"

  jq --arg slug "$slug" \
    '[.orderedItems[] | select(
      if .object | type == "object" then
        (.object.id // "" | contains($slug)) or
        (.object.url // "" | contains($slug)) or
        (.object.content // "" | contains($slug))
      elif .object | type == "string" then
        (.object | contains($slug))
      else false end
    )] | first' <<< "$page_json" 2>/dev/null
}
