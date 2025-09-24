#!/usr/bin/env bash
# -------------------------------------------------------------
# compact‑suckless‑install.sh – Artix Linux (dinit) + Xorg
# -------------------------------------------------------------
# Prerequisites: internet connection, dinit already running,
#               a working BIOS/GRUB bootloader.
# -------------------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

# ---------- 0.  USER‑CONFIG -------------------------------------------------
SRC_ROOT="${HOME}/src"               # where the repos will live
PROGS=(dwm st dmenu slstatus slock) # suckless tools to build
PICOM_REPO="https://github.com/yshui/picom.git"
# -------------------------------------------------------------

msg(){ printf "\e[1;34m▶ %s\e[0m\n" "$*"; }
err(){ printf "\e[1;31m✖ %s\e[0m\n" "$*" >&2; exit 1; }

# ---------- 1.  Install build deps -----------------------------------------
BUILD_DEPS=(
    base-devel libX11-devel libXft-devel libXinerama-devel libXrandr-devel
    libXext-devel libXrender-devel freetype2-devel libxcb-devel
    libXdamage-devel libXcomposite-devel libXfixes-devel libXcursor-devel
    libev-devel libdrm-devel libGL-devel dbus-devel git sudo
)
msg "Installing build dependencies…"
sudo pacman -Sy --needed "${BUILD_DEPS[@]}"

# ---------- 2.  Prepare source tree ----------------------------------------
mkdir -p "${SRC_ROOT}"
cd "${SRC_ROOT}"

# ---------- 3.  Clone / update suckless repos -------------------------------
for p in "${PROGS[@]}"; do
    if [[ -d "${p}" ]]; then
        (cd "${p}" && git pull --rebase --quiet)
    else
        git clone "https://git.suckless.org/${p}" "${p}"
    fi
done

# ---------- 4.  Minimal configs (edit if you like) -------------------------
# dwm
cat > dwm/config.h <<'EOF'
#include <X11/XF86keysym.h>
static const unsigned int borderpx = 2, snap = 32;
static const int showbar = 1, topbar = 1;
static const char *fonts[] = {"monospace:size=10"};
static const char dmenufont[] = "monospace:size=10";
static const char col_gray1[] = "#222222", col_gray2[] = "#444444",
              col_gray3[] = "#bbbbbb", col_gray4[] = "#eeeeee",
              col_cyan[]  = "#005577";
static const char *colors[][3] = {
    [SchemeNorm] = {col_gray3, col_gray1, col_gray2},
    [SchemeSel]  = {col_gray4, col_cyan,  col_cyan },
};
static const char *tags[] = {"1","2","3","4","5","6","7","8","9"};
static const float mfact = 0.55; static const int nmaster = 1, resizehints = 1;
static const Layout layouts[] = {
    {"[]=", tile}, {"[M]", monocle}, {"><>", NULL},
};
#define MODKEY Mod4Mask
static const Key keys[] = {
    {MODKEY, XK_p, spawn, SHCMD("dmenu_run")},
    {MODKEY, XK_Return, spawn, SHCMD("st")},
    {MODKEY, XK_b, togglebar, {0}},
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
    {MODKEY, XK_m, setlayout, {.v = &layouts[1]}},
    {MODKEY, XK_f, setlayout, {.v = &layouts[2]}},
    {MODKEY|ShiftMask, XK_q, killclient, {0}},
    {MODKEY|ShiftMask, XK_e, quit, {0}},
    TAGKEYS(XK_1,0) TAGKEYS(XK_2,1) TAGKEYS(XK_3,2) TAGKEYS(XK_4,3)
    TAGKEYS(XK_5,4) TAGKEYS(XK_6,5) TAGKEYS(XK_7,6) TAGKEYS(XK_8,7)
    TAGKEYS(XK_9,8)
};
#undef MODKEY
#undef TAGKEYS
EOF

# st
cat > st/config.h <<'EOF'
static const char *font = "monospace:size=10";
static const char *termname = "st";
static const char *shell = "/bin/bash";
static const char *colorname[] = {
    "#222222","#bbbbbb","#ff5555","#50fa7b","#f1fa8c",
    "#bd93f9","#ff79c6","#8be9fd","#ffffff"
};
static unsigned int cols = 80, rows = 24;
EOF

# dmenu
cat > dmenu/config.h <<'EOF'
static const char *fonts[] = {"monospace:size=10"};
static const char *normbgcolor = "#222222", *normfgcolor = "#bbbbbb";
static const char *selbgcolor  = "#005577", *selfgcolor  = "#eeeeee";
static const unsigned int lines = 0, min_width = 500;
EOF

