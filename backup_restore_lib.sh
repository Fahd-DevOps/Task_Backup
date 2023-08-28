#!/bin/bash

# Function to validate backup parameters
function validate_backup_params() {
    if [ "$#" -ne 4 ]; then
        echo "Usage: $0 <source_directory> <backup_directory> <encryption_key> <days>"
        exit 1
    fi

    source_dir="$1"
    backup_dir="$2"
    encryption_key="$3"
    days="$4"

    if [ ! -d "$source_dir" ] || [ ! -d "$backup_dir" ]; then
        echo "Source and backup directories must exist"
        exit 1
    fi
}

# Function to backup recent files in a directory
function backup_recent_files() {
    dir_to_backup="$1"
    backup_dir="$2"
    days="$3"

    dir_name=$(basename "$dir_to_backup")
    backup_file="${backup_dir}/${dir_name}_${backup_date}.tar.gz"
    
    find "$dir_to_backup" -type f -mtime "-$days" -print0 | xargs -0 tar -czf "$backup_file"
    
    # Encrypt the backup file using GnuPG with passphrase
    gpg --batch --symmetric --cipher-algo AES256 -o "$backup_file.gpg" --passphrase "$encryption_key" "$backup_file"
    
    rm "$backup_file"
}

# Function to archive and encrypt directories using GnuPG
function backup_directories() {
    main_backup_dir="$1"
    backup_date="$2"
    tar_file="${main_backup_dir}_${backup_date}.tar.gz"

    tar -czf "$tar_file" -C "$(dirname "$main_backup_dir")" "$(basename "$main_backup_dir")"

    # Encrypt the tar archive using GnuPG with passphrase
    gpg --batch --symmetric --cipher-algo AES256 -o "$tar_file.gpg" --passphrase "$encryption_key" "$tar_file"

    rm "$tar_file"
    echo "Backup Completed Successfully"
}

# Function to validate restore parameters
function validate_restore_params() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <backup_directory> <restore_directory> <decryption_key>"
        exit 1
    fi

    backup_dir="$1"
    restore_dir="$2"
    decryption_key="$3"

    if [ ! -d "$backup_dir" ] || [ ! -d "$restore_dir" ]; then
        echo "Backup and restore directories must exist"
        exit 1
    fi
}

# Function to decrypt and store files using GnuPG
function decrypt_and_store() {
    backup_file="$1"
    temp_dir="$2"
    decryption_key="$3"

    decrypted_file="${backup_file%.gpg}"
    
    # Decrypt the backup file using GnuPG
    echo "$decryption_key" | gpg --batch --yes --passphrase-fd 0 -o "$decrypted_file" --decrypt "$backup_file"
    
    mv "$decrypted_file" "$temp_dir"
}

# Function to restore files from temp directory
function restore_files() {
    temp_dir="$1"
    restore_dir="$2"

    find "$temp_dir" -type f -exec tar -xf {} -C "$restore_dir" \;
    rm -r "$temp_dir"
    echo "Restoration Completed Successfully"
}