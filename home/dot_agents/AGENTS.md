# AGENT SKILLS

Skills for AI agents (Agent Skills standard). Pi reads this location (`~/.agents/skills/`) alongside `~/.pi/agent/skills/`. Managed by chezmoi from `~/.dotfiles/home/dot_agents`.

## STRUCTURE

```
.agents/skills/
└── brave-search/          # web search via Brave Search API
    ├── SKILL.md           # skill definition (frontmatter + instructions)
    ├── content.js         # page content extraction
    ├── search.js          # search implementation
    ├── package.json       # deps (tldts)
    └── node_modules/      # never managed (ignored)
```

## NOTES

- One directory per skill; `SKILL.md` at the root, resources beside it.
- `node_modules` is `.chezmoiignore`d — if deps are missing after a fresh clone, run `npm install` in the skill directory.
- New skills: create the directory, `SKILL.md`, then `chezmoi add ~/.agents/skills/<name>`.
