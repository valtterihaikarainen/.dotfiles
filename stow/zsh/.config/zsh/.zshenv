# .zshenv 

#########################################################################################################
# XDG spec
#########################################################################################################
export XDG_DATA_HOME="${HOME}/.local/share" # user-specific data files
export XDG_CONFIG_HOME="${HOME}/.config" # user-specific configuration files
export XDG_STATE_HOME="${HOME}/.local/state" # user-specific state data
export XDG_CACHE_HOME="${HOME}/.cache" # user-specific non-essential data
export XDG_RUNTIME_DIR="${XDG_STATE_HOME}/runtime" # user-specific runtime files and other file objects
#########################################################################################################

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$XDG_STATE_HOME"/zsh/history
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

export PYENV_ROOT="$XDG_DATA_HOME"/pyenv

export PATH="$PYENV_ROOT/bin:$PATH"       
export PATH="$PYENV_ROOT/shims:$PATH"      


# uv
export PATH="/Users/valtterihaikarainen/.local/share/../bin:$PATH"
. "$HOME/.cargo/env"
