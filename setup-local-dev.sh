#!/bin/bash

# Setup script for local development environment
# This sets up the SQLite database and ColdFusion datasource

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

# Configuration
LOCAL_DIR="/Users/R/ColdFusion/cfusion/wwwroot/KBFData"
DB_FILE="${LOCAL_DIR}/database/kbfdata.db"
CF_HOME="/Users/R/ColdFusion/cfusion"

echo ""
info "Setting up local development environment..."
echo ""

# Check if ColdFusion is running
if ! pgrep -f "coldfusion" > /dev/null; then
    error "ColdFusion is not running!"
    echo "Please start ColdFusion first:"
    echo "  cd /Users/R/ColdFusion/cfusion/bin"
    echo "  ./cfstart"
    exit 1
fi

success "ColdFusion is running"

# Check if database exists
if [ -f "$DB_FILE" ]; then
    success "SQLite database exists: $DB_FILE"
    
    # Show database stats
    employee_count=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM EMPLOYEEINFO;")
    sales_count=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM EMPLOYEESALES;")
    
    info "Database contains:"
    info "  - $employee_count employees"
    info "  - $sales_count sales records"
else
    error "SQLite database not found: $DB_FILE"
    echo "Creating database..."
    
    # Create database
    if sqlite3 "$DB_FILE" < "${LOCAL_DIR}/database/create_local_db.sql"; then
        success "Database created successfully"
    else
        error "Failed to create database"
        exit 1
    fi
fi

echo ""
info "Next steps for ColdFusion Administrator setup:"
echo ""
echo "1. Open ColdFusion Administrator:"
echo "   http://localhost:8500/CFIDE/administrator/"
echo ""
echo "2. Go to 'Data & Services' → 'Data Sources'"
echo ""
echo "3. Add a new datasource:"
echo "   - Data Source Name: localKBFData"
echo "   - Driver: Other"
echo "   - JDBC URL: jdbc:sqlite:${DB_FILE}"
echo "   - Class: org.sqlite.JDBC"
echo ""
echo "4. Download SQLite JDBC driver if not already available:"
echo "   https://github.com/xerial/sqlite-jdbc/releases"
echo "   Place sqlite-jdbc-x.x.x.jar in: ${CF_HOME}/lib/"
echo ""
echo "5. Test the connection in CF Administrator"
echo ""

# Check if we can access CF Administrator
info "Testing ColdFusion Administrator access..."
if curl -s -f "http://localhost:8500/CFIDE/administrator/" > /dev/null; then
    success "ColdFusion Administrator is accessible"
    echo ""
    warning "IMPORTANT: You'll need to manually set up the datasource in CF Administrator"
    echo ""
    echo "Alternative: Use the ColdFusion datasource configuration file method:"
    echo "  1. Copy datasource config to: ${CF_HOME}/lib/neo-datasource.xml"
    echo "  2. Restart ColdFusion"
else
    warning "ColdFusion Administrator may not be accessible"
    echo "Please check if ColdFusion is running and try:"
    echo "  http://localhost:8500/CFIDE/administrator/"
fi

echo ""
info "Development environment setup complete!"
echo ""
echo "Test your application at:"
echo "  http://localhost:8500/KBFData/"
echo ""
echo "Login credentials for testing:"
echo "  Username: admin, Password: password123 (Administrator)"
echo "  Username: john, Password: password123 (Employee)"
echo "  Username: jane, Password: password123 (Employee)"
echo "  Username: mike, Password: password123 (Manager)"
