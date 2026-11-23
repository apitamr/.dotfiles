#!/usr/bin/env bash
# Install Homebrew, apply the Brewfile, and link this repo into $HOME.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROG="$(basename "$0")"

info() {
    printf '\033[1;34m==>\033[0m %s\n' "$*"
}

usage() {
    cat <<EOF
Usage: ./$PROG [config ...]
       ./$PROG --no-brew
       ./$PROG --help

Install Homebrew packages and link this repo into \$HOME.
Pass config names to link only those files and skip Homebrew.
--no-brew links every config and skips Homebrew.

Examples:
  ./$PROG                 Homebrew packages and every config
  ./$PROG --no-brew       every config, skip Homebrew
  ./$PROG herdr           only herdr
  ./$PROG herdr zed       herdr and zed
  ./$PROG --help          this help

Configs:
  zsh        ~/.zshrc ~/.zprofile ~/.zshenv ~/.zshrc_aliases, and Oh My Zsh
  git        ~/.gitconfig
  starship   ~/.config/starship.toml
  ghostty    ~/.config/ghostty
  nvim       ~/.config/nvim
  zed        ~/.config/zed/settings.json and keymap.json
  herdr      ~/.config/herdr/config.toml
EOF
}

skip_brew=0
configs=()

for arg in "$@"; do
    case "$arg" in
        -h | --help | help)
            usage
            exit 0
            ;;
        --no-brew)
            skip_brew=1
            ;;
        --*)
            echo "Unknown option: $arg" >&2
            usage >&2
            exit 1
            ;;
        *)
            configs+=("$arg")
            ;;
    esac
done

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "This script only supports macOS." >&2
    exit 1
fi

# --- Homebrew ---------------------------------------------------------------

install_brew() {
    if [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
        info "Installing Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo "Homebrew is not available after install." >&2
        exit 1
    fi

    info "Installing packages from Brewfile"
    brew bundle --file="$DOTFILES/Brewfile"
}

# --- Config symlinks --------------------------------------------------------
# Existing files and directories are moved aside before linking.

link() {
    local src="$1" dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" == "$src" ]]; then
            info "Already linked $dest"
            return 0
        fi
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
        info "Backing up $dest -> $backup"
        mv "$dest" "$backup"
    fi

    ln -s "$src" "$dest"
    info "Linked $dest"
}

# zshrc sources Oh My Zsh when this directory exists. Clone only; the
# upstream installer would overwrite ~/.zshrc.
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh"
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    fi
}

link_zsh() {
    link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
    link "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
    link "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
    link "$DOTFILES/zsh/.zshrc_aliases" "$HOME/.zshrc_aliases"
    install_oh_my_zsh
}

link_git() {
    link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
}

link_starship() {
    link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
}

link_ghostty() {
    link "$DOTFILES/ghostty" "$HOME/.config/ghostty"
}

link_nvim() {
    link "$DOTFILES/nvim" "$HOME/.config/nvim"
}

link_zed() {
    link "$DOTFILES/zed/settings.json" "$HOME/.config/zed/settings.json"
    link "$DOTFILES/zed/keymap.json" "$HOME/.config/zed/keymap.json"
}

link_herdr() {
    link "$DOTFILES/herdr/config.toml" "$HOME/.config/herdr/config.toml"
}

link_named() {
    case "$1" in
        zsh) link_zsh ;;
        git) link_git ;;
        starship) link_starship ;;
        ghostty) link_ghostty ;;
        nvim) link_nvim ;;
        zed) link_zed ;;
        herdr) link_herdr ;;
        *)
            echo "Unknown config: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
}

link_all() {
    link_zsh
    link_git
    link_starship
    link_ghostty
    link_nvim
    link_zed
    link_herdr
}

if [[ ${#configs[@]} -eq 0 ]]; then
    if [[ "$skip_brew" -eq 0 ]]; then
        install_brew
    fi
    info "Linking config"
    link_all
    info "Done. Open a new terminal so zsh loads the linked config."
    exit 0
fi

for name in "${configs[@]}"; do
    link_named "$name"
done

info "Done."
