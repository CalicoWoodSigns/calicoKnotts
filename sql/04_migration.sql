-- KBF Data Management System - Database Migration Script
-- This script helps migrate data from your existing database to the new one

-- Step 1: Create a linked server connection (if migrating between servers)
-- You'll need to run this on the SOURCE server to connect to the DESTINATION server

/*
-- Example of creating a linked server (adjust connection details)
EXEC sp_addlinkedserver 
    @server = 'CALICOKNOTTS_SERVER',
    @srvproduct = 'SQL Server',
    @provider = 'SQLNCLI',
    @datasrc = 'your-new-server-name';

-- Set up login mapping
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'CALICOKNOTTS_SERVER',
    @useself = 'false',
    @locallogin = NULL,
    @rmtuser = 'your-username',
    @rmtpassword = 'your-password';
*/

-- Step 2: Direct migration queries (if both databases are accessible)
-- Run these on the DESTINATION server after creating the table structure

-- Clear existing data (be careful!)
-- DELETE FROM EMPLOYEESALES;
-- DELETE FROM EMPLOYEEINFO;

-- Insert employees from source database
-- INSERT INTO EMPLOYEEINFO (USERNAME, FIRSTNAME, LASTNAME, ADDRESS1, ADDRESS2, CITY, STATE, PHONE, PASSWORD, ACCESSLEVEL)
-- SELECT USERNAME, FIRSTNAME, LASTNAME, ADDRESS1, ADDRESS2, CITY, STATE, PHONE, PASSWORD, ACCESSLEVEL
-- FROM [SOURCE_SERVER].[SOURCE_DATABASE].[dbo].[EMPLOYEEINFO];

-- Insert sales data from source database
-- INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME)
-- SELECT 
--     dest_ei.EID,
--     src_es.SALEDATE,
--     src_es.AMOUNT,
--     src_es.HOURS,
--     src_es.NOTES,
--     src_es.FIRSTNAME
-- FROM [SOURCE_SERVER].[SOURCE_DATABASE].[dbo].[EMPLOYEESALES] src_es
-- INNER JOIN [SOURCE_SERVER].[SOURCE_DATABASE].[dbo].[EMPLOYEEINFO] src_ei ON src_es.EID = src_ei.EID
-- INNER JOIN EMPLOYEEINFO dest_ei ON src_ei.USERNAME = dest_ei.USERNAME;

-- Step 3: Manual migration process (recommended)
-- 1. Run 03_export_data.sql on your existing database
-- 2. Copy the INSERT statements from the results
-- 3. Run those INSERT statements on your new database

PRINT 'Migration script template created.'
PRINT 'Please customize the server names and connection details for your environment.'
PRINT 'For manual migration:'
PRINT '1. Run 03_export_data.sql on your existing database'
PRINT '2. Copy the INSERT statements from the results'
PRINT '3. Run those INSERT statements on your new database'
