-- Local SQLite database setup for KBF Data Management System
-- This creates the same structure as the SQL Server version but optimized for SQLite

-- Create EMPLOYEEINFO table
CREATE TABLE IF NOT EXISTS EMPLOYEEINFO (
    EID INTEGER PRIMARY KEY AUTOINCREMENT,
    FIRSTNAME TEXT NOT NULL,
    LASTNAME TEXT NOT NULL,
    PHONENUMBER TEXT,
    EMAIL TEXT,
    HIREDATE TEXT,
    POSITION TEXT,
    PAYRATE DECIMAL(10,2),
    ACCESSLEVEL INTEGER DEFAULT 1,
    USERNAME TEXT UNIQUE,
    PASSWORD TEXT,
    CREATEDATE TEXT DEFAULT CURRENT_TIMESTAMP,
    LASTMODIFIED TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Create EMPLOYEESALES table
CREATE TABLE IF NOT EXISTS EMPLOYEESALES (
    SALESID INTEGER PRIMARY KEY AUTOINCREMENT,
    EID INTEGER NOT NULL,
    SALEDATE TEXT NOT NULL,
    AMOUNT DECIMAL(10,2) NOT NULL,
    HOURS DECIMAL(5,2) NOT NULL,
    CREATEDATE TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (EID) REFERENCES EMPLOYEEINFO(EID)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_employeesales_eid ON EMPLOYEESALES(EID);
CREATE INDEX IF NOT EXISTS idx_employeesales_saledate ON EMPLOYEESALES(SALEDATE);
CREATE INDEX IF NOT EXISTS idx_employeeinfo_username ON EMPLOYEEINFO(USERNAME);

-- Insert sample data for testing
INSERT OR IGNORE INTO EMPLOYEEINFO (FIRSTNAME, LASTNAME, PHONENUMBER, EMAIL, HIREDATE, POSITION, PAYRATE, ACCESSLEVEL, USERNAME, PASSWORD)
VALUES 
('Admin', 'User', '555-0100', 'admin@calicoknotts.com', date('now'), 'Administrator', 25.00, 3, 'admin', 'password123'),
('John', 'Doe', '555-0101', 'john@calicoknotts.com', date('now'), 'Sales Associate', 15.00, 1, 'john', 'password123'),
('Jane', 'Smith', '555-0102', 'jane@calicoknotts.com', date('now'), 'Sales Associate', 16.00, 1, 'jane', 'password123'),
('Mike', 'Johnson', '555-0103', 'mike@calicoknotts.com', date('now'), 'Manager', 20.00, 2, 'mike', 'password123');

-- Insert sample sales data
INSERT OR IGNORE INTO EMPLOYEESALES (EID, SALEDATE, AMOUNT, HOURS)
VALUES 
(1, date('now'), 150.00, 8.0),
(2, date('now'), 200.00, 7.5),
(3, date('now'), 175.00, 8.0),
(4, date('now'), 250.00, 8.0),
(1, date('now', '-1 day'), 125.00, 6.0),
(2, date('now', '-1 day'), 180.00, 7.0),
(3, date('now', '-1 day'), 160.00, 8.0),
(4, date('now', '-1 day'), 220.00, 8.0);

-- Create a view for easy data access (similar to the SQL Server version)
CREATE VIEW IF NOT EXISTS EmployeeSalesView AS
SELECT 
    es.SALESID,
    es.EID,
    ei.FIRSTNAME,
    ei.LASTNAME,
    es.SALEDATE,
    es.AMOUNT,
    es.HOURS,
    CASE 
        WHEN es.HOURS > 0 THEN es.AMOUNT / es.HOURS
        ELSE 0
    END AS SALESPERHOUR
FROM EMPLOYEESALES es
INNER JOIN EMPLOYEEINFO ei ON es.EID = ei.EID
ORDER BY es.SALEDATE DESC;