# slstatus
cat > slstatus/config.h <<'EOF'
static const struct arg args[] = {
    {"  %s ", "battery_percent"},
    {"  %s ", "wifi_essid"},
    {" %s",    "datetime:%Y-%m-%d %H:%M"},
};
EOF
# -------------------------------------------------------------

# ---------- 5.  Build & install each suckless program --------------------
install_prog(){
    local dir=$1
    cd "${SRC_ROOT}/${dir}"
    msg "Building ${dir}…"
    make clean >/dev/null 2>&1 || true
    make -j$(nproc)
    msg "Installing ${dir}…"
    sudo make install
}
for p in "${PROGS[@]}"; do install_prog "$p"; done

# ---------- 6.  Build & install picom (tiny compositor) -----------------
msg "Cloning picom…"
if [[ -d picom ]]; then
    (cd picom && git pull --rebase --quiet)
else
    git clone "${PICOM_REPO}"
fi
cd picom
msg "Configuring picom (meson)…"
meson setup build --prefix=/usr/local
msg "Compiling picom…"
ninja -C build
msg "Installing picom…"
sudo ninja -C build install

# ---------- 7.  Dinit service files --------------------------------------
SERVICE_DIR="/etc/dinit.d"
sudo mkdir -p "${SERVICE_DIR}"

# Xorg (starts startx which reads ~/.xinitrc)
sudo tee "${SERVICE_DIR}/xorg.service" >/dev/null <<'EOF'
description "Xorg + dwm"
exec /usr/bin/startx
respawn
EOF

# picom (runs in background, will be started by dinit as soon as X is up)
sudo tee "${SERVICE_DIR}/picom.service" >/dev/null <<'EOF'
description "Picom compositor"
exec /usr/local/bin/picom --config /etc/picom.conf
respawn
EOF

# slock (called on demand from dwm)
sudo tee "${SERVICE_DIR}/slock.service" >/dev/null <<'EOF'
description "Simple X lock"
exec /usr/local/bin/slock
once
EOF

sudo dinitctl enable xorg
sudo dinitctl enable picom

# ---------- 8.  Minimal Xorg config (keyboard + mouse) -------------------
XCONF="/etc/X11/xorg.conf.d"
sudo mkdir -p "${XCONF}"

sudo tee "${XCONF}/00-keyboard.conf" >/dev/null <<'EOF'
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "us"
    Option "XkbVariant" "intl"
EndSection
EOF

sudo tee "${XCONF}/20-mouse.conf" >/dev/null <<'EOF'
Section "InputClass"
    Identifier "mouse"
    MatchIsPointer "yes"
    Option "AccelProfile" "flat"
    Option "AccelerationScheme" "none"
EndSection
EOF

# ---------- 9.  User .xinitrc (launches dwm, ensures picom fallback) --
cat > "${HOME}/.xinitrc" <<'EOF'
#!/usr/bin/env sh
# start picom if dinit hasn't already done it
pgrep -x picom >/dev/null || picom --config /etc/picom.conf &
exec dwm
EOF
chmod +x "${HOME}/.xinitrc"

# ---------- 10. Tiny picom config ---------------------------------------
sudo tee /etc/picom.conf >/dev/null <<'EOF'
backend = "glx";
vsync = true;
shadow = true;
shadow-radius = 12;
shadow-offset-x = -5;
shadow-offset-y = -5;
shadow-opacity = 0.45;
corner-radius = 6;
fade-in-step = 0.03;
fade-out-step = 0.03;
EOF

# ---------- 11.  Finish -------------------------------------------------
msg "Installation complete."
msg "To start the new desktop simply log out of your current session and run:"
echo -e "\n    startx\n"
msg "Your previous Wayland/Sway environment is untouched – you can launch it again with ‘sway’ whenever you wish."
msg "If you ever need to tweak key bindings or colours, edit the corresponding *.h files under ${SRC_ROOT} and re‑run ‘make && sudo make install’ for that program."

# ---------- 12.  Optional portable router note (manual) -----------------
cat <<'EOF'

=== Portable‑router suggestion (manual step) ===
Your Turris Omnia is reliable but bulky. Two inexpensive alternatives that run OpenWrt out‑of‑the‑box:

1. GL.iNet GL‑AR750S‑Slim (≈ 30 USD) – pocket‑size, dual‑band Wi‑Fi, USB‑OTG.
2. Raspberry Pi 4 + official case + OpenWrt image – very flexible, cheap, and you already own a Pi?

Both give you a clean, up‑to‑date firmware and can be powered from a USB‑C powerbank, making them truly portable.

EOF
