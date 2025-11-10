Automated Backup System
Overview
A simple Python script that automatically zips files from a source folder, stores them as backups, and deletes older backups to keep only the latest few.
________________________________________
Features
•	Creates timestamped .zip backups
•	Keeps only the latest backups
•	Fully automatic and easy to run
________________________________________
Setup
1.	Requirements: Python 3.7 or newer
2.	Default folders:
o	to_backup → source files
o	backups → backup storage
3.	Optional config (config.json):
{
  "SOURCE_FOLDER": "to_backup",
  "BACKUP_FOLDER": "backups",
  "KEEP_LAST": 5
}
________________________________________
Run
Open terminal in the script folder and run:
python backup.py
The script will create a new backup and remove older ones if necessary.
________________________________________
Example
Put files in to_backup, then run the script. A file like backup_20251110_120101.zip will appear in backups.
________________________________________
Tips
•	Change KEEP_LAST to control how many backups to keep.
•	Use Task Scheduler (Windows) or cron (Linux/Mac) for automatic daily backups.
________________________________________
Author
Graded Task – Automated Backup System
