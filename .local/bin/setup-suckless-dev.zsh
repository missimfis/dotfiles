#!/usr/bin/env bash
#
# Suckless‑only developer environment
# • Minimal OS packages
# • dwm / st / dmenu (tiling WM, terminal, launcher)
# • tmux, neovim, git, make, gcc/clang
# • Dotfiles pulled from a Git repo (you can fork/modify)
#
# Usage (on a fresh machine):
#   curl -fsSL https://example.com/setup-suckless-dev.sh | bash -
#
# The script is deliberately terse – it prints what it does,
# aborts on errors, and leaves a log at ~/suckless-setup.log
#

set -euo pipefail
LOG=~/suckless-setup.log
exec > >(tee -a "$LOG") 2>&1

echo "=== Suckless Development Environment Installer ==="
echo "Start time: $(date)"
echo "Log: $LOG"
echo ""

# ----------------------------------------------------------------------
# 1. Detect package manager ------------------------------------------------
# ----------------------------------------------------------------------
if command -v apk >/dev/null; then   # Alpine
    PKG=apk
    UPDATE="apk update"
    INSTALL="apk add --no-cache"
elif command -v apt-get >/dev/null; then   # Debian/Ubuntu
    PKG=apt
    UPDATE="apt-get update"
    INSTALL="apt-get install -y"
elif command -v pacman >/dev/null; then   # Arch‑based
    PKG=pacman
    UPDATE="pacman -Sy"
    INSTALL="pacman -S --noconfirm"
elif command -v xbps-install >/dev/null; then   # Void
    PKG=xbps
    UPDATE="xbps-install -S"
    INSTALL="xbps-install -y"
else
    echo "❌ Unsupported distro – cannot find a known package manager."
    exit 1
fi

# ----------------------------------------------------------------------
# 2. System update & essential packages ---------------------------------
# ----------------------------------------------------------------------
echo "Updating package index..."
sudo $UPDATE

echo "Installing core utilities..."
sudo $INSTALL \
    git curl wget build-base \
    tmux zsh neovim \
    gcc clang make \
    libX11-devel libXft-devel libXinerama-devel \
    freetype-devel fontconfig-devel \
    libXrandr-devel libXrender-devel \
    libXext-devel

# ----------------------------------------------------------------------
# 3. Create a non‑root user (optional) ----------------------------------
# ----------------------------------------------------------------------
if id -u "$(whoami)" = 0; then
    # If we are root, create a regular user called 'dev' (feel free to rename)
    DEVUSER=${DEVUSER:-dev}
    if ! id "$DEVUSER" >/dev/null 2>&1; then
        echo "Creating user $DEVUSER ..."
        sudo useradd -m -s /bin/zsh "$DEVUSER"
        echo "$DEVUSER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$DEVUSER
    fi
    echo "Switching to $DEVUSER for the rest of the install."
    exec sudo -iu "$DEVUSER" "$0" "$@"
fi

# ----------------------------------------------------------------------
# 4. Clone dotfiles repo -------------------------------------------------
# ----------------------------------------------------------------------
DOTDIR=$HOME/.dotfiles
REPO_URL="https://github.com/yourname/suckless-dotfiles.git"   # <‑‑ replace with your own repo
if [ -d "$DOTDIR" ]; then
    echo "Dotfiles repo already exists – pulling latest changes."
    (cd "$DOTDIR" && git pull --rebase)
else
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTDIR"
fi

# ----------------------------------------------------------------------
# 5. Build and install suckless tools (dwm, st, dmenu) -------------------
# ----------------------------------------------------------------------
SUCKDIR=$HOME/src
mkdir -p "$SUCKDIR"
cd "$SUCKDIR"

build_suckless() {
    prog=$1
    url=$2
    echo "=== Building $prog ==="
    if [ -d "$prog" ]; then
        echo "Source dir exists – updating."
        (cd "$prog" && git pull --rebase)
    else
        git clone "$url" "$prog"
    fi
    cd "$prog"
    # copy our patched config.h from dotfiles (if present)
    if [ -f "$DOTDIR/$prog/config.h" ]; then
        cp "$DOTDIR/$prog/config.h" .
    fi
    make clean
    make
    sudo make install
    cd ..
}

# URLs point to the official suckless repos – you can fork them if you want
build_suckless dwm   https://git.suckless.org/dwm
build_suckless st    https://git.suckless.org/st
build_suckless dmenu https://git.suckless.org/dmenu

# ----------------------------------------------------------------------
# 6. Link dotfiles --------------------------------------------------------
# ----------------------------------------------------------------------
echo "Linking dotfiles..."
ln -sf "$DOTDIR/.zshrc"      "$HOME/.zshrc"
ln -sf "$DOTDIR/.tmux.conf"  "$HOME/.tmux.conf"
ln -sf "$DOTDIR/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim"
ln -sf "$DOTDIR/.Xresources" "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources"

# ----------------------------------------------------------------------
# 7. Set Zsh as default shell --------------------------------------------
# ----------------------------------------------------------------------
if [ "$(basename "$SHELL")" != "zsh" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
fi

# ----------------------------------------------------------------------
# 8. Enable autostart of dwm (Xorg) ---------------------------------------
# ----------------------------------------------------------------------
mkdir -p "$HOME/.xinitrc.d"
cat >"$HOME/.xinitrc" <<'EOF'
#!/bin/sh
# Load Xresources first
[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

# Start a minimal panel (optional)
# exec slstatus &

exec dwm
EOF
chmod +x "$HOME/.xinitrc"

# ----------------------------------------------------------------------
# 9. Final touches ---------------------------------------------------------
# ----------------------------------------------------------------------
echo ""
echo "=== Installation complete! ==="
echo "You can now start X with:"
echo "    startx"
echo ""
echo "Inside dwm you can:"
echo "  • Mod‑p  → dmenu (launch programs, ssh, tmux…)"
echo "  • Mod‑Shift‑Enter → open a new st terminal"
echo "  • Mod‑b  → toggle bar (if you added slstatus)"
echo ""
echo "Your tmux session can be started with:"
echo "    tmux new -s dev"
echo ""
echo "All configuration lives in $DOTDIR – feel free to edit and re‑run"
echo "the script to apply changes."
echo ""
echo "Happy hacking!"
