#!/bin/bash

# Source the library with functions
source backup_restore_lib.sh

# Validate input parameters
validate_restore_params "$@"

# Create a temp directory for restoration
temp_dir="${2}/temp_restore"
mkdir -p "$temp_dir"

# Loop through backup directory
for backup_file in "${1}"/*; do
    # Decrypt and store files in the temp directory
    decrypt_and_store "$backup_file" "$temp_dir" "$3"
done

# Restore files from temp directory
restore_files "$temp_dir" "$2"