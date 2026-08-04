# PI AGENT WORKSPACE

pi (coding agent) configuration. Managed by chezmoi from `~/.dotfiles/home/dot_pi`; files are symlinked into this directory.

## STRUCTURE

```
.pi/
├── agent/
│   ├── extensions/              # TypeScript extensions (auto-discovered)
│   │   └── herdr-agent-state.ts # herdr↔pi integration
│   ├── auth.json                # runtime state (ignored)
│   ├── sessions/                # runtime state (ignored)
│   ├── models*.json             # runtime state (ignored)
│   ├── npm/                     # runtime cache (ignored)
│   └── run-history.jsonl        # runtime state (ignored)
└── skills                       # moved to ~/.agents/skills (see .agents/AGENTS.md)
```

## NOTES

- **Extensions**: `~/.pi/agent/extensions/*.ts` or `*/index.ts` are auto-discovered; hot-reload with `/reload` in pi.
- **`herdr-agent-state.ts` is installed by herdr** — herdr regenerates it on updates and overwrites this file. Don't hand-edit it; add custom hooks/plugins as separate files beside it. When herdr updates it, commit the new version (symlink mode writes straight into the repo).
- **Runtime state is never managed** — auth.json, sessions/, models*, npm/, run-history.jsonl are in `.chezmoiignore`; do not `chezmoi add` them.

## MCP (pi-mcp-adapter)

- **Dependency**: installed via `pi install npm:pi-mcp-adapter` (registered in `~/.pi/agent/settings.json`, which is untracked — re-run the install on a fresh machine).
- **Servers**: `~/.pi/agent/mcp.json` (managed). Currently only `open-computer-use` (local stdio server, `open-computer-use mcp`, bun global).
- **Runtime state**: `~/.pi/agent/mcp-cache.json` is adapter-generated — never add it.
- macOS permissions: `open-computer-use doctor` to grant Accessibility permissions.
