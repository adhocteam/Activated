<!--
Frontmatter below follows this repo's documented conventions (description field,
shared with instructions/prompts) plus a `name` field per the common Agent Skills
format. Regenerate/validate with VS Code's built-in `agent-customization` skill
before distributing widely — see CUSTOMIZATION.md.
-->
---
name: baseline-capture
description: 'Capture a pre-Activate process, cycle-time, and developer-experience baseline before a team starts using AI-assisted coding, so later rollout and impact reports have something real to compare against.'
---

# Baseline Capture

Run this skill once, before a team starts routinely using GitHub Copilot / Activate guidance for delivery work. It produces the comparison point every later `rollout-monitor` and `impact-assessment` run depends on. Skipping this means the team can never credibly answer "did this help?" later.

## When to Use

- A team or repo is about to start (or has just started) using Activate guidance and AI-assisted coding for day-to-day delivery
- Leadership wants a defensible before/after story, not just anecdotes, before greenlighting wider rollout
- No baseline has been captured yet for this repo (check `.github/activate/` — if a `baseline-*.json` already exists, don't overwrite it; that repo has already run this skill)

## Prerequisites

- `gh` CLI installed and authenticated with at least `repo` scope against the target repository
- A named **facilitator** (usually the tech lead or EM) who will run this skill interactively with the team, not delegate it to the agent unsupervised
- Confirm whether the org has GitHub Copilot Business/Enterprise with an admin willing to grant Copilot Metrics API access. **Ask once, don't block on it** — most pilots will not get this, and the scripts below work fine without it.

## Steps

1. **Run the process inventory interview.** Sit down with the team (or draft it yourself as facilitator, then have the team correct it) and fill out [`process-inventory-template.md`](./process-inventory-template.md). Be honest about time estimates — inflated "before" numbers make every later comparison look better than it is and will undermine trust in the report.

2. **Distribute the DevEx survey externally.** Use [`devex-survey-questions.md`](./devex-survey-questions.md). Send it through a form tool outside of any AI chat tool (e.g. a shared forms product) — never collect responses inside a Copilot Chat session. Wait for responses, then compute only the aggregate (mean/median per question, response count). Do not commit individual responses.
   - If the team has fewer than ~6-8 respondents, note in the output that per-question means may be attributable to individuals and either widen the collection window (combine with an adjacent team) or say so explicitly in the report. Do not silently present it as anonymous.

3. **Pull repo-level cycle-time and quality metrics.** Run:

   ```bash
   bash scripts/pull-github-baseline.sh <owner>/<repo> > /tmp/github-baseline.json
   ```

   This covers PR cycle time, review comment counts, and closed-PR counts over the last 90 days — all tool-agnostic, no Copilot access required.

4. **Attempt the Copilot usage pull.** Run:

   ```bash
   bash scripts/pull-copilot-metrics.sh <org> <owner>/<repo> > /tmp/copilot-baseline.json
   ```

   This tries the GitHub Copilot Metrics API first and falls back automatically to git/PR proxy signals (`Co-authored-by: Copilot` trailers, Copilot coding-agent PR authorship) if the API isn't reachable. The output always records `"source"` (`metrics-api` or `proxy`) and `"confidence"` (`high` or `low`) per field — never let a downstream report drop this labeling.

5. **Assemble and commit the baseline snapshot.** Merge the two script outputs plus the survey aggregate into `.github/activate/baseline-YYYY-MM-DD.json`, save the survey aggregate separately as `.github/activate/baseline-devex-survey.json`, and commit `process-inventory.md` alongside them:

   ```bash
   mkdir -p .github/activate
   # write the three files, then:
   git add .github/activate/baseline-*.json .github/activate/baseline-devex-survey.json .github/activate/process-inventory.md
   git commit -m "chore: capture pre-Activate baseline"
   ```

6. **Have the facilitator review and sign off before committing.** This is a human gate, not an automatic step — the agent drafts, the facilitator verifies the numbers look sane (e.g. cycle times aren't obviously wrong due to a bot account skewing PR counts) before anything is committed.

## Output

```
.github/activate/
  baseline-YYYY-MM-DD.json
  baseline-devex-survey.json
  process-inventory.md
```

## Related

- [`rollout-monitor`](../rollout-monitor/SKILL.md) — run weekly starting the week after this baseline is committed
- [`impact-assessment`](../impact-assessment/SKILL.md) — run after 6 weeks, compares against this baseline
