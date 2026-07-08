# Developer Experience Survey — Baseline

Distribute this through an external form tool (not inside any AI chat session). Use a 1–5 scale for every question. Re-run the identical wording, scale, and order for the `impact-assessment` delta survey later — any wording change breaks the comparison.

1. How often do you feel slowed down by repetitive writing tasks (docs, PRs, tests)? (1 = never, 5 = constantly)
2. How confident are you in the consistency of your team's documentation? (1 = not at all, 5 = very)
3. How many hours per week do you spend on tasks that feel automatable? (open number, not 1–5)
4. How satisfied are you with your current development toolchain? (1 = very dissatisfied, 5 = very satisfied)
5. How much cognitive overhead do context switches (ticket → code → docs → review) add to your day? (1 = none, 5 = a great deal)

## Handling Responses

- Collect responses anonymously in the form tool itself.
- Compute only: mean, median, and response count per question. Do not export or commit individual rows.
- If fewer than ~6-8 people respond, treat per-question means as directional only — say so explicitly in `process-inventory.md` and in any later delta report. A small team's "anonymous" average can still be reverse-engineered.
- Save the aggregate as `.github/activate/baseline-devex-survey.json`:

```json
{
  "date_captured": "YYYY-MM-DD",
  "respondents": 0,
  "team_size": 0,
  "anonymity_note": "",
  "questions": [
    { "id": 1, "text": "Slowed by repetitive writing tasks", "mean": 0, "median": 0 },
    { "id": 2, "text": "Confidence in documentation consistency", "mean": 0, "median": 0 },
    { "id": 3, "text": "Hours/week on automatable tasks", "mean": 0, "median": 0 },
    { "id": 4, "text": "Toolchain satisfaction", "mean": 0, "median": 0 },
    { "id": 5, "text": "Cognitive overhead from context switching", "mean": 0, "median": 0 }
  ]
}
```
