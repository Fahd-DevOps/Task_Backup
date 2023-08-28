#!/bin/bash

# Source the library with functions
source backup_restore_lib.sh

# Validate input parameters
validate_backup_params "$@"

# Create a directory with the backup date
backup_date=$(date +'%Y%m%d_%H%M%S')
backup_dir="${2}/${backup_date}"
mkdir -p "$backup_dir"

# Loop through directories to backup
for dir in "${1}"/*; do
    # Check for modification date to backup only recent files
    backup_recent_files "$dir" "$backup_dir" "$4"
done

# Archive and encrypt directories
backup_directories "$backup_dir" "$3"

# Copy backup to a remote server using scp >> (secure copy) 
source remote_config.txt

encrypted_archive="../backup_test/"$backup_dir"_"$encryption_key".tar.gz.gpg"
scp -r $encrypted_archive $remote_server:$remote_destination
echo "Backup Sent Successfully"