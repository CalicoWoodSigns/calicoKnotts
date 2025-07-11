#!/bin/bash

# KBF Data Management System - Git-based Sync Script
# This script uses Git to sync local changes with remote server via GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# Load production configuration
if [ -f "$SCRIPT_DIR/config/production.env" ]; then
    source "$SCRIPT_DIR/config/production.env"
else
    error "Production environment configuration not found!"
fi

log "KBF Data Management System - Git Sync Script"
log "============================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    error "This script must be run from the root of the git repository"
fi

# Show current status
log "Current Git status:"
git status --porcelain

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    warn "You have uncommitted changes."
    git status
    echo ""
    read -p "Do you want to commit these changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        read -p "Enter commit message: " commit_msg
        if [ -z "$commit_msg" ]; then
            commit_msg="Auto-sync changes $(date +'%Y-%m-%d %H:%M:%S')"
        fi
        git commit -m "$commit_msg"
        log "Changes committed locally"
    else
        error "Please commit or stash your changes before syncing"
    fi
fi

# Push to GitHub
log "Pushing changes to GitHub..."
git push origin main

# Show the GitHub repository URL
info "Code updated at: https://github.com/CalicoWoodSigns/calicoKnotts"

# Instructions for updating remote server
log "To update the remote server with latest changes:"
echo ""
info "Option 1: SSH to remote server (if available) and run:"
echo "cd $REMOTE_PATH"
echo "git pull origin main"
echo ""
info "Option 2: Use the deployment script:"
echo "./deploy/ftps-deploy.sh"
echo ""
info "Option 3: Manual FTPS upload using FileZilla:"
echo "Host: $FTP_HOST"
echo "Username: $FTP_USER"
echo "Password: $FTP_PASS"
echo "Remote Path: $FTP_PATH"
echo ""

# Test if remote server has Git capability
log "Testing remote server Git capability..."
if command -v ssh &> /dev/null; then
    info "SSH available - you can potentially use Git on remote server"
    echo "To test: ssh $FTP_USER@$FTP_HOST 'git --version'"
else
    info "SSH not available locally - use FTPS deployment method"
fi

# Show version info
CURRENT_COMMIT=$(git rev-parse HEAD)
CURRENT_BRANCH=$(git branch --show-current)
log "Current version: $CURRENT_BRANCH @ $CURRENT_COMMIT"
log "Remote URL: $APPLICATION_URL"
log "GitHub: https://github.com/CalicoWoodSigns/calicoKnotts"

log "Sync completed! Your changes are now in version control."
