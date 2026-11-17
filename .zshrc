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
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gsts='git stash'
alias gl='git log --oneline --graph --decorate'

alias pdfsmall='gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf in.pdf'
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
}

_prompt_dir=""
_prompt_git=""
_prompt_lang=""

precmd() {
  local last_rc=$?
  local elapsed=""
  if [[ -n "$_cmd_start" ]]; then
    elapsed=$(printf '%.2fs' $(( EPOCHREALTIME - _cmd_start )))
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
  PS1="${_prompt_git}${_prompt_lang} ${NORD7}%n ${NORD14}%1~ ${NORD14}${elapsed} ${cmd_status} ${NORD11}› %F{15}"
}

PS2='%F{12} %_ %f '

# Defer slow plugins to first prompt (saves ~80ms on startup)
autoload -Uz add-zsh-hook
_lazy_zsh_plugins() {
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  bindkey '^ ' autosuggest-accept
  add-zsh-hook -d precmd _lazy_zsh_plugins
}
add-zsh-hook precmd _lazy_zsh_plugins

# Zcompile for faster startup (only when source is newer)
local zshrc="$HOME/.zshrc"
local zwc="${zshrc}.zwc"
[[ "$zshrc" -nt "$zwc" ]] && zcompile "$zshrc" 2>/dev/null
export ATUIN_TMUX_POPUP=false
# shellcheck disable=SC2034,SC2153,SC2086,SC2155

# Above line is because shellcheck doesn't support zsh, per
# https://github.com/koalaman/shellcheck/wiki/SC1071, and the ignore: param in
# ludeeus/action-shellcheck only supports _directories_, not _files_. So
# instead, we manually add any error the shellcheck step finds in the file to
# the above line ...

# Source this in your ~/.zshrc
autoload -U add-zsh-hook

zmodload zsh/datetime 2>/dev/null

# If zsh-autosuggestions is installed, configure it to use Atuin's search. If
# you'd like to override this, then add your config after the $(atuin init zsh)
# in your .zshrc
_zsh_autosuggest_strategy_atuin() {
    # silence errors, since we don't want to spam the terminal prompt while typing.
    suggestion=$(ATUIN_QUERY="$1" atuin search --cmd-only --limit 1 --search-mode prefix 2>/dev/null)
}

if [ -n "${ZSH_AUTOSUGGEST_STRATEGY:-}" ]; then
    ZSH_AUTOSUGGEST_STRATEGY=("atuin" "${ZSH_AUTOSUGGEST_STRATEGY[@]}")
else
    ZSH_AUTOSUGGEST_STRATEGY=("atuin")
fi

if [[ -z "${ATUIN_SESSION:-}" || "${ATUIN_SHLVL:-}" != "$SHLVL" ]]; then
    export ATUIN_SESSION=$(atuin uuid)
    export ATUIN_SHLVL=$SHLVL
fi
ATUIN_HISTORY_ID=""

_atuin_preexec() {
    local id
    id=$(atuin history start -- "$1" 2>/dev/null)
    export ATUIN_HISTORY_ID="$id"
    __atuin_preexec_time=${EPOCHREALTIME-}
}

_atuin_precmd() {
    local EXIT="$?" __atuin_precmd_time=${EPOCHREALTIME-}

    [[ -z "${ATUIN_HISTORY_ID:-}" ]] && return

    local duration=""
    if [[ -n $__atuin_preexec_time && -n $__atuin_precmd_time ]]; then
        printf -v duration %.0f $(((__atuin_precmd_time - __atuin_preexec_time) * 1000000000))
    fi

    (ATUIN_LOG=error atuin history end --exit $EXIT ${duration:+--duration=$duration} -- $ATUIN_HISTORY_ID &) >/dev/null 2>&1
    export ATUIN_HISTORY_ID=""
}

