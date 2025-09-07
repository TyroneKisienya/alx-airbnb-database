-- TABLE PARTITIONING IMPLEMENTATION FOR BOOKING TABLE
-- Objective: Optimize queries on large datasets using date-based partitioning

-- ============================================
-- PRE-PARTITIONING SETUP AND ANALYSIS
-- ============================================

-- Check current table size and performance baseline
SELECT 
    COUNT(*) as total_bookings,
    MIN(start_date) as earliest_booking,
    MAX(start_date) as latest_booking,
    YEAR(MIN(start_date)) as first_year,
    YEAR(MAX(start_date)) as last_year
FROM Booking;

-- Analyze data distribution by year/month
SELECT 
    YEAR(start_date) as booking_year,
    MONTH(start_date) as booking_month,
    COUNT(*) as booking_count
FROM Booking 
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY booking_year, booking_month;

-- Performance baseline - test query before partitioning
SET profiling = 1;
SELECT b.booking_id, b.start_date, b.end_date, b.status
FROM Booking b 
WHERE b.start_date BETWEEN '2024-06-01' AND '2024-08-31';
SHOW PROFILES;

-- ============================================
-- STEP 1: BACKUP EXISTING DATA
-- ============================================

-- Create backup table
CREATE TABLE Booking_backup AS SELECT * FROM Booking;

-- Verify backup
SELECT COUNT(*) as backup_count FROM Booking_backup;

-- ============================================
-- STEP 2: DROP AND RECREATE BOOKING TABLE WITH PARTITIONING
-- ============================================

-- Drop existing table (after backup!)
-- WARNING: This will drop all data in the original table
DROP TABLE Booking;

