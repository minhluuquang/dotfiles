# Project Layout Conventions

## Top-level directories under `$HOME`

| Directory | Purpose |
|---|---|
| `~/projects/` | All source code — repos, SDKs, libraries, tools, experiments |
| `~/apps/` | Running services — Docker containers, background daemons, servers, long-lived processes |

## `~/projects/` — source code

Every git clone, scaffold, SDK, or codebase goes here. Named after the project:

```
~/projects/
  browser-harness-js/   # CDP browser automation SDK
  my-api/               # a web API
  some-lib/             # a library
```

## `~/apps/` — running things

Docker compose projects, service directories with docker-compose.yml, supervisor configs, or any long-running process live here. Each subdirectory is self-contained (config, data, compose file):

```
~/apps/
  postgres/             # docker-compose.yml + data volumes
  nginx-proxy/          # reverse proxy config + compose
  homepage/             # a service accessible at http://homepage.local
```

Services under `~/apps/` are expected to be startable with a single command (`docker compose up -d`, `systemctl --user start`, etc.).

## Dotfile management — chezmoi

Dotfiles are synced across machines with [chezmoi](https://www.chezmoi.io/). The source repo is elsewhere (managed by chezmoi itself).
This Linux machine and the MacBook share the same dotfiles.

**Workflow for updating a dotfile already tracked by chezmoi:**
Always edit the chezmoi-managed version first, then apply. This ensures the change gets committed and pushed,
so it syncs to the MacBook on the next `chezmoi apply` over there.

```bash
chezmoi edit ~/.bashrc   # edit the managed version (chezmoi's source)
chezmoi apply            # write it to the real ~/.bashrc
chezmoi re-add ~/.bashrc # only needed if the file wasn't already tracked
# then commit & push from chezmoi's source directory
```

Don't edit the deployed file directly — that change stays local and is overwritten on the next `chezmoi apply`.

## Tooling — mise

Programming languages, runtimes, and tools like `nvm` are installed via [mise](https://mise.jdx.dev/), not system packages.
Currently managed by mise: Node.js, Erlang, Elixir, Zig, AWS CLI, usage.

```bash
mise ls               # list what's installed
mise install node@22  # install a new version
mise use -g node@22   # set global default
```

Prefers this over `apt`, `brew`, or manual tarball installs. If a tool can be managed by mise, use mise.

## Shell — fish

This machine uses [fish](https://fishshell.com/) as the default login shell, not bash or zsh.
Code blocks in this file use generic shell syntax — fish is compatible with the commands shown (chezmoi, mise, docker, etc.).
Fish-specific: `alias` is defined via `fish_config` or `~/.config/fish/config.fish`, and `$PATH` is managed with `fish_add_path`. Don't edit `.bashrc`/`.zshrc` expecting changes to take effect.
