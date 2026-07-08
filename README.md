# Activated Mock Project

Activated is a mock product repository that uses the Activate framework as its delivery operating system.

## What This Repository Demonstrates

- A realistic product codebase with a small, runnable service and tests
- Activate framework assets installed in standard repository locations
- Optional metrics module assets included for rollout measurement workflows

## Mock Product Scenario

This mock product tracks digital service opportunities for cross-functional teams supporting federal agencies.

## Tech Stack

- Node.js 20+
- Native HTTP server (no web framework dependency)
- Node built-in test runner

## Run the Mock Service

```bash
npm start
```

Service endpoints:

- GET /health
- GET /api/opportunities
- POST /api/opportunities

## Run Tests

```bash
npm test
```

## Repository Layout

```text
Activated/
├── AGENTS.md
├── CUSTOMIZATION.md
├── .github/
│   ├── instructions/
│   │   ├── general.instructions.md
│   │   ├── security.instructions.md
│   │   ├── cost-estimation.instructions.md
│   │   └── javascript-node.instructions.md
│   ├── prompts/
│   ├── skills/
│   ├── agents/
│   └── workflows/
├── src/
│   ├── app.js
│   └── services/
│       └── opportunityService.js
├── test/
│   └── opportunityService.test.js
└── docs/
    ├── product/mock-project-brief.md
    └── user/adoption-guide.md
```

## Activate Framework Installation Notes

Framework guidance is active through:

- AGENTS.md at repository root
- Instruction files under .github/instructions
- Prompt files under .github/prompts
- Skills under .github/skills
- Agent definitions under .github/agents

This setup follows the standard tiered customization model and can be expanded incrementally as the project grows.

## License

This project is licensed under the MIT License. See LICENSE for details.