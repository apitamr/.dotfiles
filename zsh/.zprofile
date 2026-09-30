# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/apitamr/.docker/bin"
# End of Docker Desktop section.

[[ -d "$HOME/.docker/bin" ]] && export PATH="$PATH:$HOME/.docker/bin"

# Homebrew: Apple Silicon, then Intel
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi

# After brew so ~/.local/bin stays first (uv, pipx, etc.)
path=("$HOME/.local/bin" $path)
