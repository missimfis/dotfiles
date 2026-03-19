#!/usr/bin/env zsh
# -------------------------------------------------
#  wttr.in quick‑forecast helper
#  • Default city: Winterthur
#  • Caches results for 10 minutes
#  • Silent, fast, robust
# -------------------------------------------------

set -euo pipefail               # abort on errors, undefined vars, pipeline failures
IFS=$'\n\t'                    # sane field splitting

# ---------- helpers ----------
show_help() {
  cat <<'EOF'
Usage: weather [city]

Print a short weather report from wttr.in.
If no city is supplied, "Winterthur" is used.

Options:
  -h, --help   Show this help message and exit.
EOF
}

# ---------- argument parsing ----------
while (( $# )); do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    *) break ;;                 # first non‑option is the city name
  esac
done

# Default city if none given
DESTINATION=${1:-Winterthur}

# Sanitize – keep only letters, numbers, dash, underscore
DESTINATION=${DESTINATION//[^[:alnum:]_-]/}

# ---------- fetch from wttr.in ----------
URL="https://wttr.in/${DESTINATION}?format=v2d"

# -f  : fail silently on HTTP errors (>=400)
# -s  : silent (no progress meter)
# -L  : follow redirects (just in case)
# --http2 : use HTTP/2 if the server supports it
# --max-time 10 : abort after 10 seconds
# -A  : custom user‑agent (optional but polite)
curl -fsSL --compressed \
     --http2 --max-time 10 \
     "$URL" 
