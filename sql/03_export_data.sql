-- KBF Data Management System - Data Export Script
-- Run this script on your EXISTING database to export data
-- This creates INSERT statements that can be run on your new database

-- Export EMPLOYEEINFO data
SELECT 
    'INSERT INTO EMPLOYEEINFO (USERNAME, FIRSTNAME, LASTNAME, ADDRESS1, ADDRESS2, CITY, STATE, PHONE, PASSWORD, ACCESSLEVEL) VALUES (' +
    '''' + ISNULL(USERNAME, '') + ''', ' +
    '''' + ISNULL(FIRSTNAME, '') + ''', ' +
    '''' + ISNULL(LASTNAME, '') + ''', ' +
    '''' + ISNULL(ADDRESS1, '') + ''', ' +
    '''' + ISNULL(ADDRESS2, '') + ''', ' +
    '''' + ISNULL(CITY, '') + ''', ' +
    '''' + ISNULL(STATE, '') + ''', ' +
    '''' + ISNULL(PHONE, '') + ''', ' +
    '''' + ISNULL(PASSWORD, '') + ''', ' +
    CAST(ACCESSLEVEL AS VARCHAR) + ');' AS EmployeeInserts
FROM EMPLOYEEINFO
ORDER BY EID;

-- Export EMPLOYEESALES data (last 90 days to avoid too much data)
SELECT 
    'INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME) VALUES (' +
    '(SELECT EID FROM EMPLOYEEINFO WHERE USERNAME = ''' + 
    (SELECT USERNAME FROM EMPLOYEEINFO WHERE EID = ES.EID) + '''), ' +
    '''' + CONVERT(VARCHAR, SALEDATE, 120) + ''', ' +
    CAST(AMOUNT AS VARCHAR) + ', ' +
    CAST(HOURS AS VARCHAR) + ', ' +
    '''' + ISNULL(REPLACE(NOTES, '''', ''''''), '') + ''', ' +
    '''' + ISNULL(FIRSTNAME, '') + ''');' AS SalesInserts
FROM EMPLOYEESALES ES
WHERE SALEDATE >= DATEADD(DAY, -90, GETDATE())
ORDER BY SALEDATE DESC;

-- Create a summary report
SELECT 
    'Data Export Summary' as Report,
    (SELECT COUNT(*) FROM EMPLOYEEINFO) as TotalEmployees,
    (SELECT COUNT(*) FROM EMPLOYEESALES WHERE SALEDATE >= DATEADD(DAY, -90, GETDATE())) as SalesRecordsLast90Days,
    (SELECT SUM(AMOUNT) FROM EMPLOYEESALES WHERE SALEDATE >= DATEADD(DAY, -90, GETDATE())) as TotalSalesLast90Days;
