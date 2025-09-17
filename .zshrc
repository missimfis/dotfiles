setopt HIST_IGNORE_ALL_DUPS      # no duplicate history entries
setopt SHARE_HISTORY            # share history across terminals
setopt AUTO_CD                  # `cd` just by typing a directory name
setopt EXTENDED_GLOB            # richer globbing (e.g. **/*.txt)
setopt NO_BEEP                  # silence the terminal bell
setopt PROMPT_SUBST             # allow parameter expansion in PS1
setopt CORRECT                  # spell‑check command names (optional)
setopt INTERACTIVE_COMMENTS     # allow comments after commands
setopt APPEND_HISTORY EXTENDED_HISTORY

# History file location & size
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# Enable completion system (built‑in, no extra packages)
autoload -Uz compinit
compinit

# ----- Path ----------------------------------------------------
typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.rvm/bin
  $HOME/.cargo/bin
  $HOME/scripts/
  $path
)
export PATH


# Autosuggestions (if installed)
if [[ -r "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax highlighting (if installed)
if [[ -r "${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi


export MPD_HOST=localhost

# ----- SSH Agent – start only once -------------------------------
if [[ -z $SSH_AUTH_SOCK ]] && [[ -z $SSH_AGENT_PID ]]; then
    eval "$(ssh-agent -s)"
fi
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# ----- Plugins (keep what you need) ------------------------------
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"

# ----- Keybindings -----------------------------------------------
bindkey '^ ' autosuggest-accept   # Ctrl‑Space

# ----- Source auxiliary files ------------------------------------
source "$HOME/.config/zsh/aliases.zsh"
# If you have a heavy exports file, lazy‑load it:
# function load_my_exports { source "$HOME/.config/zsh/exports.zsh" }
# Colours (uses Zsh’s built‑in $fg[]/$bg[] arrays)
autoload -Uz colors && colors

# Helper to shorten the current working directory (~/ → ~)
prompt_dir() {
  local dir="${PWD/#$HOME/~}"
  echo "$dir"
}

# Prompt layout:
#   user@host  cwd  git‑branch  $
#   └─ colourised, compact, single‑line
PROMPT='%{$fg[green]%}%n@%m%{$reset_color%} '           # user@host
PROMPT+='%{$fg[blue]%}$(prompt_dir)%{$reset_color%} '   # cwd (shortened)
PROMPT+='%(?.%{$fg[magenta]%}✔.%{$fg[red]%}✘)%{$reset_color%} ' # success/failure
PROMPT+='%{$fg[yellow]%}$(git_prompt_info)%{$reset_color%}'   # git branch (if any)
PROMPT+='%{$fg[cyan]%}$ %{$reset_color%}'               # final $ prompt

# Git branch helper – pure Zsh, no external tools
git_prompt_info() {
  local ref=$(command git symbolic-ref --quiet HEAD 2>/dev/null) ||
               command git rev-parse --short HEAD 2>/dev/null
  [[ -n $ref ]] && echo "(${ref#refs/heads/})"
}
