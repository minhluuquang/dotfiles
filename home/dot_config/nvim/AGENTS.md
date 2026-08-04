# NEOVIM CONFIG (LazyVim)

Managed by chezmoi from `~/.dotfiles/home/dot_config/nvim`.

## STRUCTURE

```
nvim/
├── init.lua               # entry point (LazyVim)
├── lazyvim.json           # LazyVim distro version
├── lazy-lock.json         # plugin lockfile (committed)
├── lua/
│   ├── config/            # options, keymaps, autocmds, lazy setup
│   └── plugins/           # blink, colorscheme, diffview, snacks (+ example)
├── stylua.toml            # formatting
├── .neoconf.json          # neoconf settings
├── .gitignore             # nvim-internal ignores
└── README.md
```

## NOTES

- `lazy-lock.json` is committed and updates as plugins change — commit the changes.
- `config.fish`-style caveat: nothing here is a chezmoi template, so all files are symlinked; edits in `~/.config/nvim` write back to the repo.