# Check if tmux popup is available (tmux >= 3.2)
__atuin_tmux_popup_check() {
    [[ -n "${TMUX-}" ]] || return 1
    [[ "${ATUIN_TMUX_POPUP:-true}" != "false" ]] || return 1

    # https://github.com/tmux/tmux/wiki/FAQ#how-often-is-tmux-released-what-is-the-version-number-scheme
    local tmux_version
    tmux_version=$(tmux -V 2>/dev/null | sed -n 's/^[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\).*/\1/p') # Could have used grep...
    [[ -z "$tmux_version" ]] && return 1

    local m1 m2
    m1=${tmux_version%%.*}
    m2=${tmux_version#*.}
    m2=${m2%%.*}
    [[ "$m1" =~ ^[0-9]+$ ]] || return 1
    [[ "$m2" =~ ^[0-9]+$ ]] || m2=0
    (( m1 > 3 || (m1 == 3 && m2 >= 2) ))
}

# Use global variable to fix scope issues with traps
__atuin_popup_tmpdir=""
__atuin_tmux_popup_cleanup() {
    [[ -n "$__atuin_popup_tmpdir" && -d "$__atuin_popup_tmpdir" ]] && command rm -rf "$__atuin_popup_tmpdir"
    __atuin_popup_tmpdir=""
}

__atuin_search_cmd() {
    local -a search_args=("$@")

    if __atuin_tmux_popup_check; then
        __atuin_popup_tmpdir=$(mktemp -d) || return 1
        local result_file="$__atuin_popup_tmpdir/result"

        trap '__atuin_tmux_popup_cleanup' EXIT HUP INT TERM

        local escaped_query escaped_args
        escaped_query=$(printf '%s' "$BUFFER" | sed "s/'/'\\\\''/g")
        escaped_args=""
        for arg in "${search_args[@]}"; do
            escaped_args+=" '$(printf '%s' "$arg" | sed "s/'/'\\\\''/g")'"
        done

        # In the popup, atuin goes to terminal, stderr goes to file
        local cdir popup_width popup_height
        cdir=$(pwd)
        popup_width="${ATUIN_TMUX_POPUP_WIDTH:-80%}" # Keep default value anyways
        popup_height="${ATUIN_TMUX_POPUP_HEIGHT:-60%}"
        tmux display-popup -d "$cdir" -w "$popup_width" -h "$popup_height" -E -E -- \
            sh -c "PATH='$PATH' ATUIN_SESSION='$ATUIN_SESSION' ATUIN_SHELL=zsh ATUIN_LOG=error ATUIN_QUERY='$escaped_query' atuin search $escaped_args -i 2>'$result_file'"

        if [[ -f "$result_file" ]]; then
            cat "$result_file"
        fi

        __atuin_tmux_popup_cleanup
        trap - EXIT HUP INT TERM
    else
        ATUIN_SHELL=zsh ATUIN_LOG=error ATUIN_QUERY=$BUFFER atuin search "${search_args[@]}" -i 3>&1 1>&2 2>&3
    fi
}

_atuin_search() {
    emulate -L zsh
    zle -I

    # swap stderr and stdout, so that the tui stuff works
    # TODO: not this
    local output
    # shellcheck disable=SC2048
    output=$(__atuin_search_cmd $*)

    zle reset-prompt
    # re-enable bracketed paste
    # shellcheck disable=SC2154
    echo -n ${zle_bracketed_paste[1]} >/dev/tty

    if [[ -n $output ]]; then
        RBUFFER=""
        LBUFFER=$output

        if [[ $LBUFFER == __atuin_accept__:* ]]
        then
            LBUFFER=${LBUFFER#__atuin_accept__:}
            zle accept-line
        fi
    fi
}
_atuin_search_vicmd() {
    _atuin_search --keymap-mode=vim-normal
}
_atuin_search_viins() {
    _atuin_search --keymap-mode=vim-insert
}

_atuin_up_search() {
    # Only trigger if the buffer is a single line
    if [[ ! $BUFFER == *$'\n'* ]]; then
        _atuin_search --shell-up-key-binding "$@"
    else
        zle up-line
    fi
}
_atuin_up_search_vicmd() {
    _atuin_up_search --keymap-mode=vim-normal
}
_atuin_up_search_viins() {
    _atuin_up_search --keymap-mode=vim-insert
}

add-zsh-hook preexec _atuin_preexec
add-zsh-hook precmd _atuin_precmd

zle -N atuin-search _atuin_search
zle -N atuin-search-vicmd _atuin_search_vicmd
zle -N atuin-search-viins _atuin_search_viins
zle -N atuin-up-search _atuin_up_search
zle -N atuin-up-search-vicmd _atuin_up_search_vicmd
zle -N atuin-up-search-viins _atuin_up_search_viins

# These are compatibility widget names for "atuin <= 17.2.1" users.
zle -N _atuin_search_widget _atuin_search
zle -N _atuin_up_search_widget _atuin_up_search

bindkey -M emacs '^r' atuin-search
bindkey -M viins '^r' atuin-search-viins
bindkey -M vicmd '/' atuin-search
bindkey -M emacs '^[[A' atuin-up-search
bindkey -M vicmd '^[[A' atuin-up-search-vicmd
bindkey -M viins '^[[A' atuin-up-search-viins
bindkey -M emacs '^[OA' atuin-up-search
bindkey -M vicmd '^[OA' atuin-up-search-vicmd
bindkey -M viins '^[OA' atuin-up-search-viins
bindkey -M vicmd 'k' atuin-up-search-vicmd
# TUI uses an alternate screen, so no explicit cleanup is needed.
_atuin_ai_cleanup() {
    true
}

# Question mark at start of line - natural language mode.
# Named with 'self-' prefix so bracketed-paste-magic activates it during
# paste, allowing url-quote-magic to escape ? in pasted URLs via self-insert.
self-atuin-ai-question-mark() {
    # If buffer is empty or just contains '?', trigger natural language mode
    if [[ -z "$BUFFER" || "$BUFFER" == "?" ]]; then
        BUFFER=""
        local output
        output=$(atuin ai inline --hook 3>&1 1>&2 2>&3)

        # Clean up the inline viewport
        _atuin_ai_cleanup

        if [[ $output == __atuin_ai_print__:* ]]; then
            zle -I
            echo "${output#__atuin_ai_print__:}"
        elif [[ $output == __atuin_ai_cancel__ ]]; then
            zle reset-prompt
        elif [[ $output == __atuin_ai_execute__:* ]]; then
            RBUFFER=""
            LBUFFER=${output#__atuin_ai_execute__:}
            zle reset-prompt
            zle accept-line
        elif [[ $output == __atuin_ai_insert__:* ]]; then
            RBUFFER=""
            LBUFFER=${output#__atuin_ai_insert__:}
            zle reset-prompt
        elif [[ -n $output ]]; then
            RBUFFER=""
            LBUFFER=$output
            zle reset-prompt
        else
            zle reset-prompt
        fi
    else
        zle self-insert
    fi
}

# Set up keybindings
zle -N self-atuin-ai-question-mark
# Atuin ends here
