# Manual Sync Guide - Download from Current Site

Since your current site at `emp77.calicowoodsigns.com` isn't accessible via automated scripts, here's how to manually sync your files.

## Option 1: Use FTP Client (Recommended)

### Step 1: Get FTP Details
Contact your current hosting provider to get:
- FTP server address
- FTP username
- FTP password
- Directory path where your files are stored

### Step 2: Download Files Using FTP Client
Use an FTP client like FileZilla, Cyberduck, or Terminal:

**Using FileZilla:**
1. Host: `ftp.your-current-host.com`
2. Username: `your_username`
3. Password: `your_password`
4. Port: 21 (or 22 for SFTP)

**Using Terminal:**
```bash
# Connect to FTP
ftp ftp.your-current-host.com

# Login with your credentials
# Navigate to your web directory
cd /public_html  # or wherever your files are

# Download files
get index.cfm
get admin_dashboard.cfml
get employee_dashboard.cfml
get edit_employee_info.cfml
get EditEmployeeSales.cfml
get read_csv.cfm
get nav.cfm
get navEmp.cfm
get TablesColumns.cfml
get ViewTableData.cfml
get rj.cfm
get style.css
get logout.cfm

# Exit FTP
quit
```

## Option 2: Use Web-based File Manager

If your hosting provides a web-based file manager:
1. Log into your hosting control panel
2. Open File Manager
3. Navigate to your web directory
4. Download the files you need

## Option 3: Use cPanel or Similar

If you have cPanel access:
1. Login to cPanel
2. Go to File Manager
3. Select your domain's public_html folder
4. Download the active files

## Files to Download (Priority Order)

### Essential Application Files:
1. `index.cfm` - Main application file
2. `admin_dashboard.cfml` - Admin interface
3. `employee_dashboard.cfml` - Employee interface  
4. `edit_employee_info.cfml` - Employee editing
5. `EditEmployeeSales.cfml` - Sales editing
6. `read_csv.cfm` - CSV import functionality
7. `nav.cfm` - Navigation component
8. `navEmp.cfm` - Employee navigation
9. `style.css` - Styling

### Optional Files:
- `TablesColumns.cfml` - Database table viewer
- `ViewTableData.cfml` - Data viewer
- `rj.cfm` - Additional functionality
- `logout.cfm` - Logout functionality
- Any `.csv` files with current data

## After Downloading Files

Once you have the files downloaded to your local directory, run this script to process them:

```bash
# Run the local file processor
./deploy/process-downloaded-files.sh
```

## Alternative: Export Database Data

If you can access your current database, export the data:

1. **Via phpMyAdmin or similar:**
   - Export EMPLOYEEINFO table
   - Export EMPLOYEESALES table
   - Save as SQL files

2. **Via ColdFusion:**
   - Create a simple export script
   - Run it on your current site
   - Download the exported data

## Next Steps

1. Download the files using one of the methods above
2. Place them in: `/Users/R/ColdFusion/cfusion/wwwroot/KBFData/`
3. Run the file processor script
4. Test your local application
5. Commit changes to Git

## Need Help?

If you're having trouble accessing your current site:
1. Check with your current hosting provider
2. Verify the domain is still active
3. Try accessing via IP address if available
4. Check if there are any DNS issues
