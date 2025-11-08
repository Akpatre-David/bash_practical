#!/bin/bash
# ===========================================================
# Script: create_users.sh
# Company: KapaMech Data Solutions Limited
# Role: DevOps Engineer Practical Assessment
# Author: <Your Full Name>
# Date: 2025-11-08
# ===========================================================
# Description:
# Automates Linux user account management for data engineering projects.
# Includes:
#   - User creation from CSV file
#   - Secure password management
#   - Account deletion (with backups)
#   - Group management
#   - Logging and reporting
# ===========================================================

# ---------------- CONFIGURATION ----------------
LOG_DIR="./logs"
BACKUP_DIR="./backups"
REPORT_DIR="./reports"
ACCOUNTS_FILE="./accounts.txt"

mkdir -p "$LOG_DIR" "$BACKUP_DIR" "$REPORT_DIR"

LOG_FILE="$LOG_DIR/actions.log"
ERR_FILE="$LOG_DIR/errors.log"

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root!" >&2
    exit 1
fi

# ---------------- HELPER FUNCTIONS ----------------
log_action() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO] $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") [ERROR] $1" | tee -a "$ERR_FILE" >&2
}

# ---------------- CORE USER MANAGEMENT ----------------
create_user_account() {
    local username="$1"
    local password="$2"
    local email="$3"
    local tier="$4"

    if id "$username" &>/dev/null; then
        log_error "User '$username' already exists. Skipping..."
        return 1
    fi

    if useradd -m -s /bin/bash "$username"; then
        echo "$username:$password" | chpasswd
        chmod 700 "/home/$username"
        log_action "✅ Created user '$username' successfully."
        echo "$username,$email,$tier,$password" >> "$REPORT_DIR/created_users.txt"
    else
        log_error "Failed to create user '$username'."
    fi
}

create_accounts_from_file() {
    if [[ ! -f "$ACCOUNTS_FILE" ]]; then
        log_error "accounts.txt file not found!"
        exit 1
    fi

    while IFS=, read -r firstname lastname email password tier; do
        # Skip header
        [[ "$firstname" == "Firstname" ]] && continue
        [[ -z "$firstname" ]] && continue

        # Generate valid Linux username (lowercase, no commas/spaces)
        username="${firstname,,}${lastname,,}"

        # Create user
        create_user_account "$username" "$password" "$email" "$tier"
    done < "$ACCOUNTS_FILE"

    log_action "User creation process completed."
}

# ---------------- ACCOUNT DELETION ----------------
delete_user_account() {
    local username="$1"

    if [[ -z "$username" ]]; then
        log_error "No username provided for deletion."
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        log_error "User '$username' does not exist."
        return 1
    fi

    read -p "Are you sure you want to delete user '$username'? (y/n): " confirm
    [[ "$confirm" != "y" ]] && { log_action "Deletion of '$username' cancelled."; return; }

    local backup_file="$BACKUP_DIR/${username}_home_$(date +%F_%H-%M).tar.gz"
    tar -czf "$backup_file" "/home/$username" &>/dev/null
    if userdel -r "$username"; then
        log_action "🗑️ Deleted user '$username'. Home directory archived at $backup_file"
    else
        log_error "Failed to delete user '$username'."
    fi
}

# ---------------- PASSWORD MANAGEMENT ----------------
update_user_password() {
    local username="$1"

    if [[ -z "$username" ]]; then
        log_error "Username not provided for password update."
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        log_error "User '$username' not found."
        return 1
    fi

    local password
    password=$(openssl rand -base64 14)

    if echo "$username:$password" | chpasswd; then
        log_action "🔑 Password updated for '$username'."
        echo "$username : $password" >> "$REPORT_DIR/password_changes.txt"
    else
        log_error "Failed to update password for '$username'."
    fi
}

# ---------------- GROUP MANAGEMENT ----------------
add_user_to_group() {
    local username="$1"
    local groups="$2"

    if [[ -z "$username" || -z "$groups" ]]; then
        log_error "Usage: add_user_to_group <username> <group1,group2,...>"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        log_error "User '$username' does not exist."
        return 1
    fi

    for group in ${groups//,/ }; do
        if ! getent group "$group" >/dev/null; then
            log_error "Group '$group' does not exist. Skipping..."
            continue
        fi
        usermod -aG "$group" "$username" && log_action "Added '$username' to group '$group'."
    done
}

remove_user_from_group() {
    local username="$1"
    local group="$2"

    if [[ -z "$username" || -z "$group" ]]; then
        log_error "Usage: remove_user_from_group <username> <group>"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        log_error "User '$username' does not exist."
        return 1
    fi

    local primary_group
    primary_group=$(id -gn "$username")

    if [[ "$group" == "$primary_group" ]]; then
        log_error "Cannot remove '$username' from their primary group '$group'."
        return 1
    fi

    gpasswd -d "$username" "$group" &>/dev/null && \
        log_action "Removed '$username' from group '$group'." || \
        log_error "Failed to remove '$username' from group '$group'."
}

# ---------------- REPORTING ----------------
generate_summary_report() {
    local report_file="$REPORT_DIR/summary_$(date +%F_%H-%M).txt"
    {
        echo "===== USER MANAGEMENT SUMMARY ====="
        echo "Date: $(date)"
        echo
        echo "Users Created: $(wc -l < "$REPORT_DIR/created_users.txt" 2>/dev/null || echo 0)"
        echo "Passwords Updated: $(wc -l < "$REPORT_DIR/password_changes.txt" 2>/dev/null || echo 0)"
        echo
        echo "See logs for full details: $LOG_FILE and $ERR_FILE"
    } > "$report_file"

    log_action "📄 Summary report generated: $report_file"
}

# ---------------- MAIN EXECUTION ----------------
case "$1" in
    create)
        create_accounts_from_file
        ;;
    delete)
        delete_user_account "$2"
        ;;
    update-pass)
        update_user_password "$2"
        ;;
    add-group)
        add_user_to_group "$2" "$3"
        ;;
    remove-group)
        remove_user_from_group "$2" "$3"
        ;;
    report)
        generate_summary_report
        ;;
    *)
        echo "Usage: $0 {create|delete <user>|update-pass <user>|add-group <user> <groups>|remove-group <user> <group>|report}"
        ;;
esac
