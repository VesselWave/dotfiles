# Invisible Caveman Extension Design

## Goal

Enforce Caveman `full` response style in every Pi turn without visible UI, commands, configuration, or session state.

## Architecture

Add a minimal user-global Pi extension under the dotfiles `pi` package. The extension uses `before_agent_start` to append fixed `full` Caveman instructions to the system prompt on every turn.

Remove the installed `npm:pi-caveman` package entry from active user settings so only one Caveman extension loads. Disable the legacy Caveman skill in tracked settings. Replace detailed Caveman rules in tracked and active user-global `AGENTS.md` files with a short ownership note: response compression comes from the extension, while code and commit messages retain normal grammar.

Do not use a skill. Skills load on demand and cannot reliably enforce every response. Do not retain upstream controls because fixed behavior needs no level selection, persistence, or runtime toggle.

## Components

- `pi/.pi/agent/extensions/caveman.ts`: fixed prompt injection only.
- `pi/.pi/agent/settings.json`: disable legacy Caveman skill; global extension remains auto-discovered after dotfiles linking.
- Active `~/.pi/agent/settings.json`: remove `npm:pi-caveman`.
- Tracked and active user-global `AGENTS.md`: use concise extension ownership note.

## Behavior

- Intensity: always `full`.
- UI: none. No footer, widget, notifications, or dialogs.
- Commands: none. No `/caveman` command.
- Configuration: none. No `caveman.json`.
- Session state: none. No custom entries.
- Safety: explicit language remains required for security warnings, irreversible actions, and ambiguous ordered steps; Caveman style resumes afterward.
- Code artifacts: normal grammar and formatting.

## Compatibility

Prompt appending supports both upstream Pi string prompts and array-based prompt variants, matching upstream extension compatibility behavior. Extension imports only Pi types and requires no runtime dependency installation.

## Error Handling

No file I/O or mutable runtime state exists. If prompt shape is absent, normalize it to an empty string before appending rules.

## Verification

- Type-check extension through Pi/Bun-compatible TypeScript tooling available in repo environment.
- Confirm active settings contain no `npm:pi-caveman` entry and tracked settings disable legacy Caveman skill.
- Start a non-interactive Pi test with extension and inspect response style if safe without changing persistent settings.
- Confirm no Caveman status, command, config, or session-entry code exists.
- Confirm unrelated working-tree changes, including current README Kitty diff, remain untouched.
