# Dotfiles (chezmoi)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) .
The source state lives in `~/.dotfiles/home/` (via `.chezmoiroot`) and files are **symlinked** into `$HOME`
(`mode: symlink`) — edits in `$HOME` write back into the repo, like GNU stow.

## Quick start

- Preview changes: `chezmoi diff`
- Apply changes: `chezmoi apply`
- Edit a file: `chezmoi edit ~/.config/fish/config.fish`
- Pull updates: `chezmoi update`

## Contents

- `~/.dotfiles/home/dot_config/fish/` Fish shell: config, aliases, functions, completions, themes.
- `~/.dotfiles/home/dot_config/herdr/` Herdr terminal workspace manager.
- `~/.dotfiles/home/dot_config/nvim/` LazyVim-based Neovim setup.
- `~/.dotfiles/home/dot_config/mise/` Tool versions (aws-cli, elixir, node, rust, usage, zig).
- `~/.dotfiles/home/dot_config/git/` Global gitignore.
- `~/.dotfiles/home/dot_pi/` pi agent extensions.
- `~/.dotfiles/home/dot_agents/` Agent skills (SKILL.md based).

## Notes

- Secrets are age-encrypted in the source (`encrypted_*.age`), never plaintext.
- Runtime state (pi sessions, herdr logs, node_modules) is excluded via `.chezmoiignore`.
- Per-directory conventions: see the `AGENTS.md` files in each config directory.
