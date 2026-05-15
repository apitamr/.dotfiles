# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # disabled — using Starship
source "$ZSH/oh-my-zsh.sh"

# Load Custom Aliases
[ -f ~/.zshrc_aliases ] && source ~/.zshrc_aliases

# Starship Prompt
eval "$(starship init zsh)"

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
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/apitamr/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

source <(COMPLETE=zsh jj)

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
