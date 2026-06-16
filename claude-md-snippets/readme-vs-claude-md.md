## Documentation roles: README.md vs. CLAUDE.md

- **README.md** — confirmed specs, design decisions, and setup/run instructions, written so another developer could get the project running from README alone. Append to it when: a feature/tool implementation completes, setup/config/env vars change, or an external dependency's preconditions get pinned down.
- **CLAUDE.md** — coding conventions, implementation patterns, and prohibitions, written so Claude follows the same conventions across sessions. Append to it when a convention or prohibition is decided or changes — keep it in sync, don't let it drift from what the code actually does.

Don't let the two duplicate each other: README is for humans setting the project up; CLAUDE.md is for Claude writing code in it.
