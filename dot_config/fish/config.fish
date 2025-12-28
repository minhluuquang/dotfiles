# ~/.config/fish/config.fish

# ==========================
# Local bin
# ==========================
# Add local bin to PATH
set -x PATH $HOME/.local/bin $PATH

# ==========================
# Go Environment Configuration
# ==========================
# Set Go environment variables
set -x GOROOT /usr/local/go
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
# Prepend Go binary directories to PATH
set -x PATH $GOBIN $GOROOT/bin $PATH

# ==========================
# AWS CLI Configuration
# ==========================
# Add AWS CLI to PATH
set -x PATH $HOME/.local/lib/aws/bin $PATH

# ==========================
# NPM Global Packages
# ==========================
# Add NPM global packages to PATH
set -x PATH $HOME/.npm-global/bin $PATH

# ==========================
# NVM (Node Version Manager)
# ==========================
# Load NVM using nvm.fish plugin
# Ensure nvm.fish is installed: fisher install jorgebucaran/nvm.fish
# This plugin handles loading .nvmrc files automatically
# No additional configuration needed here

# ==========================
# Erlang Configuration
# ==========================
# Set Erlang library path
set -x ERL_LIBS /opt/homebrew/Cellar/proper/1.4

# ==========================
# Deno Configuration
# ==========================
# Set Deno installation path and add to PATH
set -x DENO_INSTALL $HOME/.deno
set -x PATH $DENO_INSTALL/bin $PATH

# ==========================
# LLVM Configuration
# ==========================
# Add LLVM (installed via Homebrew) to PATH
set -x PATH /opt/homebrew/opt/llvm/bin $PATH

# ==========================
# Default Editor
# ==========================
# Set the default editor to nvim
set -x EDITOR nvim

# ==========================
# Locale Settings
# ==========================
# Set locale to UTF-8
set -x LC_CTYPE en_US.UTF-8

# ==========================
# Homebrew Paths
# ==========================
# Ensure Homebrew paths are first in PATH
set -x PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH

# ==========================
# Pyenv Setup
# ==========================
# Set Pyenv root directory and add to PATH
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - fish | source

# ==========================
# Rbenv Setup
# ==========================
# Initialize Rbenv
status --is-interactive; and rbenv init - | source

# ==========================
# Erlang Additional Configuration
# ==========================
# Add rebar3 to PATH and set Erlang flags
set -x PATH $HOME/.cache/rebar3/bin $PATH
set -x ERL_AFLAGS "+pc unicode -kernel shell_history enabled"

# ==========================
# Aliases
# ==========================
# Define command aliases
alias k=kubectl
alias vim=nvim

# Claude code aliase
alias ccd="claude --dangerously-skip-permissions --permission-mode plan"

# zellij alia
alias ze="zellij -l welcome"

# Codex alias
alias cdx="codex"

# ==========================
# Source Additional Scripts
# ==========================
# Source all scripts in ~/.fonts and a specific icons script
for script in $HOME/.fonts/*.sh
    if test -f $script
        bash -c "source $script"
    end
end
if test -f $HOME/.local/share/icons-in-terminal/icons_bash.sh
    bash -c "source $HOME/.local/share/icons-in-terminal/icons_bash.sh"
end

# ==========================
# GPG Configuration
# ==========================
# Set GPG TTY
set -x GPG_TTY (tty)

# ==========================
# SSH Agent Auto-Start
# ==========================
# Automatically start SSH agent and add keys if not already running
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
    ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519
    ssh-add --apple-use-keychain $HOME/.ssh/huynguyen_id_ed25519
end

source /opt/homebrew/share/fish/completions/git.fish

devbox completion fish >~/.config/fish/completions/devbox.fish

starship init fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/leo/.lmstudio/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# opencode
fish_add_path /Users/leo/.opencode/bin

# Zellij startup

# if test -z "$ZELLIJ"; and test -z "$SSH_CONNECTION"
#     if test "$ZELLIJ_AUTO_ATTACH" = true
#         zellij attach -c
#     else
#         zellij -l welcome
#     end
#
#     if test "$ZELLIJ_AUTO_EXIT" = TRUE
#         exit
#     end
# end
