[[ -d "$HOME/.docker/bin" ]] && export PATH="$PATH:$HOME/.docker/bin"

# Homebrew: Apple Silicon, then Intel
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi
