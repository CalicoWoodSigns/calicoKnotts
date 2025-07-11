#!/bin/bash

# Process downloaded files script
# Use this after manually downloading files from your current site

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

LOCAL_DIR="/Users/R/ColdFusion/cfusion/wwwroot/KBFData"
BACKUP_DIR="${LOCAL_DIR}/backups/$(date +%Y%m%d_%H%M%S)"

# Create backup directory
info "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# List of files to check and process
FILES_TO_CHECK=(
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

echo ""
info "Processing downloaded files..."
info "Local directory: $LOCAL_DIR"
info "Backup directory: $BACKUP_DIR"
echo ""

# Check which files exist
existing_files=()
missing_files=()

for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$LOCAL_DIR/$file" ]; then
        existing_files+=("$file")
        success "Found: $file"
    else
        missing_files+=("$file")
        warning "Missing: $file"
    fi
done

echo ""

# Show summary
if [ ${#existing_files[@]} -gt 0 ]; then
    info "Found ${#existing_files[@]} files:"
    for file in "${existing_files[@]}"; do
        ls -la "$LOCAL_DIR/$file" | awk '{print "  " $9 " - " $5 " bytes, " $6 " " $7 " " $8}'
    done
fi

if [ ${#missing_files[@]} -gt 0 ]; then
    echo ""
    warning "Missing ${#missing_files[@]} files:"
    for file in "${missing_files[@]}"; do
        echo "  $file"
    done
fi

echo ""

# Check for old datasource names in existing files
info "Checking for old datasource references..."
files_with_old_dsn=()
for file in "${existing_files[@]}"; do
    if grep -q "calicowoodsignsdsn" "$LOCAL_DIR/$file" 2>/dev/null; then
        files_with_old_dsn+=("$file")
        warning "File contains old datasource: $file"
    fi
done

if [ ${#files_with_old_dsn[@]} -gt 0 ]; then
    echo ""
    warning "Found ${#files_with_old_dsn[@]} files with old datasource names"
    echo "These files need to be updated to use 'calicoknottsdsn'"
    echo ""
    read -p "Do you want to update datasource names now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create backups before updating
        info "Creating backups before updating datasource names..."
        for file in "${files_with_old_dsn[@]}"; do
            cp "$LOCAL_DIR/$file" "$BACKUP_DIR/$file"
            info "Backed up: $file"
        done
        
        # Update datasource names
        info "Updating datasource names..."
        for file in "${files_with_old_dsn[@]}"; do
            sed -i '' 's/calicowoodsignsdsn/calicoknottsdsn/g' "$LOCAL_DIR/$file"
            success "Updated: $file"
        done
        
        # Verify updates
        info "Verifying updates..."
        remaining_old_dsn=$(grep -l "calicowoodsignsdsn" "${LOCAL_DIR}"/*.cfm* 2>/dev/null)
        if [ -z "$remaining_old_dsn" ]; then
            success "All datasource names updated successfully!"
        else
            warning "Some files still contain old datasource names:"
            echo "$remaining_old_dsn"
        fi
    fi
fi

echo ""

# Check for any CSV files
info "Checking for CSV data files..."
csv_files=$(find "$LOCAL_DIR" -name "*.csv" -type f)
if [ -n "$csv_files" ]; then
    success "Found CSV files:"
    echo "$csv_files"
else
    info "No CSV files found"
fi

echo ""

# Test local application
info "Testing local ColdFusion application..."
echo "You can test your application at: http://localhost:8500/KBFData/"
echo ""

# Git status
if [ -d "$LOCAL_DIR/.git" ]; then
    info "Checking Git status..."
    cd "$LOCAL_DIR"
    git status --porcelain | head -10
    if [ $? -eq 0 ]; then
        echo ""
        read -p "Do you want to commit these changes to Git? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            git commit -m "Sync files from current site $(date +%Y-%m-%d)"
            success "Changes committed to Git"
        fi
    fi
fi

echo ""

# Summary
success "File processing complete!"
info "Files processed: ${#existing_files[@]}"
info "Backups stored in: $BACKUP_DIR"

if [ ${#missing_files[@]} -gt 0 ]; then
    warning "Missing files: ${#missing_files[@]}"
    echo "You may want to download these files manually:"
    for file in "${missing_files[@]}"; do
        echo "  $file"
    done
fi

echo ""
info "Next steps:"
info "1. Test your local application: http://localhost:8500/KBFData/"
info "2. Review the processed files"
info "3. Make any necessary adjustments"
info "4. Prepare for deployment to new site"
