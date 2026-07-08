---
description: 'Node.js and JavaScript conventions for the Activated mock project'
applyTo: '**/*.{js,mjs,cjs,json}'
excludeAgent: []
---
# JavaScript and Node Instructions

## Runtime and Module Style

- Target Node.js 20 or later
- Use ES modules (`type: module`) and explicit file extensions in local imports
- Prefer built-in Node modules before adding dependencies

## Code Style

- Keep route handlers thin; move business logic into service modules
- Use small pure functions where possible to simplify testing
- Return structured errors with clear messages for invalid input

## Testing

- Use the Node built-in test runner for fast feedback (`node --test`)
- Add tests for validation failures and success paths
- Keep test fixtures explicit and readable
