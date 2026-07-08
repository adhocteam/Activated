#!/usr/bin/env bash
# Attempts real GitHub Copilot usage telemetry via the Copilot Metrics API
# (requires Copilot Business/Enterprise + an admin-scoped token). Most pilots
# will NOT have this access — that is expected, not an error condition. This
# script falls back automatically to git/PR proxy signals and always labels
# which source was actually used, so no report can present a proxy number as
# verified telemetry.
#
# Usage: pull-copilot-metrics.sh <org> <owner>/<repo>
# Requires: gh CLI. jq.

set -euo pipefail

ORG="${1:?Usage: pull-copilot-metrics.sh <org> <owner>/<repo>}"
REPO="${2:?Usage: pull-copilot-metrics.sh <org> <owner>/<repo>}"

METRICS_JSON=""
if METRICS_JSON=$(gh api "orgs/${ORG}/copilot/metrics" 2>/dev/null); then
  echo "Copilot Metrics API access confirmed for org ${ORG}." >&2
  jq -n --argjson raw "$METRICS_JSON" --arg org "$ORG" '{
    org: $org,
    source: "metrics-api",
    confidence: "high",
    raw: $raw
  }'
  exit 0
fi

echo "Copilot Metrics API not reachable for org ${ORG} (expected for most plans/tokens) — falling back to proxy signals." >&2

# Proxy signal 1: commits with a Copilot co-authorship trailer in the last 90 days.
COAUTHORED_COUNT=$(git log --since="90 days ago" --grep="Co-authored-by:.*[Cc]opilot" --oneline | wc -l | tr -d ' ')
TOTAL_COMMITS=$(git log --since="90 days ago" --oneline | wc -l | tr -d ' ')

# Proxy signal 2: PRs opened by a Copilot coding-agent bot account.
COPILOT_PR_COUNT=$(gh api "repos/${REPO}/pulls" -X GET -f state=all -f per_page=100 --paginate \
  --jq '[.[] | select(.user.login | test("copilot"; "i"))] | length' 2>/dev/null || echo 0)
TOTAL_PR_COUNT=$(gh api "repos/${REPO}/pulls" -X GET -f state=all -f per_page=100 --paginate \
  --jq 'length' 2>/dev/null || echo 0)

jq -n \
  --arg org "$ORG" \
  --arg repo "$REPO" \
  --argjson coauthored_commits "$COAUTHORED_COUNT" \
  --argjson total_commits "$TOTAL_COMMITS" \
  --argjson copilot_prs "$COPILOT_PR_COUNT" \
  --argjson total_prs "$TOTAL_PR_COUNT" \
  '{
    org: $org,
    repo: $repo,
    source: "proxy",
    confidence: "low",
    note: "Directional only — infers Copilot involvement from commit trailers and bot PR authorship, not verified usage telemetry.",
    metrics: {
      commits_with_copilot_coauthor_90d: $coauthored_commits,
      total_commits_90d: $total_commits,
      prs_opened_by_copilot_90d: $copilot_prs,
      total_prs_90d: $total_prs
    }
  }'
