# Dotfiles (chezmoi)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). This repo stores source templates under `dot_*/` that map to files in `$HOME`.

## Quick start

- Preview changes: `chezmoi diff`
- Apply changes: `chezmoi apply`
- Edit a file: `chezmoi edit ~/.config/fish/config.fish`
- Pull updates: `chezmoi update`

## Contents

- `dot_config/fish/config.fish` Fish shell environment setup, PATHs, aliases, and tool init (pyenv, rbenv, starship).
- `dot_config/git/ignore` Global gitignore entries (Claude local settings).
- `dot_config/mise/config.toml` Tool versions managed by mise (aws-cli, elixir, node, rust, usage, zig).
- `dot_config/nvim/` LazyVim-based Neovim setup.
- `dot_config/aerospace/` Placeholder for Aerospace config.

## Notes

- Paths assume macOS Homebrew locations (e.g. `/opt/homebrew`).
- Some tools in Fish config (pyenv, rbenv, starship, devbox) must be installed separately.
