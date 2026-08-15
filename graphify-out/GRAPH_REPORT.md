# Graph Report - /Users/apitamr/.dotfiles  (2026-07-13)

## Corpus Check
- Large corpus: 47 files · ~1,115,505 words. Semantic extraction will be expensive (many Claude tokens). Consider running on a subfolder.

## Summary
- 87 nodes · 58 edges · 38 communities (31 shown, 7 thin omitted)
- Extraction: 93% EXTRACTED · 5% INFERRED · 2% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.82)
- Token cost: 85,089 input · 56,725 output

## Community Hubs (Navigation)
- Stow-Managed Dotfile Packages
- Dotfiles Setup & Install
- Neovim Tree/Window Management
- Zed Cyberdream Theme
- Goku Ultra Instinct Artwork
- Zoro Portrait Artwork
- Install Script
- Lazygit Pager Config
- Stow Script
- Anime Cityscape Artwork
- Thunderstorm Cityscape Artwork
- Lazygit Editor Config

## God Nodes (most connected - your core abstractions)
1. `STOW_FOLDERS environment variable` - 10 edges
2. `M.toggle()` - 4 edges
3. `Dotfiles Repository` - 4 edges
4. `GNU Stow` - 4 edges
5. `M.open_current()` - 3 edges
6. `install script` - 3 edges
7. `has_real_buffer()` - 2 edges
8. `in_fullwindow_tree()` - 2 edges
9. `M.close_all_buffers()` - 2 edges
10. `Homebrew` - 2 edges

## Surprising Connections (you probably didn't know these)
- `install script` --references--> `STOW_FOLDERS environment variable`  [EXTRACTED]
  README.md → README.md  _Bridges community 2 → community 0_

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Set of stowable dotfiles packages managed together via STOW_FOLDERS** — readme_nvim_package, readme_zsh_package, readme_tmux_package, readme_ghostty_package, readme_zed_package, readme_lazygit_package, readme_gitconfig_package, readme_opencode_package, readme_fastfetch_package [EXTRACTED 1.00]

## Communities (38 total, 7 thin omitted)

### Community 0 - "Stow-Managed Dotfile Packages"
Cohesion: 0.20
Nodes (10): fastfetch package (System info display), ghostty package (Terminal emulator), gitconfig package (Git configuration), lazygit package (Git TUI), nvim package (Neovim configuration), opencode package (OpenCode AI assistant configuration), STOW_FOLDERS environment variable, tmux package (Terminal multiplexer) (+2 more)

### Community 2 - "Dotfiles Setup & Install"
Cohesion: 0.25
Nodes (9): macOS Dock auto-hide responsiveness, Dotfiles Repository, DOTFILES environment variable, GNU Stow, Homebrew, install script, macOS Keyboard Settings tuning, stow script (Quick Setup) (+1 more)

### Community 3 - "Neovim Tree/Window Management"
Cohesion: 0.48
Nodes (5): has_real_buffer(), in_fullwindow_tree(), M.close_all_buffers(), M.open_current(), M.toggle()

### Community 5 - "Zed Cyberdream Theme"
Cohesion: 0.33
Nodes (5): author, description, name, $schema, themes

### Community 6 - "Goku Ultra Instinct Artwork"
Cohesion: 1.00
Nodes (3): Goku (Dragon Ball character), goku-cosmic.jpg (cosmic digital art of Goku in Ultra Instinct, dark moody composition with fire and galaxy nebula effects), Ultra Instinct (silver-white hair transformation state)

## Ambiguous Edges - Review These
- `Minimalist black and white anime portrait` → `Roronoa Zoro (One Piece)`  [AMBIGUOUS]
  images/luffy.jpg · relation: depicts

## Knowledge Gaps
- **22 isolated node(s):** `$schema`, `name`, `description`, `author`, `themes` (+17 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Minimalist black and white anime portrait` and `Roronoa Zoro (One Piece)`?**
  _Edge tagged AMBIGUOUS (relation: depicts) - confidence is low._
- **Why does `STOW_FOLDERS environment variable` connect `Stow-Managed Dotfile Packages` to `Dotfiles Setup & Install`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **Why does `install script` connect `Dotfiles Setup & Install` to `Stow-Managed Dotfile Packages`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `$schema`, `name`, `description` to the rest of the system?**
  _22 weakly-connected nodes found - possible documentation gaps or missing edges._