# Minimal Fast Zsh Config

# History
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_EXPIRE_DUPS_FIRST
export HISTSIZE=50000 SAVEHIST=50000 HISTFILE=~/.zsh_history

# Completion - cached
autoload -Uz compinit && compinit -C -d ~/.cache/zsh/zcompdump

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
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --ansi'
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
if [[ -n $(whence -w fzf-history-widget) ]]; then
  bindkey '^R' fzf-history-widget
else
  # Fallback to native zsh history search
  bindkey '^R' history-incremental-search-backward
fi

# Nord colors (bright for dark bg)
NORD7="%F{15}"     # Nord7 (white)
NORD8="%F{14}"     # Nord8 (cyan)
NORD9="%F{9}"      # Nord9 (red)
NORD10="%F{10}"    # Nord10 (green)
NORD11="%F{9}"     # Nord11 (red) - brighter
NORD12="%F{12}"    # Nord12 (blue)
NORD13="%F{13}"    # Nord13 (magenta)
NORD14="%F{10}"    # Nord14 (green) - brighter

# Prompt - Nord theme, with execution time and status
preexec() {
  _cmd_start=$EPOCHREALTIME
  _cmd_exectime=$(date +%H:%M:%S)
}
precmd() {
  local elapsed=""
  if [[ -n "$_cmd_start" ]]; then
    local now=$EPOCHREALTIME
    local elapsed_ms=$(( (now - _cmd_start) * 1000 ))
    local elapsed_s=$(( elapsed_ms / 1000 ))
    local ms=$(( elapsed_ms % 1000 ))
    elapsed="${elapsed_s}.$(( ms / 100 ))s"
  fi
  local git_branch=""
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    git_branch="$(git branch --show-current 2>/dev/null)"
    [[ -n "$git_branch" ]] && git_branch=" ${NORD13}⭠${git_branch}%f"
  fi
  local lang_info=""
  if [[ -f package.json ]]; then
    local node_v=$(node -v 2>/dev/null)
    [[ -n "$node_v" ]] && lang_info=" ${NORD10}●node${node_v}%f"
  elif [[ -f Cargo.toml ]]; then
    local rust_v=$(rustc --version 2>/dev/null | awk '{print $2}')
    [[ -n "$rust_v" ]] && lang_info=" ${NORD9}●rust${rust_v}%f"
  elif [[ -f go.mod ]]; then
    local go_v=$(go version 2>/dev/null | awk '{print $3}')
    [[ -n "$go_v" ]] && lang_info=" ${NORD12}●${go_v}%f"
  elif [[ -f pyproject.toml || -f requirements.txt ]]; then
    local py_v=$(python3 --version 2>/dev/null | awk '{print $2}')
    [[ -n "$py_v" ]] && lang_info=" ${NORD14}●py${py_v}%f"
  fi
  local cmd_status="%F{9}✗%f"
  [[ $? -eq 0 ]] && cmd_status="%F{10}✓%f"
  PS1="${NORD8}${_cmd_exectime}%f${git_branch}${lang_info} ${NORD7}%n ${NORD14}%1~ ${NORD14}${elapsed} ${cmd_status} ${NORD11}› %F{15}"
}
PS2='%F{12} %_ %f '

# Load plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Zcompile for faster startup
if [[ -n "$HOME/.zshrc" ]]; then
  zcompile ~/.zshrc 2>/dev/null
fi
