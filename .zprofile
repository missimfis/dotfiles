if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec sway
fi
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


# Added by `rbenv init` on Di 20 Jan 2026 20:19:40 CET
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
