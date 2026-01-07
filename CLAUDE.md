# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick Setup Commands

```bash
# Fresh macOS setup (run from anywhere)
curl -fsSL https://raw.githubusercontent.com/Vib1240n/Dotfiles/main/bootstrap.sh | bash

# Manual setup
mkdir -p ~/Development && cd ~/Development
git clone https://github.com/Vib1240n/Dotfiles.git dotfiles
cd dotfiles && ln -sf ~/Development/dotfiles/.config ~/.config
brew bundle --file=~/.config/Brewfile
```

## Development Commands

**Package Management:**
```bash
# Update Brewfile from current system
cd ~/.config && brew bundle dump --describe --force

# Install/update packages
brew bundle --file=~/.config/Brewfile

# Check running services
brew services list
```

**Window Management (yabai/skhd):**
```bash
# Restart services
yabai --restart-service
skhd --restart-service

# Check logs
tail -f /tmp/yabai_$USER.err.log
tail -f /tmp/skhd_$USER.err.log

# Update yabai (HEAD version requires re-signing)
brew upgrade yabai
codesign -fs 'yabai-cert' $(which yabai)
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```

**Configuration Editing (via aliases):**
```bash
# Open common configs in nvim
zshrc          # Edit ~/.zshrc
nvimrc         # Edit ~/.config/nvim/
sketchybarrc   # Edit ~/.config/sketchybar/
yabairc        # Edit ~/.config (yabai config in .yabairc)
functions      # Edit ~/.config/functions/functions.sh
```

## Repository Architecture

### Core Structure
- **Bootstrap Script**: `bootstrap.sh` - Automated macOS setup
- **Configuration Root**: `.config/` - All application configs
- **Window Manager**: `.yabairc` - yabai configuration (symlinked to home)
- **Shell Config**: `.config/zshrc` - ZSH configuration

### Configuration Systems

**Window Management Stack:**
- `yabai` - Tiling window manager (BSP layout)
- `skhd` - Hotkey daemon for window controls
- `sketchybar` - Status bar with custom widgets
- `borders` - Window border enhancement

**Key Mappings Philosophy:**
- Letter-based workspace system (A=browsers, F=Fusion360, X=terminal, etc.)
- Hyper key (Ctrl+Alt+Shift+Cmd) for workspace switching
- Mode-based operation (resize, service, open, pass modes)
- 8 spaces across 2 displays (1-4 horizontal, 5-8 vertical)

### Development Environment

**Terminal Setup:**
- **Shell**: ZSH with oh-my-posh theming
- **Terminals**: iTerm2, Alacritty, WezTerm, Ghostty configs
- **Editor**: Neovim with AstroNvim configuration
- **Tools**: bat, lsd, ripgrep, lazygit pre-installed

**Language Environments:**
- **Python**: pyenv + pyenv-virtualenv
- **Node**: nvm (lazy-loaded for performance)
- **Java**: jenv with multiple OpenJDK versions
- **Ruby**: chruby + ruby-install

### Custom Functions & Aliases

**Navigation Shortcuts:**
```bash
dev        # cd ~/Development
config     # cd ~/.config
dotfiles   # cd ~/Development/dotfiles
```

**System Utilities:**
```bash
c          # clear
restart    # exec $SHELL -l
sr         # source ~/.zshrc
cat        # aliased to 'bat'
ls         # aliased to 'lsd -l'
```

## Important Configuration Files

**Core Window Management:**
- `.yabairc` - Window manager rules, layouts, signals
- `.config/skhd/skhdrc` - Hotkey bindings with mode system
- `.config/sketchybar/` - Status bar configuration (Lua-based)

**Shell Environment:**
- `.config/zshrc` - ZSH configuration with optimized startup
- `.config/functions/alias` - Custom aliases
- `.config/functions/functions.sh` - Shell functions

**Application Configs:**
- `.config/nvim/` - AstroNvim configuration
- `.config/Brewfile` - Homebrew package definitions
- `.config/raycast/` - Raycast extensions (auto-managed)

## Manual Setup Requirements

Some components require manual installation due to security restrictions:

**yabai & skhd (HEAD versions):**
1. `brew install koekeishiya/formulae/yabai --HEAD`
2. `brew install koekeishiya/formulae/skhd --HEAD`
3. Create codesigning certificates in Keychain Access
4. Sign binaries and configure sudoers

**Bitwarden:**
- Install manually from bitwarden.com (excluded from Brewfile for security)

**Accessibility Permissions:**
- Grant to yabai, skhd, iTerm, Raycast in System Settings

## Workspace System

The configuration uses a letter-based workspace system mapped to 8 numbered spaces:

**Display 1 (Horizontal - Spaces 1-4):**
- **A** (Space 1): Browsers (Arc, Zen, Chrome)
- **F** (Space 2): Fusion 360
- **B** (Space 3): 3D Printing (Bambu Studio, etc.)
- **W** (Space 4): Utilities (Wootility, Stats, etc.)

**Display 2 (Vertical - Spaces 5-8):**
- **D** (Space 5): Discord/Communication
- **X** (Space 6): Terminal applications
- **O** (Space 7): Obsidian
- **S** (Space 8): Music (Spotify, Music app)

Key bindings use Hyper (Ctrl+Alt+Shift+Cmd) + letter for workspace switching.

## Performance Considerations

**ZSH Optimization:**
- Completion caching enabled
- NVM lazy-loaded via oh-my-zsh plugin
- Minimal startup time focus

**Service Management:**
- sketchybar and borders auto-start via Homebrew services
- yabai/skhd use separate service management system

## Troubleshooting

**Common Issues:**
- yabai/skhd not appearing in Accessibility: Re-sign binaries after updates
- Services not starting: Check logs in `/tmp/` directory
- Slow shell startup: Profile with `zprof` (enable in zshrc)
- Window management not working: Verify Accessibility permissions and sudoers configuration