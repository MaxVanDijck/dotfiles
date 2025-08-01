# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="alanpeabody"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 14

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable warnings for insecure completion-dependent directories.
DISABLE_COMPFIX="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Only build completion cache once per day
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#

# fzf catpuccin theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Extract a number of commonly used compression formats
extract ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1    ;;
      *.tar.gz)  tar xzf $1    ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar $1      ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xf $1     ;;
      *.tbz2)    tar xjf $1    ;;
      *.tgz)     tar xzf $1    ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.deb)     ar x $1       ;;
      *.tar.xz)  tar xf $1     ;;
      *.tar.zst) unzstd        ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# alias to find Halter repos
repo () 
{
 dirs=()
 find ~/halter -type d -name "$1*" -mindepth 2 -maxdepth 2 | while read dir; do 
    dir=$(echo $dir | cut -d'/' -f5-) # remove the prefix
    dirs+=("$dir")
 done
 case ${#dirs[@]} in
   0) echo "No Halter repository matches pattern";;
   1) cd ~/halter/"${dirs[1]}"; clear;;
   *) 
     dir=$(printf '%s\n' "${dirs[@]}" | fzf --height 40% --layout=reverse --border --bind=k:up,j:down)
     cd ~/halter/"$dir"
     clear
     ;;
 esac
}

# Start docker container and attach
rund() {
 # Attach to container if running
 if [[ $(docker ps -q -f name=$1) ]]; then
    docker attach $1
    docker exec -it $1 bash
 else
    # If not running, start and attach to it
    docker start $1 && docker exec -it $1 bash
 fi
}

alias n=nvim

clearall () {
  tmux list-panes -s -F "#{pane_id} #{pane_current_command}" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -e zsh -e tmux | awk '{print $1}' | xargs -I{} tmux send-keys -t {} "clear" Enter
}

# Halter specific configuration
export PATH="$PATH:$HOME/.bin"
source ~/.halter_core
source ~/.halter_backend

# create predefined tmux sessions in a personal or halter directory
cns () {
  if [[ $# -eq 1 ]]; then
   dirs=()
   find ~/halter -type d -name "$1*" -mindepth 2 -maxdepth 2 | while read dir; do 
      dir=$(echo $dir | cut -d'/' -f5-) # remove the prefix
      dirs+=("$dir")
   done
   case ${#dirs[@]} in
     0) echo "No Halter repository matches pattern";;
     1) selected=~/halter/"${dirs[1]}";;
     *) 
       dir=$(printf '%s\n' "${dirs[@]}" | fzf --height 40% --layout=reverse --border --bind=k:up,j:down)
       selected=~/halter/"$dir"
       ;;
   esac
  else
    selected=$({ find ~/halter -type d -mindepth 2 -maxdepth 2; find ~/max -type d -mindepth 1 -maxdepth 1; find ~/halter/platform/concourse -type d -mindepth 1 -maxdepth 1} | fzf)
  fi


  base_directory=$(basename "$selected")


  # check if the session exists
  if tmux has-session -t "$base_directory" 2>/dev/null; then
    # switch to the existing session
    tmux switch -t "$base_directory:0.0" > /dev/null 2>&1
  else
    # create a new session if it doesn't exist
    tmux new-session -d -s "$base_directory" -c "$selected" > /dev/null 2>&1

    # create second window
    tmux new-window -d -t "$base_directory:1" -c "$selected" > /dev/null 2>&1

    # split the first window horizontally
    tmux split-window -h -t "$base_directory:1" -c "$selected" > /dev/null 2>&1

    # split the first window horizontally
    tmux split-window -v -t "$base_directory:1.1" -c "$selected" > /dev/null 2>&1

    # switch to created session
    tmux switch -t "$base_directory:1.0"
  fi
}


# Aliases for eza to replace ls
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons' 
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

alias lS='eza -1 --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config '~/.config/oh-my-posh/config.omp.json')"
fi

# Attach to most recent tmux session or start tmux if there is no session
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
 (tmux attach -t $(tmux list-sessions -F "#{session_id}" | head -n 1) || tmux new -s default) > /dev/null 2>&1
fi


# use asdf for java and python
. /opt/homebrew/opt/asdf/libexec/asdf.sh
. ~/.asdf/plugins/java/set-java-home.zsh

# tell uv not to install apple-silicon incompatible versions of python
export SYSTEM_VERSION_COMPAT=0

# Imagemagick
export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"
export SNACKS_GHOSTTY=true

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:/Users/maxvandijck/.spicetify
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/bin:$PATH"
# bun completions
[ -s "/Users/maxvandijck/.bun/_bun" ] && source "/Users/maxvandijck/.bun/_bun"

. "$HOME/.local/bin/env"
