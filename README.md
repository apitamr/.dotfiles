# dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a stow package that mirrors the layout of `$HOME`.

## Packages

| Package    | Config for           |
| ---------- | -------------------- |
| `ghostty`  | Ghostty terminal     |
| `git`      | Git                  |
| `herdr`    | herdr                |
| `nvim`     | Neovim               |
| `starship` | Starship prompt      |
| `tmux`     | tmux                 |
| `zed`      | Zed editor           |
| `zsh`      | zsh (oh-my-zsh)      |

`bg/` (wallpapers) and `graphify-out/` are not stow packages.

## Install

```sh
git clone https://github.com/apitamr/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` installs Homebrew, the `Brewfile` and oh-my-zsh, then stows every package.
Existing files are backed up to `~/.dotfiles-backup/`. It is safe to re-run.

```sh
./install.sh nvim zsh   # stow only these packages
./install.sh --no-brew  # skip Homebrew and the Brewfile
./install.sh -n         # dry run
```
