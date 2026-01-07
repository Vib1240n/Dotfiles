#!/bin/bash
# Arch Linux Hyprland Setup Script
# Automated installation of all packages and configuration
# GitHub Repo: https://github.com/Vib1240n/Linux-dots

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================================================="
echo "Arch Linux + Hyprland Automated Setup"
echo "========================================================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Do not run this script as root. Run as regular user with sudo privileges.${NC}"
    exit 1
fi

# Check internet connection
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo -e "${RED}No internet connection. Please connect and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}Internet connection confirmed.${NC}"
echo ""

# ============================================================================
# STEP 1: System Update
# ============================================================================
echo -e "${BLUE}Step 1: Updating system...${NC}"
sudo pacman -Syu --noconfirm

# ============================================================================
# STEP 2: Install Base Packages
# ============================================================================
echo ""
echo -e "${BLUE}Step 2: Installing base packages...${NC}"

sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    wget \
    curl \
    unzip \
    unrar \
    p7zip \
    vim \
    nano

# ============================================================================
# STEP 3: Install Wayland and Graphics
# ============================================================================
echo ""
echo -e "${BLUE}Step 3: Installing Wayland and graphics drivers...${NC}"

sudo pacman -S --needed --noconfirm \
    wayland \
    xorg-xwayland \
    mesa \
    vulkan-intel \
    libva-intel-driver \
    intel-media-driver

# ============================================================================
# STEP 4: Install Hyprland and Components
# ============================================================================
echo ""
echo -e "${BLUE}Step 4: Installing Hyprland and components...${NC}"

sudo pacman -S --needed --noconfirm \
    hyprland \
    hyprlock \
    hypridle \
    hyprpaper \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent

# ============================================================================
# STEP 5: Install Essential Applications
# ============================================================================
echo ""
echo -e "${BLUE}Step 5: Installing essential applications...${NC}"

sudo pacman -S --needed --noconfirm \
    kitty \
    nemo \
    rofi-wayland \
    waybar \
    swaync \
    dunst \
    libnotify \
    swww \
    grim \
    slurp \
    wl-clipboard \
    cliphist

# ============================================================================
# STEP 6: Install Audio System
# ============================================================================
echo ""
echo -e "${BLUE}Step 6: Installing audio system...${NC}"

sudo pacman -S --needed --noconfirm \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    wireplumber \
    pamixer \
    playerctl \
    pavucontrol

systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

# ============================================================================
# STEP 7: Install System Utilities
# ============================================================================
echo ""
echo -e "${BLUE}Step 7: Installing system utilities...${NC}"

sudo pacman -S --needed --noconfirm \
    brightnessctl \
    btop \
    fastfetch \
    jq \
    networkmanager \
    network-manager-applet \
    bluez \
    bluez-utils \
    blueman

# ============================================================================
# STEP 8: Install Fonts
# ============================================================================
echo ""
echo -e "${BLUE}Step 8: Installing fonts...${NC}"

sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk

# ============================================================================
# STEP 9: Install Theming Tools
# ============================================================================
echo ""
echo -e "${BLUE}Step 9: Installing theming tools...${NC}"

sudo pacman -S --needed --noconfirm \
    nwg-look \
    python-pywal

# ============================================================================
# STEP 10: Install Key Remapping
# ============================================================================
echo ""
echo -e "${BLUE}Step 10: Installing keyd for key remapping...${NC}"

sudo pacman -S --needed --noconfirm keyd
sudo systemctl enable keyd
sudo systemctl start keyd

# ============================================================================
# STEP 11: Install AUR Helper (yay)
# ============================================================================
echo ""
echo -e "${BLUE}Step 11: Installing yay (AUR helper)...${NC}"

if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    echo -e "${GREEN}yay installed successfully${NC}"
else
    echo -e "${GREEN}yay already installed${NC}"
fi

# ============================================================================
# STEP 12: Install AUR Packages
# ============================================================================
echo ""
echo -e "${BLUE}Step 12: Installing AUR packages...${NC}"

yay -S --needed --noconfirm \
    clipse \
    zen-browser-bin

# ============================================================================
# STEP 13: Clone Configuration Repository
# ============================================================================
echo ""
echo -e "${BLUE}Step 13: Cloning configuration repository...${NC}"

