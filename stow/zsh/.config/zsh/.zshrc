#!/bin/zsh
#
# ~/.zshrc: Main configuration file for the Zsh shell.
#

# -----------------------------------------------------------------------------
# SECTION 1: ENVIRONMENT & PATH
#
# Set up the shell environment, locale, and command search path.
# -----------------------------------------------------------------------------

# Set the default language and ensure all locale settings use UTF-8.
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR='vim'
export KEYTIMEOUT=1

# ---- Homebrew & coreutils for *all* interactive shells ----
if [[ "$(uname)" == "Darwin" ]]; then
  # 1) make sure Homebrew itself is on $PATH
  if [[ -d /opt/homebrew/bin ]]; then
    PATH="/opt/homebrew/bin:$PATH"      # Apple-Silicon Macs
  elif [[ -d /usr/local/bin ]]; then
    PATH="/usr/local/bin:$PATH"         # Intel Macs or Linuxbrew
  fi

  # 2) put GNU coreutils wrappers first, if they exist
  if command -v brew &>/dev/null; then
    coreutils_bin="$(brew --prefix coreutils 2>/dev/null)/libexec/gnubin"
    [[ -d $coreutils_bin ]] && PATH="$coreutils_bin:$PATH"
  fi

  export PATH
fi


# -----------------------------------------------------------------------------
# SECTION 1A: XDG BASE DIRECTORIES 
#
# Define standard locations per the XDG spec and configure directories 
# -----------------------------------------------------------------------------

export XDG_DATA_HOME="${HOME}/.local/share" # user-specific data files
export XDG_CONFIG_HOME="${HOME}/.config" # user-specific configuration files
export XDG_STATE_HOME="${HOME}/.local/state" # user-specific state data
export XDG_CACHE_HOME="${HOME}/.cache" # user-specific non-essential data
export XDG_RUNTIME_DIR="${XDG_STATE_HOME}/runtime" # user-specific runtime files and other file objects

export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"



# -----------------------------------------------------------------------------
# SECTION 2: HISTORY
#
# Configure command history settings.
# -----------------------------------------------------------------------------

HISTSIZE=10000
SAVEHIST=10000
mkdir -p ~/.cache/zsh
HISTFILE=~/.cache/zsh/history

# -----------------------------------------------------------------------------
# SECTION 3: COMPLETION SYSTEM
#
# Initialize and configure Zsh's tab-completion system.
# -----------------------------------------------------------------------------

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# Include hidden files (dotfiles) in completion results.
_comp_options+=(globdots)

# For the custom 'ls' alias, hide standard macOS folders from tab-completion.
zstyle ':completion:*' ignored-patterns \
    'Applications' 'Desktop' 'Documents' \
    'Library' 'Movies' 'Music' 'Pictures' 'Downloads'

# -----------------------------------------------------------------------------
# SECTION 4: KEYBINDINGS & ZSH LINE EDITOR (ZLE)
#
# Configure the command-line editing experience, including Vi mode and custom keys.
# -----------------------------------------------------------------------------

# --- Enable Vi Mode ---
bindkey -v

# --- Vi Keys for Completion Menu ---
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# --- Standard Keybindings ---
bindkey '^e' edit-command-line     # Edit the current command in $EDITOR (Ctrl+e).

# --- Edit Command in Vim (Ctrl+e) ---
autoload -U edit-command-line
zle -N edit-command-line

# --- Dynamic Cursor Shape for Vi Mode ---
# Changes cursor to a block in normal mode and a beam in insert mode.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q' # Block cursor
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q' # Beam cursor
  fi
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins # Start in vi insert mode.
  echo -ne "\e[5 q" # Set beam cursor on startup.
}
zle -N zle-line-init
preexec() {
  echo -ne '\e[5 q' # Set beam cursor for each new prompt.
}

# Set initial cursor shape on shell startup
echo -ne '\e[5 q'

# -----------------------------------------------------------------------------
# SECTION 5: ALIASES & CUSTOM FUNCTIONS
#
# Define custom shortcuts and helper functions.
# -----------------------------------------------------------------------------

# --- Aliases ---

# Use GNU 'ls' with custom flags to group directories first and hide stock macOS folders.
alias ls='ls --group-directories-first --color=auto \
    --hide=Applications --hide=Desktop --hide=Documents \
    --hide=Library --hide=Movies --hide=Music \
    --hide=Pictures --hide=Downloads'

alias v='nvim'

alias cdvrc='cd ~/.config/nvim'
alias cdzsh='v ~/.zshrc'

# -----------------------------------------------------------------------------
# SECTION 6: PROMPT
#
# Configure the appearance of the shell prompt (PS1).
# -----------------------------------------------------------------------------

autoload -U colors && colors
# [user@hostname current_directory]$
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


# -----------------------------------------------------------------------------
# SECTION 7: SOURCING PERSONAL & PLATFORM-SPECIFIC CONFIGS
#
# -----------------------------------------------------------------------------

# Source local Zsh configuration if it exists
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Source custom aliases and shortcuts if they exist
if [[ -f "$HOME/.config/aliasrc" ]]; then
    source "$HOME/.config/aliasrc"
fi
if [[ -f "$HOME/.config/shortcutrc" ]]; then
    source "$HOME/.config/shortcutrc"
fi

# Source termux specific aliases if running in Termux on Android
if [[ -n "$TERMUX_VERSION" ]]; then
    alias copy="termux-clipboard-set"
fi

# -----------------------------------------------------------------------------
# SECTION 8
#
# python venv_wrapper
#
# Usage:
#
# $ mkenv myvirtualenv # creates venv under ~/.virtualenvs/
# $ venv myvirtualenv # activates venv
# $ deactivate # deactivates venv
# $ rmvenv myvirtualenv # removes venv
# 
# -----------------------------------------------------------------------------

export VENV_HOME="$HOME/.virtualenvs"
[[ -d $VENV_HOME ]] || mkdir -p $VENV_HOME

lsvenv() {
    ls -1 $VENV_HOME
}

venv() {
    if [ $# -eq 0 ]; then
        echo "Please provide venv name"
    else
# source "$VENV_HOME/$1/bin/activate"  # commented out by conda initialize
    fi
}

mkvenv() {
    if [ $# -eq 0 ]; then
        echo "Please provide venv name"
    else
        python3 -m venv "$VENV_HOME/$1"
    fi
}

rmvenv() { # Corrected function name from rmenv
    if [ $# -eq 0 ]; then
        echo "Please provide venv name"
    else
        rm -r "$VENV_HOME/$1"
    fi
}
# -----------------------------------------------------------------------------
# SECTION 9
#
# Initialize pyenv in interactive login
# # -----------------------------------------------------------------------------

if command -v pyenv >/dev/null; then
  eval "$(pyenv init --path)"   # sets PATH early (shell-recommended)
  eval "$(pyenv init -)"        # adds completions & shell functions
fi

# -----------------------------------------------------------------------------
# SECTION 10
#
# Load Zsh plugins.
# IMPORTANT: This section should be the very last part of the file.
# -----------------------------------------------------------------------------

if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

