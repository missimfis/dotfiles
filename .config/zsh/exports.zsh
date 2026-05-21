#!/usr/bin/env zsh
# In exports.zsh (replace the four PATH lines with this block)
typeset -U path                         # unique, preserve order
path=(
  $HOME/.local/bin                      # local user scripts
  $HOME/.cargo/bin                      # Rust binaries
  $HOME/.local/share/go/bin             # Go binaries
  $HOME/.local/share/neovim/bin         # Neovim portable build
  $path                                 # keep whatever was already there (e.g. /usr/local/bin)
)
export PATH
# History (XDG location)
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
setopt APPEND_HISTORY EXTENDED_HISTORY   # keep timestamps

export EDITOR=nvim
export TERMINAL=foot
export BROWSER=librewolf

export MANPAGER='nvim +Man!'
export MANWIDTH=999

export XDG_CURRENT_DESKTOP=Wayland
export MOZ_ENABLE_WAYLAND=1

# Go environment (kept after PATH is built)
export GOPATH=$HOME/.local/share/go

# Initialise zoxide (still useful)

