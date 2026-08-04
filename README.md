# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) :
the source state lives in [`home/`](home/) and files are symlinked into `$HOME` (`mode: symlink`),
so edits in `$HOME` write back into this repo.

## Structure

```
home/                      # chezmoi source state (.chezmoiroot) → $HOME
├── dot_config/            # → ~/.config/  (fish, herdr, nvim, mise, git)
├── dot_pi/                # → ~/.pi/     (pi agent extensions)
├── dot_agents/            # → ~/.agents/ (agent skills)
├── dot_gitconfig.tmpl     # → ~/.gitconfig
├── private_dot_gnupg/     # → ~/.gnupg
└── run_onchange_after_install-packages.sh.tmpl   # package installer
```

Prefixes: `dot_` → hidden file, `private_` → 0700, `*.tmpl` → template, `encrypted_*.age` → age-encrypted secret.

## Quick start

```bash
chezmoi diff      # preview
chezmoi apply     # apply (symlinks into $HOME)
chezmoi update    # pull + apply
chezmoi verify    # check everything matches
```

## Fresh machine bootstrap

The repo lives at `~/.dotfiles` (not chezmoi's default), so `init` needs `--source`:

```bash
chezmoi init --apply --source ~/.dotfiles https://github.com/minhluuquang/dotfiles.git
```

## Testing

Refactor validation lives in `~/projects/dotfiles-sandbox` (macOS sandbox + Debian container).

See [AGENTS.md](AGENTS.md) for agents working in this repo.
