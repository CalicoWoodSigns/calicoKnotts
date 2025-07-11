#!/bin/bash

# FTPS Deployment Helper for CFDynamics Hosting
# This script prepares files and provides FTPS connection details

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEMP_DIR=$(mktemp -d)

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

log "KBF Data Management System - FTPS Deployment Helper"
log "=================================================="

# Load production configuration
if [ -f "$SCRIPT_DIR/config/production.env" ]; then
    source "$SCRIPT_DIR/config/production.env"
else
    echo "Error: production.env not found"
    exit 1
fi

# Prepare deployment package
log "Preparing deployment package..."
rsync -av \
    --exclude-from="$PROJECT_DIR/.gitignore" \
    --exclude='.git/' \
    --exclude='deploy/' \
    --exclude='*.log' \
    --exclude='temp/' \
    "$PROJECT_DIR/" "$TEMP_DIR/"

log "Files prepared in: $TEMP_DIR"

# Display FTPS connection information
echo ""
info "FTPS Connection Details:"
echo "========================"
echo "Protocol: FTPS (Explicit FTP over TLS)"
echo "Host: $FTP_HOST"
echo "Port: $FTP_PORT"
echo "Username: $FTP_USER"
echo "Password: $FTP_PASS"
echo "Remote Path: $FTP_PATH"
echo "Connection Mode: Passive (PASV)"
echo ""

info "FileZilla Configuration:"
echo "========================"
echo "1. Open FileZilla"
echo "2. File → Site Manager"
echo "3. Click 'New Site'"
echo "4. Enter the following:"
echo "   - Protocol: FTP - File Transfer Protocol"
echo "   - Host: $FTP_HOST"
echo "   - Port: $FTP_PORT"
echo "   - Encryption: Use explicit FTP over TLS if available"
echo "   - Logon Type: Normal"
echo "   - User: $FTP_USER"
echo "   - Password: $FTP_PASS"
echo "5. Click 'Transfer Settings' tab"
echo "6. Transfer mode: Passive"
echo "7. Click 'Connect'"
echo ""

info "Upload Instructions:"
echo "==================="
echo "1. Navigate to remote directory: $FTP_PATH"
echo "2. Upload all files from: $TEMP_DIR"
echo "3. Maintain directory structure"
echo "4. Overwrite existing files when prompted"
echo ""

warn "Important Notes:"
echo "================"
echo "- Use Passive mode for FTPS connections"
echo "- Files are prepared in temporary directory: $TEMP_DIR"
echo "- Remember to clean up temp directory after upload"
echo "- Test the application at: $APPLICATION_URL"
echo ""

read -p "Press Enter to open temp directory in Finder..."
open "$TEMP_DIR"

echo ""
log "Deployment package ready!"
log "Upload the contents of $TEMP_DIR to your FTPS server"
log "Application will be available at: $APPLICATION_URL"

# Cleanup function
cleanup() {
    read -p "Remove temporary files? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$TEMP_DIR"
        log "Temporary files cleaned up"
    else
        log "Temporary files kept at: $TEMP_DIR"
    fi
}

trap cleanup EXIT
