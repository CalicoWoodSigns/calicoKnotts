-- KBF Data Management System - Sample Data
-- Run this script to populate the database with initial data

-- Insert sample employees
INSERT INTO EMPLOYEEINFO (USERNAME, FIRSTNAME, LASTNAME, ADDRESS1, CITY, STATE, PHONE, PASSWORD, ACCESSLEVEL)
VALUES 
    ('admin', 'Admin', 'User', '123 Main St', 'Los Angeles', 'CA', '555-0001', 'admin123', 3),
    ('manager', 'Manager', 'Person', '456 Oak Ave', 'Los Angeles', 'CA', '555-0002', 'manager123', 2),
    ('john.doe', 'John', 'Doe', '789 Pine St', 'Los Angeles', 'CA', '555-0003', 'password123', 1),
    ('jane.smith', 'Jane', 'Smith', '321 Elm St', 'Los Angeles', 'CA', '555-0004', 'password123', 1),
    ('bob.wilson', 'Bob', 'Wilson', '654 Maple Ave', 'Los Angeles', 'CA', '555-0005', 'password123', 1),
    ('alice.johnson', 'Alice', 'Johnson', '987 Cedar Blvd', 'Los Angeles', 'CA', '555-0006', 'password123', 1);

-- Insert sample sales data for the current month
DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
DECLARE @CurrentDate DATE = GETDATE();
DECLARE @EID INT;
DECLARE @Counter INT = 1;

-- Get employee IDs for sample data
DECLARE @John INT = (SELECT EID FROM EMPLOYEEINFO WHERE USERNAME = 'john.doe');
DECLARE @Jane INT = (SELECT EID FROM EMPLOYEEINFO WHERE USERNAME = 'jane.smith');
DECLARE @Bob INT = (SELECT EID FROM EMPLOYEEINFO WHERE USERNAME = 'bob.wilson');
DECLARE @Alice INT = (SELECT EID FROM EMPLOYEEINFO WHERE USERNAME = 'alice.johnson');

-- Insert sample sales data for the past 30 days
WHILE @Counter <= 30
BEGIN
    DECLARE @SampleDate DATE = DATEADD(DAY, -@Counter, @CurrentDate);
    
    -- John's sales (high performer)
    IF @Counter % 2 = 1 -- Work every other day
    BEGIN
        INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME)
        VALUES (@John, @SampleDate, 
                150 + (RAND() * 200), -- $150-$350 range
                6 + (RAND() * 3), -- 6-9 hours
                'Daily sales entry', 'John');
    END
    
    -- Jane's sales (consistent performer)
    IF @Counter % 3 <> 0 -- Work 2 out of 3 days
    BEGIN
        INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME)
        VALUES (@Jane, @SampleDate, 
                100 + (RAND() * 150), -- $100-$250 range
                5 + (RAND() * 4), -- 5-9 hours
                'Daily sales entry', 'Jane');
    END
    
    -- Bob's sales (part-time)
    IF @Counter % 4 = 0 -- Work 1 out of 4 days
    BEGIN
        INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME)
        VALUES (@Bob, @SampleDate, 
                80 + (RAND() * 120), -- $80-$200 range
                3 + (RAND() * 2), -- 3-5 hours
                'Part-time sales', 'Bob');
    END
    
    -- Alice's sales (weekend warrior)
    IF DATEPART(WEEKDAY, @SampleDate) IN (1, 7) -- Weekends only
    BEGIN
        INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME)
        VALUES (@Alice, @SampleDate, 
                200 + (RAND() * 300), -- $200-$500 range
                8 + (RAND() * 4), -- 8-12 hours
                'Weekend sales', 'Alice');
    END
    
    SET @Counter = @Counter + 1;
END

-- Insert today's sample entry if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM EMPLOYEESALES WHERE EID = @John AND CONVERT(date, SALEDATE) = CONVERT(date, GETDATE()))
BEGIN
    INSERT INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS, NOTES, FIRSTNAME)
    VALUES (@John, GETDATE(), 275.50, 8, 'Today''s sales', 'John');
END

PRINT 'Sample data inserted successfully!'
PRINT 'Employees created: 6 (1 admin, 1 manager, 4 employees)'
PRINT 'Sales records created: Approximately 30-60 records for the past 30 days'

-- Display summary
SELECT 
    'Summary Report' as Report,
    (SELECT COUNT(*) FROM EMPLOYEEINFO) as TotalEmployees,
    (SELECT COUNT(*) FROM EMPLOYEESALES) as TotalSalesRecords,
    (SELECT SUM(AMOUNT) FROM EMPLOYEESALES) as TotalSalesAmount,
    (SELECT SUM(HOURS) FROM EMPLOYEESALES) as TotalHours;
