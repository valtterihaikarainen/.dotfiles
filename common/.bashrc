#!/usr/bin/env bash
#
# If not running interactively, don't do anything
[[ -n $PS1 ]] || return
set -o vi
bind -m vi-command '"\C-l": clear-screen'
bind -m vi-insert '"\C-l": clear-screen'
# use vardump instead of parr
alias parr='vardump'
# Set environment
export GREP_COLOR='1;36'
export HISTCONTROL='ignoredups'
export HISTSIZE=5000
export HISTFILESIZE=5000
export LSCOLORS='ExGxbEaECxxEhEhBaDaCaD'
export PAGER='less'
# Shell Options
shopt -s cdspell
shopt -s checkwinsize
shopt -s extglob
# Bash Version >= 4
shopt -s autocd   2>/dev/null || true
shopt -s dirspell 2>/dev/null || true
# Aliases
alias ..='echo "cd .."; cd ..'
alias l='ls -a1 --color'
alias ll='ls -lha'
alias v='nvim'

# Define color codes - using 256 color mode for better compatibility
readonly COLOR_RESET='\[\033[0m\]'
readonly COLOR_BOLD='\[\033[1m\]'
readonly COLOR_PROMPT='\[\033[38;5;251m\]'
readonly COLOR_ERROR='\[\033[38;5;197m\]'
readonly COLOR_OS='\[\033[38;5;245m\]'
readonly COLOR_USER='\[\033[38;5;33m\]'    
readonly COLOR_HOST='\[\033[38;5;136m\]'   
readonly COLOR_PATH='\[\033[38;5;64m\]'    
readonly COLOR_GIT='\[\033[38;5;61m\]'     

# Build the prompt
build_prompt() {
    # Start with newline for breathing room (optional - remove if you don't like it)
    PS1="\n"
    
    # Exit code of last command (only shown if non-zero)
    PS1+='$(ret=$?; [ $ret -ne 0 ] && echo "'${COLOR_ERROR}'✗ ($ret) '${COLOR_RESET}'")'
    
    # Username (red for root, normal color otherwise)
    if [[ $EUID -eq 0 ]]; then
        PS1+="${COLOR_ROOT}${COLOR_BOLD}\u${COLOR_RESET}"
    else
        PS1+="${COLOR_USER}\u${COLOR_RESET}"
    fi
    
    # @ symbol
    PS1+="${COLOR_PROMPT}@${COLOR_RESET}"
    
    # Hostname
    PS1+="${COLOR_HOST}\h${COLOR_RESET}"
    
    # Current directory
    PS1+=" ${COLOR_PROMPT}in${COLOR_RESET} ${COLOR_PATH}\w${COLOR_RESET}"
    
    # Git branch (if in a git repository)
    PS1+='$(
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n $branch ]]; then
            # Check if repo is dirty
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                echo " '${COLOR_GIT}'('${COLOR_BOLD}'$branch*'${COLOR_RESET}${COLOR_GIT}')'${COLOR_RESET}'"
            else
                echo " '${COLOR_GIT}'($branch)'${COLOR_RESET}'"
            fi
        fi
    )'
    
    PS1+="${COLOR_PROMPT} \$${COLOR_RESET} "      # Classic $ or #
}

# Call the function to build the prompt
build_prompt

# Prompt command - sets the terminal title
_prompt_command() {
    local user=$USER
    local host=${HOSTNAME%%.*}
    local pwd=${PWD/#$HOME/\~}
    printf "\033]0;%s%s@%s:%s\007" "$user" "$host" "$pwd"
}
PROMPT_COMMAND=_prompt_command
PROMPT_DIRTRIM=3  # Show only last 3 directories in path

# Custom prompt for YSAP profile
if [[ $ITERM_PROFILE == 'YSAP-'* ]]; then
    PS1="${COLOR_USER}dave${COLOR_RESET}"
    PS1+="${COLOR_PROMPT}@${COLOR_RESET}"
    PS1+="${COLOR_HOST}ysap${COLOR_RESET} "
    PS1+="${COLOR_PROMPT}❯${COLOR_RESET} "
    PROMPT_DIRTRIM=1
fi


# load completion
. /etc/bash/bash_completion 2>/dev/null ||
	. ~/.bash_completion 2>/dev/null
true
