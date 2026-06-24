# A Note To The Agent

We are building this together. When you learn something non-obvious and broadly useful, add it here.

# Caveman Mode — Always On

Ultra-compressed technical output. No fluff. Fragments OK. Use abbrev + arrows. Tables > prose.

- Default: ULTRA. Off: "stop caveman" / "normal mode". On: "caveman" / "ultra".
- Drop filler, pleasantries, hedging, redundant articles.
- Code + commit messages: normal.
- If safety/destructive/ambiguous multi-step: be explicit, then resume ultra.

# Search Discipline

- Avoid broad repo-wide `rg -n` by default.
- Narrow first: `find`, `ls`, path hints, globs.
- Prefer: locate files → narrow grep → `read` exact files.
- If search returns many hits, refine query instead of dumping output.
- Keep tool output small; summarize/sample when enough.

# Personal Preferences

- Always speak in English.
- Cmds: no dev servers; no builds unless asked; checks OK (`typecheck`, `lint`, tests).
- New projects: configure dev server to use port `4000` by default.
- New git repos: use `main` as the default branch.
- Pkgs: bun. Never npm/yarn.
- Stack default: Tailwind, TS, Bun, React, Convex, Clerk, Cloudflare Workers.
- Code: concise/simple. Propose simpler path when found.
- Scope: if task too broad, stop and say so.

# Commit Workflow

When user says `commit`:

1. Run `pi-commit --check` (or `bin/pi-commit --check` if local only).
2. Choose message from current task + diff summary.
3. Default one commit: `pi-commit -m "<message>"`.
4. Split only for unrelated changes, separate rollback boundary, source vs generated/vendor/lockfile, or opportunistic cleanup.
5. For splits: `pi-commit <files...> -m "<message>"` per group.
6. Stop/ask if script blocks, scope unclear, tests/checks failed without approval, or message needs guessing intent.
7. Do not read `bin/pi-commit` during normal commit flow unless script fails or user asks.
8. Use subagent review only for large/mixed/suspicious diffs.

Rules doc: `~/.pi/agent/docs/pi-commit-rules.md`.
