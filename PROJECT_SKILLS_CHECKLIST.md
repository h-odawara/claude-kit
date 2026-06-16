# Project-specific skills checklist

The skills bundled in `skills/` are generic — they work the same way in any project. They are not enough on their own. When setting up `.claude/` for a project (new or existing), also author project-specific skills for at least the categories below. Use the same SKILL.md shape as the bundled ones (frontmatter `name`/`description`, then steps) — write each as `.claude/skills/<name>/SKILL.md` in the project itself, not here in claude-kit, since the exact commands are project-specific.

## Categories to cover

1. **Build** — the exact compile/build command(s) for this project's toolchain (e.g. `dotnet build`, `npm run build`, `uv run python -m build`, `cargo build`). Include the no-op/check-only variant if one exists (build without running).

2. **Install / dependency setup** — how a fresh checkout gets its dependencies (e.g. `dotnet restore`, `npm install`, `uv sync`, `pip install -e .`). Note any non-obvious prerequisites (a specific SDK version, a system package, an env var that must be set first).

3. **Test execution** — not just "the test command" but enough to run a single test/class (faster iteration loop matters more than the full-suite command). See the bundled skills' shape for the pattern — list full-suite, filtered, and verbose-output variants.

4. **Dev/test environment startup** — whatever has to be running before the app/feature can be exercised: a local server, a database, an emulator, an editor (e.g. opening a game engine's editor on the right project and pressing Play), a REPL with the right state loaded. If Claude can't drive the last step itself (e.g. clicking Play in a GUI), say so explicitly in the skill and describe what to hand back to the user and what to ask them to check.

5. **Lint/format check**, if the project has one — the check command and the fix command, and whether Claude should run the fix automatically or just report findings.

## Why this matters

Without these, every session re-derives "how do I even run this" from scratch by reading package.json/csproj/pyproject.toml, which is slower and more error-prone than a skill that already encodes the right command, the right flags, and the right caveats (e.g. "this requires X to be running first"). A generic `run-tests`-shaped skill that's wrong for this project's actual test runner is worse than no skill — verify the commands actually work before treating the skill as done, the same way you'd verify any other code change.

## When a project skill should defer to a generic one

If a project-specific skill would just restate something already covered by a bundled skill with no project-specific nuance (e.g. nothing project-specific to add to `git-commit`), don't create a duplicate — only add a project skill where there's actual project-specific content (a real command, a real path, a real caveat).
