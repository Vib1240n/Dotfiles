#!/bin/bash

# Server Setup Script
# Usage: curl -sSL https://raw.githubusercontent.com/your-username/your-repo/main/server-setup.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Modify these as needed
GITHUB_USERNAME="vib1240n"
DOTFILES_REPO="Dotfiles"
PUBLIC_KEY_URL="https://github.com/${GITHUB_USERNAME}.keys"  # Your GitHub SSH keys

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to detect Linux distribution
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    elif [[ -f /etc/redhat-release ]]; then
        DISTRO="rhel"
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
    else
        error "Cannot detect Linux distribution"
        exit 1
    fi
}

# Display system information
show_system_info() {
    log "=== System Information ==="
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "OS: $PRETTY_NAME"
        echo "Kernel: $(uname -r)"
        echo "Architecture: $(uname -m)"
    fi
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo ""
}

# Update and upgrade system
update_system() {
    log "Updating system packages..."
    case $DISTRO in
        ubuntu|debian)
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -y
            apt-get upgrade -y
            apt-get install -y curl wget git vim htop unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release
            ;;
        centos|rhel|almalinux|rocky)
            yum update -y
            yum install -y curl wget git vim htop unzip epel-release
            yum groupinstall -y "Development Tools"
            ;;
        fedora)
            dnf update -y
            dnf install -y curl wget git vim htop unzip
            dnf groupinstall -y "Development Tools"
            ;;
        *)
            error "Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

# Install Docker
install_docker() {
    log "Installing Docker..."
    case $DISTRO in
        ubuntu|debian)
            # Add Docker's official GPG key
            curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DISTRO $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            apt-get update -y
            apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        centos|rhel|almalinux|rocky)
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        fedora)
            dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
    esac
    
    systemctl enable docker
    systemctl start docker
    
    # Add ubuntu user to docker group (will be created later)
    log "Docker installed successfully"
}

# Install Zsh and Oh My Zsh
install_zsh() {
    log "Installing Zsh and Oh My Zsh..."
    
    case $DISTRO in
        ubuntu|debian)
            apt-get install -y zsh
            ;;
        centos|rhel|almalinux|rocky|fedora)
            if command -v dnf &> /dev/null; then
                dnf install -y zsh
            else
                yum install -y zsh
            fi
            ;;
    esac
    
    # Install Oh My Zsh for root first
    if [[ ! -d ~/.oh-my-zsh ]]; then
        export RUNZSH=no
        export KEEP_ZSHRC=yes
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    fi
    
    log "Zsh and Oh My Zsh installed successfully"
}

# Change default shell to zsh
change_shell() {
    log "Changing default shell to zsh..."
    chsh -s $(which zsh) root
    
    # Create a basic .zshrc if it doesn't exist
    if [[ ! -f ~/.zshrc ]]; then
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    fi
}

# Create ubuntu user with full privileges
create_ubuntu_user() {
    log "Creating ubuntu user with full privileges..."
    
    # Create user if it doesn't exist
    if ! id "ubuntu" &>/dev/null; then
        case $DISTRO in
            ubuntu|debian)
                adduser --disabled-password --gecos "" ubuntu
                usermod -aG sudo ubuntu
                ;;
            centos|rhel|almalinux|rocky|fedora)
                useradd -m -s /bin/bash ubuntu
                usermod -aG wheel ubuntu
                ;;
        esac
    fi
    
    # Add to docker group
    usermod -aG docker ubuntu
    
    # Setup sudo without password
    case $DISTRO in
        ubuntu|debian)
            echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
            ;;
        centos|rhel|almalinux|rocky|fedora)
            echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
            # Ensure wheel group has sudo access
            if ! grep -q "^%wheel.*NOPASSWD" /etc/sudoers; then
                echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/wheel
            fi
            ;;
    esac
    
    # Install zsh and oh-my-zsh for ubuntu user
    sudo -u ubuntu bash -c '
        # Install Oh My Zsh for ubuntu user
        export RUNZSH=no
        export KEEP_ZSHRC=yes
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    '
    
    # Change ubuntu user shell to zsh
    chsh -s $(which zsh) ubuntu
    
    log "Ubuntu user created with full privileges"
}

# Setup SSH key authentication
setup_ssh() {
    log "Setting up SSH key authentication..."
    
    # Setup SSH for ubuntu user
    mkdir -p /home/ubuntu/.ssh
    chmod 700 /home/ubuntu/.ssh
    
    # Download public keys from GitHub
    if curl -fsSL "$PUBLIC_KEY_URL" -o /home/ubuntu/.ssh/authorized_keys; then
        log "Downloaded SSH keys from GitHub"
    else
        warn "Could not download SSH keys from GitHub. Manual setup required."
        touch /home/ubuntu/.ssh/authorized_keys
    fi
    
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    
    # Configure SSH daemon
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    
    # Update SSH configuration
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    
    # Restart SSH service
    systemctl restart sshd
    
    log "SSH key authentication configured"
}

# Install Neovim from official source
install_neovim() {
    log "Installing Neovim from official source..."
    
    # Remove old versions
    rm -rf /opt/nvim /usr/local/bin/nvim
    
    # Download and install latest Neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -C /opt -xzf nvim-linux64.tar.gz
    ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
    
    # Make available for ubuntu user
    sudo -u ubuntu bash -c 'echo "export PATH=\"/usr/local/bin:\$PATH\"" >> ~/.zshrc'
    
    log "Neovim installed successfully"
}

# Setup Neovim configuration
setup_nvim_config() {
    log "Setting up Neovim configuration..."
    
    # Setup for ubuntu user
    sudo -u ubuntu bash -c "
        cd ~
        mkdir -p ~/.config
        
        # Clone the Dotfiles repository
        if git clone https://github.com/${GITHUB_USERNAME}/${DOTFILES_REPO}.git ~/dotfiles; then
            echo 'Dotfiles repository cloned successfully'
            
            # Copy the nvim configuration from dotfiles to the correct location
            if [[ -d ~/dotfiles/.config/nvim ]]; then
                cp -r ~/dotfiles/.config/nvim ~/.config/
                echo 'Neovim configuration copied successfully'
            else
                echo 'Warning: .config/nvim not found in dotfiles repository'
            fi
            
            # Clean up the temporary dotfiles directory (optional)
            # rm -rf ~/dotfiles
        else
            echo 'Warning: Could not clone Dotfiles repository'
        fi
    "
    
    log "Neovim configuration setup complete"
}

# Main execution
main() {
    log "Starting server setup..."
    
    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
    
    # Detect distribution
    detect_distro
    log "Detected distribution: $DISTRO"
    
    # Run setup functions
    show_system_info
    update_system
    install_docker
    install_zsh
    change_shell
    create_ubuntu_user
    setup_ssh
    install_neovim
    setup_nvim_config
    
    log "=== Setup Complete ==="
    log "You can now SSH as ubuntu user: ssh ubuntu@your-server-ip"
    log "Docker is installed and ubuntu user has access"
    log "Default shell is now zsh with Oh My Zsh"
    log "Neovim is installed at /usr/local/bin/nvim"
    
    warn "IMPORTANT: Test SSH access as ubuntu user before closing this session!"
    warn "If SSH keys weren't downloaded, add your public key to /home/ubuntu/.ssh/authorized_keys"
}

# Run main function
main "$@"
