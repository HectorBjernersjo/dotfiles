NVM=0;
CONDA=0;
NVIM_THEME=0;
VIM_MODE=1;

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
DOTFILES_PATH="$HOME/dotfiles"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Set PATH

# Add in zsh plugins
# zinit light zsh-users/zsh-syntax-highlighting
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

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':autocomplete:*' default-context history-incremental-search-backward

# Aliases
alias ls='ls --color'
alias rm='trash'
alias vim='nvim'
alias nano='nvim'
alias neofetch='fastfetch'
alias tadd='pwd >> ~/.config/tmux/directories.txt'
alias hist='fc -l -n 0'
alias shist='fc -l -n 0 | fzf'
alias clip='clip.exe'
alias dir_stats='python3 $DOTFILES_PATH/scripts/dir_stats.py'
alias mv_dir='$DOTFILES_PATH/scripts/move_dir.sh'
alias cp_dir='$DOTFILES_PATH/scripts/copy_dir.sh'
alias padd='~/dotfiles/installation/addpkg.sh'
alias nvim_clear='rm -rf ~/.local/state/nvim/swap/*'

if [ $NVIM_THEME ]; then
    nvim_random_listen() {
        local random_number=$(od -An -N2 -i /dev/random | tr -d ' ')
        local server_name="/tmp/themelistener${random_number}"
        nvim --listen "$server_name" "$@"
    }
fi

# eval $(thefuck --alias)

if [ $CONDA ]; then
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
fi
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

if (( NVM )); then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/share/nvm/nvm.sh" ] && \. "/usr/share/nvm/nvm.sh"  # This loads nvm
    [ -s "/usr/share/nvm/bash_completion" ] && \. "/usr/share/nvm/bash_completion"  # This loads nvm bash_completion
fi

export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="$DOTFILES_PATH/allwaysinpath:$PATH"


# Dotnet setup
export PATH=$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH
export PATH=$PATH:~/Programs/netcoredbg
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH

export PASSWORD_STORE_DIR=/home/hector/drive/Ica/password-store
export EDITOR=nvim
export VISUAL=nvim

# Rocm setup
export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMD_SERIALIZE_KERNEL=3
export ROC_ENABLE_PREEMPTION=0
export HSA_ENABLE_SDMA=0

# Test for macbook but probably good either way
export XDG_SESSION_TYPE=wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland

# For cv2
export QT_QPA_PLATFORM=xcb
export LS_COLORS=$LS_COLORS:'ow=1;34:'


if [ $VIM_MODE ]; then
    set -o vi
    export KEYTIMEOUT=1
    function zle-keymap-select () {
      if [[ ${KEYMAP} == 'vicmd' ]]; then
        # Block cursor for command mode
        echo -ne '\e[2 q'
      else
        # I-beam cursor for insert mode
        echo -ne '\e[5 q'
      fi
    }

    # Ensure the correct cursor is displayed when the line editor is initialized
    function zle-line-init () {
      # I-beam cursor for insert mode
      echo -ne '\e[5 q'
    }

    # Tell ZLE to call our functions
    zle -N zle-keymap-select
    zle -N zle-line-init

    bindkey -M viins '^y' autosuggest-accept
    bindkey -M viins '^p' history-search-backward
    bindkey -M viins '^n' history-search-forward
    bindkey -M viins '^[w' kill-region
    bindkey -M viins "^[[1;5C" forward-word
    bindkey -M viins "^[[1;5D" backward-word
    bindkey -M viins "^[[3~" delete-char
    bindkey -M viins "^o" fzf-completion
fi

