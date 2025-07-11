# Local Development Setup Guide

## Overview
This guide sets up a local development environment using SQLite, so you can develop and test your application locally while keeping the production environment separate.

## Environment Configuration

### How It Works
- **Local Development**: Uses SQLite database (`localKBFData` datasource)
- **Production**: Uses SQL Server database (`calicoknottsdsn` datasource)
- **Auto-Detection**: The application automatically detects which environment it's running in

### Configuration Files
- `config/database.cfm` - Environment detection and database configuration
- `database/kbfdata.db` - Local SQLite database file
- `database/create_local_db.sql` - Database schema and sample data

## Setup Steps

### 1. Install SQLite JDBC Driver
```bash
# Download SQLite JDBC driver
curl -L -o sqlite-jdbc.jar https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.46.0.0/sqlite-jdbc-3.46.0.0.jar

# Copy to ColdFusion lib directory (you may need admin privileges)
sudo cp sqlite-jdbc.jar /Users/R/ColdFusion/cfusion/lib/
```

### 2. Create Local Datasource in ColdFusion Administrator

1. **Open ColdFusion Administrator**:
   - URL: `http://localhost:8500/CFIDE/administrator/`
   - Login with your admin credentials

2. **Navigate to Data Sources**:
   - Go to "Data & Services" → "Data Sources"

3. **Add New Data Source**:
   - **Data Source Name**: `localKBFData`
   - **Driver**: `Other`
   - Click "Add"

4. **Configure the Data Source**:
   - **JDBC URL**: `jdbc:sqlite:/Users/R/ColdFusion/cfusion/wwwroot/KBFData/database/kbfdata.db`
   - **Driver Class**: `org.sqlite.JDBC`
   - **Username**: (leave blank)
   - **Password**: (leave blank)

5. **Test Connection**:
   - Click "Submit"
   - Verify the connection test passes

### 3. Alternative: Manual Driver Installation

If you have permission issues, manually copy the driver:

```bash
# Create backup of current lib directory
cd /Users/R/ColdFusion/cfusion/lib
ls -la sqlite-jdbc* || echo "No existing SQLite driver found"

# Copy the downloaded driver
# You may need to use Finder to copy the file with admin privileges
```

### 4. Restart ColdFusion (if needed)

```bash
cd /Users/R/ColdFusion/cfusion/bin
./cfstop
./cfstart
```

## Database Schema

### Tables Created
- **EMPLOYEEINFO**: Employee information and login credentials
- **EMPLOYEESALES**: Sales tracking data
- **Indexes**: Performance optimization

### Sample Data
- 4 test employees with different access levels
- 8 sample sales records
- Test login credentials (see below)

## Test Login Credentials

| Username | Password | Access Level | Role |
|----------|----------|--------------|------|
| admin | password123 | 3 | Administrator |
| john | password123 | 1 | Employee |
| jane | password123 | 1 | Employee |
| mike | password123 | 2 | Manager |

## Testing Your Setup

1. **Test Database Connection**:
   ```bash
   sqlite3 database/kbfdata.db "SELECT COUNT(*) FROM EMPLOYEEINFO;"
   ```

2. **Test Application**:
   - Open: `http://localhost:8500/KBFData/`
   - Login with test credentials
   - Verify data displays correctly

3. **Check Environment Detection**:
   - Look for environment info at the top of the page (local environment only)
   - Should show "Environment: local" and "Datasource: localKBFData"

## Database Management

### View Data
```bash
# Connect to database
sqlite3 database/kbfdata.db

# List tables
.tables

# View employees
SELECT * FROM EMPLOYEEINFO;

# View sales
SELECT * FROM EMPLOYEESALES;

# Exit
.exit
```

### Backup Database
```bash
# Backup current database
cp database/kbfdata.db database/kbfdata_backup_$(date +%Y%m%d_%H%M%S).db
```

### Reset Database
```bash
# Remove current database
rm database/kbfdata.db

# Recreate with sample data
sqlite3 database/kbfdata.db < database/create_local_db.sql
```

## Troubleshooting

### Common Issues

1. **Datasource Not Found**:
   - Check if SQLite JDBC driver is in `/Users/R/ColdFusion/cfusion/lib/`
   - Verify datasource name in CF Administrator
   - Restart ColdFusion

2. **Permission Denied**:
   - Check file permissions on database file
   - Ensure ColdFusion can read/write to database directory

3. **Database Locked**:
   - Close any open SQLite connections
   - Restart ColdFusion if needed

### Debug Mode
The application shows debug information in local environment:
- Environment detection results
- Current datasource being used
- Database type and file location

## Production Deployment

When deploying to production:
1. The application automatically detects the production environment
2. Uses `calicoknottsdsn` datasource (SQL Server)
3. No debug information is shown
4. Database configuration is handled by CFDynamics

## File Structure
```
KBFData/
├── config/
│   └── database.cfm          # Environment detection
├── database/
│   ├── kbfdata.db           # SQLite database file
│   └── create_local_db.sql  # Database schema
├── setup-local-dev.sh       # Setup script
└── [application files]
```

## Security Notes
- Test credentials are for development only
- Change passwords before production deployment
- SQLite database file should not be committed to version control
- Local database is for development/testing only
