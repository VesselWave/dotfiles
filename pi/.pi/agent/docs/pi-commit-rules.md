# Pi Commit Rules

## Default Workflow

Token-minimal workflow for Pi:

```text
commit → check → choose msg → commit all or named paths → report hash
```

Commands:

```bash
pi-commit --check                         # inspect only
pi-commit -m "msg"                        # full tree
pi-commit file... -m "msg"                # named files only
pi-commit --amend -m "msg"                # full tree into HEAD
```

When user says `commit`:

1. Run `bin/pi-commit --check`.
2. Use current session context + diff summary to choose message.
3. Default to one commit: `bin/pi-commit -m "<message>"`.
4. Split only if needed: `bin/pi-commit <files...> -m "<message>"`.
5. Report only commit hash + message + leftovers/warnings.

## Split Criteria

Use more than one commit only when at least one is true:

- unrelated user-visible changes
- separate rollback boundary
- source changes and generated/vendor/lockfile changes should be isolated
- opportunistic cleanup mixed with requested fix

Do not split merely because many files changed.

## Block Criteria

Stop and ask user when:

- script reports secret-looking path
- merge/rebase/cherry-pick is active
- diff contains changes outside requested scope
- commit message would require guessing product intent
- tests/checks failed and user did not approve committing failure

## Subagents

Do not use subagents by default.

Use a fresh reviewer only when diff is large, mixed, or suspicious. Reviewer output should answer: commit now, split, or block.

## Script Source

Do not read `bin/pi-commit` during normal commit flow. Read it only when:

- script fails unexpectedly
- user asks to modify/debug script
- output indicates possible script bug
