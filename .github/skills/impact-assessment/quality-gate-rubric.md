# Quality Gate Rubric

Speed without quality is not a win. Use these thresholds — don't eyeball it — when deciding whether AI-assisted output quality was maintained.

| Metric | Maintained | Degraded | Where it comes from |
|---|---|---|---|
| PR rework rate (`pull-github-baseline.sh`) | Within 5 percentage points of baseline | More than 5 points worse than baseline | `pr_rework_rate_pct` field, baseline vs. current |
| Bug/defect rate (if tracked in issue tracker) | Within 15% of baseline | More than 15% worse than baseline | Manual pull from issue tracker; not automated by these scripts |
| Human gate compliance (`rollout-monitor` weekly logs) | ≥ 80% across the rollout period | Below 80% on average | Weekly health check "Human Gate Compliance" section |
| Docs flagged as inaccurate/stale post-merge | 0, or trending down week over week | Any upward trend across 3+ consecutive weeks | Weekly friction logs |

## Overall Determination

- **Maintained**: no metric above is in the "Degraded" column.
- **Mixed**: one metric degraded, others maintained — call this out specifically in the final report rather than averaging it away.
- **Degraded**: two or more metrics degraded — the report's recommendation must address this before recommending wider rollout, regardless of speed gains.

## Recommendation Guidance

- If quality degraded while speed improved: tighten AGENTS.md/instruction-file constraints, add project-specific rules from the friction log, and re-check in 2-3 weeks before recommending expansion.
- If quality was maintained or improved alongside speed gains: this is the credible win — cite the specific numbers, not just "38x faster," and note the confidence level of each metric.
