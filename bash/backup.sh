#!/bin/bash
# ==========================
# 🔹 Automatic Backup Script
# ==========================

SOURCE_DIR="$1"
BACKUP_DIR="${2:-./backups}"

if [ -z "$SOURCE_DIR" ]; then
    echo "❌ Usage: $0 <source_directory> [backup_directory]"
    exit 1
fi

mkdir -p "$BACKUP_DIR"
LOG_FILE="$BACKUP_DIR/backup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if [ ! -d "$SOURCE_DIR" ]; then
    log "❌ ERROR: Directory $SOURCE_DIR does not exist!"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE_NAME="backup-${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

log "🚀 Starting backup of $SOURCE_DIR ..."
tar -czf "$ARCHIVE_PATH" "$SOURCE_DIR" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    log "✅ Backup created successfully: $ARCHIVE_NAME"
else
    log "❌ Backup failed!"
    exit 1
fi

log "🧹 Cleaning up old backups (keeping latest 5)..."
cd "$BACKUP_DIR"
ls -tp backup-*.tar.gz 2>/dev/null | grep -v '/$' | tail -n +6 | xargs -d '\n' rm -f --
log "✅ Cleanup complete."

log "🎉 Backup process finished successfully."