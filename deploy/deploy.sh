#!/bin/bash

# KBF Data Management System - Deployment Script
# Usage: ./deploy.sh [environment]
# Environments: staging, production

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Default environment
ENVIRONMENT=${1:-staging}

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Load environment configuration
if [ -f "$SCRIPT_DIR/config/$ENVIRONMENT.env" ]; then
    log "Loading configuration for $ENVIRONMENT environment"
    source "$SCRIPT_DIR/config/$ENVIRONMENT.env"
else
    error "Configuration file not found: $SCRIPT_DIR/config/$ENVIRONMENT.env"
fi

# Validate required variables
if [ -z "$REMOTE_HOST" ] || [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_PATH" ]; then
    error "Missing required configuration variables. Check your environment file."
fi

log "Starting deployment to $ENVIRONMENT environment"
log "Remote host: $REMOTE_HOST"
log "Remote path: $REMOTE_PATH"

# Pre-deployment checks
log "Running pre-deployment checks..."

# Check if git repository is clean
if ! git diff-index --quiet HEAD --; then
    warn "Git repository has uncommitted changes"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        error "Deployment cancelled"
    fi
fi

# Build/preparation steps
log "Preparing deployment package..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
log "Using temporary directory: $TEMP_DIR"

# Copy files to temporary directory
rsync -av \
    --exclude-from="$PROJECT_DIR/.gitignore" \
    --exclude='.git/' \
    --exclude='deploy/' \
    --exclude='*.log' \
    --exclude='temp/' \
    "$PROJECT_DIR/" "$TEMP_DIR/"

# Deploy to remote server
log "Deploying to remote server..."

if [ "$DEPLOY_METHOD" == "rsync" ]; then
    # Deploy using rsync
    rsync -avz \
        --delete \
        --exclude='config/config.properties' \
        --exclude='logs/' \
        --exclude='cache/' \
        "$TEMP_DIR/" \
        "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/"
elif [ "$DEPLOY_METHOD" == "ftps" ]; then
    # Deploy using FTPS
    log "Using FTPS deployment to Windows server..."
    log "Manual FTPS deployment required:"
    log "  Host: $FTP_HOST"
    log "  User: $FTP_USER"
    log "  Port: $FTP_PORT"
    log "  Path: $FTP_PATH"
    log "  Files prepared in: $TEMP_DIR"
    log "Use FileZilla or similar FTPS client with 'Explicit FTP over TLS' and Passive mode"
    read -p "Press Enter after completing FTPS upload..."
elif [ "$DEPLOY_METHOD" == "git" ]; then
    # Deploy using git
    ssh "$REMOTE_USER@$REMOTE_HOST" "cd $REMOTE_PATH && git pull origin main"
else
    error "Unknown deployment method: $DEPLOY_METHOD"
fi

# Post-deployment tasks
log "Running post-deployment tasks..."

# Restart services if specified
if [ ! -z "$RESTART_COMMAND" ]; then
    log "Restarting services..."
    ssh "$REMOTE_USER@$REMOTE_HOST" "$RESTART_COMMAND"
fi

# Clean up
rm -rf "$TEMP_DIR"

log "Deployment completed successfully!"
log "Application URL: $APPLICATION_URL"
