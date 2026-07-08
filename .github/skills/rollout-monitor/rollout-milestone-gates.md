# Rollout Milestone Gates

These defaults are a starting point, not a fixed standard — adjust the thresholds for team size and repo complexity **before Week 1 kicks off**, and record what you changed and why. A 3-person team and a 30-person program shouldn't use the same "50% of tickets" bar.

| Milestone | Default Gate Criteria | When | Adjust for... |
|---|---|---|---|
| Week 1 | Everyone on the team has used Copilot/Activate guidance for at least one real task | Day 7 | Team size — smaller teams should hit 100% easily; if not, that's a signal |
| Week 2 | AI assistance used for ≥ 50% of tickets/PRs in the sprint | Day 14 | Sprint length, ticket granularity |
| Week 3 | Human-gate compliance ≥ 80% (AI-drafted content reviewed before merge) | Day 21 | Team's existing review culture/tooling |
| Week 4 | Friction log reviewed as a team; AGENTS.md or an instruction file updated with at least one project-specific rule from real friction | Day 28 | N/A — this one shouldn't be relaxed; it's the feedback loop that makes the whole rollout self-correcting |
| Week 6 | `impact-assessment` run completed; team retrospective held | Day 42 | N/A |

## If a Gate Is Repeatedly Missed

Don't let a missed gate just roll over silently week after week. After two consecutive misses on the same gate:

1. Name the specific blocker in that week's Friction Log (not just "adoption is slow")
2. Decide explicitly: extend the timeline, change the gate criteria (and say why), or escalate to the facilitator's manager
3. Record the decision in the week's health check — a gate that's quietly ignored for six weeks tells leadership nothing useful at impact-assessment time
