# If you come from bash you might have to change your $PATH.
export GOPATH="$HOME/go"
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/jwt_tool/jwt_tool.py:$GOPATH/bin

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export NVM_DIR="$HOME/.nvm"
export HISTSIZE=10000
export WAYLAND_DISPLAY=wayland-1

# fzf theme
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  aliases
  docker
  docker-compose
  golang
  jsontools
)

if [ -f "$HOME/.hiddenrc" ]; then
  source ~/.hiddenrc
fi
source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Custom bindings
bindkey -s ^g "tmux-sessionizer\n"
bindkey -s ^n "nvim \n"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

###############
### Aliases ###
###############
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias dc='docker compose'
alias jt='docker run -it --network "host" --rm -v "${PWD}:/tmp" -v "${HOME}/.jwt_tool:/root/.jwt_tool" ticarpi/jwt_tool'
alias plog="sed 's/^[^{]*//' | jq"
alias zsstat='sudo grep -r . /sys/kernel/debug/zswap/'
alias zsinfo='sudo grep -r . /sys/module/zswap/parameters/'
alias dnuke='docker rm -f $(docker ps -aq) && docker system prune -af --volumes'


################
### Starship ###
################
eval "$(starship init zsh)"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

. /usr/share/nvm/init-nvm.sh
alias urlenc='jq -Rr @uri'