LINUX_DOTS_DIR="$HOME/Linux-dots"

if [ -d "$LINUX_DOTS_DIR" ]; then
    echo -e "${YELLOW}Linux-dots directory already exists. Backing up...${NC}"
    mv "$LINUX_DOTS_DIR" "$LINUX_DOTS_DIR.backup.$(date +%Y%m%d_%H%M%S)"
fi

git clone https://github.com/Vib1240n/Linux-dots.git "$LINUX_DOTS_DIR"

# ============================================================================
# STEP 14: Deploy Configurations
# ============================================================================
echo ""
echo -e "${BLUE}Step 14: Deploying configurations...${NC}"

mkdir -p ~/.config

# Backup existing configs
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
for dir in hypr rofi waybar swaync kitty btop nvim gtk-3.0 gtk-4.0 fastfetch; do
    if [ -d ~/.config/$dir ]; then
        echo "Backing up existing $dir config..."
        mv ~/.config/$dir ~/.config/$dir.backup.$TIMESTAMP
    fi
done

# Copy configurations
echo "Copying configurations from Linux-dots..."
cp -r "$LINUX_DOTS_DIR/hypr" ~/.config/
cp -r "$LINUX_DOTS_DIR/rofi" ~/.config/
cp -r "$LINUX_DOTS_DIR/waybar" ~/.config/
cp -r "$LINUX_DOTS_DIR/swaync" ~/.config/
cp -r "$LINUX_DOTS_DIR/kitty" ~/.config/
cp -r "$LINUX_DOTS_DIR/btop" ~/.config/
cp -r "$LINUX_DOTS_DIR/fastfetch" ~/.config/
cp -r "$LINUX_DOTS_DIR/nvim" ~/.config/
cp -r "$LINUX_DOTS_DIR/gtk-3.0" ~/.config/
cp -r "$LINUX_DOTS_DIR/gtk-4.0" ~/.config/

# ============================================================================
# STEP 15: Fix Hyprland Config for Arch
# ============================================================================
echo ""
echo -e "${BLUE}Step 15: Fixing Hyprland config for Arch...${NC}"

# Remove Asahi-specific environment variables
sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,mesa/d' ~/.config/hypr/hyprland.conf
sed -i '/env = LIBGL_ALWAYS_SOFTWARE,0/d' ~/.config/hypr/hyprland.conf

# Remove hyprpm reload
sed -i '/exec-once = hyprpm reload/d' ~/.config/hypr/hyprland.conf

# Remove invalid gesture syntax
sed -i '/^gesture = 4, horizontal, workspace$/d' ~/.config/hypr/hyprland.conf

# Remove invalid tag windowrules
sed -i '/windowrule = tag/d' ~/.config/hypr/hyprland.conf

# Fix battery device name
sed -i 's/"macsmc-battery"/"BAT0"/g' ~/.config/waybar/config.jsonc

# Make scripts executable
find ~/.config/hypr/scripts -type f -name "*.sh" -exec chmod +x {} \;
find ~/.config/waybar/scripts -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} \; 2>/dev/null || true
find ~/.config/rofi/scripts -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} \; 2>/dev/null || true

echo -e "${GREEN}Hyprland config fixed for Arch${NC}"

# ============================================================================
# STEP 16: Set Up keyd Configuration
# ============================================================================
echo ""
echo -e "${BLUE}Step 16: Setting up keyd configuration...${NC}"

sudo mkdir -p /etc/keyd

# Default config for all keyboards
sudo tee /etc/keyd/default.conf > /dev/null <<'KEYD_DEFAULT'
[ids]
*

[main]
capslock = overload(hyper, capslock)
leftshift = overload(shift, enter)
leftcontrol = overload(meh, leftcontrol)
f1 = mute
f2 = volumedown
f3 = volumeup
f4 = previoussong
f5 = playpause
f6 = nextsong
f7 = brightnessdown
f8 = brightnessup
f9 = f9
f10 = f10
f11 = f11
f12 = f12

[hyper:C-A-S-M]

[meh:C-A-S]
KEYD_DEFAULT

echo -e "${GREEN}keyd default config created${NC}"