-- Create new partitioned Booking table
CREATE TABLE Booking (
    booking_id VARCHAR(50) PRIMARY KEY,
    property_id CHAR(50) NOT NULL,
    user_id CHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending','confirmed','canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Foreign key constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,

    -- Constraint
    CONSTRAINT chk_booking_date CHECK (end_date > start_date),

    -- Indexes optimized for partitioned table
    INDEX idx_booking_property_id (property_id),
    INDEX idx_booking_user_id (user_id),
    INDEX idx_booking_status (status),
    INDEX idx_booking_created_at (created_at),
    INDEX idx_booking_dates (start_date, end_date)
)
-- PARTITION BY RANGE based on start_date (monthly partitions)
PARTITION BY RANGE (YEAR(start_date) * 100 + MONTH(start_date)) (
    -- 2023 Partitions
    PARTITION p2023_01 VALUES LESS THAN (202302),  -- January 2023
    PARTITION p2023_02 VALUES LESS THAN (202303),  -- February 2023  
    PARTITION p2023_03 VALUES LESS THAN (202304),  -- March 2023
    PARTITION p2023_04 VALUES LESS THAN (202305),  -- April 2023
    PARTITION p2023_05 VALUES LESS THAN (202306),  -- May 2023
    PARTITION p2023_06 VALUES LESS THAN (202307),  -- June 2023
    PARTITION p2023_07 VALUES LESS THAN (202308),  -- July 2023
    PARTITION p2023_08 VALUES LESS THAN (202309),  -- August 2023
    PARTITION p2023_09 VALUES LESS THAN (202310),  -- September 2023
    PARTITION p2023_10 VALUES LESS THAN (202311),  -- October 2023
    PARTITION p2023_11 VALUES LESS THAN (202312),  -- November 2023
    PARTITION p2023_12 VALUES LESS THAN (202401),  -- December 2023

    -- 2024 Partitions
    PARTITION p2024_01 VALUES LESS THAN (202402),  -- January 2024
    PARTITION p2024_02 VALUES LESS THAN (202403),  -- February 2024
    PARTITION p2024_03 VALUES LESS THAN (202404),  -- March 2024
    PARTITION p2024_04 VALUES LESS THAN (202405),  -- April 2024
    PARTITION p2024_05 VALUES LESS THAN (202406),  -- May 2024
    PARTITION p2024_06 VALUES LESS THAN (202407),  -- June 2024
    PARTITION p2024_07 VALUES LESS THAN (202408),  -- July 2024
    PARTITION p2024_08 VALUES LESS THAN (202409),  -- August 2024
    PARTITION p2024_09 VALUES LESS THAN (202410),  -- September 2024
    PARTITION p2024_10 VALUES LESS THAN (202411),  -- October 2024
    PARTITION p2024_11 VALUES LESS THAN (202412),  -- November 2024
    PARTITION p2024_12 VALUES LESS THAN (202501),  -- December 2024

    -- 2025 Partitions
    PARTITION p2025_01 VALUES LESS THAN (202502),  -- January 2025
    PARTITION p2025_02 VALUES LESS THAN (202503),  -- February 2025
    PARTITION p2025_03 VALUES LESS THAN (202504),  -- March 2025
    PARTITION p2025_04 VALUES LESS THAN (202505),  -- April 2025
    PARTITION p2025_05 VALUES LESS THAN (202506),  -- May 2025
    PARTITION p2025_06 VALUES LESS THAN (202507),  -- June 2025
    PARTITION p2025_07 VALUES LESS THAN (202508),  -- July 2025
    PARTITION p2025_08 VALUES LESS THAN (202509),  -- August 2025
    PARTITION p2025_09 VALUES LESS THAN (202510),  -- September 2025
    PARTITION p2025_10 VALUES LESS THAN (202511),  -- October 2025
    PARTITION p2025_11 VALUES LESS THAN (202512),  -- November 2025
    PARTITION p2025_12 VALUES LESS THAN (202601),  -- December 2025

    -- Future partition for overflow
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ============================================
-- STEP 3: RESTORE DATA TO PARTITIONED TABLE
-- ============================================

-- Insert data back from backup
INSERT INTO Booking SELECT * FROM Booking_backup;

-- Verify data restoration
SELECT COUNT(*) as restored_count FROM Booking;

-- Check partition distribution
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    PARTITION_DESCRIPTION
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'Booking' 
    AND PARTITION_NAME IS NOT NULL
ORDER BY PARTITION_NAME;

-- ============================================
-- ALTERNATIVE: QUARTERLY PARTITIONING (FOR VERY LARGE DATASETS)
-- ============================================

/*
-- If monthly partitions are too granular, use quarterly partitioning:

DROP TABLE Booking;

CREATE TABLE Booking (
    booking_id VARCHAR(50) PRIMARY KEY,
    property_id CHAR(50) NOT NULL,
    user_id CHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending','confirmed','canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_booking_date CHECK (end_date > start_date),

    INDEX idx_booking_property_id (property_id),
    INDEX idx_booking_user_id (user_id),
    INDEX idx_booking_status (status),
    INDEX idx_booking_dates (start_date, end_date)
)
PARTITION BY RANGE (YEAR(start_date) * 10 + QUARTER(start_date)) (
    PARTITION p2023_q1 VALUES LESS THAN (20232),  -- Q1 2023
    PARTITION p2023_q2 VALUES LESS THAN (20233),  -- Q2 2023
    PARTITION p2023_q3 VALUES LESS THAN (20234),  -- Q3 2023
    PARTITION p2023_q4 VALUES LESS THAN (20241),  -- Q4 2023
    PARTITION p2024_q1 VALUES LESS THAN (20242),  -- Q1 2024
    PARTITION p2024_q2 VALUES LESS THAN (20243),  -- Q2 2024
    PARTITION p2024_q3 VALUES LESS THAN (20244),  -- Q3 2024
    PARTITION p2024_q4 VALUES LESS THAN (20251),  -- Q4 2024
    PARTITION p2025_q1 VALUES LESS THAN (20252),  -- Q1 2025
    PARTITION p2025_q2 VALUES LESS THAN (20253),  -- Q2 2025
    PARTITION p2025_q3 VALUES LESS THAN (20254),  -- Q3 2025
    PARTITION p2025_q4 VALUES LESS THAN (20261),  -- Q4 2025
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

-- ============================================
-- STEP 4: PERFORMANCE TESTING QUERIES
-- ============================================

-- Enable query profiling
SET profiling = 1;

-- Test 1: Single month query (should use only one partition)
SELECT b.booking_id, b.start_date, b.end_date, b.status, u.first_name, p.name
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date BETWEEN '2024-07-01' AND '2024-07-31'
ORDER BY b.start_date;

-- Test 2: Quarter query (should use 3 partitions)
SELECT b.booking_id, b.start_date, b.status, COUNT(*) OVER() as total_count
FROM Booking b
WHERE b.start_date BETWEEN '2024-04-01' AND '2024-06-30'
AND b.status = 'confirmed'
ORDER BY b.start_date DESC;

-- Test 3: Year-end query (should use multiple partitions efficiently)
SELECT 
    MONTH(b.start_date) as booking_month,
    COUNT(*) as monthly_bookings,
    AVG(DATEDIFF(b.end_date, b.start_date)) as avg_duration
FROM Booking b
WHERE b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY MONTH(b.start_date)
ORDER BY booking_month;

-- Test 4: Cross-year query
SELECT b.status, COUNT(*) as status_count
FROM Booking b
WHERE b.start_date BETWEEN '2024-11-01' AND '2025-02-28'
GROUP BY b.status;

-- Test 5: Recent bookings (common dashboard query)
SELECT b.booking_id, b.start_date, b.status, u.first_name, p.name
FROM Booking b
JOIN User u ON b.user_id = u.user_id  
JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY b.start_date DESC
LIMIT 50;

-- Show execution times
SHOW PROFILES;

-- ============================================
-- STEP 5: ANALYZE PARTITION USAGE
-- ============================================

-- Check which partitions were accessed for each query
EXPLAIN PARTITIONS 
SELECT * FROM Booking 
WHERE start_date BETWEEN '2024-07-01' AND '2024-07-31';

-- Detailed execution plan
EXPLAIN FORMAT=JSON
SELECT b.booking_id, b.start_date, b.status
FROM Booking b
WHERE b.start_date BETWEEN '2024-06-01' AND '2024-08-31'
ORDER BY b.start_date;

-- Check partition sizes and row counts
SELECT 
    PARTITION_NAME as partition_name,
    TABLE_ROWS as estimated_rows,
    ROUND(DATA_LENGTH/1024/1024, 2) as data_size_mb,
    ROUND(INDEX_LENGTH/1024/1024, 2) as index_size_mb,
    PARTITION_DESCRIPTION as range_description
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'Booking' 
    AND PARTITION_NAME IS NOT NULL
ORDER BY PARTITION_NAME;

-- ============================================
-- STEP 6: PARTITION MAINTENANCE OPERATIONS
-- ============================================

-- Add new partitions for future months (run monthly/quarterly)
ALTER TABLE Booking ADD PARTITION (
    PARTITION p2026_01 VALUES LESS THAN (202602),
    PARTITION p2026_02 VALUES LESS THAN (202603),
    PARTITION p2026_03 VALUES LESS THAN (202604)
);

-- Drop old partitions (for data retention - run quarterly/yearly)
-- WARNING: This permanently deletes data!
-- ALTER TABLE Booking DROP PARTITION p2022_01, p2022_02, p2022_03;

-- Reorganize partitions if needed
-- ALTER TABLE Booking REORGANIZE PARTITION p_future INTO (
--     PARTITION p2026_04 VALUES LESS THAN (202605),
--     PARTITION p_future VALUES LESS THAN MAXVALUE
-- );

-- ============================================
-- STEP 7: MONITORING AND OPTIMIZATION
-- ============================================

-- Monitor partition pruning effectiveness
SELECT 
    SQL_TEXT,
    ROWS_EXAMINED,
    ROWS_SENT,
    TIMER_WAIT/1000000000000 as exec_time_seconds
FROM performance_schema.events_statements_history 
WHERE SQL_TEXT LIKE '%Booking%'
ORDER BY TIMER_WAIT DESC 
LIMIT 10;

-- Check for partition-wise operations
SHOW STATUS LIKE 'Handler_read%';

-- Optimize tables after partitioning
OPTIMIZE TABLE Booking;

-- Update table statistics
ANALYZE TABLE Booking;

-- ============================================
-- CLEANUP BACKUP DATA (OPTIONAL)
-- ============================================

-- After verifying partitioned table works correctly:
-- DROP TABLE Booking_backup;

-- ============================================
-- AUTOMATED PARTITION MANAGEMENT PROCEDURE
-- ============================================

DELIMITER //

CREATE PROCEDURE AddMonthlyPartitions(IN months_ahead INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE partition_date DATE;
    DECLARE partition_name VARCHAR(20);
    DECLARE partition_value INT;
    DECLARE sql_statement VARCHAR(500);
    DECLARE counter INT DEFAULT 1;
    
    WHILE counter <= months_ahead DO
        SET partition_date = DATE_ADD(LAST_DAY(CURDATE()), INTERVAL counter MONTH);
        SET partition_name = CONCAT('p', YEAR(partition_date), '_', LPAD(MONTH(partition_date), 2, '0'));
        SET partition_value = YEAR(partition_date) * 100 + MONTH(partition_date) + 1;
        
        SET sql_statement = CONCAT(
            'ALTER TABLE Booking ADD PARTITION (',
            'PARTITION ', partition_name, ' VALUES LESS THAN (', partition_value, ')',
            ')'
        );
        
        SET @sql = sql_statement;
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET counter = counter + 1;
    END WHILE;
END//

DELIMITER ;

-- Usage: Add partitions for next 6 months
-- CALL AddMonthlyPartitions(6);

-- ============================================
-- PERFORMANCE COMPARISON QUERIES
-- ============================================

/*
BEFORE PARTITIONING vs AFTER PARTITIONING:

Run these queries and compare execution times:

1. Date Range Query (3 months):
   Before: Scans entire table
   After: Scans only 3 partitions

2. Recent Data Query (last 30 days):  
   Before: Full table scan with date filtering
   After: Scans only current month partition

3. Historical Data Query (specific month):
   Before: Full table scan
   After: Scans only one partition

4. Aggregation by Month:
   Before: Full table scan with GROUP BY
   After: Partition-wise parallel processing
*/

-- Performance test template
-- Run before and after partitioning:
SET SESSION query_cache_type = OFF;
SET profiling = 1;

-- Your test query here
SELECT COUNT(*) FROM Booking WHERE start_date BETWEEN '2024-07-01' AND '2024-09-30';

SHOW PROFILES;

-- Expected improvements:
-- - 60-90% reduction in query execution time for date range queries
-- - 70-95% reduction in rows examined  
-- - Better concurrent query performance
-- - Faster data maintenance operations