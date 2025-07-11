# KBF Data Management System - Database Setup Guide

## Overview
This guide will help you set up the database for your new calicoknotts.com hosting and migrate data from your existing database.

## Prerequisites
- Access to CFDynamics control panel
- SQL Server Management Studio or similar database tool
- Access to your existing database

## Step 1: Create Database on New Server

### 1.1 Create Database in Control Panel
1. Log into your CFDynamics control panel
2. Go to "Space Home" → "Databases"
3. Click "Add Database"
4. Choose "SQL Server 2019"
5. Database name: `calicoknotts_db` (or your preferred name)
6. Create a database user with full permissions
7. Note down the connection details

### 1.2 Create Datasource in ColdFusion Administrator
1. Access ColdFusion Administrator (usually at your-domain.com/CFIDE/administrator)
2. Go to "Data & Services" → "Data Sources"
3. Add New Data Source:
   - Data Source Name: `calicoknottsdsn`
   - Driver: Microsoft SQL Server
   - Server: [Server name from control panel]
   - Port: 1433
   - Database: [Your database name]
   - Username: [Your database username]
   - Password: [Your database password]
4. Click "Submit" and test the connection

## Step 2: Create Database Structure

### 2.1 Run Table Creation Script
1. Connect to your new database using SQL Server Management Studio
2. Open and run: `sql/01_create_tables.sql`
3. This will create:
   - EMPLOYEEINFO table
   - EMPLOYEESALES table
   - Indexes for performance
   - Helpful views

### 2.2 Verify Structure
Run this query to verify tables were created:
```sql
SELECT TABLE_NAME, TABLE_TYPE 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
```

## Step 3: Migrate Data from Existing Database

### Option A: Manual Export/Import (Recommended)
1. Run `sql/03_export_data.sql` on your **existing database**
2. Copy the INSERT statements from the results
3. Run those INSERT statements on your **new database**

### Option B: Use Sample Data for Testing
1. Run `sql/02_sample_data.sql` on your new database
2. This creates sample employees and sales data for testing

### Option C: Direct Migration (Advanced)
1. Modify `sql/04_migration.sql` with your server details
2. Run the migration script (requires linked server setup)

## Step 4: Update ColdFusion Code

### 4.1 Update Datasource Name
Your current code uses `datasource="calicowoodsignsdsn"`
You'll need to update this to match your new datasource name.

**Find and replace in all .cfm/.cfml files:**
- Old: `datasource="calicowoodsignsdsn"`
- New: `datasource="calicoknottsdsn"`

### 4.2 Files to Update
- `index.cfm`
- `admin_dashboard.cfml`
- `employee_dashboard.cfml`
- `EditEmployeeSales.cfml`
- `edit_employee_info.cfml`
- Any other files with database queries

## Step 5: Test the Application

### 5.1 Test Database Connection
1. Upload your files to the new server
2. Access your application at `http://calicoknotts.com`
3. Check for any database connection errors

### 5.2 Test Login
Use the sample credentials or your migrated data:
- Admin: `admin` / `admin123`
- Manager: `manager` / `manager123`
- Employee: `john.doe` / `password123`

### 5.3 Test Functionality
- Login with different user levels
- Add sales entries
- View dashboards
- Check leaderboards

## Step 6: Production Deployment

### 6.1 Update Application Settings
1. Verify timezone settings (Pacific Time)
2. Update budget amounts if needed
3. Configure email settings if using email features

### 6.2 Security Checklist
- [ ] Change default passwords
- [ ] Set up SSL certificate
- [ ] Configure firewall rules
- [ ] Set up database backups
- [ ] Review access levels

## Troubleshooting

### Common Issues
1. **Database Connection Errors**
   - Check datasource configuration
   - Verify server name and credentials
   - Test connection in CF Administrator

2. **Table Not Found Errors**
   - Ensure all SQL scripts ran successfully
   - Check table names match exactly
   - Verify case sensitivity

3. **Login Issues**
   - Check EMPLOYEEINFO table has data
   - Verify password fields are populated
   - Check ACCESSLEVEL values (1=employee, 2=manager, 3=admin)

### Support Resources
- CFDynamics Support: Submit ticket for database issues
- ColdFusion Documentation: For CF-specific problems
- SQL Server Documentation: For database-specific issues

## Backup and Maintenance

### Regular Backups
1. Set up automatic database backups in control panel
2. Export data regularly using the export script
3. Keep backups of your ColdFusion code

### Performance Monitoring
1. Monitor database performance
2. Check query execution times
3. Review and optimize slow queries

---

**Need Help?**
If you encounter issues during setup, the migration scripts provide a solid foundation. The sample data can be used for testing while you work on migrating your real data.
