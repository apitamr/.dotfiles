typeset -U path PATH fpath FPATH

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f "$HOME/.goup/env" ]] && . "$HOME/.goup/env"

# uv
path=("$HOME/.local/bin" $path)

# Machine-local secrets, e.g. TYPESAFE_API_KEY (not tracked)
[[ -f "$HOME/.zshenv.local" ]] && . "$HOME/.zshenv.local"
