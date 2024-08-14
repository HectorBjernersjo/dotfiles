# source ~/.zsh_autosuggest
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Set PATH
export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"

export DOTFILES_PATH=~/dotfiles

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

# Keybindings
bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char
bindkey "^o" fzf-completion

# History
HISTSIZE=5000
HISTFILESIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
unsetopt extended_history

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias tadd='pwd >> ~/.config/tmux/directories.txt'
alias history='fc -l -n 0 | fzf'
alias dir_stats='python3 $DOTFILES_PATH/scripts/dir_stats.py'
alias padd='~/dotfiles/installation/addpkg.sh'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
# bindkey '^I' autosuggest-accept

# # Improve cd suggestions
# _zsh_autosuggest_strategy_test() {
#   local suggestion
#   case $1 in
#     cd*)
# 	  # local curdir=$(pwd)
# 	  # echo $curdir
# 	  local options=$(\ls | awk '/^'$2'/' )
# 	  # printf $options
#       suggestion=$options
#       ;;
#     *)
#       # Default strategy: use history and suggestions
# escaped_text=$(printf "%q" "$1")
# suggestion=$(awk -v pat="$1" '$0 ~ "^([0-9]+ " pat ")"' ~/testfile | tail -n 1 | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')
#       ;;
#   esac
#
#   # Check if suggestion is empty
#   if [ -z "$suggestion" ]; then
#   else
#     printf "%s" "$suggestion"
#   fi
# }
#
# # Apply the new strategy
# # ZSH_AUTOSUGGEST_STRATEGY=test
#
# # Function to get top completion suggestion
# get_top_completion() {
#   local word="di"
#   local -a suggestions
#
#   # Enable completion system if not already enabled
#   autoload -Uz compinit && compinit
#
#   # Use _main_complete to generate completions for the word
#   suggestions=("${(@f)$(compadd -Q -U -a suggestions -- ${(z)word})}")
#
#   # Return the top suggestion
#   if [ -n "$suggestions[1]" ]; then
#     echo "$suggestions[1]"
#   else
#     echo "No suggestion found"
#   fi
# }
#
# # Example usage: get top completion for 'cd'
# get_top_completion "cd"
#

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/hector/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/hector/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/hector/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/hector/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Dotnet setup
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH
export PATH=$PATH:~/Programs/netcoredbg
export PASSWORD_STORE_DIR=/home/hector/Drive/Ica/password-store
export EDITOR=nvim

eval $(thefuck --alias)
