#!/usr/bin/env bash

#===============================================================================
# macOS Development Environment Bootstrap Script
# Run with: curl -fsSL https://raw.githubusercontent.com/Vib1240n/Dotfiles/main/bootstrap.sh | bash
#===============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_REPO="https://github.com/Vib1240n/Dotfiles.git"
DEV_DIR="$HOME/Development"
DOTFILES_DIR="$DEV_DIR/dotfiles"

#===============================================================================
# Helper Functions
#===============================================================================

print_step() {
    echo -e "${BLUE}==>${NC} ${1}"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_error() {
    echo -e "${RED}✗${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} ${1}"
}

check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is only for macOS"
        exit 1
    fi
    print_success "Running on macOS"
}

install_xcode_tools() {
    print_step "Checking for Xcode Command Line Tools..."
    
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools already installed at $(xcode-select -p)"
    else
        print_warning "Xcode Command Line Tools not found. Installing..."
        
        # Trigger the installation
        xcode-select --install
        
        # Wait for user to complete installation
        echo ""
        print_warning "Please complete the Xcode Command Line Tools installation in the popup window."
        print_warning "Press ENTER after the installation is complete..."
        read -r
        
        # Verify installation
        if xcode-select -p &> /dev/null; then
            print_success "Xcode Command Line Tools installed successfully"
        else
            print_error "Xcode Command Line Tools installation failed or was cancelled"
            print_error "Please run 'xcode-select --install' manually and try again"
            exit 1
        fi
    fi
    
    # Accept Xcode license if needed
    if ! sudo xcodebuild -license check &> /dev/null; then
        print_warning "Xcode license needs to be accepted..."
        sudo xcodebuild -license accept
        print_success "Xcode license accepted"
    fi
}

#===============================================================================
# Main Setup Functions
#===============================================================================

create_directories() {
    print_step "Creating Development directory..."
    mkdir -p "$DEV_DIR"
    print_success "Created $DEV_DIR"
}

clone_dotfiles() {
    print_step "Cloning dotfiles repository..."
    
    if [ -d "$DOTFILES_DIR" ]; then
        print_warning "Dotfiles directory already exists. Pulling latest changes..."
        cd "$DOTFILES_DIR"
        git pull origin main
    else
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        print_success "Cloned dotfiles to $DOTFILES_DIR"
    fi
}

symlink_configs() {
    print_step "Creating symlinks..."
    
    # Backup existing configs
    if [ -d "$HOME/.config" ] && [ ! -L "$HOME/.config" ]; then
        print_warning "Backing up existing .config to .config.backup"
        mv "$HOME/.config" "$HOME/.config.backup"
    fi
    
    if [ -f "$HOME/.yabairc" ] && [ ! -L "$HOME/.yabairc" ]; then
        print_warning "Backing up existing .yabairc to .yabairc.backup"
        mv "$HOME/.yabairc" "$HOME/.yabairc.backup"
    fi
    
    # Create symlinks
    ln -sf "$DOTFILES_DIR/.config" "$HOME/.config"
    print_success "Symlinked .config"
    
    # Symlink .yabairc
    if [ -f "$DOTFILES_DIR/.yabairc" ]; then
        ln -sf "$DOTFILES_DIR/.yabairc" "$HOME/.yabairc"
        chmod +x "$HOME/.yabairc"
        print_success "Symlinked .yabairc"
    else
        print_warning ".yabairc not found in dotfiles"
    fi
    
    # Symlink zshrc if it exists
    if [ -f "$DOTFILES_DIR/.config/zshrc" ]; then
        ln -sf "$DOTFILES_DIR/.config/zshrc" "$HOME/.zshrc"
        print_success "Symlinked .zshrc"
    fi
}

install_homebrew() {
    print_step "Installing Homebrew..."
    
    if command -v brew &> /dev/null; then
        print_warning "Homebrew already installed. Updating..."
        brew update
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for this script
        if [[ $(uname -m) == 'arm64' ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed"
    fi
}

install_brew_packages() {
    print_step "Installing packages from Brewfile..."
    
    if [ ! -f "$HOME/.config/Brewfile" ]; then
        print_error "Brewfile not found at $HOME/.config/Brewfile"
        return 1
    fi
    
    cd "$HOME/.config"
    
    # Install everything except Bitwarden, yabai, and skhd (installed manually)
    print_warning "Installing all packages (excluding Bitwarden, yabai, skhd - install manually)"
    brew bundle --file="$HOME/.config/Brewfile" --no-upgrade
    
    print_success "Brew packages installed"
}

setup_macos_settings() {
    print_step "Configuring macOS settings..."
    
    # Enable Displays have separate Spaces (required for yabai)
    defaults write com.apple.spaces spans-displays -bool false
    
    print_success "macOS settings configured"
    print_warning "You need to log out and back in for Spaces changes to take effect"
}

start_services() {
    print_step "Starting services..."
    
    # Start sketchybar
    if command -v sketchybar &> /dev/null; then
        brew services start sketchybar 2>/dev/null || true
        print_success "Started sketchybar service"
    fi
    
    # Start borders
    if command -v borders &> /dev/null; then
        brew services start borders 2>/dev/null || true
        print_success "Started borders service"
    fi
}

final_instructions() {
    echo ""
    print_success "=================================="
    print_success "Bootstrap Complete!"
    print_success "=================================="
    echo ""
    print_warning "Next Steps:"
    echo "1. Install yabai and skhd manually:"
    echo "   brew install koekeishiya/formulae/yabai --HEAD"
    echo "   brew install koekeishiya/formulae/skhd --HEAD"
    echo ""
    echo "2. Set up codesigning certificates:"
    echo "   - Open Keychain Access"
    echo "   - Create certificates: yabai-cert and skhd-cert"
    echo "   - codesign -fs 'yabai-cert' \$(which yabai)"
    echo "   - codesign -fs 'skhd-cert' \$(which skhd)"
    echo ""
    echo "3. Configure yabai sudoers:"
    echo "   echo \"\$(whoami) ALL=(root) NOPASSWD: sha256:\$(shasum -a 256 \$(which yabai) | cut -d \" \" -f 1) \$(which yabai) --load-sa\" | sudo tee /private/etc/sudoers.d/yabai"
    echo ""
    echo "4. Grant Accessibility permissions:"
    echo "   - System Settings → Privacy & Security → Accessibility"
    echo "   - Add and enable: yabai, skhd, iTerm, Raycast"
    echo ""
    echo "5. Start yabai and skhd services:"
    echo "   yabai --start-service"
    echo "   skhd --start-service"
    echo ""
    echo "6. Install Bitwarden manually from:"
    echo "   https://bitwarden.com/download/"
    echo ""
    echo "7. Restart your terminal or run:"
    echo "   exec zsh"
    echo ""
    echo "8. Log out and back in for Spaces settings to take effect"
    echo ""
}

#===============================================================================
# Main Execution
#===============================================================================

main() {
    clear
    echo "=================================="
    echo "macOS Dev Environment Bootstrap"
    echo "=================================="
    echo ""
    
    check_macos
    install_xcode_tools
    create_directories
    clone_dotfiles
    symlink_configs
    install_homebrew
    install_brew_packages
    setup_macos_settings
    start_services
    final_instructions
}

# Run main function
main
