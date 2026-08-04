# MISE CONFIG

Tool version manager ([mise](https://mise.jdx.dev/)). Managed by chezmoi from `~/.dotfiles/home/dot_config/mise`.

## STRUCTURE

```
mise/
└── config.toml            # [tools]: aws-cli, erlang, elixir, node, rust, usage, zig
```

## NOTES

- Install/update tools with `mise install` / `mise use -g <tool>@<version>`.
- Keep `[tools]` in sync with what the onchange installer script (`run_onchange_after_install-packages.sh.tmpl`) expects.
