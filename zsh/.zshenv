typeset -U path PATH fpath FPATH

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f "$HOME/.goup/env" ]] && . "$HOME/.goup/env"

# uv
path=("$HOME/.local/bin" $path)
