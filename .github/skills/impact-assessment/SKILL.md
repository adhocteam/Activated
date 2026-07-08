<!--
Frontmatter follows this repo's documented conventions (description field)
plus a `name` field per the common Agent Skills format. Regenerate/validate
with VS Code's built-in `agent-customization` skill before wide distribution.
-->
---
name: impact-assessment
description: 'After at least 6 weeks of Activate/Copilot adoption, compare current metrics against the pre-Activate baseline and produce a credible before/after report, including a quality check so speed gains are not mistaken for a win if quality dropped.'
---

# Impact Assessment

Run this skill after at least 6 weeks of rollout (post [`rollout-monitor`](../rollout-monitor/SKILL.md)). It answers the question the whole measurement effort exists for: did this actually help, and did it cost anything in quality? Unlike a purely retrospective estimate, every number here is compared against the specific baseline this team captured — no PERT estimates standing in for a real "before."

## Prerequisites

- `.github/activate/baseline-*.json`, `baseline-devex-survey.json`, and `process-inventory.md` exist
- At least 6 weeks of `.github/activate/weekly/week-*-snapshot.json` files exist

## Steps

1. **Re-run the DevEx survey externally**, identical wording/scale/order to the baseline survey in [`baseline-capture/devex-survey-questions.md`](../baseline-capture/devex-survey-questions.md). Collect the same way (external form, aggregate only, same anonymity caveat if the team is small).

2. **Pull current metrics** using the same scripts as baseline capture, against the same 90-day-equivalent window:

   ```bash
   bash ../baseline-capture/scripts/pull-github-baseline.sh <owner>/<repo> > /tmp/current-github.json
   bash ../baseline-capture/scripts/pull-copilot-metrics.sh <org> <owner>/<repo> > /tmp/current-copilot.json
   ```

3. **Run the comparison script** to diff against the baseline:

   ```bash
   bash scripts/compare-to-baseline.sh .github/activate/baseline-*.json /tmp/current-github.json /tmp/current-copilot.json > /tmp/comparison.json
   ```

   The script preserves each field's `source`/`confidence` label through the comparison — if the baseline used `proxy` data and the current pull got `metrics-api` access (or vice versa), the report must flag that the comparison itself is lower-confidence, not just the individual numbers.

4. **Fill in the DevEx delta** using [`devex-survey-delta-template.md`](./devex-survey-delta-template.md).

5. **Apply the quality gate rubric** in [`quality-gate-rubric.md`](./quality-gate-rubric.md). This step is not optional — speed improvement with degraded quality is not a win, and the rubric exists specifically so that judgment call isn't made informally.

6. **Write the final report** to `.github/activate/impact-assessment-YYYY-MM-DD.md`, combining: the metric comparison table, the DevEx delta, the quality gate results, and a clear recommendation — continue as-is, adjust AGENTS.md/instructions, or roll back.

7. **Facilitator reviews and signs off** before this report goes to leadership. If quality degraded, the report must say so plainly even if speed numbers look good.

## Related

- [`baseline-capture`](../baseline-capture/SKILL.md) — the comparison point this skill depends on
- [`rollout-monitor`](../rollout-monitor/SKILL.md) — supplies the weekly friction-log context referenced in the final recommendation
