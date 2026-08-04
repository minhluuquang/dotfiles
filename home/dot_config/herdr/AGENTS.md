# HERDR CONFIG

Terminal-native workspace/tab/pane manager. Managed by chezmoi from `~/.dotfiles/home/dot_config/herdr`.

## STRUCTURE

```
herdr/
├── config.toml            # settings: theme, keybindings, plugins, onboarding
├── *.log                  # runtime (ignored)
├── *.sock                 # runtime (ignored)
├── session.json           # runtime (ignored)
└── release-notes.json     # runtime (ignored)
```

## NOTES

- **herdr rewrites `config.toml`** (e.g. on updates) — with symlink mode those writes land directly in the repo; commit them.
- Runtime files (`*.log`, `*.sock`, `session.json`, `release-notes.json`, `plugins*`) are `.chezmoiignore`d — never add them.
- Full config reference: https://herdr.dev/docs/config-reference/
