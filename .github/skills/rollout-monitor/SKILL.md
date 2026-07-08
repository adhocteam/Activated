<!--
Frontmatter follows this repo's documented conventions (description field)
plus a `name` field per the common Agent Skills format. Regenerate/validate
with VS Code's built-in `agent-customization` skill before wide distribution.
-->
---
name: rollout-monitor
description: 'Run a weekly adoption health check during the first six weeks of Activate/Copilot rollout: pull fresh metrics, log friction, and check milestone gates.'
---

# Rollout Monitor

Run this skill once a week (Friday is a reasonable default) for the first 6 weeks after [`baseline-capture`](../baseline-capture/SKILL.md) has been committed. It turns raw metrics plus team input into a short, honest weekly record — so adoption problems surface while they're still cheap to fix, instead of only showing up in the week-6 impact report.

## Prerequisites

- `.github/activate/baseline-*.json` already exists (run `baseline-capture` first if not)
- A GitHub Action (`activate-metrics-weekly.workflow.yml`, installed from `activate-framework/workflows/`) is scheduled to pull and commit the raw weekly snapshot automatically — this skill picks up that snapshot rather than re-pulling metrics itself. If the workflow isn't installed, run the two `baseline-capture` scripts manually instead: `pull-github-baseline.sh` and `pull-copilot-metrics.sh`.

## Steps

1. **Read this week's snapshot** from `.github/activate/weekly/week-N-snapshot.json` (produced by the scheduled Action, or run manually — see Prerequisites).

2. **Fill in the human sections** of [`weekly-health-check-template.md`](./weekly-health-check-template.md) with the facilitator and team:
   - Skill/Copilot usage this week (from the snapshot's `source`/`confidence`-labeled fields — never restate a `proxy` number as if it were `metrics-api` data)
   - Human gate compliance (were AI-drafted PR descriptions and docs reviewed by a person before merge?)
   - Friction log — anything that required significant rework
   - Adoption blockers

3. **Check this week's milestone gate** against [`rollout-milestone-gates.md`](./rollout-milestone-gates.md). If a gate is missed, don't just note it — record what will change before next week's check (pairing session, AGENTS.md update, etc.).

4. **Commit the week's health check**:

   ```bash
   git add .github/activate/weekly/week-N-health-check.md
   git commit -m "chore: week N rollout health check"
   ```

5. **Post the async check-in** (optional, for distributed teams) using the `/activate-metrics-checkin` prompt to draft a short Slack/Teams post from this week's health check.

## Human Gate

The facilitator reviews and edits the friction log and blockers sections before committing — these are judgment calls about people and process, not something the agent should finalize unsupervised.

## Related

- [`baseline-capture`](../baseline-capture/SKILL.md) — must run first
- [`impact-assessment`](../impact-assessment/SKILL.md) — run after week 6, uses these weekly snapshots plus the baseline
