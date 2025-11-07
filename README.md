# Dotfiles

Personal configuration files for development environment setup.

> **Note:** Some configurations are optimized for macOS and may require adjustments for other operating systems.

## What's Included

- **nvim** - Neovim configuration with plugins and themes
- **zsh** - Shell configuration
- **tmux** - Terminal multiplexer configuration
- **ghostty** - Terminal emulator themes and config
- **zed** - Code editor themes and settings
- **lazygit** - Git TUI configuration
- **github-copilot** - GitHub Copilot CLI configuration
- **gitconfig** - Git configuration
- **opencode** - OpenCode AI assistant configuration

## Installation

### Prerequisites

Before setting up the dotfiles, ensure you have the following installed:

1. **Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```

2. **Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **GNU Stow** (via Homebrew)
   ```bash
   brew install stow
   ```

### Setup

Uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management.

> **Important:** Before running the installation scripts, make them executable:
> ```bash
> chmod +x stow install
> ```

### Quick Setup

```bash
./stow
```

### Manual Installation

```bash
# Set environment variables (optional)
export DOTFILES=$HOME/.dotfiles
export STOW_FOLDERS="tmux,zsh,nvim,ghostty,zed,lazygit,github-copilot,gitconfig,opencode"

# Run install script
./install
```

The install script will:

1. Remove any existing symlinks for each package
2. Create fresh symlinks to your home directory

## macOS Configuration

### Keyboard Settings

Improve keyboard responsiveness for faster typing:

```bash
# Reduce key repeat delay and increase repeat rate
defaults write -g InitialKeyRepeat -int 9
defaults write -g KeyRepeat -int 1
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Dock Settings

Make Dock auto-hide more responsive:

```bash
# Remove delay when auto-hiding Dock
defaults write com.apple.dock autohide-delay -int 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
killall Dock
```

## Structure

Each directory represents a package that can be independently stowed:

```
.dotfiles/
├── ghostty/          # Terminal emulator
├── github-copilot/   # GitHub Copilot CLI
├── gitconfig/        # Git configuration
├── lazygit/          # Git TUI
├── nvim/             # Neovim editor
├── opencode/         # OpenCode AI assistant
├── tmux/             # Terminal multiplexer
├── zed/              # Code editor
└── zsh/              # Shell
```

