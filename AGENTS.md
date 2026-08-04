# DOTFILES

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), in a dmmulroy-style layout (source state in `home/`, files symlinked into `$HOME`).

## STRUCTURE

```
.dotfiles/
├── home/                        # chezmoi source state (via .chezmoiroot) → $HOME
│   ├── dot_config/              # → ~/.config/
│   │   ├── fish/                # Shell (AGENTS.md)
│   │   ├── herdr/               # Terminal workspace manager (AGENTS.md)
│   │   ├── nvim/                # Neovim / LazyVim (AGENTS.md)
│   │   ├── mise/                # Tool versions (AGENTS.md)
│   │   └── git/                 # Global gitignore (AGENTS.md)
│   ├── dot_pi/                  # → ~/.pi/ pi agent extensions (AGENTS.md)
│   ├── dot_agents/              # → ~/.agents/ agent skills (AGENTS.md)
│   ├── dot_gitconfig.tmpl       # → ~/.gitconfig (template)
│   ├── private_dot_gnupg/       # → ~/.gnupg (0700)
│   ├── AGENTS.md  Readme.md     # → ~/AGENTS.md, ~/Readme.md (managed)
│   ├── .chezmoiignore           # runtime state that is never managed
│   └── run_onchange_*.sh.tmpl   # package installer (runs when changed)
├── README.md                    # repo docs (not applied)
└── AGENTS.md                    # this file
```

## CONVENTIONS

- **Prefixes**: `dot_` → hidden name in `$HOME`; `private_` → 0700 perms; `*.tmpl` → template; `encrypted_*.age` → age-encrypted secret.
- **Symlink mode**: `mode = "symlink"` — plain files are symlinked into `$HOME` (stow behavior): edits in `$HOME` write back into this repo. Templates, encrypted, private, and executable files are copied, never symlinked.
- **Never manage runtime state**: pi auth/sessions/models, herdr logs/session, `node_modules`, lock files — all in `.chezmoiignore`.
- **Secrets** are age-encrypted (`encrypted_private_secrets.fish.age`), never plaintext.

## COMMANDS

| Task | Command |
|------|---------|
| Add a file | `chezmoi add ~/.path/to/file` (creates the `dot_` entry) |
| Preview | `chezmoi diff` |
| Apply | `chezmoi apply` (add `--exclude scripts` to skip installers) |
| Update (pull + apply) | `chezmoi update` |
| Verify | `chezmoi verify` / `chezmoi doctor` |
| Edit managed file | `chezmoi edit ~/.config/fish/config.fish` |

## TESTING

Structural refactors are validated in `~/projects/dotfiles-sandbox` (macOS sandbox via `--source`/`--destination` + Debian Docker container) before touching this repo. Run `scripts/test-macos-sandbox.sh` and `scripts/test-debian.sh` there.

## FRESH MACHINE

The repo lives at `~/.dotfiles` (not chezmoi's default `~/.local/share/chezmoi`), so the first `init` needs `--source`:

```bash
chezmoi init --apply --source ~/.dotfiles https://github.com/minhluuquang/dotfiles.git
```
