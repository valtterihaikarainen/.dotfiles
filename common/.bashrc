#!/usr/bin/env bash
#
# Bash Configuration File
# Personal shell environment settings, aliases, and custom prompt

# =============================================================================
# INITIAL CHECKS
# =============================================================================

# Exit if not running interactively
[[ -n $PS1 ]] || return

# =============================================================================
# SHELL BEHAVIOR
# =============================================================================

# Enable vi mode for command line editing
set -o vi

# Allow Ctrl+L to clear screen in both vi modes
bind -m vi-command '"\C-l": clear-screen'
bind -m vi-insert '"\C-l": clear-screen'

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

export GREP_COLOR='1;36'           # Cyan color for grep matches
export HISTCONTROL='ignoredups'    # Ignore duplicate commands in history
export HISTSIZE=5000               # Number of commands to remember
export HISTFILESIZE=5000           # Number of lines in history file
export LSCOLORS='ExGxbEaECxxEhEhBaDaCaD'  # BSD ls colors
export PAGER='less'                # Default pager

# =============================================================================
# SHELL OPTIONS
# =============================================================================

shopt -s cdspell        # Autocorrect minor spelling errors in cd
shopt -s checkwinsize   # Update LINES and COLUMNS after each command
shopt -s extglob        # Enable extended pattern matching

# Bash 4.0+ features (fail silently on older versions)
shopt -s autocd   2>/dev/null || true    # cd into directories by typing just the name
shopt -s dirspell 2>/dev/null || true    # Autocorrect directory names during completion

# =============================================================================
# ALIASES
# =============================================================================

alias ..='echo "cd .."; cd ..'     # Go up one directory (with feedback)
alias l='ls -a1 --color'           # List all files, one per line
alias ll='ls -lha'                 # Long format with human-readable sizes
alias v='vim'                      # Quick vim alias
alias parr='vardump'               # Use vardump instead of parr

# =============================================================================
# PROMPT COLORS
# =============================================================================
# Using 256-color mode for better terminal compatibility

readonly COLOR_RESET='\[\033[0m\]'
readonly COLOR_BOLD='\[\033[1m\]'
readonly COLOR_PROMPT='\[\033[38;5;251m\]'   # Light gray for decorative elements
readonly COLOR_ERROR='\[\033[38;5;197m\]'    # Bright red for errors
readonly COLOR_ROOT='\[\033[38;5;196m\]'     # Red for root user
readonly COLOR_USER='\[\033[38;5;33m\]'      # Blue for regular user
readonly COLOR_HOST='\[\033[38;5;136m\]'     # Yellow/orange for hostname
readonly COLOR_PATH='\[\033[38;5;64m\]'      # Green for path
readonly COLOR_GIT='\[\033[38;5;61m\]'       # Purple for git info

# =============================================================================
# PROMPT CONSTRUCTION
# =============================================================================

build_prompt() {
    # Start with newline for visual separation
    PS1="\n"
    
    # Show exit code of last command (only if non-zero)
    PS1+='$(ret=$?; [ $ret -ne 0 ] && echo "'${COLOR_ERROR}'✗ ($ret) '${COLOR_RESET}'")'
    
    # Username (bold red for root, blue for regular users)
    if [[ $EUID -eq 0 ]]; then
        PS1+="${COLOR_ROOT}${COLOR_BOLD}\u${COLOR_RESET}"
    else
        PS1+="${COLOR_USER}\u${COLOR_RESET}"
    fi
    
    # @ separator
    PS1+="${COLOR_PROMPT}@${COLOR_RESET}"
    
    # Hostname
    PS1+="${COLOR_HOST}\h${COLOR_RESET}"
    
    # Current directory
    PS1+=" ${COLOR_PROMPT}in${COLOR_RESET} ${COLOR_PATH}\w${COLOR_RESET}"
    
    # Git branch indicator (with dirty status)
    PS1+='$(
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n $branch ]]; then
            # Check if repository has uncommitted changes
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                echo " '${COLOR_GIT}'('${COLOR_BOLD}'$branch*'${COLOR_RESET}${COLOR_GIT}')'${COLOR_RESET}'"
            else
                echo " '${COLOR_GIT}'($branch)'${COLOR_RESET}'"
            fi
        fi
    )'
    
    # Prompt character ($ for user, # for root)
    PS1+="\n${COLOR_PROMPT}\$${COLOR_RESET} "
}

# =============================================================================
# TERMINAL TITLE
# =============================================================================

# Update terminal window title with user@host:path
_prompt_command() {
    local user=$USER
    local host=${HOSTNAME%%.*}  # Short hostname (strip domain)
    local pwd=${PWD/#$HOME/\~}  # Replace home dir with ~
    printf "\033]0;%s@%s:%s\007" "$user" "$host" "$pwd"
}

PROMPT_COMMAND=_prompt_command
PROMPT_DIRTRIM=3  # Show only last 3 directory levels in prompt

# =============================================================================
# PROFILE-SPECIFIC OVERRIDES
# =============================================================================

# Custom minimal prompt for YSAP iTerm profile
if [[ $ITERM_PROFILE == 'YSAP-'* ]]; then
    PS1="${COLOR_USER}dave${COLOR_RESET}"
    PS1+="${COLOR_PROMPT}@${COLOR_RESET}"
    PS1+="${COLOR_HOST}ysap${COLOR_RESET} "
    PS1+="${COLOR_PROMPT}❯${COLOR_RESET} "
    PROMPT_DIRTRIM=1  # Show only current directory
fi

# =============================================================================
# SYSTEM INFORMATION DISPLAY
# =============================================================================

# Display system info on shell startup (if fastfetch is installed)
if command -v fastfetch &>/dev/null; then
    fastfetch
fi

# =============================================================================
# COMPLETION
# =============================================================================

# Load bash completion (try system location first, then user location)
. /etc/bash/bash_completion 2>/dev/null ||
    . ~/.bash_completion 2>/dev/null

# Call the prompt building function
build_prompt

# Ensure script always exits successfully
true
