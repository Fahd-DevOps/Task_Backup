Secure Encrypted Backup and Restore Scripts

These scripts allow you to perform secure encrypted backups of directories and restore them later using encryption.

1. **Usage:**

   - Run `backup.sh` with the following command:
     ```bash
     ./backup.sh /path/to/source/directory /path/to/backup/directory encryption_key days
     ```
   - Run `restore.sh` with the following command:
     ```bash
     ./restore.sh /path/to/backup/directory /path/to/restore/directory decryption_key
     ```

2. **Components:**

   - `backup.sh`: Initiates the backup process, encrypts files, and copies them to a remote server.
   - `restore.sh`: Restores encrypted backup files, decrypts them, and places them in the restore directory.
   - `backup_restore_lib.sh`: A library of shared functions for validation, backup, and restore.

3. **Cron Job:**

   To schedule the backup script to run daily, add an entry in the crontab:
   ```bash
   0 0 * * * /path/to/backup.sh /path/to/source/directory /path/to/backup/directory encryption_key days