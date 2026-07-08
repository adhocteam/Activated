---
description: 'Draft a short async Slack/Teams check-in post from this week''s rollout health check, for distributed teams.'
agent: 'agent'
tools:
  - 'changes'
---

# Activate Metrics Check-in

Draft a short async check-in post from the most recent file in `.github/activate/weekly/`.

## Instructions

1. Find the latest `week-N-health-check.md` under `.github/activate/weekly/`.
2. Draft a short post (4 questions, one or two sentences of answer each) using this template:

```markdown
## Activate Week N Check-in

**What worked well this week?**

**What friction did you hit?**

**Which skill or Copilot feature saved you the most time?**

**What's one rule we should add to AGENTS.md based on this week?**
```

3. Pull the answers from the week's Friction Log and Adoption Blockers sections — don't invent detail that isn't in the health check. If a section is empty, leave the corresponding answer as a prompt for the team to fill in rather than guessing.
4. Output the draft for the facilitator to post — do not post it anywhere automatically.

Review: ${selection}
