#!/usr/bin/env bash
# Pulls tool-agnostic cycle-time and quality metrics for the last 90 days.
# Does not depend on Copilot access of any kind — these numbers are the most
# reliable ones in every baseline/rollout/impact report.
#
# Usage: pull-github-baseline.sh <owner>/<repo>
# Requires: gh CLI authenticated with at least `repo` scope.

set -euo pipefail

REPO="${1:?Usage: pull-github-baseline.sh <owner>/<repo>}"
SINCE_DATE=$(date -u -d '90 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-90d +%Y-%m-%dT%H:%M:%SZ)

echo "Pulling closed PRs for ${REPO} since ${SINCE_DATE}..." >&2

PRS_JSON=$(gh api "repos/${REPO}/pulls" \
  -X GET -f state=closed -f per_page=100 --paginate \
  --jq "[.[] | select(.created_at >= \"${SINCE_DATE}\") | {
    number: .number,
    created: .created_at,
    merged: .merged_at,
    review_comments: .review_comments,
    user: .user.login
  }]")

MERGED_COUNT=$(echo "$PRS_JSON" | jq '[.[] | select(.merged != null)] | length')
AVG_CYCLE_HOURS=$(echo "$PRS_JSON" | jq '
  [.[] | select(.merged != null) |
    ((.merged | fromdateiso8601) - (.created | fromdateiso8601)) / 3600] |
  if length > 0 then (add / length * 100 | round / 100) else null end
')
AVG_REVIEW_COMMENTS=$(echo "$PRS_JSON" | jq '
  [.[] | .review_comments] |
  if length > 0 then (add / length * 100 | round / 100) else null end
')

# Rework proxy: PRs that received a "changes requested" review before merge.
REWORK_COUNT=0
if [ "$MERGED_COUNT" -gt 0 ]; then
  REWORK_COUNT=$(echo "$PRS_JSON" | jq -r '.[].number' | while read -r pr; do
    gh api "repos/${REPO}/pulls/${pr}/reviews" --jq '[.[] | select(.state == "CHANGES_REQUESTED")] | length'
  done | awk '{s+=($1>0)} END {print s+0}')
fi
REWORK_RATE=$(awk -v r="$REWORK_COUNT" -v m="$MERGED_COUNT" 'BEGIN { if (m > 0) printf "%.2f", (r/m)*100; else print "null" }')

jq -n \
  --arg repo "$REPO" \
  --arg since "$SINCE_DATE" \
  --argjson merged_count "$MERGED_COUNT" \
  --argjson avg_cycle_hours "${AVG_CYCLE_HOURS:-null}" \
  --argjson avg_review_comments "${AVG_REVIEW_COMMENTS:-null}" \
  --argjson rework_rate_pct "${REWORK_RATE:-null}" \
  '{
    repo: $repo,
    window_since: $since,
    source: "github-api",
    confidence: "high",
    metrics: {
      prs_merged_90d: $merged_count,
      avg_pr_cycle_hours: $avg_cycle_hours,
      avg_review_comments_per_pr: $avg_review_comments,
      pr_rework_rate_pct: $rework_rate_pct
    }
  }'
