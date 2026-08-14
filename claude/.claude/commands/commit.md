---
description: Secret-scan diff, ask GPT-5.6 Luna for subject, and commit
allowed-tools: Bash(pi-commit-auto), Bash(pi-commit:*), Bash(git status:*), Bash(git diff:*)
---

!`pi-commit-auto`

Report the result above verbatim. On `error blocked secret-looking path`, do not
work around the scan — tell the user which path tripped it.

Only if the changes are unrelated enough to need splitting (see the commit
workflow in `AGENTS.md`) fall back to per-group `pi-commit <files...> -m "<msg>"`.
