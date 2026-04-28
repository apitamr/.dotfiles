eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# Auto-start tmux on login (skip inside Zed's integrated terminal)
if [ -x "$(command -v tmux)" ] && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -z "$ZED_TERM" ]; then
  tmux new-session -A -s main
fi
