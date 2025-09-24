#!/usr/bin/env zsh
# ------------------------------------------------------------------
#  backup.sh – inkrementelles, komprimiertes Backup mit Snapshots
#  Author:  (dein Name)
#  Lizenz:  MIT
# ------------------------------------------------------------------

set -euo pipefail               # Saubere Fehlerbehandlung
IFS=$'\n\t'                     # Saubere Feldtrennung

# --------------------------- Konfiguration ---------------------------
# Pfade (bitte an deine Umgebung anpassen)
SRC_DIR="/home/missimfis/extData/backup/missimfis"
DST_ROOT="/home/missimfis/extData/backup"
SNAP_ROOT="${DST_ROOT}/snapshots"          # Ort für hard‑link‑Snapshots
LOGFILE="${DST_ROOT}/backup.log"
EXCLUDE_FILE="${DST_ROOT}/exclude.lst"     # Datei mit Ausschlüssen

# Retention (wie lange Snapshots behalten werden)
RETENTION_DAYS=7          # tägliche Snapshots
RETENTION_MONTHS=3        # monatliche Snapshots (letzter Tag des Monats)

# Kompressions‑Tool (pigz = parallel gzip, pbzip2 = parallel bzip2)
COMPRESS_PROG="pigz"      # -> gzip‑Kompatibel, schneller als gzip allein
COMP_LEVEL=9              # max. Kompression (0‑9)

# Lock‑File, um parallele Läufe zu verhindern
LOCKFILE="/var/run/backup.lock"

# ------------------------------------------------------------------
#  Funktionen
# ------------------------------------------------------------------

log() {
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$ts] $*" | tee -a "$LOGFILE"
}

die() {
    log "ERROR: $*"
    rm -f "$LOCKFILE"
    exit 1
}

# ------------------------------------------------------------------
#  1️⃣ Lock‑File prüfen
# ------------------------------------------------------------------
if [[ -e "$LOCKFILE" ]]; then
    die "Ein anderer Backup‑Lauf scheint noch aktiv zu sein (Lockfile $LOCKFILE)."
fi
touch "$LOCKFILE"

# ------------------------------------------------------------------
#  2️⃣ Vorbereitung
# ------------------------------------------------------------------
mkdir -p "$DST_ROOT" "$SNAP_ROOT"
[[ -f "$EXCLUDE_FILE" ]] || cat >"$EXCLUDE_FILE" <<'EOF'
.cache
.thumbnails
*.tmp
*.bak
EOF

# Datum für den Archivnamen
DATE=$(date +%Y%m%d)
ARCHIVE_NAME="missimfis_${DATE}_backup.tar.gz"
ARCHIVE_PATH="${DST_ROOT}/${ARCHIVE_NAME}"

# ------------------------------------------------------------------
#  3️⃣ (Optional) BTRFS‑Snapshot erstellen – falls BTRFS verwendet wird
# ------------------------------------------------------------------
if mountpoint -q "$SRC_DIR" && grep -qs btrfs /proc/mounts; then
    SNAPSHOT="${SNAP_ROOT}/${DATE}"
    log "Erstelle BTRFS‑Snapshot: $SNAPSHOT"
    btrfs subvolume snapshot -r "$SRC_DIR" "$SNAPSHOT"
    SRC_FOR_TAR="$SNAPSHOT"
else
    SRC_FOR_TAR="$SRC_DIR"
fi

# ------------------------------------------------------------------
#  4️⃣ Incrementelles tar‑Backup mit hard‑links (rsync‑Style)
# ------------------------------------------------------------------
# Wir nutzen das TAR‑Feature "--listed-incremental". Es schreibt ein
# Metadaten‑File (hier: .snapshot) in das Zielverzeichnis.
INCREMENTAL_FILE="${SNAP_ROOT}/.snapshot"

log "Starte tar‑Backup → $ARCHIVE_PATH"
tar --create \
    --gzip \
    --use-compress-program="${COMPRESS_PROG} -${COMP_LEVEL}" \
    --listed-incremental="${INCREMENTAL_FILE}" \
    --exclude-from="${EXCLUDE_FILE}" \
    --exclude="${ARCHIVE_PATH}" \
    --file="${ARCHIVE_PATH}" \
    -C "$(dirname "$SRC_FOR_TAR")" "$(basename "$SRC_FOR_TAR")"

log "Tar‑Backup abgeschlossen."

# ------------------------------------------------------------------
#  5️⃣ Aufräumen: alte Snapshots entfernen (Retention‑Policy)
# ------------------------------------------------------------------
log "Alte Snapshots entfernen (>$RETENTION_DAYS Tage)…"
find "$SNAP_ROOT" -maxdepth 1 -type d -mtime +"$RETENTION_DAYS" -exec rm -rf {} +

# Monatliche Aufbewahrung (letzter Tag jedes Monats)
log "Monatliche Snapshots behalten (letzter Tag, ≤ $RETENTION_MONTHS Monate)…"
current_month=$(date +%Y-%m)
for dir in "$SNAP_ROOT"/*/; do
    [[ -d "$dir" ]] || continue
    snap_date=$(basename "$dir")
    # Prüfe, ob das Verzeichnis älter als RETENTION_MONTHS ist
    if [[ $(date -d "$snap_date" +%s) -lt $(date -d "-${RETENTION_MONTHS} months" +%s) ]]; then
        # Behalte nur, wenn es der letzte Tag des Monats ist
        last_day_of_month=$(date -d "${snap_date}-01 +1 month -1 day" +%d)
        if [[ $(date -d "$snap_date" +%d) -ne $last_day_of_month ]]; then
            log "Entferne alter Monats‑Snapshot: $snap_date"
            rm -rf "$dir"
        fi
    fi
done

# ------------------------------------------------------------------
#  6️⃣ Abschluss & Cleanup
# ------------------------------------------------------------------
rm -f "$LOCKFILE"
log "Backup‑Durchlauf erfolgreich beendet."

exit 0
