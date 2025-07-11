#!/bin/bash

# Sync script to download current files from emp77.calicowoodsigns.com
# This script downloads only the active files you're using

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
CURRENT_SITE="emp77.calicowoodsigns.com"
LOCAL_DIR="/Users/R/ColdFusion/cfusion/wwwroot/KBFData"
BACKUP_DIR="${LOCAL_DIR}/backups/$(date +%Y%m%d_%H%M%S)"

# List of active files to sync
ACTIVE_FILES=(
    "index.cfm"
    "admin_dashboard.cfml"
    "employee_dashboard.cfml"
    "edit_employee_info.cfml"
    "EditEmployeeSales.cfml"
    "read_csv.cfm"
    "nav.cfm"
    "navEmp.cfm"
    "TablesColumns.cfml"
    "ViewTableData.cfml"
    "rj.cfm"
    "style.css"
    "logout.cfm"
)

# Create backup directory
info "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Function to backup and download a file
sync_file() {
    local file="$1"
    local url="http://${CURRENT_SITE}/${file}"
    local local_file="${LOCAL_DIR}/${file}"
    local backup_file="${BACKUP_DIR}/${file}"
    
    info "Syncing: $file"
    
    # Backup existing file if it exists
    if [ -f "$local_file" ]; then
        cp "$local_file" "$backup_file"
        info "Backed up existing file to: $backup_file"
    fi
    
    # Download the file
    if curl -s -f -o "$local_file" "$url"; then
        success "Downloaded: $file"
        
        # Show file size and modification time
        ls -la "$local_file" | awk '{print "  Size: " $5 " bytes, Modified: " $6 " " $7 " " $8}'
        
        # Check if file contains the old datasource name
        if grep -q "calicowoodsignsdsn" "$local_file" 2>/dev/null; then
            warning "File contains old datasource name 'calicowoodsignsdsn'"
            echo "  -> This file will need datasource name update"
        fi
        
    else
        error "Failed to download: $file"
        error "URL: $url"
        
        # Restore backup if download failed and backup exists
        if [ -f "$backup_file" ]; then
            cp "$backup_file" "$local_file"
            info "Restored backup file"
        fi
    fi
    
    echo ""
}

# Main sync process
info "Starting sync from current site: $CURRENT_SITE"
info "Local directory: $LOCAL_DIR"
info "Backup directory: $BACKUP_DIR"
echo ""

# Test connection to current site
info "Testing connection to current site..."
if curl -s -f -I "http://${CURRENT_SITE}" > /dev/null; then
    success "Connection to $CURRENT_SITE successful"
else
    error "Cannot connect to $CURRENT_SITE"
    error "Please check:"
    error "1. Is the site accessible?"
    error "2. Is there a firewall blocking the connection?"
    error "3. Is the domain correct?"
    exit 1
fi

echo ""

# Sync each active file
for file in "${ACTIVE_FILES[@]}"; do
    sync_file "$file"
done

# Check for any CSV files (data files)
info "Checking for CSV data files..."
csv_files=$(curl -s "http://${CURRENT_SITE}/" | grep -o '[^"]*\.csv' | head -5)
if [ -n "$csv_files" ]; then
    info "Found CSV files on current site:"
    echo "$csv_files"
    echo ""
    read -p "Do you want to download these CSV files? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r csv_file; do
            if [ -n "$csv_file" ]; then
                sync_file "$csv_file"
            fi
        done <<< "$csv_files"
    fi
fi

# Summary
echo ""
info "Sync completed!"
info "Files synced to: $LOCAL_DIR"
info "Backups stored in: $BACKUP_DIR"
echo ""

# Check for files that need datasource updates
info "Checking for files that need datasource updates..."
files_needing_update=$(grep -l "calicowoodsignsdsn" *.cfm* 2>/dev/null)
if [ -n "$files_needing_update" ]; then
    warning "The following files contain old datasource names:"
    echo "$files_needing_update"
    echo ""
    read -p "Do you want to update datasource names now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Running datasource update script..."
        bash "${LOCAL_DIR}/sql/update_datasources.sh"
    fi
fi

echo ""
success "Sync process complete!"
info "Your local files are now synchronized with: $CURRENT_SITE"
info "Next steps:"
info "1. Review the downloaded files"
info "2. Test your local application"
info "3. Commit changes to Git if needed"
