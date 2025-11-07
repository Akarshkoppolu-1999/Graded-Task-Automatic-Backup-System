import os
import zipfile
from datetime import datetime
import json

DEFAULTS = {
    "SOURCE_FOLDER": "to_backup",
    "BACKUP_FOLDER": "backups",
    "KEEP_LAST": 5
}

CONFIG_FILE = "config.json"

def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, "r") as f:
            data = json.load(f)
        for k, v in DEFAULTS.items():
            data.setdefault(k, v)
        return data
    return DEFAULTS

def make_zip(source_folder, backup_folder):
    os.makedirs(source_folder, exist_ok=True)
    os.makedirs(backup_folder, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    zip_name = f"backup_{timestamp}.zip"
    zip_path = os.path.join(backup_folder, zip_name)

    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for root, dirs, files in os.walk(source_folder):
            for file in files:
                full_path = os.path.join(root, file)
                arcname = os.path.relpath(full_path, start=source_folder)
                zf.write(full_path, arcname)

    print(f"Created backup: {zip_path}")
    return zip_path

def cleanup_backups(backup_folder, keep_last):
    if keep_last <= 0:
        return
    items = [f for f in os.listdir(backup_folder) if f.lower().endswith('.zip')]
    items.sort(reverse=True)
    to_remove = items[keep_last:]
    for fname in to_remove:
        try:
            path = os.path.join(backup_folder, fname)
            os.remove(path)
            print(f"Removed old backup: {path}")
        except Exception as e:
            print(f"Could not remove {fname}: {e}")

if __name__ == '__main__':
    cfg = load_config()
    src = cfg['SOURCE_FOLDER']
    bak = cfg['BACKUP_FOLDER']
    keep = int(cfg.get('KEEP_LAST', 5))

    make_zip(src, bak)
    cleanup_backups(bak, keep)
    print('Done.')