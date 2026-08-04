# GIT CONFIG

Managed by chezmoi from `~/.dotfiles/home/dot_config/git` + `dot_gitconfig.tmpl`.

## STRUCTURE

```
git/
└── ignore                 # global gitignore (applies to all repos)
~/.gitconfig               # from dot_gitconfig.tmpl (template)
```

## NOTES

- `~/.gitconfig` is a **template** — it renders per-OS (darwin/linux credential helpers) and is copied, not symlinked.
- **git-credential-manager rewrites the credential section** (`username = ...` under `[credential "https://github.com"]`). The template mirrors GCM's output (username after the helper lines) — keep it in sync if GCM's format changes, or the file will show as drifted.
