# FISH SHELL CONFIG

Managed by chezmoi from `~/.dotfiles/home/dot_config/fish`.

## STRUCTURE

```
fish/
├── config.fish            # core: PATHs, editor, aliases, tool init (template)
├── conf.d/                # auto-sourced fragments (fzf, git, pnpm-shell-completion)
├── functions/             # lazy-loaded functions (__git.* helpers, fzf helpers)
├── completions/           # bun, devbox, fisher, fzf, mise, pnpm
├── themes/                # fish themes
├── fish_plugins           # fisher plugin list
└── secrets.fish           # AGE-ENCRYPTED — decrypts from encrypted_private_secrets.fish.age
```

## NOTES

- `secrets.fish` is age-encrypted in the source state (`encrypted_private_secrets.fish.age`) — never commit plaintext secrets.
- `fish_variables` is runtime state (fish writes it) — not managed.
- `config.fish` is a template (`config.fish.tmpl` in source) — it renders per-OS, so it is copied, not symlinked.
