# Initial Query Problems:

Multiple Subqueries in SELECT: Each row triggered 3 separate subqueries for review data
Subquery in WHERE: Used inefficient IN clause with subquery
Double User JOIN: Joined User table twice for guest and host info
No LIMIT: Could return thousands of records
Calculated ORDER BY: Used non-indexed calculated fields for sorting

# Optimization Techniques Applied:

#### Replaced Subqueries with JOINs:

Changed correlated subqueries to LEFT JOIN with pre-aggregated data
Reduced N+1 query problems


#### Optimized WHERE Clause:

Removed subquery and used direct property location filters
Added date range filter for recent bookings only


#### Reduced Data Selection:

Selected only essential columns
Removed large text fields when not needed


#### Added Proper Indexing Strategy:

Created composite indexes for common query patterns
Optimized for ORDER BY and WHERE clauses


#### Pagination Support:

Added LIMIT clauses
Provided OFFSET examples for pagination



### Expected Performance Improvements:

Query Time: From 2-5 seconds → 50-200ms (90%+ improvement)
Rows Examined: From 50,000+ → 1,000 (95%+ reduction)
Memory Usage: Significantly reduced due to eliminated subqueries
Scalability: Better performance as data grows

Testing Commands:
sql-- Before optimization
EXPLAIN FORMAT=JSON 
SELECT b.booking_id, u.first_name, p.name 
FROM Booking b 
INNER JOIN User u ON b.user_id = u.user_id 
INNER JOIN Property p ON b.property_id = p.property_id 
WHERE b.property_id IN (SELECT property_id FROM Property WHERE location LIKE '%New York%');

-- After optimization  
EXPLAIN FORMAT=JSON
SELECT b.booking_id, u.first_name, p.name 
FROM Booking b 
INNER JOIN User u ON b.user_id = u.user_id 
INNER JOIN Property p ON b.property_id = p.property_id 
WHERE p.location LIKE 'New York%' 
ORDER BY b.created_at DESC 
LIMIT 100;
The key is to always measure first, then optimize systematically, and test the results. Start with the most impactful changes (removing subqueries) and then fine-tune with indexing and query structure improvements.