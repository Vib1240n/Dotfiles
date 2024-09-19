# ZSH export and plugins for oh my zsh;
export ZSH="$HOME/.oh-my-zsh"
plugins=(git macos)
# neofetch
clear;fastfetch -c ~/.config/fastfetch/left.jsonc; print -n "\e[H"; fastfetch -c ~/.config/fastfetch/right.jsonc
#custom aliases
alias mcos="source /Users/bb8/Development/Bash\ Scriptss/mcos.sh"
alias dev="cd /Users/bb8/Development"
alias c="clear"
alias fa="cd /Users/bb8/Development/Flutter\ App/flutter_application_1"
alias restart="exec $SHELL -l"
alias sr="source ~/.zshrc"
alias aws="cd ~/Desktop/.Misc && ssh -i "vibhore-alex-ace-key.pem" ubuntu@ec2-3-226-119-86.compute-1.amazonaws.com"
alias ggs="cd ~/.aws && ssh -i "aws-ssh-connect.pem" ubuntu@ec2-35-90-4-112.us-west-2.compute.amazonaws.com"
alias gcom="source ~/Development/Bash\ Scriptss/gcommands.sh"
alias mgit="source ~/Development/Bash\ Scriptss/maingit.sh"
alias haas="cd /Users/bb8/Development/Home-Assistant"
alias acoj="cd /Users/bb8/Development/A-Cup-Of-Java"
alias sql="mysql -u root -p"
alias ppl="ppl.py"
alias cat=bat
alias ql=quick-look
alias postgres="LC_ALL='C' /opt/homebrew/opt/postgresql@16/bin/postgres -D /opt/homebrew/var/postgresql@16"
alias pgstart= "brew services start postgresql@16"
alias pgstop="brew services stop postgresql@16"
alias pgrestart="brew services restart postgresql@16"
alias bsl="brew services list"
alias phpstart="brew services start php"
alias phpstop="brew services stop php"
alias phprestart="brew services restart php"
alias phpnod="opt/homebrew/opt/php/sbin/php-fpm --nodaemonize"
alias zen_update="xattr -c '/Applications/Zen Browser.app/'"


source /opt/homebrew/opt/chruby/share/chruby/auto.sh
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# homebrew exports for formulas
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

export PATH="$HOME/.jenv/bin:$PATH"
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(oh-my-posh init zsh --config '~/.config/oh-my-posh/customomp.omp.json')"
export ANDROID_SDK_ROOT="/opt/homebrew/share/android-commandlinetools"
export PATH="/opt/homebrew/bin/pandoc:$PATH"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
function suyabai () {
    SHA256=$(shasum -a 256 $(which yabai) | awk "{print \$1;}")
    if [ -f "/private/etc/sudoers.d/yabai" ]; then
        sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'${SHA256}'/' /private/etc/sudoers.d/yabai
        echo "sudoers > yabai > sha256 hash update complete"
    else
        echo "sudoers file does not exist yet. Please create one before running this script."
    fi
}
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
