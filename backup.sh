#!/usr/bin/env bash
set -euo pipefail

DEFAULT_SOURCE="to_backup"
DEFAULT_BACKUP_DIR="backups"
DEFAULT_KEEP=5
LOGFILE="backup.log"
CONFIG_FILE="config.cfg"

# load config if present
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
fi

SOURCE=${1:-${SOURCE:-$DEFAULT_SOURCE}}
BACKUP_DIR=${2:-${BACKUP_DIR:-$DEFAULT_BACKUP_DIR}}
KEEP=${3:-${KEEP:-$DEFAULT_KEEP}}

timestamp=$(date +"%Y%m%d-%H%M%S")
base_name="$(basename "$SOURCE")"
backup_name="${base_name}_backup_${timestamp}.tar.gz"
backup_path="${BACKUP_DIR}/${backup_name}"

mkdir -p "$BACKUP_DIR"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Starting backup of '$SOURCE' -> '$backup_path'" | tee -a "$LOGFILE"

if [[ ! -d "$SOURCE" ]]; then
  echo "Source folder '$SOURCE' does not exist. Exiting." | tee -a "$LOGFILE"
  exit 1
fi

tar -czf "$backup_path" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"
echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup created: $backup_name" | tee -a "$LOGFILE"

shopt -s nullglob
files=( "$BACKUP_DIR/${base_name}_backup_"*.tar.gz )
if (( ${#files[@]} > KEEP )); then
  IFS=$'\n' sorted=( $(ls -1tr "${files[@]}") )
  to_delete_count=$((${#sorted[@]} - KEEP))
  echo "Removing $to_delete_count old backup(s)" | tee -a "$LOGFILE"
  for ((i=0; i<to_delete_count; i++)); do
    rm -f "${sorted[$i]}"
    echo "Deleted ${sorted[$i]}" | tee -a "$LOGFILE"
  done
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup finished." | tee -a "$LOGFILE"