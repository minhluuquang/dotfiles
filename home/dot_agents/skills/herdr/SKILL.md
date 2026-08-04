---
name: herdr
description: "Control Herdr, a terminal multiplexer for coding agents. Use Herdr to inspect or control panes, tabs, workspaces, terminals, run commands, and starting and monitoring background processes like dev servers. Use for subagent when the user or another skill explicitly asks for or requires subagents. Requires HERDR_ENV=1."
---

# Herdr

Herdr organizes terminals into workspaces, tabs, and panes, recognizes coding agents running inside panes, and exposes the current session through the `herdr` CLI.

Before issuing any control command, verify that this agent is running inside a Herdr-managed pane:

```bash
test "${HERDR_ENV:-}" = 1
```

If the check fails, say that you are not running inside Herdr and stop. Do not inspect or control the focused Herdr session from outside Herdr.

When the check passes, the `herdr` binary in `PATH` talks to the current session. Use it to inspect neighboring work, create terminal layout, start agents and commands, read output, and wait for state changes.

## Learn the current CLI

The installed binary is the authority for command syntax. Start with:

```bash
herdr --help
```

Then print the relevant command group by running the group without a subcommand:

```bash
herdr agent
herdr pane
herdr workspace
herdr tab
herdr worktree
herdr terminal
herdr notification
herdr integration
herdr session
herdr wait
```

Do not run bare `herdr` for discovery; it launches or attaches the TUI. Do not probe a mutating nested command by omitting arguments. Commands such as `herdr workspace create` are valid with defaults and will execute.

Most control commands return JSON. Read identifiers and state from those responses instead of predicting them. Agent targets accept terminal ids, unique agent names, detected/reported agent labels, and legacy pane ids.

## Understand layout, panes, and agents

Choose the primitive that matches the job:

- Workspace, tab, and pane topology organize terminal locations.
- Pane commands control raw terminals, shells, tests, servers, input, and output.
- Agent commands control the recognized coding agent currently occupying a pane.

A pane exists whether or not it contains an agent. `agent start` requires an available shell pane and never creates, splits, or moves layout on its own; pass `--split right|down` to have Herdr create the sibling pane. Use pane commands for ordinary processes. Use agent commands when Herdr must validate agent identity or interpret `idle`, `working`, `blocked`, and `unknown` lifecycle states.

Agent commands accept either a unique live agent name or the terminal/pane id currently hosting that agent. They do not accept bare agent-kind labels. Names must match `[a-z][a-z0-9_-]{0,31}` and be unique among live agents. A name follows the current pane occupant and is cleared when that agent exits, is released, or is replaced.

`idle` means the agent is ready for input and its tab has been seen in the focused Herdr UI. `done` is the same underlying idle state after unseen background work finishes. Focusing the tab or targeting the pane or agent with a focus command marks it seen. CLI reads do not mark it seen. `blocked` means Herdr recognized an approval or question UI. `unknown` means an agent is present but Herdr cannot classify it confidently; it does not prove completion.

## Use IDs and caller context

Public IDs are opaque stable handles. Prefer parsing them from JSON responses (`herdr pane list`, `herdr workspace list`, creation responses) over predicting formats. Closed tab and pane IDs are not reused. A pane moved into another workspace receives a new workspace-qualified pane ID; continue with the ID from the move response instead of the previous value.

Herdr injects the caller's context into each managed pane:

```bash
printf '%s\n' "$HERDR_WORKSPACE_ID" "$HERDR_TAB_ID" "$HERDR_PANE_ID"
```

Prefer `--current` when a pane command should target the calling pane. Omitting a target may use the UI-focused pane, which can belong to the user or another client.

Discover live state with:

```bash
herdr workspace list
herdr tab list --workspace "$HERDR_WORKSPACE_ID"
herdr pane current --current
herdr pane list --workspace "$HERDR_WORKSPACE_ID"
herdr agent list
```

Creation responses expose the IDs to use next. `workspace create` returns the workspace, tab, and root pane. `tab create` returns the tab and root pane. `pane split` returns the new pane.

## Start and coordinate an agent

Default to a sibling pane in the current tab and the current working directory. Do not create a workspace, tab, worktree, or different cwd unless the user explicitly requests that topology or location.

