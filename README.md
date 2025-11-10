# Graded Task - Automated Backup System (Bash Script)

This is a simple automated backup script written in **Bash**.

##  How It Works
- Takes files from a source folder (`to_backup`)  
- Compresses them into a `.tar.gz` file  
- Saves backups inside the `backups` folder  
- Keeps only the latest 5 backups (old ones are deleted automatically)  
- Logs all actions in `backup.log`

##  Files
- **backup.sh** → Main script  
- **config.cfg** → Configuration file  
- **to_backup/** → Folder containing files to back up  
- **backups/** → Folder where backups are stored  
- **backup.log** → Log file (auto-created)

##  How to Run
```bash
chmod +x backup.sh        # Give permission (first time only)
./backup.sh               # Run with defaults
./backup.sh folderA folderB 3   # (optional) custom source, backup folder, keep-last
