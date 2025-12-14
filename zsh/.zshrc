# ─── Auto-start Tmux ────────────────────────────────────────────────────────
# Only auto-start in Ghostty (skip IDEs like VS Code, Zed, JetBrains)
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    tmux attach -t default || tmux new -s default
  fi
fi

# ─── Oh My Zsh Configuration ────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh


# ─── Load Custom Aliases ────────────────────────────────────────────────────
[ -f ~/.zshrc_aliases ] && source ~/.zshrc_aliases

# ─── Starship Prompt ────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── Editor Configuration ───────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ─── Path Configuration ─────────────────────────────────────────────────────
export PATH="/opt/homebrew/opt/trash/bin:$PATH"
export PATH="/Users/strygwyr/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.goup/env"

  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completio

# ─── Zsh Plugins ────────────────────────────────────────────────────────────
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ─── Docker CLI Completion ──────────────────────────────────────────────────
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/apitamr/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
