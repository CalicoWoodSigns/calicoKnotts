#!/bin/bash

# FTP Sync script to download current files from your existing hosting
# Use this if HTTP downloads don't work

# Configuration - UPDATE THESE WITH YOUR CURRENT SITE'S FTP DETAILS
FTP_SERVER="ftp.calicowoodsigns.com"  # Update with your current FTP server
FTP_USER="your_ftp_username"          # Update with your FTP username
FTP_PASS="your_ftp_password"          # Update with your FTP password
FTP_DIR="/public_html"                # Update with your remote directory path

LOCAL_DIR="/Users/R/ColdFusion/cfusion/wwwroot/KBFData"
BACKUP_DIR="${LOCAL_DIR}/backups/$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if FTP credentials are set
if [ "$FTP_USER" == "your_ftp_username" ]; then
    error "Please update FTP credentials in this script first!"
    echo ""
    echo "Edit this file and update:"
    echo "- FTP_SERVER (your current hosting FTP server)"
    echo "- FTP_USER (your FTP username)"
    echo "- FTP_PASS (your FTP password)"
    echo "- FTP_DIR (remote directory path)"
    echo ""
    echo "Current hosting info from Settings.rtf:"
    echo "- Domain: emp77.calicowoodsigns.com"
    echo "- You'll need to get FTP details from your hosting provider"
    exit 1
fi

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

# Test FTP connection
info "Testing FTP connection to $FTP_SERVER..."
if ! ftp -n <<EOF
open $FTP_SERVER
user $FTP_USER $FTP_PASS
quit
EOF
then
    error "FTP connection failed!"
    error "Please check your FTP credentials and server details"
    exit 1
fi

success "FTP connection successful"

# Function to download a file via FTP
ftp_download() {
    local file="$1"
    local remote_file="${FTP_DIR}/${file}"
    local local_file="${LOCAL_DIR}/${file}"
    local backup_file="${BACKUP_DIR}/${file}"
    
    info "Downloading: $file"
    
    # Backup existing file if it exists
    if [ -f "$local_file" ]; then
        cp "$local_file" "$backup_file"
        info "Backed up existing file"
    fi
    
    # Download via FTP
    if ftp -n <<EOF
open $FTP_SERVER
user $FTP_USER $FTP_PASS
cd $FTP_DIR
get $file $local_file
quit
EOF
    then
        if [ -f "$local_file" ]; then
            success "Downloaded: $file"
            ls -la "$local_file" | awk '{print "  Size: " $5 " bytes, Modified: " $6 " " $7 " " $8}'
            
            # Check if file contains the old datasource name
            if grep -q "calicowoodsignsdsn" "$local_file" 2>/dev/null; then
                warning "File contains old datasource name 'calicowoodsignsdsn'"
            fi
        else
            error "Download failed: $file"
        fi
    else
        error "FTP download failed: $file"
    fi
    
    echo ""
}

# Main sync process
info "Starting FTP sync from: $FTP_SERVER"
info "Remote directory: $FTP_DIR"
info "Local directory: $LOCAL_DIR"
echo ""

# Sync each active file
for file in "${ACTIVE_FILES[@]}"; do
    ftp_download "$file"
done

# Summary
echo ""
success "FTP sync completed!"
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
success "FTP sync process complete!"
info "Your local files are now synchronized with your current hosting"
