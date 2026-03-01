#!/bin/sh

BIN=/mnt/us/extensions/tailscale/bin
TAILSCALE="$BIN/tailscale"
TAILDROP_DIR_FILE="$BIN/taildrop_dir.txt"
DEFAULT_TAILDROP_DIR=/mnt/us/extensions/tailscale/taildrop
LOG="$BIN/taildrop_receive_log.txt"

eips_log() {
    echo "$1" >> "$LOG"
    eips 0 22 "$(printf '%-50s' "$1")" 2>/dev/null
}

echo "[$(date)] Receiving taildrop files..." > "$LOG"

TAILDROP_DIR=$DEFAULT_TAILDROP_DIR
if [ -s "$TAILDROP_DIR_FILE" ]; then
    TAILDROP_DIR=$(cat "$TAILDROP_DIR_FILE")
fi

mkdir -p "$TAILDROP_DIR"

eips_log "Receiving Taildrop files..."
if "$TAILSCALE" file get "$TAILDROP_DIR" >> "$LOG" 2>&1; then
    eips_log "Taildrop files received OK"
else
    eips_log "Taildrop receive failed - check log"
    exit 1
fi
