# ZSH export and plugins for oh my zsh;
# zmodload zsh/zprof
export ZSH="$HOME/.oh-my-zsh"
eval $(/opt/homebrew/bin/brew shellenv)
zstyle ':omz:plugins:nvm' lazy yes
plugins=(git macos nvm)
# neofetch

source $HOME/.config/functions/alias
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/bb8/.config/functions/functions.sh
c;fastfetch
# source /Users/bb8/Development/git-sync/git-sync
# source /Users/bb8/Development/git-sync/contrib/git-sync-on-inotify
 # for f in ~/Development/git-sync/*; do source $f; done
# # homebrew exports for formulas
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
# JENV CONFIG
export PATH="$HOME/.jenv/bin:$PATH"
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
# PYENV CONFIG
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(oh-my-posh init zsh --config '~/.config/oh-my-posh/customomp.omp.json')"
# EXPORTS
export ANDROID_SDK_ROOT="/opt/homebrew/share/android-commandlinetools"
export PATH="/opt/homebrew/bin/pandoc:$PATH"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
PRELINE="\r\033[A"

export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH="/opt/homebrew/opt/whois/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
alias ls="lsd -l"
alias csr='clear && sr'
alias ai='cursor'

alias vidconvert="source ~/Development/Bash\ Scriptss/vidconvert.sh"
alias haos="ssh -i ~/.ssh/id_rsa root@192.168.5.38 -p 22"
alias finderNotifOn="sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd"
alias finderNotifOff="sudo defaults delete Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification && sudo pkill diskarbitrationd"
# Function to sleep MacBook with optional delay in seconds
# clear;fastfetch -c ~/.config/fastfetch/left.jsonc -l none; print -n "\e[H"; fastfetch -c ~/.config/fastfetch/right.jsonc -l none
#
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi


export CONFIG=/Users/bb8/.config
# zprof
