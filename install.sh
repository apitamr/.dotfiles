#!/usr/bin/env bash
# Set up a machine from these dotfiles. Safe to re-run.
#
#   ./install.sh              Homebrew + Brewfile + oh-my-zsh, then stow every package
#   ./install.sh nvim zsh     same, but stow only these packages
#   ./install.sh --no-brew    skip Homebrew/Brewfile (still installs stow if missing)
#   ./install.sh -n           dry run: show what would happen
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET="$HOME"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
SKIP=(bg graphify-out) # top-level dirs that are not stow packages

DRY_RUN=0
BREW=1
while [[ "${1:-}" == -* ]]; do
  case "$1" in
    -n | --dry-run) DRY_RUN=1 ;;
    --no-brew) BREW=0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

run() {
  if ((DRY_RUN)); then echo "  would run: $*"; else "$@"; fi
}

# 1. Homebrew
for prefix in /opt/homebrew /usr/local; do
  [[ -x "$prefix/bin/brew" ]] && eval "$("$prefix/bin/brew" shellenv)" && break
done
if ! command -v brew >/dev/null; then
  echo "==> Installing Homebrew"
  if ((DRY_RUN)); then
    echo "  would run: Homebrew install script"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for prefix in /opt/homebrew /usr/local; do
      [[ -x "$prefix/bin/brew" ]] && eval "$("$prefix/bin/brew" shellenv)" && break
    done
  fi
fi

# 2. Brewfile (a failed entry shouldn't stop the dotfiles from linking)
if ((BREW)) && [[ -f "$DOTFILES/Brewfile" ]]; then
  echo "==> brew bundle"
  run brew bundle --file="$DOTFILES/Brewfile" || echo "  warning: some Brewfile entries failed; continuing" >&2
fi
if ! command -v stow >/dev/null; then
  echo "==> Installing stow"
  run brew install stow
fi

# 3. oh-my-zsh, before stowing so its installer can't replace the linked .zshrc
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "==> Installing oh-my-zsh"
  if ((DRY_RUN)); then
    echo "  would run: oh-my-zsh install script"
  else
    ZSH="$HOME/.oh-my-zsh" RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended ||
      echo "  warning: oh-my-zsh install failed; continuing" >&2
  fi
fi

# 4. packages
if (($#)); then
  packages=("$@")
else
  packages=()
  for dir in "$DOTFILES"/*/; do
    name="$(basename "$dir")"
    [[ " ${SKIP[*]} " == *" $name "* ]] || packages+=("$name")
  done
fi

# 5. back up anything in the way that isn't already ours
backed_up=0
backup() {
  local target="$1" rel="${1#"$TARGET"/}"
  backed_up=1
  echo "  backup: ~/$rel -> ${BACKUP/#$HOME/~}/$rel"
  run mkdir -p "$(dirname "$BACKUP/$rel")"
  run mv "$target" "$BACKUP/$rel"
}

for pkg in "${packages[@]}"; do
  [[ -d "$DOTFILES/$pkg" ]] || { echo "No such package: $pkg" >&2; exit 1; }
  echo "==> $pkg"
  while IFS= read -r -d '' entry; do
    rel="${entry#"$DOTFILES/$pkg"/}"
    target="$TARGET/$rel"
    [[ -e "$target" || -L "$target" ]] || continue
    [[ "$(basename "$rel")" == .DS_Store ]] && continue

    resolved="$(realpath "$target" 2>/dev/null || true)"
    [[ "$resolved" == "$DOTFILES"/* ]] && continue            # already linked here
    [[ -d "$entry" && -d "$target" && ! -L "$target" ]] && continue # real dir, stow merges into it
    backup "$target"
  done < <(find "$DOTFILES/$pkg" -mindepth 1 -print0)
done

# 6. link
stow_flags=(-d "$DOTFILES" -t "$TARGET" --ignore='\.DS_Store' -v)
if ((DRY_RUN)); then
  if ((backed_up)); then
    echo "Dry run: skipping stow simulation (it would report the files above as conflicts)."
    exit 0
  fi
  stow_flags+=(-n)
fi
stow "${stow_flags[@]}" -R "${packages[@]}"

((DRY_RUN)) || echo "Done."
