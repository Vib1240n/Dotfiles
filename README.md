# Dotfiles

Personal macOS development environment configuration files.

## Features

- **Window Management**: yabai + skhd configurations (install manually)
- **Status Bar**: SketchyBar with custom widgets
- **Terminal**: iTerm2, Alacritty, and WezTerm configs
- **Shell**: ZSH with oh-my-posh theming
- **Editor**: Neovim (AstroNvim configuration)
- **Development Tools**: Complete brew package setup

## Quick Setup (Fresh macOS Install)

Run this single command in Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Vib1240n/Dotfiles/main/bootstrap.sh | bash
```

### What the bootstrap script does:

1. Creates `~/Development` directory
2. Clones this repository to `~/Development/dotfiles`
3. Symlinks `.config` directory to `~/.config`
4. Symlinks `.yabairc` to `~/.yabairc`
5. Installs Homebrew
6. Installs all packages from Brewfile (except yabai, skhd, and Bitwarden)
7. Configures macOS settings (Displays have separate Spaces)
8. Starts sketchybar and borders services

**Note**: yabai and skhd must be installed manually (see Post-Install Steps)

## Verifying/Updating Brewfile

Before using the bootstrap script, you may want to verify the Brewfile includes everything you need:

```bash
# Generate a fresh Brewfile from your current installation
cd ~/.config
brew bundle dump --describe --force

# Review the changes
git diff Brewfile
```

## Manual Setup

If you prefer to set things up manually:

```bash
# Create directories
mkdir -p ~/Development
cd ~/Development

# Clone repository
git clone https://github.com/Vib1240n/Dotfiles.git dotfiles
cd dotfiles

# Symlink configs
ln -sf ~/Development/dotfiles/.config ~/.config
ln -sf ~/Development/dotfiles/.yabairc ~/.yabairc

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
cd ~/.config
brew bundle

# Start services
brew services start sketchybar
brew services start borders
```

## Post-Install Steps

### 1. Install yabai and skhd (HEAD versions)

```bash
# Install
brew install koekeishiya/formulae/yabai --HEAD
brew install koekeishiya/formulae/skhd --HEAD
```

### 2. Set up codesigning certificates

Create self-signed certificates for yabai and skhd:

1. Open **Keychain Access**
2. Go to **Keychain Access → Certificate Assistant → Create a Certificate**
3. Create two certificates:
   - **Name**: `yabai-cert`, **Type**: Code Signing, **Identity**: Self-Signed Root
   - **Name**: `skhd-cert`, **Type**: Code Signing, **Identity**: Self-Signed Root

Then sign the binaries:

```bash
codesign -fs 'yabai-cert' $(which yabai)
codesign -fs 'skhd-cert' $(which skhd)
```

### 3. Configure yabai sudoers

```bash
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```

### 4. Grant Accessibility Permissions

Go to **System Settings → Privacy & Security → Accessibility** and enable:
- yabai
- skhd
- iTerm (or your terminal)
- Raycast

### 5. Start yabai and skhd services

```bash
yabai --start-service
skhd --start-service
```

### 6. Install Bitwarden Manually

The bootstrap script excludes Bitwarden - install it manually from [bitwarden.com/download](https://bitwarden.com/download/)

### 7. Restart Terminal

```bash
exec zsh
```

### 8. Log Out and Back In

Required for Spaces settings to take effect.

## Troubleshooting

### yabai/skhd not appearing in Accessibility settings

This is common on macOS Sequoia with HEAD versions. Make sure you:

1. Created the codesigning certificates (`yabai-cert` and `skhd-cert`)
2. Signed the binaries
3. Restarted the services after signing

### Services not starting

Check logs:
```bash
tail -f /tmp/yabai_$USER.err.log
tail -f /tmp/skhd_$USER.err.log
```

### Updating yabai/skhd from HEAD

After updating, re-sign and update sudoers:
```bash
brew upgrade yabai
codesign -fs 'yabai-cert' $(which yabai)
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
yabai --restart-service
```

## Directory Structure

```
.
├── .config/
│   ├── Brewfile          # Homebrew packages
│   ├── nvim/             # Neovim config (AstroNvim)
│   ├── skhd/             # Keyboard shortcuts
│   ├── sketchybar/       # Status bar config
│   ├── wezterm/          # WezTerm config
│   ├── alacritty/        # Alacritty config
│   ├── functions/        # Shell functions
│   └── zshrc             # ZSH configuration
├── .yabairc              # Yabai window manager config
├── bootstrap.sh          # Automated setup script
└── README.md             # This file
```

## Key Bindings (skhd)

See `.config/skhd/skhdrc` for full keybindings. Highlights:

- `hyper + h/j/k/l` - Focus window (left/down/up/right)
- `alt + shift + h/j/k/l` - Swap windows
- `hyper + 1-8` - Focus space 1-8
- `meh + 1-8` - Move window to space 1-8
- `meh + r` - Enter resize mode
- `meh + s` - Enter service mode
- `meh + return` - Enter launch mode

**Modifier Keys:**
- `hyper` = Ctrl + Shift + Alt + Cmd
- `meh` = Ctrl + Shift + Alt

## Notes

- **Brewfile**: The included Brewfile was created from an existing setup. Run `brew bundle dump --describe --force` in `~/.config` to generate a fresh one with your current packages.
- **yabai/skhd**: These are intentionally not auto-installed due to codesigning requirements on macOS Sequoia. Manual installation ensures proper setup.
- **Bitwarden**: Not included in Brewfile for security reasons - install manually.

## License

MIT
