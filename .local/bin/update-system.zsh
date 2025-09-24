#!/usr/bin/env zsh
# --------------------------------------------------------------
#  Arch / Manjaro system update script
#  • Pick the fastest mirrors (GeoIP + rank)
#  • Refresh the pacman database once
#  • Upgrade system packages (pacman + AUR helper)
#  • Minimal sudo prompts, robust error handling
# --------------------------------------------------------------

set -euo pipefail          # abort on errors, undefined vars, pipe failures
IFS=$'\n\t'                # sane field splitting

# ---------- 1. Choose the best mirrors ----------
#   - `--geoip` picks a region‑based list
#   - `--fasttrack 5` keeps only the 5 fastest mirrors
#   - `--save` writes the new list to /etc/pacman.d/mirrorlist
#   - `sudo` is needed only for this step
echo "🔎 Selecting fastest mirrors…"
#sudo reflector --country Germany,France,Netherlands,Switzerland \
#               --age 12 \
#               --protocol https \
#               --sort rate \
#               --download-timeout 15 \
#               --fastest 5 \
#               --save /etc/pacman.d/mirrorlist

# ---------- 2. Refresh the package database ----------
#   - `-Sy` updates the sync database once (no double‑sync)
#   - `-u` upgrades all installed packages
#   - `--noconfirm` skips the interactive prompt (optional)
echo "📦 Updating official repos…"
sudo pacman -Syu --noconfirm

# ---------- 3. Update AUR packages ----------
#   Choose ONE AUR helper.  Paru is currently the most active.
#   If you still prefer Trizen, just replace `paru` with `trizen`.
if command -v paru >/dev/null 2>&1; then
    echo "🛠️ Updating AUR packages with paru…"
    paru -Syu --noconfirm
elif command -v yay >/dev/null 2>&1; then
    echo "🛠️ Updating AUR packages with yay…"
    yay -Syu --noconfirm
else
    echo "⚠️ No AUR helper found (paru/yay). Skipping AUR update."
fi


echo "✅ System update completed!"!/bin/zsh
