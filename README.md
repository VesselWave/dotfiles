# VesselWave's dotfiles

My current shell + terminal + editor + compositor setup, split into simple package-style directories.

Configs included here:
- Shell: [fish](fish/.config/fish)
- Terminal: [Alacritty](alacritty/.config/alacritty)
- Multiplexer: [tmux](tmux/.config/tmux/tmux.conf)
- Editor: [Vim](vim/.vimrc)
- Compositor: [niri](niri/.config/niri)

## Setup

Copy, modify, reuse.

This repo uses a GNU Stow-style layout, but it ships its own linker script, so `stow` is not required.

Bootstrap:

```bash
cd ~/repos/dotfiles
./scripts/link
```

What this does:
- links all packages into `$HOME`
- if target already exists and differs, moves it to `*.backup.<timestamp>`
- if target already points at right repo file, leaves it alone

## Manage dotfiles

Each top-level directory is one package:

- `fish` → `~/.config/fish/...`
- `alacritty` → `~/.config/alacritty/...`
- `tmux` → `~/.config/tmux/...`
- `vim` → `~/.vimrc`
- `niri` → `~/.config/niri/...`

Link all current packages:

```bash
./scripts/link
# same as
./scripts/link all
```

Link only selected packages:

```bash
./scripts/link fish
./scripts/link fish tmux vim
```

Preview changes without touching filesystem:

```bash
./scripts/link -n
./scripts/link -n fish tmux
```

Print suggested adopt commands for unmanaged sibling files near existing repo symlinks:

```bash
./scripts/link --adopt-cmds fish
./scripts/link --adopt-cmds fish tmux
# output like:
# mv -- ~/.config/fish/functions/fisher.fish ~/repos/dotfiles/fish/.config/fish/functions/
```

Show exact filesystem ops too:

```bash
./scripts/link -v
./scripts/link -v fish
./scripts/link -n -v fish
```

List package names:

```bash
./scripts/link --list
```

Every run ends with summary counts.

## How `scripts/link` works

For each file inside package dirs like `fish/`, `alacritty/`, `tmux/`, `vim/`, `niri/`:

1. script strips package root
2. maps remaining path into `$HOME`
3. if real file already exists there, moves it to timestamped backup
4. creates symlink from `$HOME/...` to repo file
5. if symlink already points to same file, prints `ok` and skips
6. prints final summary with counts for packages, files, links, moves, removals, and created dirs

Examples:
- `fish/.config/fish/config.fish` → `~/.config/fish/config.fish`
- `vim/.vimrc` → `~/.vimrc`
- `tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`

## Add new dotfiles

Rule: path inside package should mirror path under `$HOME`.

Examples:
- `fish/.config/fish/functions/foo.fish` → `~/.config/fish/functions/foo.fish`
- `vim/.vimrc` → `~/.vimrc`
- `niri/.config/niri/config.kdl` → `~/.config/niri/config.kdl`

Typical flow:

1. copy file into right package path in repo
2. preview with dry run if wanted
3. link that package
4. commit

Example: add Fish function:

```bash
cd ~/repos/dotfiles
cp ~/.config/fish/functions/foo.fish fish/.config/fish/functions/foo.fish
./scripts/link -n -v fish
./scripts/link fish
```

Example: add file to existing package:

```bash
cp ~/.config/tmux/tmux-extra.conf tmux/.config/tmux/tmux-extra.conf
./scripts/link tmux
```

Example: create brand new package:

```bash
mkdir -p kitty/.config/kitty
cp ~/.config/kitty/kitty.conf kitty/.config/kitty/kitty.conf
./scripts/link kitty
```

If target file in `$HOME` already exists and is not symlinked, `scripts/link` will move it to `*.backup.<timestamp>` before linking repo version.

### Adopt commands mode

`./scripts/link --adopt-cmds ...` is a lightweight `stow --adopt`-style helper, but it never moves files for you.

What it does:
- looks in package-managed subdirs under `$HOME`
- only scans dirs that already contain at least one symlink into that package
- skips `$HOME` root itself, so it will not sweep random top-level files
- skips paths already present in repo
- skips files ignored by git and obvious backup/temp names
- prints shell-safe `mv -- ... ...` commands with `~` paths
- highlights source filename in terminal output, still shell-safe for spaces
- destination is directory only
- `-v` adds candidate comments and summary
- leaves selection to you

Example:
- `~/.config/fish/functions/fisher.fish` next to repo symlinked Fish functions
- command mode prints move command into `fish/.config/fish/functions/fisher.fish`
- you run only commands you want, then link package normally

Typical flow:

```bash
./scripts/link --adopt-cmds fish
# run selected mv commands manually
./scripts/link fish
```

Verbose preview:

```bash
./scripts/link --adopt-cmds -v fish
```

## Fish

Fish is main shell config here.

Included:
- prompt config
- transient prompt support
- custom functions like `pi`, `gemini`, `mcd`, `rsync`, `sudonp`, `wire`
- path setup for local toolchains
- long-running command notifications

Notes:
- `fish_variables` is intentionally not tracked
- old commented API key material was not copied
- `pi` auto-creates `~/repos/test/work-<timestamp>` if started from `$HOME`

## Alacritty

Included:
- main config: [alacritty.toml](alacritty/.config/alacritty/alacritty.toml)
- theme file: [dank-theme.toml](alacritty/.config/alacritty/dank-theme.toml)

## niri

Included:
- main config: [config.kdl](niri/.config/niri/config.kdl)
- modular `dms/` config fragments

This part is more machine-specific than shell/editor configs.

## Notes

Not tracked on purpose:
- git remote setup
- GitHub auth tokens
- machine state files
- random backup files

## Contact

Open an issue in the repo.

Other feedback welcome.
- Email: vesselwave at protonmail dot com
