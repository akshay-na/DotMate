# ---------------------------------------------------------------
# Zsh Environment Initialization Script
# ---------------------------------------------------------------
# Purpose:
# This script customizes the Zsh environment by:
# - Setting up path configurations and aliases.
# - Managing plugins via Zinit.
# - Configuring history options and keybindings.
# - Initializing various tools (Starship, Zoxide, Fzf).
# - Loading additional local configurations if present.
# ---------------------------------------------------------------

# Usage:
# Place this file in the home directory as `.zshrc`. Make sure to install necessary plugins
# and tools such as Starship, Zoxide, and Fzf for complete functionality. For local customizations,
# define additional configurations in `.aliases_local` or `.zshrc_local` as needed.
# ---------------------------------------------------------------


# ---------------------------------------------------------------
# Source Common Configuration and Aliases
# ---------------------------------------------------------------
source ~/.commonrc

# Zoxide alias for interactive directory selection with Fzf
alias zi="zoxide query -ls | fzf | xargs -I {} zoxide cd '{}'"

# ---------------------------------------------------------------
# Path Configuration
# ---------------------------------------------------------------
export PATH="/opt/homebrew/bin:$PATH"   # macOS (Homebrew)
export PATH="$HOME/.local/bin:$PATH"    # Linux
export YSU_MESSAGE_POSITION="after"                                  # Custom message positioning

# ---------------------------------------------------------------
# Dotfiles Repository Update Check
# ---------------------------------------------------------------
check_dotfiles_update() {
  git pull
}

# ---------------------------------------------------------------
# NVM Version Management Update (if required)
# ---------------------------------------------------------------
update_nvm() {
  cd "$NVM_DIR" && git checkout "$(git describe --abbrev=0 --tags)"
}

# ---------------------------------------------------------------
# Zinit Plugin Manager Initialization and Plugins
# ---------------------------------------------------------------
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME}/.zinit"

# Install Zinit if not already installed
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load Zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
zinit light zsh-users/zsh-history-substring-search

# OMZ (Oh My Zsh) Plugins via Zinit snippets
zinit snippet OMZP::git
zinit snippet OMZP::kubectl
zinit snippet OMZP::npm
zinit snippet OMZP::vscode
zinit snippet OMZP::z
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# Replay Zinit history quietly
zinit cdreplay -q

# ---------------------------------------------------------------
# Keybindings
# ---------------------------------------------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ---------------------------------------------------------------
# Zsh History Settings
# ---------------------------------------------------------------
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# History options
setopt appendhistory           # Append to history file
setopt sharehistory            # Share history between sessions
setopt hist_ignore_space       # Ignore commands with leading spaces
setopt hist_ignore_all_dups    # Ignore all duplicates in history
setopt hist_save_no_dups       # Prevent duplicate entries when saving
setopt hist_ignore_dups        # Ignore duplicate entries during the session
setopt hist_find_no_dups       # Ignore duplicates during history search

# ---------------------------------------------------------------
# Completion Styling and Options
# ---------------------------------------------------------------
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache/
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':autocomplete:*' async true
zstyle ':completion:*' menu no

# Fzf-tab completion preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Git VCS info styling
zstyle ':vcs_info:git:*:-all-' get-revision true

# Docker-specific completion options
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes



# ---------------------------------------------------------------
# Tool Initializations (Starship, Zoxide, Fzf)
# ---------------------------------------------------------------
eval "$(starship init zsh)"         # Initialize Starship
eval "$(zoxide init zsh)"           # Initialize Zoxide
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh >/dev/null 2>&1 # Initialize Fzf if available

# ---------------------------------------------------------------
# Load Additional Local Configurations
# ---------------------------------------------------------------
[ -f ~/.aliases_local ] && source ~/.aliases_local
[ -f ~/.zshrc_local ] && source ~/.zshrc_local