# Internal keyboard config
INTERNAL_KB=$(cat /proc/bus/input/devices 2>/dev/null | grep -B 5 "AT Translated Set 2 keyboard" | grep "^I:" | head -1)
if [ -n "$INTERNAL_KB" ]; then
    VENDOR=$(echo "$INTERNAL_KB" | grep -oP 'Vendor=\K[0-9a-f]+')
    PRODUCT=$(echo "$INTERNAL_KB" | grep -oP 'Product=\K[0-9a-f]+')
    
    if [ -n "$VENDOR" ] && [ -n "$PRODUCT" ]; then
        sudo tee /etc/keyd/internal-keyboard.conf > /dev/null <<KEYD_INTERNAL
[ids]
${VENDOR}:${PRODUCT}

[main]
# Swap Left Alt and Left Meta for macOS-style layout
leftalt = leftmeta
leftmeta = leftalt

# Keep all other mappings
capslock = overload(hyper, capslock)
leftshift = overload(shift, enter)
leftcontrol = overload(meh, leftcontrol)
f1 = mute
f2 = volumedown
f3 = volumeup
f4 = previoussong
f5 = playpause
f6 = nextsong
f7 = brightnessdown
f8 = brightnessup
f9 = f9
f10 = f10
f11 = f11
f12 = f12

[hyper:C-A-S-M]

[meh:C-A-S]
KEYD_INTERNAL
        echo -e "${GREEN}Internal keyboard config created (${VENDOR}:${PRODUCT})${NC}"
    fi
fi

sudo systemctl restart keyd

# ============================================================================
# STEP 17: Create Necessary Directories
# ============================================================================
echo ""
echo -e "${BLUE}Step 17: Creating necessary directories...${NC}"

mkdir -p ~/Pictures/screenshots
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.cache/wal
mkdir -p ~/.cache/cliphist

# ============================================================================
# STEP 18: Set Up Auto-start Hyprland
# ============================================================================
echo ""
echo -e "${BLUE}Step 18: Setting up auto-start Hyprland on login...${NC}"

if ! grep -q "exec Hyprland" ~/.bash_profile 2>/dev/null; then
    cat >> ~/.bash_profile <<'BASH_PROFILE'

# Auto-start Hyprland on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec Hyprland
fi
BASH_PROFILE
    echo -e "${GREEN}Auto-start configured${NC}"
fi

# ============================================================================
# STEP 19: Enable Services
# ============================================================================
echo ""
echo -e "${BLUE}Step 19: Enabling system services...${NC}"

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

# ============================================================================
# STEP 20: Initialize Pywal
# ============================================================================
echo ""
echo -e "${BLUE}Step 20: Initializing pywal...${NC}"

if [ -d ~/Pictures/Wallpapers ] && [ "$(ls -A ~/Pictures/Wallpapers 2>/dev/null)" ]; then
    FIRST_WALLPAPER=$(ls ~/Pictures/Wallpapers/* | head -1)
    wal -i "$FIRST_WALLPAPER" -n
    echo -e "${GREEN}Pywal initialized${NC}"
else
    echo -e "${YELLOW}Add wallpapers to ~/Pictures/Wallpapers${NC}"
fi

# ============================================================================
# DONE
# ============================================================================
echo ""
echo "========================================================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "========================================================================="
echo ""
echo "Summary:"
echo "  ✓ System updated"
echo "  ✓ Hyprland and all components installed"
echo "  ✓ Configurations deployed from GitHub"
echo "  ✓ keyd configured (Capslock→Hyper, Meta/Alt swap on internal)"
echo "  ✓ Scripts made executable"
echo "  ✓ Auto-start configured"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Reboot: reboot"
echo "  2. Hyprland starts automatically on login"
echo "  3. Add wallpapers to ~/Pictures/Wallpapers"
echo "  4. Configure monitors in ~/.config/hypr/monitors.conf"
echo ""
echo -e "${BLUE}Keybindings:${NC}"
echo "  Ctrl + Space       → Rofi"
echo "  Hyper + H/J/K/L    → Focus windows (Capslock + HJKL)"
echo "  Meh + H/J/K/L      → Swap windows (Left Ctrl + HJKL)"
echo "  Super + Shift + 3  → Full screenshot"
echo "  Super + Shift + 4  → Area screenshot"
echo ""
echo -e "${GREEN}Ready to reboot!${NC}"
