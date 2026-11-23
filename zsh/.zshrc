export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# After oh-my-zsh so these win over plugin aliases
[ -f ~/.zshrc_aliases ] && source ~/.zshrc_aliases

export STARSHIP_CONFIG="$HOME/.config/starship.toml"
(( $+commands[starship] )) && eval "$(starship init zsh)"

eval "$(mise activate zsh)"

# Added by Kiri: its docker and kiri commands (kiri setup --uninstall removes this)
case ":$PATH:" in *":$HOME/.kiri/bin:"*) ;; *) export PATH="$PATH:$HOME/.kiri/bin" ;; esac
