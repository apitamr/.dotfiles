export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# After oh-my-zsh so these win over plugin aliases
[ -f ~/.zshrc_aliases ] && source ~/.zshrc_aliases

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export STARSHIP_CONFIG="$HOME/.config/starship.toml"
(( $+commands[starship] )) && eval "$(starship init zsh)"
