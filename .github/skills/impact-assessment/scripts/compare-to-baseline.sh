#!/usr/bin/env bash
# Diffs current GitHub + Copilot metrics against the committed baseline,
# preserving each field's source/confidence label through the comparison.
#
# Usage: compare-to-baseline.sh <baseline.json> <current-github.json> <current-copilot.json>
# Requires: jq

set -euo pipefail

BASELINE="${1:?Usage: compare-to-baseline.sh <baseline.json> <current-github.json> <current-copilot.json>}"
CURRENT_GITHUB="${2:?Missing current-github.json}"
CURRENT_COPILOT="${3:?Missing current-copilot.json}"

jq -n \
  --slurpfile baseline "$BASELINE" \
  --slurpfile current_github "$CURRENT_GITHUB" \
  --slurpfile current_copilot "$CURRENT_COPILOT" \
  '
  def pct_change(old; new):
    if old == null or new == null or old == 0 then null
    else ((new - old) / old * 100 * 100 | round / 100) end;

  ($baseline[0].github // $baseline[0]) as $b_gh |
  ($baseline[0].copilot // {}) as $b_cp |
  $current_github[0] as $c_gh |
  $current_copilot[0] as $c_cp |

  {
    generated_note: "source/confidence carried through from each input file — a mismatch between baseline and current confidence means the comparison itself is lower-confidence, not just the raw numbers.",
    github_metrics: {
      confidence_note: (
        if ($b_gh.confidence // "high") == ($c_gh.confidence // "high")
        then "consistent"
        else "MISMATCH: baseline and current confidence differ — treat this comparison as lower-confidence"
        end
      ),
      prs_merged: {
        baseline: $b_gh.metrics.prs_merged_90d,
        current: $c_gh.metrics.prs_merged_90d
      },
      avg_pr_cycle_hours: {
        baseline: $b_gh.metrics.avg_pr_cycle_hours,
        current: $c_gh.metrics.avg_pr_cycle_hours,
        pct_change: pct_change($b_gh.metrics.avg_pr_cycle_hours; $c_gh.metrics.avg_pr_cycle_hours)
      },
      avg_review_comments_per_pr: {
        baseline: $b_gh.metrics.avg_review_comments_per_pr,
        current: $c_gh.metrics.avg_review_comments_per_pr,
        pct_change: pct_change($b_gh.metrics.avg_review_comments_per_pr; $c_gh.metrics.avg_review_comments_per_pr)
      },
      pr_rework_rate_pct: {
        baseline: $b_gh.metrics.pr_rework_rate_pct,
        current: $c_gh.metrics.pr_rework_rate_pct,
        point_change: (
          if $b_gh.metrics.pr_rework_rate_pct == null or $c_gh.metrics.pr_rework_rate_pct == null then null
          else ($c_gh.metrics.pr_rework_rate_pct - $b_gh.metrics.pr_rework_rate_pct)
          end
        )
      }
    },
    copilot_usage: {
      source: $c_cp.source,
      confidence: $c_cp.confidence,
      baseline_source: ($b_cp.source // "unknown"),
      note: (
        if ($b_cp.source // "unknown") != ($c_cp.source // "unknown")
        then "Instrumentation mode changed between baseline and current pull (e.g. proxy -> metrics-api) — do not present usage deltas as apples-to-apples."
        else "Instrumentation mode unchanged since baseline."
        end
      ),
      current_raw: $c_cp
    }
  }
  '