Honor a direction requested by the user. Otherwise inspect the caller pane:

```bash
herdr pane layout --pane "$HERDR_PANE_ID"
```

Start the agent with `--split` so Herdr creates the sibling pane itself; keep the user's focus in the calling pane and explicitly preserve the caller's working directory:

```bash
herdr agent start reviewer --split right --cwd "$PWD" --no-focus -- pi
```

Replace `right` with `down` when appropriate. Read the new pane id from the response when you need it for pane-level commands. Pass native agent arguments only after `--`:

```bash
herdr agent start reviewer --split right --cwd "$PWD" --no-focus -- pi --model fast
```

`agent start` returns only after Herdr detects the expected agent in the same pane and considers it ready for interactive input. It defaults to a 30-second startup timeout.

Submit work through the agent surface:

```bash
herdr agent send reviewer "Review the current diff and report only actionable findings."
herdr agent wait reviewer --status idle --timeout 120000
```

`agent send` writes literal text to the agent. `agent wait` blocks until the agent's lifecycle status matches `--status idle|working|blocked|unknown`. Wait for `idle` after sending work; wait for `blocked` when you expect the agent to stop and ask for input or approval. If the agent was already working, completion of the active turn may satisfy the wait.

Use `agent wait` for a state-specific workflow, such as waiting for an already-running agent to request input:

```bash
herdr agent wait reviewer --status blocked --timeout 120000
```

Use logical keys for interactive agent UI controls via the pane surface:

```bash
herdr pane send-keys <pane-id> esc
herdr pane send-keys <pane-id> ctrl+c
```

Herdr validates all keys before writing any bytes. Read the result through the resolved agent:

```bash
herdr agent get reviewer
herdr agent read reviewer --source recent-unwrapped --lines 120
```

If a wait fails or returns `blocked`, inspect `agent get`, `agent read`, and `agent explain` before deciding what input to send. Use the pane surface only when raw terminal control is intentional.

## Run an ordinary command in another pane

Create a sibling pane with the same geometry rule, preserve the caller's working directory, and keep user focus unchanged:

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
```

Read the new pane ID from the response, then run and inspect the command:

```bash
herdr pane run <returned-pane-id> "just test"
herdr wait output <returned-pane-id> --match "test result" --timeout 120000
herdr pane read <returned-pane-id> --source recent-unwrapped --lines 120
```

`pane run` atomically sends command text and Enter. `wait output` searches the selected snapshot immediately, so output that already exists can match. Use `--match <text>` for a literal substring or `--regex` for a Rust regular expression. Omitting `--timeout` allows an indefinite wait.

Use the read source that matches the task:

- `visible`: the currently rendered viewport.
- `recent`: recent rendered output, including soft wraps.
- `recent-unwrapped`: recent output with soft wraps joined; prefer it for logs and transcripts.
- `detection`: the plain-text bottom-buffer snapshot used for agent detection.

Use `--format ansi` when colors and terminal styling are evidence. Otherwise use text.

`--lines` asks Herdr for more rows from the pane's available screen and host scrollback. If increasing it does not reveal more of a completed response, the pane is probably running the agent on the terminal's alternate screen. Rows that leave the alternate screen do not enter Herdr's host scrollback, so a larger line count cannot recover them.

After that failed read, ask the agent to write its complete response as Markdown in a temporary directory and reply only with the file path, then read the file directly. Use this only as a fallback; do not request file output in the initial prompt.

## Safety and coordination rules

- Use `--no-focus` for background work unless the user asked to switch context.
- Use `--current`, an explicit pane ID, or a unique agent name. Do not rely on another client's focused pane.
- Parse IDs from JSON responses. Do not derive them from sidebar order or examples.
- Do not close workspaces, tabs, panes, or sessions you did not create unless the user explicitly asked.
- Never run `herdr server stop` from an active session unless the user explicitly intends to stop the server and its pane processes.
- Never kill the main Herdr process. Use named sessions for experiments that need an isolated server: start one with `herdr --session sandbox` and stop it with `herdr session stop sandbox` when done.
- CLI server errors are JSON on stderr with exit status 1. CLI syntax errors exit with status 2.
