# Current Process Inventory (Pre-Activate)

Date captured: YYYY-MM-DD
Team size: N engineers, N designers, N PMs

## Task Types & Manual Time Estimates

<!-- Be honest, not aspirational. Inflated pre-Activate estimates make every later comparison misleading. -->

| Task | Weekly frequency | Avg. time per task (mins) | Who does it |
|---|---|---|---|
| Write user stories from requirements | | | |
| Code review / PR description | | | |
| Write unit tests | | | |
| Document a new endpoint or feature | | | |
| Draft a PR from a ticket | | | |
| Run & interpret the test suite | | | |

## Tooling in Use

- IDE: <!-- VS Code / JetBrains / etc. -->
- AI tools currently in use: <!-- none / GitHub Copilot / ad hoc ChatGPT / etc. -->
- Copilot plan tier (if applicable): <!-- Individual / Business / Enterprise / unknown -->
- Copilot Metrics API access confirmed?: <!-- yes / no / not attempted -->
- Ticket system: <!-- Jira / GitHub Issues / Linear / etc. -->
- PR review tool: <!-- GitHub / GitLab / etc. -->

## Cycle Time Baselines (last 90 days, from `pull-github-baseline.sh`)

- Avg. PR-to-merge time: X hours
- PRs merged in the last 90 days: X
- Avg. review comments per PR: X

## Code Quality Baselines (last 90 days)

- PR rejection/rework rate: X% <!-- e.g. PRs with a "changes requested" review before merge -->
- Bug/defect rate: X per sprint <!-- issues opened post-deploy, if tracked -->

## Instrumentation Mode for This Engagement

<!-- Filled in during Step 4 of baseline-capture/SKILL.md -->

- Copilot usage signal source: <!-- metrics-api / proxy -->
- Reason (if proxy): <!-- e.g. "org on Copilot Individual plan", "no admin willing to grant Metrics API token for a single-team pilot" -->
- This determines the confidence level attached to every Copilot-usage number in later rollout and impact reports.

## DevEx Survey

- Distribution method: <!-- e.g. Google Form, Microsoft Forms link -->
- Respondents: N / team size
- Anonymity note: <!-- e.g. "team of 5, so results are directional only" -->
- Aggregate results stored at: `.github/activate/baseline-devex-survey.json`
