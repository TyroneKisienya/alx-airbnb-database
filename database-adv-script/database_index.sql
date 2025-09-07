-- Email index for login queries (already UNIQUE, but explicit index for performance)
CREATE INDEX idx_user_email ON User(email);

-- Role index for filtering by user types (guest, host, admin)
CREATE INDEX idx_user_role ON User(role);

-- Phone number index for contact lookups
CREATE INDEX idx_user_phone ON User(phone_number);

-- Created_at index for user registration analytics
CREATE INDEX idx_user_created_at ON User(created_at);

-- ============================================
-- PROPERTY TABLE INDEXES
-- ============================================

-- Host_id index for finding all properties by a specific host
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Location index for geographical searches (partial index for large text)
CREATE INDEX idx_property_location ON Property(location(100));

-- Price per night index for price filtering and sorting
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Combined index for location + price queries (common search pattern)
CREATE INDEX idx_property_location_price ON Property(location(100), pricepernight);

-- Created_at index for new property listings
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Updated_at index for recently modified properties
CREATE INDEX idx_property_updated_at ON Property(updated_at);

-- ============================================
-- BOOKING TABLE INDEXES
-- ============================================

-- User_id index for finding user's booking history
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Property_id index for finding property's booking history
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Status index for filtering by booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Date range index for availability searches (composite index)
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Created_at index for recent bookings
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Combined index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Combined index for user booking status queries
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- ============================================
-- REVIEW TABLE INDEXES
-- ============================================

-- Property_id index for finding property reviews
CREATE INDEX idx_review_property_id ON Review(property_id);

-- User_id index for finding user's reviews
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Rating index for filtering by rating scores
CREATE INDEX idx_review_rating ON Review(rating);

-- Created_at index for recent reviews
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Combined index for property rating queries
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Combined index for recent property reviews
CREATE INDEX idx_review_property_date ON Review(property_id, created_at);

-- ============================================
-- PAYMENT TABLE INDEXES
-- ============================================

-- Booking_id index for finding payment by booking
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Payment_date index for financial reports
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Payment_method index for payment analytics
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Combined index for payment history queries
CREATE INDEX idx_payment_booking_date ON Payment(booking_id, payment_date);

-- ============================================
-- MESSAGE TABLE INDEXES
-- ============================================

-- Sender_id index for outgoing messages
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Recipient_id index for incoming messages
CREATE INDEX idx_message_recipient_id ON Message(recepient_id);

-- Sent_at index for chronological message ordering
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Combined index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recepient_id, sent_at);

-- ============================================
-- SPECIALIZED INDEXES FOR COMMON QUERIES
-- ============================================

-- Index for finding available properties in date range and location
CREATE INDEX idx_availability_search ON Property(location(50), pricepernight);

-- Index for host performance analytics
CREATE INDEX idx_host_analytics ON Review(property_id, rating, created_at);

-- Index for user activity tracking
CREATE INDEX idx_user_activity ON Booking(user_id, created_at, status);


-- Enable query timing
SET profiling = 1;

-- Test Query 1: Property search (common user query)
EXPLAIN FORMAT=JSON 
SELECT property_id, name, location, pricepernight 
FROM Property 
WHERE location LIKE 'New York%' 
AND pricepernight BETWEEN 100 AND 300 
ORDER BY pricepernight;

-- Test Query 2: User booking history
EXPLAIN FORMAT=JSON
SELECT b.booking_id, b.start_date, b.end_date, p.name 
FROM Booking b 
JOIN Property p ON b.property_id = p.property_id 
WHERE b.user_id = 'some_user_id' 
ORDER BY b.created_at DESC;

-- Check execution time
SHOW PROFILES;

From EXPLAIN output, look for: 

type: Should be "ref" or "range" instead of "ALL" (full table scan)
possible_keys: Shows which indexes MySQL can use
key: Shows which index MySQL actually uses
rows: Number of rows examined (lower is better)
Extra: Should avoid "Using filesort" and "Using temporary"

Performance improvements you should see:

Query execution time reduced by 50-90%
Rows examined reduced significantly
Better query plans with index usage

4. Common Query Patterns That Will Benefit:

Property searches (location + price filtering)
User booking history (user_id + date sorting)
Availability checks (property_id + date ranges)
Rating calculations (property_id + rating aggregation)
Host analytics (host_id + various metrics)

5. Index Usage Monitoring:
sql-- Check if indexes are being used
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    CARDINALITY,
    SEQ_IN_INDEX,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'your_database_name'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;