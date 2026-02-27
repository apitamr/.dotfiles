# Zsh Options
setopt AUTO_CD              # cd by typing directory name
setopt HIST_IGNORE_DUPS     # don't record duplicate commands
setopt HIST_IGNORE_SPACE    # don't record commands starting with space
setopt HIST_REDUCE_BLANKS   # remove extra blanks from history
setopt SHARE_HISTORY        # share history across sessions
setopt INTERACTIVE_COMMENTS # allow comments in interactive shell

# Docker CLI Completions (must be before compinit)
fpath=($HOME/.docker/completions $fpath)

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # disabled — using Starship
source "$ZSH/oh-my-zsh.sh"

# Load Custom Aliases
[ -f ~/.zshrc_aliases ] && source ~/.zshrc_aliases

# Starship Prompt
eval "$(starship init zsh)"

# Editor Configuration
export EDITOR="nvim"
export VISUAL="nvim"

# Path Configuration
export PATH="/opt/homebrew/opt/trash/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.cargo/bin:$PATH"
[ -f "$HOME/.goup/env" ] && . "$HOME/.goup/env"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Zsh Plugins
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# PHP
export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
export COMPOSER_PHP="/opt/homebrew/opt/php@8.3/bin/php"

# bun completions
[ -s "/Users/apitamr/.bun/_bun" ] && source "/Users/apitamr/.bun/_bun"
