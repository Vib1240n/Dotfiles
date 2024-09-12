#!/bin/sh

# Run linux update

echo "Updating Linux..."
sudo apt update && sudo apt upgrade -y

# Installing packages
echo "Installing packages..."
sudo apt install -y git
sudo apt install -y build-essential
sudo apt install -y curl
sudo apt install -y wget
sudo apt install -y unzip

# Installing brew and cask
echo "Installing brew and cask..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

# Installing brew packages
echo "Installing brew packages..."
brew install neovim
brew install zsh


# Installing oh my zsh
echo "Installing oh my zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Installing oh my zsh plugins
echo "Installing oh my zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
