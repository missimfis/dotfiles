# Minimal Fast Zsh Config

zmodload zsh/datetime

# Completion - cached
autoload -Uz compinit && compinit -C -d ~/.cache/zsh/zcompdump

# Load modular configs
[[ -f ~/.config/zsh/exports.zsh ]] && source ~/.config/zsh/exports.zsh
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh

# History (after exports so this overrides any HISTFILE from there)
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_EXPIRE_DUPS_FIRST
export HISTSIZE=50000 SAVEHIST=50000 HISTFILE=~/.zsh_history

# Options
setopt AUTO_CD EXTENDED_GLOB NO_BEEP PROMPT_SUBST NO_CORRECT_ALL INTERACTIVE_COMMENTS GLOB_DOTS

# Path
typeset -U path
path=(
  ~/.local/bin
  ~/.cargo/bin
  ~/.npm-global/bin
  ~/bin
  /usr/local/bin
  /usr/local/games
  $path
)

# Editor
export EDITOR=nvim
export VISUAL=nvim

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_R_OPTS='--height=60% --reverse --ansi --tac'
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh

# Zoxide
eval "$(zoxide init zsh)"

# Aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias la='eza -la --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --style=auto --paging=never'
alias find='fd'
alias top='btop'
alias g='lazygit'
alias v='nvim'
alias c='clear'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash'
alias gl='git log --oneline --graph --decorate'

# Quick functions
ff() { fzf --height=60% --reverse --bind 'enter:execute(nvim {})+abort' }
gf() { rg --smart-case --hidden "$1" | fzf --height=60% --reverse --ansi }

# FZF History Search (Ctrl+R) - overrides default zsh history
if (( $+functions[fzf-history-widget] )); then
  bindkey '^R' fzf-history-widget
else
  bindkey '^R' history-incremental-search-backward
fi

# Nord colors
NORD7="%F{15}"     # white
NORD8="%F{14}"     # cyan
NORD9="%F{9}"      # bright red
NORD10="%F{10}"    # bright green
NORD12="%F{12}"    # bright blue
NORD13="%F{13}"    # bright magenta
NORD14="%F{10}"    # green
NORD11="%F{9}"     # red (for prompt arrow)

# Prompt - Nord theme, with execution time and status
preexec() {
  _cmd_start=$EPOCHREALTIME
  _cmd_exectime=${(%):-%D{%H:%M:%S}}
}

_prompt_dir=""
_prompt_git=""
_prompt_lang=""

precmd() {
  local last_rc=$?
  local elapsed=""
  if [[ -n "$_cmd_start" ]]; then
    local now=$EPOCHREALTIME
    local elapsed_ms=$(( (now - _cmd_start) * 1000 ))
    local elapsed_s=$(( elapsed_ms / 1000 ))
    local ms=$(( elapsed_ms % 1000 ))
    elapsed="${elapsed_s}.$(( ms / 100 ))s"
  fi

  if [[ "$PWD" != "$_prompt_dir" ]]; then
    _prompt_dir="$PWD"
    _prompt_git=""
    _prompt_lang=""

    if git rev-parse --is-inside-work-tree &>/dev/null; then
      local branch="$(git branch --show-current 2>/dev/null)"
      [[ -n "$branch" ]] && _prompt_git=" ${NORD13}⭠${branch}%f"
    fi

    if [[ -f package.json ]]; then
      local v=$(node -v 2>/dev/null)
      [[ -n "$v" ]] && _prompt_lang=" ${NORD10}●node${v}%f"
    elif [[ -f Cargo.toml ]]; then
      local v=$(rustc --version 2>/dev/null | awk '{print $2}')
      [[ -n "$v" ]] && _prompt_lang=" ${NORD9}●rust${v}%f"
    elif [[ -f go.mod ]]; then
      local v=$(go version 2>/dev/null | awk '{print $3}')
      [[ -n "$v" ]] && _prompt_lang=" ${NORD12}●${v}%f"
    elif [[ -f pyproject.toml || -f requirements.txt ]]; then
      local v=$(python3 --version 2>/dev/null | awk '{print $2}')
      [[ -n "$v" ]] && _prompt_lang=" ${NORD14}●py${v}%f"
    fi
  fi

  local cmd_status="%F{9}✗%f"
  [[ $last_rc -eq 0 ]] && cmd_status="%F{10}✓%f"
  PS1="${NORD8}${_cmd_exectime}%f${_prompt_git}${_prompt_lang} ${NORD7}%n ${NORD14}%1~ ${NORD14}${elapsed} ${cmd_status} ${NORD11}› %F{15}"
}

PS2='%F{12} %_ %f '

# Load plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Zcompile for faster startup (only when source is newer)
local zshrc="$HOME/.zshrc"
local zwc="${zshrc}.zwc"
[[ "$zshrc" -nt "$zwc" ]] && zcompile "$zshrc" 2>/dev/null
