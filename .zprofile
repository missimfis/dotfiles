if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec sway
fi
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"


# Added by `rbenv init` on Di 20 Jan 2026 20:19:40 CET
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"

# Start user runit services (runsvdir) at login (singleton via PID file)
if [ -d "$HOME/.runit/sv" ]; then
  pidfile="$HOME/.runit/runsvdir.pid"
  if ! kill -0 "$(cat "$pidfile" 2>/dev/null)" 2>/dev/null; then
    rm -f "$HOME/.runit/service" 2>/dev/null
    runsvdir "$HOME/.runit/sv" >/dev/null 2>&1 &
    echo $! > "$pidfile"
  fi
fi
